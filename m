Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24D8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 10:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391103AbiEFLB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 07:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391100AbiEFLBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 07:01:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B2722BEA
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 03:58:06 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651834684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGkD3iVME+BhlvIXayj/uprtMH0zghaRYvzGomdhdrI=;
        b=OSRWQcPQU4w2/mVRx6kSbwKF82GH6K9wlqBiYjIP/Hat2e56waI59UI0jGkbdkO/u/BhEf
        ebZpVTRgcr05PWW6V3ofSRy5MdsEHJSeptyk0ZJZ/ob8JiiS2CaPnMAz/reHH8ZE0QZKVk
        uenCsIb+wXpFSKvTWhDoj7sNJj6bWQAua07vpus++3VxGHggSMFqjaEC4tMIzZ33f7odAI
        jcBWuJcWK0YdRNOit3Kjaqx2r9fEr48icogG8ZDRrmeaVSdDPZmFufGDJYk81N5SU5pgPn
        DyqFodXvS7vVckS3htETjD3lpJ4QjsD2xJ1F03hl3etfY8wTUzL/7QcSp+R3PQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651834684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGkD3iVME+BhlvIXayj/uprtMH0zghaRYvzGomdhdrI=;
        b=CThwDiR7GlaRyygmdaSi4Oev1RBc3QiTiaSbnE2jLDuXUO1oqzjaTJe1BzMCrnApxwA+Vk
        L+S8RW0sEKejf8Dg==
To:     linux-scsi@vger.kernel.org
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@suse.de>,
        Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Davidlohr Bueso <dbueso@suse.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/4] scsi: fcoe: Use per-CPU API to update per-CPU statistics.
Date:   Fri,  6 May 2022 12:57:56 +0200
Message-Id: <20220506105758.283887-3-bigeasy@linutronix.de>
In-Reply-To: <20220506105758.283887-1-bigeasy@linutronix.de>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The per-CPU statistics (struct fc_stats) is updated by getting a stable
per-CPU pointer via get_cpu() + per_cpu_ptr() and then performing the
increment. This can be optimized by using this_cpu_*() which will do
whatever is needed on the architecture to perform the update safe and
efficient.
The read out of the individual value (fc_get_host_stats()) should be
done by using READ_ONCE() instead of a plain-C access. The difference is
that READ_ONCE() will always perform a single access while the plain-C
access can be splitt by the compiler into two loads if it appears
beneficial.
The usage of u64 has the side-effect that it is also 64bit wide on 32bit
architectures and the read is always split into two loads. The can lead
to strange values if the read happens during an update which alters both
32bit parts of the 64bit value. This can be circumvanted by either using
a 32bit variables on 32bit architecures or extending the statistics with
a sequence counter.

Use this_cpu_*() API to update the statistics and READ_ONCE() to read
it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  | 22 +++++-------------
 drivers/scsi/bnx2fc/bnx2fc_io.c    | 13 +++++------
 drivers/scsi/fcoe/fcoe.c           | 36 ++++++++++--------------------
 drivers/scsi/fcoe/fcoe_ctlr.c      | 26 ++++++++-------------
 drivers/scsi/fcoe/fcoe_transport.c |  6 ++---
 drivers/scsi/libfc/fc_fcp.c        | 29 +++++++++---------------
 drivers/scsi/libfc/fc_lport.c      | 30 ++++++++++++-------------
 drivers/scsi/qedf/qedf_main.c      |  7 ++----
 8 files changed, 62 insertions(+), 107 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc=
_fcoe.c
index d295867a9b465..05ddbb9bb7d8a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -273,7 +273,6 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct f=
c_frame *fp)
 	struct fcoe_port	*port;
 	struct fcoe_hdr		*hp;
 	struct bnx2fc_rport	*tgt;
-	struct fc_stats		*stats;
 	u8			sof, eof;
 	u32			crc;
 	unsigned int		hlen, tlen, elen;
@@ -399,10 +398,8 @@ static int bnx2fc_xmit(struct fc_lport *lport, struct =
fc_frame *fp)
 	}
=20
 	/*update tx stats */
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
-	stats->TxFrames++;
-	stats->TxWords +=3D wlen;
-	put_cpu();
+	this_cpu_inc(lport->stats->TxFrames);
+	this_cpu_add(lport->stats->TxWords, wlen);
=20
 	/* send down to lld */
 	fr_dev(fp) =3D lport;
@@ -512,7 +509,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	u32 fr_len, fr_crc;
 	struct fc_lport *lport;
 	struct fcoe_rcv_info *fr;
-	struct fc_stats *stats;
 	struct fc_frame_header *fh;
 	struct fcoe_crc_eof crc_eof;
 	struct fc_frame *fp;
@@ -543,10 +539,8 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len =3D skb->len - sizeof(struct fcoe_crc_eof);
=20
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
-	stats->RxFrames++;
-	stats->RxWords +=3D fr_len / FCOE_WORD_TO_BYTE;
-	put_cpu();
+	this_cpu_inc(lport->stats->RxFrames);
+	this_cpu_add(lport->stats->RxWords, fr_len / FCOE_WORD_TO_BYTE);
=20
 	fp =3D (struct fc_frame *)skb;
 	fc_frame_init(fp);
@@ -633,9 +627,7 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 	fr_crc =3D le32_to_cpu(fr_crc(fp));
=20
 	if (unlikely(fr_crc !=3D ~crc32(~0, skb->data, fr_len))) {
-		stats =3D per_cpu_ptr(lport->stats, get_cpu());
-		crc_err =3D (stats->InvalidCRCCount++);
-		put_cpu();
+		crc_err =3D this_cpu_inc_return(lport->stats->InvalidCRCCount);
 		if (crc_err < 5)
 			printk(KERN_WARNING PFX "dropping frame with "
 			       "CRC error\n");
@@ -964,9 +956,7 @@ static void bnx2fc_indicate_netevent(void *context, uns=
igned long event,
 				mutex_unlock(&lport->lp_mutex);
 				fc_host_port_type(lport->host) =3D
 					FC_PORTTYPE_UNKNOWN;
-				per_cpu_ptr(lport->stats,
-					    get_cpu())->LinkFailureCount++;
-				put_cpu();
+				this_cpu_inc(lport->stats->LinkFailureCount);
 				fcoe_clean_pending_queue(lport);
 				wait_for_upload =3D 1;
 			}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_i=
o.c
index 962454f2e2b16..6a1fc35b832ae 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -2032,7 +2032,6 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	struct bnx2fc_interface *interface =3D port->priv;
 	struct bnx2fc_hba *hba =3D interface->hba;
 	struct fc_lport *lport =3D port->lport;
-	struct fc_stats *stats;
 	int task_idx, index;
 	u16 xid;
=20
@@ -2045,20 +2044,18 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	io_req->data_xfer_len =3D scsi_bufflen(sc_cmd);
 	bnx2fc_priv(sc_cmd)->io_req =3D io_req;
=20
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
 	if (sc_cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
 		io_req->io_req_flags =3D BNX2FC_READ;
-		stats->InputRequests++;
-		stats->InputBytes +=3D io_req->data_xfer_len;
+		this_cpu_inc(lport->stats->InputRequests);
+		this_cpu_add(lport->stats->InputBytes, io_req->data_xfer_len);
 	} else if (sc_cmd->sc_data_direction =3D=3D DMA_TO_DEVICE) {
 		io_req->io_req_flags =3D BNX2FC_WRITE;
-		stats->OutputRequests++;
-		stats->OutputBytes +=3D io_req->data_xfer_len;
+		this_cpu_inc(lport->stats->OutputRequests);
+		this_cpu_add(lport->stats->OutputBytes, io_req->data_xfer_len);
 	} else {
 		io_req->io_req_flags =3D 0;
-		stats->ControlRequests++;
+		this_cpu_inc(lport->stats->ControlRequests);
 	}
-	put_cpu();
=20
 	xid =3D io_req->xid;
=20
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index af9b788823ac7..8bff94b5474cc 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1434,8 +1434,7 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_d=
evice *netdev,
=20
 	return NET_RX_SUCCESS;
 err:
-	per_cpu_ptr(lport->stats, get_cpu())->ErrorFrames++;
-	put_cpu();
+	this_cpu_inc(lport->stats->ErrorFrames);
 err2:
 	kfree_skb(skb);
 	return NET_RX_DROP;
@@ -1475,7 +1474,6 @@ static int fcoe_xmit(struct fc_lport *lport, struct f=
c_frame *fp)
 	struct ethhdr *eh;
 	struct fcoe_crc_eof *cp;
 	struct sk_buff *skb;
-	struct fc_stats *stats;
 	struct fc_frame_header *fh;
 	unsigned int hlen;		/* header length implies the version */
 	unsigned int tlen;		/* trailer length */
@@ -1586,10 +1584,8 @@ static int fcoe_xmit(struct fc_lport *lport, struct =
fc_frame *fp)
 		skb_shinfo(skb)->gso_size =3D 0;
 	}
 	/* update tx stats: regardless if LLD fails */
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
-	stats->TxFrames++;
-	stats->TxWords +=3D wlen;
-	put_cpu();
+	this_cpu_inc(lport->stats->TxFrames);
+	this_cpu_add(lport->stats->TxWords, wlen);
=20
 	/* send down to lld */
 	fr_dev(fp) =3D lport;
@@ -1611,7 +1607,6 @@ static inline int fcoe_filter_frames(struct fc_lport =
*lport,
 	struct fcoe_interface *fcoe;
 	struct fc_frame_header *fh;
 	struct sk_buff *skb =3D (struct sk_buff *)fp;
-	struct fc_stats *stats;
=20
 	/*
 	 * We only check CRC if no offload is available and if it is
@@ -1641,11 +1636,8 @@ static inline int fcoe_filter_frames(struct fc_lport=
 *lport,
 		return 0;
 	}
=20
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
-	stats->InvalidCRCCount++;
-	if (stats->InvalidCRCCount < 5)
+	if (this_cpu_inc_return(lport->stats->InvalidCRCCount) < 5)
 		printk(KERN_WARNING "fcoe: dropping frame with CRC error\n");
-	put_cpu();
 	return -EINVAL;
 }
=20
@@ -1658,7 +1650,6 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	u32 fr_len;
 	struct fc_lport *lport;
 	struct fcoe_rcv_info *fr;
-	struct fc_stats *stats;
 	struct fcoe_crc_eof crc_eof;
 	struct fc_frame *fp;
 	struct fcoe_hdr *hp;
@@ -1686,9 +1677,11 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	 */
 	hp =3D (struct fcoe_hdr *) skb_network_header(skb);
=20
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
 	if (unlikely(FC_FCOE_DECAPS_VER(hp) !=3D FC_FCOE_VER)) {
-		if (stats->ErrorFrames < 5)
+		struct fc_stats *stats;
+
+		stats =3D per_cpu_ptr(lport->stats, raw_smp_processor_id());
+		if (READ_ONCE(stats->ErrorFrames) < 5)
 			printk(KERN_WARNING "fcoe: FCoE version "
 			       "mismatch: The frame has "
 			       "version %x, but the "
@@ -1701,8 +1694,8 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len =3D skb->len - sizeof(struct fcoe_crc_eof);
=20
-	stats->RxFrames++;
-	stats->RxWords +=3D fr_len / FCOE_WORD_TO_BYTE;
+	this_cpu_inc(lport->stats->RxFrames);
+	this_cpu_add(lport->stats->RxWords, fr_len / FCOE_WORD_TO_BYTE);
=20
 	fp =3D (struct fc_frame *)skb;
 	fc_frame_init(fp);
@@ -1718,13 +1711,11 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 		goto drop;
=20
 	if (!fcoe_filter_frames(lport, fp)) {
-		put_cpu();
 		fc_exch_recv(lport, fp);
 		return;
 	}
 drop:
-	stats->ErrorFrames++;
-	put_cpu();
+	this_cpu_inc(lport->stats->ErrorFrames);
 	kfree_skb(skb);
 }
=20
@@ -1848,7 +1839,6 @@ static int fcoe_device_notification(struct notifier_b=
lock *notifier,
 	struct net_device *netdev =3D netdev_notifier_info_to_dev(ptr);
 	struct fcoe_ctlr *ctlr;
 	struct fcoe_interface *fcoe;
-	struct fc_stats *stats;
 	u32 link_possible =3D 1;
 	u32 mfs;
 	int rc =3D NOTIFY_OK;
@@ -1922,9 +1912,7 @@ static int fcoe_device_notification(struct notifier_b=
lock *notifier,
 			break;
 		case FCOE_CTLR_ENABLED:
 		case FCOE_CTLR_UNUSED:
-			stats =3D per_cpu_ptr(lport->stats, get_cpu());
-			stats->LinkFailureCount++;
-			put_cpu();
+			this_cpu_inc(lport->stats->LinkFailureCount);
 			fcoe_clean_pending_queue(lport);
 		}
 	}
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 558f3f4e18593..39e16eab47aad 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -824,22 +824,21 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_c=
tlr *fip)
 	unsigned long deadline;
 	unsigned long sel_time =3D 0;
 	struct list_head del_list;
-	struct fc_stats *stats;
=20
 	INIT_LIST_HEAD(&del_list);
=20
-	stats =3D per_cpu_ptr(fip->lp->stats, get_cpu());
-
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
 		deadline =3D fcf->time + fcf->fka_period + fcf->fka_period / 2;
 		if (fip->sel_fcf =3D=3D fcf) {
 			if (time_after(jiffies, deadline)) {
-				stats->MissDiscAdvCount++;
+				u64 miss_cnt;
+
+				miss_cnt =3D this_cpu_inc_return(fip->lp->stats->MissDiscAdvCount);
 				printk(KERN_INFO "libfcoe: host%d: "
 				       "Missing Discovery Advertisement "
 				       "for fab %16.16llx count %lld\n",
 				       fip->lp->host->host_no, fcf->fabric_name,
-				       stats->MissDiscAdvCount);
+				       miss_cnt);
 			} else if (time_after(next_timer, deadline))
 				next_timer =3D deadline;
 		}
@@ -855,7 +854,7 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctl=
r *fip)
 			 */
 			list_del(&fcf->list);
 			list_add(&fcf->list, &del_list);
-			stats->VLinkFailureCount++;
+			this_cpu_inc(fip->lp->stats->VLinkFailureCount);
 		} else {
 			if (time_after(next_timer, deadline))
 				next_timer =3D deadline;
@@ -864,7 +863,6 @@ static unsigned long fcoe_ctlr_age_fcfs(struct fcoe_ctl=
r *fip)
 				sel_time =3D fcf->time;
 		}
 	}
-	put_cpu();
=20
 	list_for_each_entry_safe(fcf, next, &del_list, list) {
 		/* Removes fcf from current list */
@@ -1142,7 +1140,6 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip,=
 struct sk_buff *skb)
 	struct fip_desc *desc;
 	struct fip_encaps *els;
 	struct fcoe_fcf *sel;
-	struct fc_stats *stats;
 	enum fip_desc_type els_dtype =3D 0;
 	u8 els_op;
 	u8 sub;
@@ -1286,10 +1283,8 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip=
, struct sk_buff *skb)
 	fr_dev(fp) =3D lport;
 	fr_encaps(fp) =3D els_dtype;
=20
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
-	stats->RxFrames++;
-	stats->RxWords +=3D skb->len / FIP_BPW;
-	put_cpu();
+	this_cpu_inc(lport->stats->RxFrames);
+	this_cpu_add(lport->stats->RxWords, skb->len / FIP_BPW);
=20
 	fc_exch_recv(lport, fp);
 	return;
@@ -1427,9 +1422,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr=
 *fip,
 						      ntoh24(vp->fd_fc_id));
 			if (vn_port && (vn_port =3D=3D lport)) {
 				mutex_lock(&fip->ctlr_mutex);
-				per_cpu_ptr(lport->stats,
-					    get_cpu())->VLinkFailureCount++;
-				put_cpu();
+				this_cpu_inc(lport->stats->VLinkFailureCount);
 				fcoe_ctlr_reset(fip);
 				mutex_unlock(&fip->ctlr_mutex);
 			}
@@ -1457,8 +1450,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr=
 *fip,
 		 * followed by physical port
 		 */
 		mutex_lock(&fip->ctlr_mutex);
-		per_cpu_ptr(lport->stats, get_cpu())->VLinkFailureCount++;
-		put_cpu();
+		this_cpu_inc(lport->stats->VLinkFailureCount);
 		fcoe_ctlr_reset(fip);
 		mutex_unlock(&fip->ctlr_mutex);
=20
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_tr=
ansport.c
index 4d0e19e7c84b9..62341c6353a72 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -183,9 +183,9 @@ void __fcoe_get_lesb(struct fc_lport *lport,
 	memset(lesb, 0, sizeof(*lesb));
 	for_each_possible_cpu(cpu) {
 		stats =3D per_cpu_ptr(lport->stats, cpu);
-		lfc +=3D stats->LinkFailureCount;
-		vlfc +=3D stats->VLinkFailureCount;
-		mdac +=3D stats->MissDiscAdvCount;
+		lfc +=3D READ_ONCE(stats->LinkFailureCount);
+		vlfc +=3D READ_ONCE(stats->VLinkFailureCount);
+		mdac +=3D READ_ONCE(stats->MissDiscAdvCount);
 	}
 	lesb->lesb_link_fail =3D htonl(lfc);
 	lesb->lesb_vlink_fail =3D htonl(vlfc);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index bce90eb56c9ce..945adca5e72fd 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -143,8 +143,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lp=
ort *lport, gfp_t gfp)
 		INIT_LIST_HEAD(&fsp->list);
 		spin_lock_init(&fsp->scsi_pkt_lock);
 	} else {
-		per_cpu_ptr(lport->stats, get_cpu())->FcpPktAllocFails++;
-		put_cpu();
+		this_cpu_inc(lport->stats->FcpPktAllocFails);
 	}
 	return fsp;
 }
@@ -266,8 +265,7 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 	if (!fsp->seq_ptr)
 		return -EINVAL;
=20
-	per_cpu_ptr(fsp->lp->stats, get_cpu())->FcpPktAborts++;
-	put_cpu();
+	this_cpu_inc(fsp->lp->stats->FcpPktAborts);
=20
 	fsp->state |=3D FC_SRB_ABORT_PENDING;
 	rc =3D fc_seq_exch_abort(fsp->seq_ptr, 0);
@@ -436,8 +434,7 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struc=
t fc_lport *lport,
 	if (likely(fp))
 		return fp;
=20
-	per_cpu_ptr(lport->stats, get_cpu())->FcpFrameAllocFails++;
-	put_cpu();
+	this_cpu_inc(lport->stats->FcpFrameAllocFails);
 	/* error case */
 	fc_fcp_can_queue_ramp_down(lport);
 	shost_printk(KERN_ERR, lport->host,
@@ -471,7 +468,6 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, st=
ruct fc_frame *fp)
 {
 	struct scsi_cmnd *sc =3D fsp->cmd;
 	struct fc_lport *lport =3D fsp->lp;
-	struct fc_stats *stats;
 	struct fc_frame_header *fh;
 	size_t start_offset;
 	size_t offset;
@@ -533,14 +529,12 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, =
struct fc_frame *fp)
=20
 		if (~crc !=3D le32_to_cpu(fr_crc(fp))) {
 crc_err:
-			stats =3D per_cpu_ptr(lport->stats, get_cpu());
-			stats->ErrorFrames++;
+			this_cpu_inc(lport->stats->ErrorFrames);
 			/* per cpu count, not total count, but OK for limit */
-			if (stats->InvalidCRCCount++ < FC_MAX_ERROR_CNT)
+			if (this_cpu_inc_return(lport->stats->InvalidCRCCount) < FC_MAX_ERROR_C=
NT)
 				printk(KERN_WARNING "libfc: CRC error on data "
 				       "frame for port (%6.6x)\n",
 				       lport->port_id);
-			put_cpu();
 			/*
 			 * Assume the frame is total garbage.
 			 * We may have copied it over the good part
@@ -1861,7 +1855,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct s=
csi_cmnd *sc_cmd)
 	struct fc_fcp_pkt *fsp;
 	int rval;
 	int rc =3D 0;
-	struct fc_stats *stats;
=20
 	rval =3D fc_remote_port_chkready(rport);
 	if (rval) {
@@ -1913,20 +1906,18 @@ int fc_queuecommand(struct Scsi_Host *shost, struct=
 scsi_cmnd *sc_cmd)
 	/*
 	 * setup the data direction
 	 */
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
 	if (sc_cmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
 		fsp->req_flags =3D FC_SRB_READ;
-		stats->InputRequests++;
-		stats->InputBytes +=3D fsp->data_len;
+		this_cpu_inc(lport->stats->InputRequests);
+		this_cpu_add(lport->stats->InputBytes, fsp->data_len);
 	} else if (sc_cmd->sc_data_direction =3D=3D DMA_TO_DEVICE) {
 		fsp->req_flags =3D FC_SRB_WRITE;
-		stats->OutputRequests++;
-		stats->OutputBytes +=3D fsp->data_len;
+		this_cpu_inc(lport->stats->OutputRequests);
+		this_cpu_add(lport->stats->OutputBytes, fsp->data_len);
 	} else {
 		fsp->req_flags =3D 0;
-		stats->ControlRequests++;
+		this_cpu_inc(lport->stats->ControlRequests);
 	}
-	put_cpu();
=20
 	/*
 	 * send it to the lower layer
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 19cd4a95d354d..9c02c9523c4d4 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -308,21 +308,21 @@ struct fc_host_statistics *fc_get_host_stats(struct S=
csi_Host *shost)
=20
 		stats =3D per_cpu_ptr(lport->stats, cpu);
=20
-		fc_stats->tx_frames +=3D stats->TxFrames;
-		fc_stats->tx_words +=3D stats->TxWords;
-		fc_stats->rx_frames +=3D stats->RxFrames;
-		fc_stats->rx_words +=3D stats->RxWords;
-		fc_stats->error_frames +=3D stats->ErrorFrames;
-		fc_stats->invalid_crc_count +=3D stats->InvalidCRCCount;
-		fc_stats->fcp_input_requests +=3D stats->InputRequests;
-		fc_stats->fcp_output_requests +=3D stats->OutputRequests;
-		fc_stats->fcp_control_requests +=3D stats->ControlRequests;
-		fcp_in_bytes +=3D stats->InputBytes;
-		fcp_out_bytes +=3D stats->OutputBytes;
-		fc_stats->fcp_packet_alloc_failures +=3D stats->FcpPktAllocFails;
-		fc_stats->fcp_packet_aborts +=3D stats->FcpPktAborts;
-		fc_stats->fcp_frame_alloc_failures +=3D stats->FcpFrameAllocFails;
-		fc_stats->link_failure_count +=3D stats->LinkFailureCount;
+		fc_stats->tx_frames +=3D READ_ONCE(stats->TxFrames);
+		fc_stats->tx_words +=3D READ_ONCE(stats->TxWords);
+		fc_stats->rx_frames +=3D READ_ONCE(stats->RxFrames);
+		fc_stats->rx_words +=3D READ_ONCE(stats->RxWords);
+		fc_stats->error_frames +=3D READ_ONCE(stats->ErrorFrames);
+		fc_stats->invalid_crc_count +=3D READ_ONCE(stats->InvalidCRCCount);
+		fc_stats->fcp_input_requests +=3D READ_ONCE(stats->InputRequests);
+		fc_stats->fcp_output_requests +=3D READ_ONCE(stats->OutputRequests);
+		fc_stats->fcp_control_requests +=3D READ_ONCE(stats->ControlRequests);
+		fcp_in_bytes +=3D READ_ONCE(stats->InputBytes);
+		fcp_out_bytes +=3D READ_ONCE(stats->OutputBytes);
+		fc_stats->fcp_packet_alloc_failures +=3D READ_ONCE(stats->FcpPktAllocFai=
ls);
+		fc_stats->fcp_packet_aborts +=3D READ_ONCE(stats->FcpPktAborts);
+		fc_stats->fcp_frame_alloc_failures +=3D READ_ONCE(stats->FcpFrameAllocFa=
ils);
+		fc_stats->link_failure_count +=3D READ_ONCE(stats->LinkFailureCount);
 	}
 	fc_stats->fcp_input_megabytes =3D div_u64(fcp_in_bytes, 1000000);
 	fc_stats->fcp_output_megabytes =3D div_u64(fcp_out_bytes, 1000000);
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cbe01915da8c1..3d6b137314f3f 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1067,7 +1067,6 @@ static int qedf_xmit(struct fc_lport *lport, struct f=
c_frame *fp)
 	u32			crc;
 	unsigned int		hlen, tlen, elen;
 	int			wlen;
-	struct fc_stats		*stats;
 	struct fc_lport *tmp_lport;
 	struct fc_lport *vn_port =3D NULL;
 	struct qedf_rport *fcport;
@@ -1215,10 +1214,8 @@ static int qedf_xmit(struct fc_lport *lport, struct =
fc_frame *fp)
 	hp->fcoe_sof =3D sof;
=20
 	/*update tx stats */
-	stats =3D per_cpu_ptr(lport->stats, get_cpu());
-	stats->TxFrames++;
-	stats->TxWords +=3D wlen;
-	put_cpu();
+	this_cpu_inc(lport->stats->TxFrames);
+	this_cpu_add(lport->stats->TxWords, wlen);
=20
 	/* Get VLAN ID from skb for printing purposes */
 	__vlan_hwaccel_get_tag(skb, &vlan_tci);
--=20
2.36.0

