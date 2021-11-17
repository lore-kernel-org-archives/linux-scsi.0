Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4D0C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5591661A8D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 03:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhKQDD3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 22:03:29 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:41862 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhKQDDY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 22:03:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 436692191A;
        Wed, 17 Nov 2021 03:00:25 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8F75113BBF;
        Wed, 17 Nov 2021 03:00:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mI/QFkZwlGFefgAAMHmgww
        (envelope-from <dave@stgolabs.net>); Wed, 17 Nov 2021 03:00:22 +0000
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     hare@suse.de, bigeasy@linutronix.de, tglx@linutronix.de,
        linux-scsi@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/3] scsi/fcoe: Add a local_lock to percpu localport statistics
Date:   Tue, 16 Nov 2021 18:59:56 -0800
Message-Id: <20211117025956.79616-4-dave@stgolabs.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211117025956.79616-1-dave@stgolabs.net>
References: <20211117025956.79616-1-dave@stgolabs.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Updating the per-CPU lport->stats relies on disabling preemption
with get/put_cpu() semantics. However, this is a bit harsh for
PREEMPT_RT and by using a local_lock, it can allow the region
to be preemptible, guaranteeing CPU locality, without making any
difference to the non-RT common case as it will continue to
disable preemption.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 16 ++++++++++------
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  5 +++--
 drivers/scsi/fcoe/fcoe.c          | 29 ++++++++++++++++++-----------
 drivers/scsi/fcoe/fcoe_ctlr.c     | 24 +++++++++++++++---------
 drivers/scsi/libfc/fc_fcp.c       | 31 ++++++++++++++++++++++---------
 drivers/scsi/qedf/qedf_main.c     |  7 ++++---
 include/scsi/libfc.h              |  7 +++++++
 7 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 71fa62bd3083..25bb08514824 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -398,11 +398,12 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct fc_frame *fp)
 		skb_shinfo(skb)->gso_size = 0;
 	}
 
-	/*update tx stats */
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	/* update tx stats */
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	stats->TxFrames++;
 	stats->TxWords += wlen;
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 
 	/* send down to lld */
 	fr_dev(fp) = lport;
@@ -870,6 +871,7 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 	struct fc_lport *vport;
 	struct bnx2fc_interface *interface, *tmp;
 	struct fcoe_ctlr *ctlr;
+	struct fc_stats *stats;
 	int wait_for_upload = 0;
 	u32 link_possible = 1;
 
@@ -962,9 +964,11 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 				mutex_unlock(&lport->lp_mutex);
 				fc_host_port_type(lport->host) =
 					FC_PORTTYPE_UNKNOWN;
-				per_cpu_ptr(lport->stats,
-					    get_cpu())->LinkFailureCount++;
-				put_cpu();
+
+				local_lock(&lport->stats->lock);
+				stats = this_cpu_ptr(lport->stats);
+				stats->LinkFailureCount++;
+				local_unlock(&lport->stats->lock);
 				fcoe_clean_pending_queue(lport);
 				wait_for_upload = 1;
 			}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index b9114113ee73..219ce4bc4008 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -2046,7 +2046,8 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
 	sc_cmd->SCp.ptr = (char *)io_req;
 
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		io_req->io_req_flags = BNX2FC_READ;
 		stats->InputRequests++;
@@ -2059,7 +2060,7 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 		io_req->io_req_flags = 0;
 		stats->ControlRequests++;
 	}
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 
 	xid = io_req->xid;
 
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index a0064a1b4a32..80e6d5427d51 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1339,6 +1339,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	struct fcoe_interface *fcoe;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
+	struct fc_stats *stats;
 	struct ethhdr *eh;
 	unsigned int cpu;
 
@@ -1433,8 +1434,10 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 
 	return NET_RX_SUCCESS;
 err:
-	per_cpu_ptr(lport->stats, get_cpu())->ErrorFrames++;
-	put_cpu();
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
+	stats->ErrorFrames++;
+	local_unlock(&lport->stats->lock);
 err2:
 	kfree_skb(skb);
 	return NET_RX_DROP;
@@ -1585,10 +1588,11 @@ static int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 		skb_shinfo(skb)->gso_size = 0;
 	}
 	/* update tx stats: regardless if LLD fails */
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	stats->TxFrames++;
 	stats->TxWords += wlen;
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 
 	/* send down to lld */
 	fr_dev(fp) = lport;
@@ -1640,11 +1644,12 @@ static inline int fcoe_filter_frames(struct fc_lport *lport,
 		return 0;
 	}
 
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	stats->InvalidCRCCount++;
 	if (stats->InvalidCRCCount < 5)
 		printk(KERN_WARNING "fcoe: dropping frame with CRC error\n");
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 	return -EINVAL;
 }
 
@@ -1685,7 +1690,8 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	 */
 	hp = (struct fcoe_hdr *) skb_network_header(skb);
 
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
 		if (stats->ErrorFrames < 5)
 			printk(KERN_WARNING "fcoe: FCoE version "
@@ -1717,13 +1723,13 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 		goto drop;
 
 	if (!fcoe_filter_frames(lport, fp)) {
-		put_cpu();
+		local_unlock(&lport->stats->lock);
 		fc_exch_recv(lport, fp);
 		return;
 	}
 drop:
 	stats->ErrorFrames++;
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 	kfree_skb(skb);
 }
 
@@ -1921,9 +1927,10 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 			break;
 		case FCOE_CTLR_ENABLED:
 		case FCOE_CTLR_UNUSED:
-			stats = per_cpu_ptr(lport->stats, get_cpu());
+			local_lock(&lport->stats->lock);
+			stats = this_cpu_ptr(lport->stats);
 			stats->LinkFailureCount++;
-			put_cpu();
+			local_unlock(&lport->stats->lock);
 			fcoe_clean_pending_queue(lport);
 		}
 	}
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 1756a0ac6f08..d033aacafc5e 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -828,7 +828,8 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 
 	INIT_LIST_HEAD(&del_list);
 
-	stats = per_cpu_ptr(fip->lp->stats, get_cpu());
+	local_lock(&fip->lp->stats->lock);
+	stats = this_cpu_ptr(fip->lp->stats);
 
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
 		deadline = fcf->time + fcf->fka_period + fcf->fka_period / 2;
@@ -864,7 +865,7 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 				sel_time = fcf->time;
 		}
 	}
-	put_cpu();
+	local_unlock(&fip->lp->stats->lock);
 
 	list_for_each_entry_safe(fcf, next, &del_list, list) {
 		/* Removes fcf from current list */
@@ -1286,10 +1287,11 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	fr_dev(fp) = lport;
 	fr_encaps(fp) = els_dtype;
 
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	stats->RxFrames++;
 	stats->RxWords += skb->len / FIP_BPW;
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 
 	fc_exch_recv(lport, fp);
 	return;
@@ -1321,6 +1323,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	struct fcoe_fcf *fcf = fip->sel_fcf;
 	struct fc_lport *lport = fip->lp;
 	struct fc_lport *vn_port = NULL;
+	struct fc_stats *stats;
 	u32 desc_mask;
 	int num_vlink_desc;
 	int reset_phys_port = 0;
@@ -1427,9 +1430,10 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 						      ntoh24(vp->fd_fc_id));
 			if (vn_port && (vn_port == lport)) {
 				mutex_lock(&fip->ctlr_mutex);
-				per_cpu_ptr(lport->stats,
-					    get_cpu())->VLinkFailureCount++;
-				put_cpu();
+				local_lock(&lport->stats->lock);
+				stats = this_cpu_ptr(lport->stats);
+				stats->VLinkFailureCount++;
+				local_unlock(&lport->stats->lock);
 				fcoe_ctlr_reset(fip);
 				mutex_unlock(&fip->ctlr_mutex);
 			}
@@ -1457,8 +1461,10 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		 * followed by physical port
 		 */
 		mutex_lock(&fip->ctlr_mutex);
-		per_cpu_ptr(lport->stats, get_cpu())->VLinkFailureCount++;
-		put_cpu();
+		local_lock(&lport->stats->lock);
+		stats = this_cpu_ptr(lport->stats);
+		stats->VLinkFailureCount++;
+		local_unlock(&lport->stats->lock);
 		fcoe_ctlr_reset(fip);
 		mutex_unlock(&fip->ctlr_mutex);
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 871b11edb586..bee26f4f2ea6 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -147,8 +147,12 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
 		INIT_LIST_HEAD(&fsp->list);
 		spin_lock_init(&fsp->scsi_pkt_lock);
 	} else {
-		per_cpu_ptr(lport->stats, get_cpu())->FcpPktAllocFails++;
-		put_cpu();
+		struct fc_stats *stats;
+
+		local_lock(&lport->stats->lock);
+		stats = this_cpu_ptr(lport->stats);
+		stats->FcpPktAllocFails++;
+		local_unlock(&lport->stats->lock);
 	}
 	return fsp;
 }
@@ -266,12 +270,15 @@ static void fc_fcp_abort_done(struct fc_fcp_pkt *fsp)
 static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 {
 	int rc;
+	struct fc_stats *stats;
 
 	if (!fsp->seq_ptr)
 		return -EINVAL;
 
-	per_cpu_ptr(fsp->lp->stats, get_cpu())->FcpPktAborts++;
-	put_cpu();
+	local_lock(&fsp->lp->stats->lock);
+	stats = this_cpu_ptr(fsp->lp->stats);
+	stats->FcpPktAborts++;
+	local_unlock(&fsp->lp->stats->lock);
 
 	fsp->state |= FC_SRB_ABORT_PENDING;
 	rc = fc_seq_exch_abort(fsp->seq_ptr, 0);
@@ -435,13 +442,16 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 						  size_t len)
 {
 	struct fc_frame *fp;
+	struct fc_stats *stats;
 
 	fp = fc_frame_alloc(lport, len);
 	if (likely(fp))
 		return fp;
 
-	per_cpu_ptr(lport->stats, get_cpu())->FcpFrameAllocFails++;
-	put_cpu();
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
+	stats->FcpFrameAllocFails++;
+	local_unlock(&lport->stats->lock);
 	/* error case */
 	fc_fcp_can_queue_ramp_down(lport);
 	shost_printk(KERN_ERR, lport->host,
@@ -537,8 +547,10 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 
 		if (~crc != le32_to_cpu(fr_crc(fp))) {
 crc_err:
-			stats = per_cpu_ptr(lport->stats, get_cpu());
+			local_lock(&lport->stats->lock);
+			stats = this_cpu_ptr(lport->stats);
 			stats->ErrorFrames++;
+			local_unlock(&lport->stats->lock);
 			/* per cpu count, not total count, but OK for limit */
 			if (stats->InvalidCRCCount++ < FC_MAX_ERROR_CNT)
 				printk(KERN_WARNING "libfc: CRC error on data "
@@ -1917,7 +1929,8 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	/*
 	 * setup the data direction
 	 */
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		fsp->req_flags = FC_SRB_READ;
 		stats->InputRequests++;
@@ -1930,7 +1943,7 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 		fsp->req_flags = 0;
 		stats->ControlRequests++;
 	}
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 
 	/*
 	 * send it to the lower layer
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 1bf7a22d4948..1488f7431db5 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1213,11 +1213,12 @@ static int qedf_xmit(struct fc_lport *lport, struct fc_frame *fp)
 		FC_FCOE_ENCAPS_VER(hp, FC_FCOE_VER);
 	hp->fcoe_sof = sof;
 
-	/*update tx stats */
-	stats = per_cpu_ptr(lport->stats, get_cpu());
+	/* update tx stats */
+	local_lock(&lport->stats->lock);
+	stats = this_cpu_ptr(lport->stats);
 	stats->TxFrames++;
 	stats->TxWords += wlen;
-	put_cpu();
+	local_unlock(&lport->stats->lock);
 
 	/* Get VLAN ID from skb for printing purposes */
 	__vlan_hwaccel_get_tag(skb, &vlan_tci);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index eeb8d689ff6b..d8d717bdbb74 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -240,6 +240,7 @@ struct fc_rport_priv {
  * @OutputBytes:           Number of transmitted bytes
  * @VLinkFailureCount:     Number of virtual link failures
  * @MissDiscAdvCount:      Number of missing FIP discovery advertisement
+ * @lock:                  Protects percpu stats management
  */
 struct fc_stats {
 	u64		SecondsSinceLastReset;
@@ -263,6 +264,7 @@ struct fc_stats {
 	u64		OutputBytes;
 	u64		VLinkFailureCount;
 	u64		MissDiscAdvCount;
+	local_lock_t    lock;
 };
 
 /**
@@ -824,9 +826,14 @@ static inline void fc_lport_state_enter(struct fc_lport *lport,
  */
 static inline int fc_lport_init_stats(struct fc_lport *lport)
 {
+	int cpu;
+
 	lport->stats = alloc_percpu(struct fc_stats);
 	if (!lport->stats)
 		return -ENOMEM;
+
+	for_each_possible_cpu(cpu)
+		local_lock_init(&per_cpu_ptr(lport->stats, cpu)->lock);
 	return 0;
 }
 
-- 
2.26.2

