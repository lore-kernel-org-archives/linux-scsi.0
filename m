From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/6] fcoe: Add runtime debug logging with module parameter
	debug_logging
Date: Mon, 01 Jun 2009 10:50:09 -0700
Message-ID: <20090601175009.12911.40575.stgit@fritz>
References: <20090601174948.12911.35446.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22416 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbZFARuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2009 13:50:07 -0400
In-Reply-To: <20090601174948.12911.35446.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This patch converts all FC_DBG statements to use new runtime tunable
debug macros. The fcoe.ko module now has a debug_logging module
parameter.

fcoe_debug_logging is an unsigned integer representing a bitmask of all
available logging levels. Currently only two logging levels are
supported-

   bit
LSB 0 = general fcoe logging
    1 = netdevice related logging

This patch also attempts to clean up some debug statement formatting
so it's more readable.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |  108 +++++++++++++++++++++++-----------------------
 drivers/scsi/fcoe/fcoe.h |   24 ++++++++++
 2 files changed, 77 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6f39d4e..8870948 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -45,8 +45,6 @@
 
 #include "fcoe.h"
 
-static int debug_fcoe;
-
 MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FCoE");
 MODULE_LICENSE("GPL v2");
@@ -307,23 +305,22 @@ static int fcoe_netdev_config(struct fc_lport *lp, struct net_device *netdev)
 #ifdef NETIF_F_FCOE_CRC
 	if (netdev->features & NETIF_F_FCOE_CRC) {
 		lp->crc_offload = 1;
-		printk(KERN_DEBUG "fcoe:%s supports FCCRC offload\n",
-		       netdev->name);
+		FCOE_NETDEV_DBG(netdev, "Supports FCCRC offload\n");
 	}
 #endif
 #ifdef NETIF_F_FSO
 	if (netdev->features & NETIF_F_FSO) {
 		lp->seq_offload = 1;
 		lp->lso_max = netdev->gso_max_size;
-		printk(KERN_DEBUG "fcoe:%s supports LSO for max len 0x%x\n",
-		       netdev->name, lp->lso_max);
+		FCOE_NETDEV_DBG(netdev, "Supports LSO for max len 0x%x\n",
+				lp->lso_max);
 	}
 #endif
 	if (netdev->fcoe_ddp_xid) {
 		lp->lro_enabled = 1;
 		lp->lro_xid = netdev->fcoe_ddp_xid;
-		printk(KERN_DEBUG "fcoe:%s supports LRO for max xid 0x%x\n",
-		       netdev->name, lp->lro_xid);
+		FCOE_NETDEV_DBG(netdev, "Supports LRO for max xid 0x%x\n",
+				lp->lro_xid);
 	}
 	skb_queue_head_init(&fc->fcoe_pending_queue);
 	fc->fcoe_pending_queue_active = 0;
@@ -409,7 +406,8 @@ static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
 	/* add the new host to the SCSI-ml */
 	rc = scsi_add_host(lp->host, dev);
 	if (rc) {
-		FC_DBG("fcoe_shost_config:error on scsi_add_host\n");
+		FCOE_NETDEV_DBG(fcoe_netdev(lp), "fcoe_shost_config: "
+				"error on scsi_add_host\n");
 		return rc;
 	}
 	sprintf(fc_host_symbolic_name(lp->host), "%s v%s over %s",
@@ -450,8 +448,7 @@ static int fcoe_if_destroy(struct net_device *netdev)
 
 	BUG_ON(!netdev);
 
-	printk(KERN_DEBUG "fcoe_if_destroy:interface on %s\n",
-	       netdev->name);
+	FCOE_NETDEV_DBG(netdev, "Destroying interface\n");
 
 	lp = fcoe_hostlist_lookup(netdev);
 	if (!lp)
@@ -562,8 +559,7 @@ static int fcoe_if_create(struct net_device *netdev)
 
 	BUG_ON(!netdev);
 
-	printk(KERN_DEBUG "fcoe_if_create:interface on %s\n",
-	       netdev->name);
+	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
 	lp = fcoe_hostlist_lookup(netdev);
 	if (lp)
@@ -572,7 +568,7 @@ static int fcoe_if_create(struct net_device *netdev)
 	shost = libfc_host_alloc(&fcoe_shost_template,
 				 sizeof(struct fcoe_softc));
 	if (!shost) {
-		FC_DBG("Could not allocate host structure\n");
+		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
 		return -ENOMEM;
 	}
 	lp = shost_priv(shost);
@@ -581,7 +577,8 @@ static int fcoe_if_create(struct net_device *netdev)
 	/* configure fc_lport, e.g., em */
 	rc = fcoe_lport_config(lp);
 	if (rc) {
-		FC_DBG("Could not configure lport\n");
+		FCOE_NETDEV_DBG(netdev, "Could not configure lport for the "
+				"interface\n");
 		goto out_host_put;
 	}
 
@@ -595,28 +592,32 @@ static int fcoe_if_create(struct net_device *netdev)
 	/* configure lport network properties */
 	rc = fcoe_netdev_config(lp, netdev);
 	if (rc) {
-		FC_DBG("Could not configure netdev for the interface\n");
+		FCOE_NETDEV_DBG(netdev, "Could not configure netdev for the "
+				"interface\n");
 		goto out_netdev_cleanup;
 	}
 
 	/* configure lport scsi host properties */
 	rc = fcoe_shost_config(lp, shost, &netdev->dev);
 	if (rc) {
-		FC_DBG("Could not configure shost for lport\n");
+		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
+				"interface\n");
 		goto out_netdev_cleanup;
 	}
 
 	/* lport exch manager allocation */
 	rc = fcoe_em_config(lp);
 	if (rc) {
-		FC_DBG("Could not configure em for lport\n");
+		FCOE_NETDEV_DBG(netdev, "Could not configure the EM for the "
+				"interface\n");
 		goto out_netdev_cleanup;
 	}
 
 	/* Initialize the library */
 	rc = fcoe_libfc_config(lp, &fcoe_libfc_fcn_templ);
 	if (rc) {
-		FC_DBG("Could not configure libfc for lport!\n");
+		FCOE_NETDEV_DBG(netdev, "Could not configure libfc for the "
+				"interface\n");
 		goto out_lp_destroy;
 	}
 
@@ -655,7 +656,7 @@ static int __init fcoe_if_init(void)
 		fc_attach_transport(&fcoe_transport_function);
 
 	if (!scsi_transport_fcoe_sw) {
-		printk(KERN_ERR "fcoe_init:fc_attach_transport() failed\n");
+		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
 		return -ENODEV;
 	}
 
@@ -716,7 +717,7 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	unsigned targ_cpu = smp_processor_id();
 #endif /* CONFIG_SMP */
 
-	printk(KERN_DEBUG "fcoe: Destroying receive thread for CPU %d\n", cpu);
+	FCOE_DBG("Destroying receive thread for CPU %d\n", cpu);
 
 	/* Prevent any new skbs from being queued for this CPU. */
 	p = &per_cpu(fcoe_percpu, cpu);
@@ -738,8 +739,8 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 		p0 = &per_cpu(fcoe_percpu, targ_cpu);
 		spin_lock_bh(&p0->fcoe_rx_list.lock);
 		if (p0->thread) {
-			FC_DBG("Moving frames from CPU %d to CPU %d\n",
-			       cpu, targ_cpu);
+			FCOE_DBG("Moving frames from CPU %d to CPU %d\n",
+				 cpu, targ_cpu);
 
 			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
 				__skb_queue_tail(&p0->fcoe_rx_list, skb);
@@ -805,12 +806,12 @@ static int fcoe_cpu_callback(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		FC_DBG("CPU %x online: Create Rx thread\n", cpu);
+		FCOE_DBG("CPU %x online: Create Rx thread\n", cpu);
 		fcoe_percpu_thread_create(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		FC_DBG("CPU %x offline: Remove Rx thread\n", cpu);
+		FCOE_DBG("CPU %x offline: Remove Rx thread\n", cpu);
 		fcoe_percpu_thread_destroy(cpu);
 		break;
 	default:
@@ -848,24 +849,21 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
 	lp = fc->ctlr.lp;
 	if (unlikely(lp == NULL)) {
-		FC_DBG("cannot find hba structure");
+		FCOE_NETDEV_DBG(dev, "Cannot find hba structure");
 		goto err2;
 	}
 	if (!lp->link_up)
 		goto err2;
 
-	if (unlikely(debug_fcoe)) {
-		FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
-		       "end:%p sum:%d dev:%s", skb->len, skb->data_len,
-		       skb->head, skb->data, skb_tail_pointer(skb),
-		       skb_end_pointer(skb), skb->csum,
-		       skb->dev ? skb->dev->name : "<NULL>");
-
-	}
+	FCOE_NETDEV_DBG(dev, "skb_info: len:%d data_len:%d head:%p "
+			"data:%p tail:%p end:%p sum:%d dev:%s",
+			skb->len, skb->data_len, skb->head, skb->data,
+			skb_tail_pointer(skb), skb_end_pointer(skb),
+			skb->csum, skb->dev ? skb->dev->name : "<NULL>");
 
 	/* check for FCOE packet type */
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
-		FC_DBG("wrong FC type frame");
+		FCOE_NETDEV_DBG(dev, "Wrong FC type frame");
 		goto err;
 	}
 
@@ -903,8 +901,9 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 		 * the first CPU now. For non-SMP systems this
 		 * will check the same CPU twice.
 		 */
-		FC_DBG("CPU is online, but no receive thread ready "
-		       "for incoming skb- using first online CPU.\n");
+		FCOE_NETDEV_DBG(dev, "CPU is online, but no receive thread "
+				"ready for incoming skb- using first online "
+				"CPU.\n");
 
 		spin_unlock_bh(&fps->fcoe_rx_list.lock);
 		cpu = first_cpu(cpu_online_map);
@@ -1203,19 +1202,17 @@ int fcoe_percpu_receive_thread(void *arg)
 		fr = fcoe_dev_from_skb(skb);
 		lp = fr->fr_dev;
 		if (unlikely(lp == NULL)) {
-			FC_DBG("invalid HBA Structure");
+			FCOE_NETDEV_DBG(skb->dev, "Invalid HBA Structure");
 			kfree_skb(skb);
 			continue;
 		}
 
-		if (unlikely(debug_fcoe)) {
-			FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
-			       "tail:%p end:%p sum:%d dev:%s",
-			       skb->len, skb->data_len,
-			       skb->head, skb->data, skb_tail_pointer(skb),
-			       skb_end_pointer(skb), skb->csum,
-			       skb->dev ? skb->dev->name : "<NULL>");
-		}
+		FCOE_NETDEV_DBG(skb->dev, "skb_info: len:%d data_len:%d "
+				"head:%p data:%p tail:%p end:%p sum:%d dev:%s",
+				skb->len, skb->data_len,
+				skb->head, skb->data, skb_tail_pointer(skb),
+				skb_end_pointer(skb), skb->csum,
+				skb->dev ? skb->dev->name : "<NULL>");
 
 		/*
 		 * Save source MAC address before discarding header.
@@ -1235,7 +1232,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		stats = fc_lport_get_stats(lp);
 		if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
 			if (stats->ErrorFrames < 5)
-				printk(KERN_WARNING "FCoE version "
+				printk(KERN_WARNING "fcoe: FCoE version "
 				       "mismatch: The frame has "
 				       "version %x, but the "
 				       "initiator supports version "
@@ -1288,7 +1285,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		if (fr_flags(fp) & FCPHF_CRC_UNCHECKED) {
 			if (le32_to_cpu(fr_crc(fp)) !=
 			    ~crc32(~0, skb->data, fr_len)) {
-				if (debug_fcoe || stats->InvalidCRCCount < 5)
+				if (stats->InvalidCRCCount < 5)
 					printk(KERN_WARNING "fcoe: dropping "
 					       "frame with CRC error\n");
 				stats->InvalidCRCCount++;
@@ -1434,7 +1431,8 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	case NETDEV_REGISTER:
 		break;
 	default:
-		FC_DBG("Unknown event %ld from netdev netlink\n", event);
+		FCOE_NETDEV_DBG(real_dev, "Unknown event %ld "
+				"from netdev netlink\n", event);
 	}
 	if (link_possible && !fcoe_link_ok(lp))
 		fcoe_ctlr_link_up(&fc->ctlr);
@@ -1507,8 +1505,8 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
 
 	owner = fcoe_netdev_to_module_owner(netdev);
 	if (owner) {
-		printk(KERN_DEBUG "fcoe:hold driver module %s for %s\n",
-		       module_name(owner), netdev->name);
+		FCOE_NETDEV_DBG(netdev, "Hold driver module %s\n",
+				module_name(owner));
 		return  try_module_get(owner);
 	}
 	return -ENODEV;
@@ -1529,8 +1527,8 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
 
 	owner = fcoe_netdev_to_module_owner(netdev);
 	if (owner) {
-		printk(KERN_DEBUG "fcoe:release driver module %s for %s\n",
-		       module_name(owner), netdev->name);
+		FCOE_NETDEV_DBG(netdev, "Release driver module %s\n",
+				module_name(owner));
 		module_put(owner);
 		return 0;
 	}
@@ -1561,7 +1559,7 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 	}
 	rc = fcoe_if_destroy(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_if_destroy(%s) failed\n",
+		printk(KERN_ERR "fcoe: Failed to destroy interface (%s)\n",
 		       netdev->name);
 		rc = -EIO;
 		goto out_putdev;
@@ -1600,7 +1598,7 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 
 	rc = fcoe_if_create(netdev);
 	if (rc) {
-		printk(KERN_ERR "fcoe: fcoe_if_create(%s) failed\n",
+		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
 		fcoe_ethdrv_put(netdev);
 		rc = -EIO;
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index a1eb8c1..0d724fa 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -40,6 +40,30 @@
 #define FCOE_MIN_XID		0x0001	/* the min xid supported by fcoe_sw */
 #define FCOE_MAX_XID		0x07ef	/* the max xid supported by fcoe_sw */
 
+unsigned int fcoe_debug_logging;
+module_param_named(debug_logging, fcoe_debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
+
+#define FCOE_LOGGING        0x01 /* General logging, not categorized */
+#define FCOE_NETDEV_LOGGING 0x02 /* Netdevice logging */
+
+#define FCOE_CHECK_LOGGING(LEVEL, CMD)					\
+do {                                                            	\
+	if (unlikely(fcoe_debug_logging & LEVEL))			\
+		do {							\
+			CMD;						\
+		} while (0);						\
+} while (0);
+
+#define FCOE_DBG(fmt, args...)						\
+	FCOE_CHECK_LOGGING(FCOE_LOGGING,				\
+			   printk(KERN_INFO "fcoe: " fmt, ##args);)
+
+#define FCOE_NETDEV_DBG(netdev, fmt, args...)			\
+	FCOE_CHECK_LOGGING(FCOE_NETDEV_LOGGING,			\
+			   printk(KERN_INFO "fcoe: %s" fmt,	\
+				  netdev->name, ##args);)
+
 /*
  * this percpu struct for fcoe
  */

