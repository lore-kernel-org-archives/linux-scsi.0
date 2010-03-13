From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/16] libfc, libfcoe,
	fcoe: use smp_processor_id() only when preempt disabled
Date: Fri, 12 Mar 2010 16:08:55 -0800
Message-ID: <20100313000855.22251.94746.stgit@localhost.localdomain>
References: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42119 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMAI6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:08:58 -0500
In-Reply-To: <20100313000730.22251.54662.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When the kernel is configured for preemption, using smp_processor_id()
when preemption is enabled causes a warning backtrace and is wrong
since we could move off of that CPU as soon as we get the ID,
and we would be referencing the wrong CPU, and possibly an invalid one
if it could be hotswapped out.

Remove the fc_lport_get_stats() function and explicitly use per_cpu_ptr()
to get the statistics.  Where preemption has been disabled by holding
a _bh lock continue to use smp_processor_id(), but otherwise use
get_cpu()/put_cpu().

In fcoe_recv_frame() also changed the cases where we return in the
middle to do a goto to the code which bumps ErrorFrames and does
a put_cpu().  Two of these cases didn't bump ErrorFrames before, but
doing so is harmless because they "can't happen", due to prior length
checks.

Also rearranged code in fcoe_recv_frame() to have only one call to
fc_exch_recv().  It's just as efficient and saves a call to put_cpu().

In fc_fcp.c, adjusted a FIXME comment for code which doesn't need fixing.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c     |   51 +++++++++++++++++++++---------------------
 drivers/scsi/fcoe/libfcoe.c  |   19 +++++++++++-----
 drivers/scsi/libfc/fc_exch.c |    3 ++
 drivers/scsi/libfc/fc_fcp.c  |    8 ++++---
 include/scsi/libfc.h         |    9 -------
 5 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index feddb53..c9bf473 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1074,7 +1074,7 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	struct sk_buff *skb;
 #ifdef CONFIG_SMP
 	struct fcoe_percpu_s *p0;
-	unsigned targ_cpu = smp_processor_id();
+	unsigned targ_cpu = get_cpu();
 #endif /* CONFIG_SMP */
 
 	FCOE_DBG("Destroying receive thread for CPU %d\n", cpu);
@@ -1130,6 +1130,7 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 			kfree_skb(skb);
 		spin_unlock_bh(&p->fcoe_rx_list.lock);
 	}
+	put_cpu();
 #else
 	/*
 	 * This a non-SMP scenario where the singular Rx thread is
@@ -1298,8 +1299,8 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 
 	return 0;
 err:
-	fc_lport_get_stats(lport)->ErrorFrames++;
-
+	per_cpu_ptr(lport->dev_stats, get_cpu())->ErrorFrames++;
+	put_cpu();
 err2:
 	kfree_skb(skb);
 	return -1;
@@ -1528,9 +1529,10 @@ int fcoe_xmit(struct fc_lport *lport, struct fc_frame *fp)
 		skb_shinfo(skb)->gso_size = 0;
 	}
 	/* update tx stats: regardless if LLD fails */
-	stats = fc_lport_get_stats(lport);
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 	stats->TxFrames++;
 	stats->TxWords += wlen;
+	put_cpu();
 
 	/* send down to lld */
 	fr_dev(fp) = lport;
@@ -1594,7 +1596,7 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	hp = (struct fcoe_hdr *) skb_network_header(skb);
 	fh = (struct fc_frame_header *) skb_transport_header(skb);
 
-	stats = fc_lport_get_stats(lport);
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 	if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
 		if (stats->ErrorFrames < 5)
 			printk(KERN_WARNING "fcoe: FCoE version "
@@ -1603,9 +1605,7 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 			       "initiator supports version "
 			       "%x\n", FC_FCOE_DECAPS_VER(hp),
 			       FC_FCOE_VER);
-		stats->ErrorFrames++;
-		kfree_skb(skb);
-		return;
+		goto drop;
 	}
 
 	skb_pull(skb, sizeof(struct fcoe_hdr));
@@ -1620,16 +1620,12 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	fr_sof(fp) = hp->fcoe_sof;
 
 	/* Copy out the CRC and EOF trailer for access */
-	if (skb_copy_bits(skb, fr_len, &crc_eof, sizeof(crc_eof))) {
-		kfree_skb(skb);
-		return;
-	}
+	if (skb_copy_bits(skb, fr_len, &crc_eof, sizeof(crc_eof)))
+		goto drop;
 	fr_eof(fp) = crc_eof.fcoe_eof;
 	fr_crc(fp) = crc_eof.fcoe_crc32;
-	if (pskb_trim(skb, fr_len)) {
-		kfree_skb(skb);
-		return;
-	}
+	if (pskb_trim(skb, fr_len))
+		goto drop;
 
 	/*
 	 * We only check CRC if no offload is available and if it is
@@ -1643,25 +1639,27 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 		fr_flags(fp) |= FCPHF_CRC_UNCHECKED;
 
 	fh = fc_frame_header_get(fp);
-	if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
-	    fh->fh_type == FC_TYPE_FCP) {
-		fc_exch_recv(lport, fp);
-		return;
-	}
-	if (fr_flags(fp) & FCPHF_CRC_UNCHECKED) {
+	if ((fh->fh_r_ctl != FC_RCTL_DD_SOL_DATA ||
+	    fh->fh_type != FC_TYPE_FCP) &&
+	    (fr_flags(fp) & FCPHF_CRC_UNCHECKED)) {
 		if (le32_to_cpu(fr_crc(fp)) !=
 		    ~crc32(~0, skb->data, fr_len)) {
 			if (stats->InvalidCRCCount < 5)
 				printk(KERN_WARNING "fcoe: dropping "
 				       "frame with CRC error\n");
 			stats->InvalidCRCCount++;
-			stats->ErrorFrames++;
-			fc_frame_free(fp);
-			return;
+			goto drop;
 		}
 		fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 	}
+	put_cpu();
 	fc_exch_recv(lport, fp);
+	return;
+
+drop:
+	stats->ErrorFrames++;
+	put_cpu();
+	kfree_skb(skb);
 }
 
 /**
@@ -1834,8 +1832,9 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	if (link_possible && !fcoe_link_ok(lport))
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 	else if (fcoe_ctlr_link_down(&fcoe->ctlr)) {
-		stats = fc_lport_get_stats(lport);
+		stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 		stats->LinkFailureCount++;
+		put_cpu();
 		fcoe_clean_pending_queue(lport);
 	}
 out:
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index d60f332..626edd6 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -549,7 +549,7 @@ EXPORT_SYMBOL(fcoe_ctlr_els_send);
  * fcoe_ctlr_age_fcfs() - Reset and free all old FCFs for a controller
  * @fip: The FCoE controller to free FCFs on
  *
- * Called with lock held.
+ * Called with lock held and preemption disabled.
  *
  * An FCF is considered old if we have missed three advertisements.
  * That is, there have been no valid advertisement from it for three
@@ -566,17 +566,20 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 	struct fcoe_fcf *next;
 	unsigned long sel_time = 0;
 	unsigned long mda_time = 0;
+	struct fcoe_dev_stats *stats;
 
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
 		mda_time = fcf->fka_period + (fcf->fka_period >> 1);
 		if ((fip->sel_fcf == fcf) &&
 		    (time_after(jiffies, fcf->time + mda_time))) {
 			mod_timer(&fip->timer, jiffies + mda_time);
-			fc_lport_get_stats(fip->lp)->MissDiscAdvCount++;
+			stats = per_cpu_ptr(fip->lp->dev_stats,
+					    smp_processor_id());
+			stats->MissDiscAdvCount++;
 			printk(KERN_INFO "libfcoe: host%d: Missing Discovery "
 			       "Advertisement for fab %llx count %lld\n",
 			       fip->lp->host->host_no, fcf->fabric_name,
-			       fc_lport_get_stats(fip->lp)->MissDiscAdvCount);
+			       stats->MissDiscAdvCount);
 		}
 		if (time_after(jiffies, fcf->time + fcf->fka_period * 3 +
 			       msecs_to_jiffies(FIP_FCF_FUZZ * 3))) {
@@ -586,7 +589,9 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 			WARN_ON(!fip->fcf_count);
 			fip->fcf_count--;
 			kfree(fcf);
-			fc_lport_get_stats(fip->lp)->VLinkFailureCount++;
+			stats = per_cpu_ptr(fip->lp->dev_stats,
+					    smp_processor_id());
+			stats->VLinkFailureCount++;
 		} else if (fcoe_ctlr_mtu_valid(fcf) &&
 			   (!sel_time || time_before(sel_time, fcf->time))) {
 			sel_time = fcf->time;
@@ -899,9 +904,10 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	fr_eof(fp) = FC_EOF_T;
 	fr_dev(fp) = lport;
 
-	stats = fc_lport_get_stats(lport);
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 	stats->RxFrames++;
 	stats->RxWords += skb->len / FIP_BPW;
+	put_cpu();
 
 	fc_exch_recv(lport, fp);
 	return;
@@ -999,7 +1005,8 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 		LIBFCOE_FIP_DBG(fip, "performing Clear Virtual Link\n");
 
 		spin_lock_bh(&fip->lock);
-		fc_lport_get_stats(lport)->VLinkFailureCount++;
+		per_cpu_ptr(lport->dev_stats,
+			    smp_processor_id())->VLinkFailureCount++;
 		fcoe_ctlr_reset(fip);
 		spin_unlock_bh(&fip->lock);
 
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index fe1ceb3..549657a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -676,9 +676,10 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	}
 	memset(ep, 0, sizeof(*ep));
 
-	cpu = smp_processor_id();
+	cpu = get_cpu();
 	pool = per_cpu_ptr(mp->pool, cpu);
 	spin_lock_bh(&pool->lock);
+	put_cpu();
 	index = pool->next_index;
 	/* allocate new exch from pool */
 	while (fc_exch_ptr_get(pool, index)) {
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5340d00..be6a469 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -483,13 +483,14 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 
 		if (~crc != le32_to_cpu(fr_crc(fp))) {
 crc_err:
-			stats = fc_lport_get_stats(lport);
+			stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 			stats->ErrorFrames++;
-			/* FIXME - per cpu count, not total count! */
+			/* per cpu count, not total count, but OK for limit */
 			if (stats->InvalidCRCCount++ < 5)
 				printk(KERN_WARNING "libfc: CRC error on data "
 				       "frame for port (%6x)\n",
 				       fc_host_port_id(lport->host));
+			put_cpu();
 			/*
 			 * Assume the frame is total garbage.
 			 * We may have copied it over the good part
@@ -1818,7 +1819,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	/*
 	 * setup the data direction
 	 */
-	stats = fc_lport_get_stats(lport);
+	stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		fsp->req_flags = FC_SRB_READ;
 		stats->InputRequests++;
@@ -1831,6 +1832,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		fsp->req_flags = 0;
 		stats->ControlRequests++;
 	}
+	put_cpu();
 
 	fsp->tgt_flags = rpriv->flags;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 4b912ee..8d0d1b2 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -918,15 +918,6 @@ static inline void fc_lport_free_stats(struct fc_lport *lport)
 }
 
 /**
- * fc_lport_get_stats() - Get a local port's statistics
- * @lport: The local port whose statistics are to be retreived
- */
-static inline struct fcoe_dev_stats *fc_lport_get_stats(struct fc_lport *lport)
-{
-	return per_cpu_ptr(lport->dev_stats, smp_processor_id());
-}
-
-/**
  * lport_priv() - Return the private data from a local port
  * @lport: The local port whose private data is to be retreived
  */

