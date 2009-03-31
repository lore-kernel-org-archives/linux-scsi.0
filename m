From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/14 v2] fcoe: Use per-CPU kernel function for dev_stats
	instead of an array
Date: Tue, 31 Mar 2009 15:51:50 -0700
Message-ID: <20090331225150.14562.96936.stgit@fritz>
References: <20090317184140.22987.74322.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbZCaWvw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Mar 2009 18:51:52 -0400
In-Reply-To: <20090317184140.22987.74322.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Remove the hotplug creation of dev_stats, we allocate for all possible CPUs
now when we allocate the lport.

v2: Durring the 2.6.30 merge window, before these patches were comitted,
'percpu_ptr' was renamed 'per_cpu_ptr'. This latest update updates this
patch for the name change.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe_sw.c   |   13 +---
 drivers/scsi/fcoe/libfcoe.c   |  143 +++++------------------------------------
 drivers/scsi/libfc/fc_fcp.c   |    8 +-
 drivers/scsi/libfc/fc_lport.c |   11 ++-
 include/scsi/libfc.h          |   23 ++++++-
 5 files changed, 53 insertions(+), 145 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index 2bbbe3c..a675390 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -113,8 +113,6 @@ static struct scsi_host_template fcoe_sw_shost_template = {
  */
 static int fcoe_sw_lport_config(struct fc_lport *lp)
 {
-	int i = 0;
-
 	lp->link_up = 0;
 	lp->qfull = 0;
 	lp->max_retry_count = 3;
@@ -123,12 +121,7 @@ static int fcoe_sw_lport_config(struct fc_lport *lp)
 	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
 			      FCP_SPPF_RETRY | FCP_SPPF_CONF_COMPL);
 
-	/*
-	 * allocate per cpu stats block
-	 */
-	for_each_online_cpu(i)
-		lp->dev_stats[i] = kzalloc(sizeof(struct fcoe_dev_stats),
-					   GFP_KERNEL);
+	fc_lport_init_stats(lp);
 
 	/* lport fc_lport related configuration */
 	fc_lport_config(lp);
@@ -311,7 +304,6 @@ static inline int fcoe_sw_em_config(struct fc_lport *lp)
  */
 static int fcoe_sw_destroy(struct net_device *netdev)
 {
-	int cpu;
 	struct fc_lport *lp = NULL;
 	struct fcoe_softc *fc;
 	u8 flogi_maddr[ETH_ALEN];
@@ -363,8 +355,7 @@ static int fcoe_sw_destroy(struct net_device *netdev)
 	fcoe_clean_pending_queue(lp);
 
 	/* Free memory used by statistical counters */
-	for_each_online_cpu(cpu)
-		kfree(lp->dev_stats[cpu]);
+	fc_lport_free_stats(lp);
 
 	/* Release the net_device and Scsi_Host */
 	dev_put(fc->real_dev);
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index d22275b..648a2fc 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -71,9 +71,6 @@ DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 /* Function Prototyes */
 static int fcoe_check_wait_queue(struct fc_lport *);
 static void fcoe_recv_flogi(struct fcoe_softc *, struct fc_frame *, u8 *);
-#ifdef CONFIG_HOTPLUG_CPU
-static int fcoe_cpu_callback(struct notifier_block *, ulong, void *);
-#endif /* CONFIG_HOTPLUG_CPU */
 static int fcoe_device_notification(struct notifier_block *, ulong, void *);
 static void fcoe_dev_setup(void);
 static void fcoe_dev_cleanup(void);
@@ -83,87 +80,6 @@ static struct notifier_block fcoe_notifier = {
 	.notifier_call = fcoe_device_notification,
 };
 
-
-#ifdef CONFIG_HOTPLUG_CPU
-static struct notifier_block fcoe_cpu_notifier = {
-	.notifier_call = fcoe_cpu_callback,
-};
-
-/**
- * fcoe_create_percpu_data() - creates the associated cpu data
- * @cpu: index for the cpu where fcoe cpu data will be created
- *
- * create percpu stats block, from cpu add notifier
- *
- * Returns: none
- */
-static void fcoe_create_percpu_data(unsigned int cpu)
-{
-	struct fc_lport *lp;
-	struct fcoe_softc *fc;
-
-	write_lock_bh(&fcoe_hostlist_lock);
-	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		lp = fc->lp;
-		if (lp->dev_stats[cpu] == NULL)
-			lp->dev_stats[cpu] =
-				kzalloc(sizeof(struct fcoe_dev_stats),
-					GFP_KERNEL);
-	}
-	write_unlock_bh(&fcoe_hostlist_lock);
-}
-
-/**
- * fcoe_destroy_percpu_data() - destroys the associated cpu data
- * @cpu: index for the cpu where fcoe cpu data will destroyed
- *
- * destroy percpu stats block called by cpu add/remove notifier
- *
- * Retuns: none
- */
-static void fcoe_destroy_percpu_data(unsigned int cpu)
-{
-	struct fc_lport *lp;
-	struct fcoe_softc *fc;
-
-	write_lock_bh(&fcoe_hostlist_lock);
-	list_for_each_entry(fc, &fcoe_hostlist, list) {
-		lp = fc->lp;
-		kfree(lp->dev_stats[cpu]);
-		lp->dev_stats[cpu] = NULL;
-	}
-	write_unlock_bh(&fcoe_hostlist_lock);
-}
-
-/**
- * fcoe_cpu_callback() - fcoe cpu hotplug event callback
- * @nfb: callback data block
- * @action: event triggering the callback
- * @hcpu: index for the cpu of this event
- *
- * this creates or destroys per cpu data for fcoe
- *
- * Returns NOTIFY_OK always.
- */
-static int fcoe_cpu_callback(struct notifier_block *nfb, unsigned long action,
-			     void *hcpu)
-{
-	unsigned int cpu = (unsigned long)hcpu;
-
-	switch (action) {
-	case CPU_ONLINE:
-		fcoe_create_percpu_data(cpu);
-		break;
-	case CPU_DEAD:
-		fcoe_destroy_percpu_data(cpu);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-#endif /* CONFIG_HOTPLUG_CPU */
-
 /**
  * fcoe_rcv() - this is the fcoe receive function called by NET_RX_SOFTIRQ
  * @skb: the receive skb
@@ -181,7 +97,6 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fc_lport *lp;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_softc *fc;
-	struct fcoe_dev_stats *stats;
 	struct fc_frame_header *fh;
 	struct fcoe_percpu_s *fps;
 	unsigned short oxid;
@@ -252,13 +167,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	return 0;
 err:
-#ifdef CONFIG_SMP
-	stats = lp->dev_stats[smp_processor_id()];
-#else
-	stats = lp->dev_stats[0];
-#endif
-	if (stats)
-		stats->ErrorFrames++;
+	fc_lport_get_stats(lp)->ErrorFrames++;
 
 err2:
 	kfree_skb(skb);
@@ -495,11 +404,9 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	}
 #endif
 	/* update tx stats: regardless if LLD fails */
-	stats = lp->dev_stats[smp_processor_id()];
-	if (stats) {
-		stats->TxFrames++;
-		stats->TxWords += wlen;
-	}
+	stats = fc_lport_get_stats(lp);
+	stats->TxFrames++;
+	stats->TxWords += wlen;
 
 	/* send down to lld */
 	fr_dev(fp) = lp;
@@ -565,8 +472,6 @@ int fcoe_percpu_receive_thread(void *arg)
 			continue;
 		}
 
-		stats = lp->dev_stats[smp_processor_id()];
-
 		if (unlikely(debug_fcoe)) {
 			FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
 			       "tail:%p end:%p sum:%d dev:%s",
@@ -593,13 +498,16 @@ int fcoe_percpu_receive_thread(void *arg)
 		hp = (struct fcoe_hdr *) skb_network_header(skb);
 		fh = (struct fc_frame_header *) skb_transport_header(skb);
 
+		stats = fc_lport_get_stats(lp);
 		if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
-			if (stats) {
-				if (stats->ErrorFrames < 5)
-					FC_DBG("unknown FCoE version %x",
-					       FC_FCOE_DECAPS_VER(hp));
-				stats->ErrorFrames++;
-			}
+			if (stats->ErrorFrames < 5)
+				printk(KERN_WARNING "FCoE version "
+				       "mismatch: The frame has "
+				       "version %x, but the "
+				       "initiator supports version "
+				       "%x\n", FC_FCOE_DECAPS_VER(hp),
+				       FC_FCOE_VER);
+			stats->ErrorFrames++;
 			kfree_skb(skb);
 			continue;
 		}
@@ -607,10 +515,8 @@ int fcoe_percpu_receive_thread(void *arg)
 		skb_pull(skb, sizeof(struct fcoe_hdr));
 		fr_len = skb->len - sizeof(struct fcoe_crc_eof);
 
-		if (stats) {
-			stats->RxFrames++;
-			stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
-		}
+		stats->RxFrames++;
+		stats->RxWords += fr_len / FCOE_WORD_TO_BYTE;
 
 		fp = (struct fc_frame *)skb;
 		fc_frame_init(fp);
@@ -885,9 +791,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		if (new_link_up)
 			fc_linkup(lp);
 		else {
-			stats = lp->dev_stats[smp_processor_id()];
-			if (stats)
-				stats->LinkFailureCount++;
+			stats = fc_lport_get_stats(lp);
+			stats->LinkFailureCount++;
 			fc_linkdown(lp);
 			fcoe_clean_pending_queue(lp);
 		}
@@ -1371,10 +1276,6 @@ static int __init fcoe_init(void)
 	INIT_LIST_HEAD(&fcoe_hostlist);
 	rwlock_init(&fcoe_hostlist_lock);
 
-#ifdef CONFIG_HOTPLUG_CPU
-	register_cpu_notifier(&fcoe_cpu_notifier);
-#endif /* CONFIG_HOTPLUG_CPU */
-
 	for_each_possible_cpu(cpu) {
 		p = &per_cpu(fcoe_percpu, cpu);
 		skb_queue_head_init(&p->fcoe_rx_list);
@@ -1430,17 +1331,9 @@ static void __exit fcoe_exit(void)
 	struct fcoe_percpu_s *p;
 	struct sk_buff *skb;
 
-	/*
-	 * Stop all call back interfaces
-	 */
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_cpu_notifier(&fcoe_cpu_notifier);
-#endif /* CONFIG_HOTPLUG_CPU */
 	fcoe_dev_cleanup();
 
-	/*
-	 * stop timer
-	 */
+	/* Stop the timer */
 	del_timer_sync(&fcoe_timer);
 
 	/* releases the associated fcoe transport for each lport */
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a5725f3..0997e8b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -407,10 +407,12 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 
 		if (~crc != le32_to_cpu(fr_crc(fp))) {
 crc_err:
-			stats = lp->dev_stats[smp_processor_id()];
+			stats = fc_lport_get_stats(lp);
 			stats->ErrorFrames++;
+			/* FIXME - per cpu count, not total count! */
 			if (stats->InvalidCRCCount++ < 5)
-				FC_DBG("CRC error on data frame\n");
+				printk(KERN_WARNING "CRC error on data frame for port (%6x)\n",
+				       fc_host_port_id(lp->host));
 			/*
 			 * Assume the frame is total garbage.
 			 * We may have copied it over the good part
@@ -1752,7 +1754,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	/*
 	 * setup the data direction
 	 */
-	stats = lp->dev_stats[smp_processor_id()];
+	stats = fc_lport_get_stats(lp);
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		fsp->req_flags = FC_SRB_READ;
 		stats->InputRequests++;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 7ef4450..b8178ef 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -267,10 +267,10 @@ EXPORT_SYMBOL(fc_get_host_speed);
 
 struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 {
-	int i;
 	struct fc_host_statistics *fcoe_stats;
 	struct fc_lport *lp = shost_priv(shost);
 	struct timespec v0, v1;
+	unsigned int cpu;
 
 	fcoe_stats = &lp->host_stats;
 	memset(fcoe_stats, 0, sizeof(struct fc_host_statistics));
@@ -279,10 +279,11 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	jiffies_to_timespec(lp->boot_time, &v1);
 	fcoe_stats->seconds_since_last_reset = (v0.tv_sec - v1.tv_sec);
 
-	for_each_online_cpu(i) {
-		struct fcoe_dev_stats *stats = lp->dev_stats[i];
-		if (stats == NULL)
-			continue;
+	for_each_possible_cpu(cpu) {
+		struct fcoe_dev_stats *stats;
+
+		stats = per_cpu_ptr(lp->dev_stats, cpu);
+
 		fcoe_stats->tx_frames += stats->TxFrames;
 		fcoe_stats->tx_words += stats->TxWords;
 		fcoe_stats->rx_frames += stats->RxFrames;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index a70eafa..4e1d394 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -22,6 +22,7 @@
 
 #include <linux/timer.h>
 #include <linux/if.h>
+#include <linux/percpu.h>
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
@@ -661,7 +662,8 @@ struct fc_lport {
 	unsigned long		boot_time;
 
 	struct fc_host_statistics host_stats;
-	struct fcoe_dev_stats	*dev_stats[NR_CPUS];
+	struct fcoe_dev_stats	*dev_stats;
+
 	u64			wwpn;
 	u64			wwnn;
 	u8			retry_count;
@@ -722,6 +724,25 @@ static inline void fc_lport_state_enter(struct fc_lport *lp,
 	lp->state = state;
 }
 
+static inline int fc_lport_init_stats(struct fc_lport *lp)
+{
+	/* allocate per cpu stats block */
+	lp->dev_stats = alloc_percpu(struct fcoe_dev_stats);
+	if (!lp->dev_stats)
+		return -ENOMEM;
+	return 0;
+}
+
+static inline void fc_lport_free_stats(struct fc_lport *lp)
+{
+	free_percpu(lp->dev_stats);
+}
+
+static inline struct fcoe_dev_stats *fc_lport_get_stats(struct fc_lport *lp)
+{
+	return per_cpu_ptr(lp->dev_stats, smp_processor_id());
+}
+
 
 /*
  * LOCAL PORT LAYER

