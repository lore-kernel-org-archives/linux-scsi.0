From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/11] fcoe: fix spelling typos and bad comments
Date: Tue, 21 Apr 2009 16:27:36 -0700
Message-ID: <20090421232735.8165.30537.stgit@fritz>
References: <20090421232647.8165.46673.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37541 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbZDUX1i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 19:27:38 -0400
In-Reply-To: <20090421232647.8165.46673.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c    |   47 ++++++++++++++++++-------------------------
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 7bd0e82..8ad1265 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -57,7 +57,7 @@ DEFINE_RWLOCK(fcoe_hostlist_lock);
 DEFINE_TIMER(fcoe_timer, NULL, 0, 0);
 DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
-/* Function Prototyes */
+/* Function Prototypes */
 static int fcoe_reset(struct Scsi_Host *shost);
 static int fcoe_xmit(struct fc_lport *, struct fc_frame *);
 static int fcoe_rcv(struct sk_buff *, struct net_device *,
@@ -138,7 +138,6 @@ static struct scsi_host_template fcoe_shost_template = {
 /**
  * fcoe_lport_config() - sets up the fc_lport
  * @lp: ptr to the fc_lport
- * @shost: ptr to the parent scsi host
  *
  * Returns: 0 for success
  */
@@ -380,7 +379,7 @@ static int fcoe_if_destroy(struct net_device *netdev)
 	dev_mc_delete(fc->real_dev, FIP_ALL_ENODE_MACS, ETH_ALEN, 0);
 	rtnl_unlock();
 
-	/* Free the per-CPU revieve threads */
+	/* Free the per-CPU receive threads */
 	fcoe_percpu_clean(lp);
 
 	/* Free existing skbs */
@@ -720,7 +719,7 @@ static void fcoe_percpu_thread_destroy(unsigned int cpu)
 	}
 #else
 	/*
-	 * This a non-SMP scenario where the singluar Rx thread is
+	 * This a non-SMP scenario where the singular Rx thread is
 	 * being removed. Free all skbs and stop the thread.
 	 */
 	spin_lock_bh(&p->fcoe_rx_list.lock);
@@ -777,7 +776,7 @@ static struct notifier_block fcoe_cpu_notifier = {
  * @skb: the receive skb
  * @dev: associated net device
  * @ptype: context
- * @odldev: last device
+ * @olddev: last device
  *
  * this function will receive the packet and build fc frame and pass it up
  *
@@ -904,7 +903,7 @@ static inline int fcoe_start_io(struct sk_buff *skb)
 }
 
 /**
- * fcoe_get_paged_crc_eof() - in case we need alloc a page for crc_eof
+ * fcoe_get_paged_crc_eof() - in case we need to alloc a page for crc_eof
  * @skb: the skb to be xmitted
  * @tlen: total len
  *
@@ -946,7 +945,7 @@ static int fcoe_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 
 /**
  * fcoe_fc_crc() - calculates FC CRC in this fcoe skb
- * @fp: the fc_frame containg data to be checksummed
+ * @fp: the fc_frame containing data to be checksummed
  *
  * This uses crc32() to calculate the crc for fc frame
  * Return   : 32 bit crc
@@ -1061,7 +1060,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 		cp = NULL;
 	}
 
-	/* adjust skb netowrk/transport offsets to match mac/fcoe/fc */
+	/* adjust skb network/transport offsets to match mac/fcoe/fc */
 	skb_push(skb, elen + hlen);
 	skb_reset_mac_header(skb);
 	skb_reset_network_header(skb);
@@ -1294,17 +1293,16 @@ void fcoe_watchdog(ulong vp)
 
 
 /**
- * fcoe_check_wait_queue() - put the skb into fcoe pending xmit queue
- * @lp: the fc_port for this skb
- * @skb: the associated skb to be xmitted
+ * fcoe_check_wait_queue() - attempt to clear the transmit backlog
+ * @lp: the fc_lport
  *
  * This empties the wait_queue, dequeue the head of the wait_queue queue
  * and calls fcoe_start_io() for each packet, if all skb have been
  * transmitted, return qlen or -1 if a error occurs, then restore
- * wait_queue and  try again later.
+ * wait_queue and try again later.
  *
  * The wait_queue is used when the skb transmit fails. skb will go
- * in the wait_queue which will be emptied by the time function OR
+ * in the wait_queue which will be emptied by the timer function or
  * by the next skb transmit.
  *
  * Returns: 0 for success
@@ -1353,10 +1351,6 @@ out:
  */
 static void fcoe_dev_setup()
 {
-	/*
-	 * here setup a interface specific wd time to
-	 * monitor the link state
-	 */
 	register_netdevice_notifier(&fcoe_notifier);
 }
 
@@ -1435,10 +1429,9 @@ out:
 
 /**
  * fcoe_if_to_netdev() - parse a name buffer to get netdev
- * @ifname: fixed array for output parsed ifname
  * @buffer: incoming buffer to be copied
  *
- * Returns: NULL or ptr to netdeive
+ * Returns: NULL or ptr to net_device
  */
 static struct net_device *fcoe_if_to_netdev(const char *buffer)
 {
@@ -1456,7 +1449,7 @@ static struct net_device *fcoe_if_to_netdev(const char *buffer)
 }
 
 /**
- * fcoe_netdev_to_module_owner() - finds out the nic drive moddule of the netdev
+ * fcoe_netdev_to_module_owner() - finds out the driver module of the netdev
  * @netdev: the target netdev
  *
  * Returns: ptr to the struct module, NULL for failure
@@ -1486,7 +1479,7 @@ fcoe_netdev_to_module_owner(const struct net_device *netdev)
  * Holds the Ethernet driver module by try_module_get() for
  * the corresponding netdev.
  *
- * Returns: 0 for succsss
+ * Returns: 0 for success
  */
 static int fcoe_ethdrv_get(const struct net_device *netdev)
 {
@@ -1508,7 +1501,7 @@ static int fcoe_ethdrv_get(const struct net_device *netdev)
  * Releases the Ethernet driver module by module_put for
  * the corresponding netdev.
  *
- * Returns: 0 for succsss
+ * Returns: 0 for success
  */
 static int fcoe_ethdrv_put(const struct net_device *netdev)
 {
@@ -1526,7 +1519,7 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
 
 /**
  * fcoe_destroy() - handles the destroy from sysfs
- * @buffer: expcted to be a eth if name
+ * @buffer: expected to be an eth if name
  * @kp: associated kernel param
  *
  * Returns: 0 for success
@@ -1563,7 +1556,7 @@ out_nodev:
 
 /**
  * fcoe_create() - Handles the create call from sysfs
- * @buffer: expcted to be a eth if name
+ * @buffer: expected to be an eth if name
  * @kp: associated kernel param
  *
  * Returns: 0 for success
@@ -1717,7 +1710,7 @@ int fcoe_reset(struct Scsi_Host *shost)
 
 /**
  * fcoe_hostlist_lookup_softc() - find the corresponding lport by a given device
- * @device: this is currently ptr to net_device
+ * @dev: this is currently ptr to net_device
  *
  * Returns: NULL or the located fcoe_softc
  */
@@ -1754,7 +1747,7 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 
 /**
  * fcoe_hostlist_add() - Add a lport to lports list
- * @lp: ptr to the fc_lport to badded
+ * @lp: ptr to the fc_lport to be added
  *
  * Returns: 0 for success
  */
@@ -1774,7 +1767,7 @@ int fcoe_hostlist_add(const struct fc_lport *lp)
 
 /**
  * fcoe_hostlist_remove() - remove a lport from lports list
- * @lp: ptr to the fc_lport to badded
+ * @lp: ptr to the fc_lport to be removed
  *
  * Returns: 0 for success
  */
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index f410f4a..62ba0f3 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -122,7 +122,7 @@ static void fcoe_ctlr_reset_fcfs(struct fcoe_ctlr *fip)
 }
 
 /**
- * fcoe_ctrl_destroy() - Disable and tear-down the FCoE controller.
+ * fcoe_ctlr_destroy() - Disable and tear-down the FCoE controller.
  * @fip:	FCoE controller.
  *
  * This is called by FCoE drivers before freeing the &fcoe_ctlr.

