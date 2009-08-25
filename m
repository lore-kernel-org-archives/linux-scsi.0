From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 23/64] fcoe: use rtnl mutex in place of hostlist lock
Date: Tue, 25 Aug 2009 14:00:28 -0700
Message-ID: <20090825210028.1553.67220.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41749 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbZHYVA1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:27 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

This just cuts down on the number of locks we're dealing with, and
eliminates the need to take another lock in the netdev notifier.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   37 +++++++++++--------------------------
 1 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c0264a9..ac481ad 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -58,8 +58,8 @@ MODULE_PARM_DESC(ddp_min, "Minimum I/O size in bytes for "	\
 DEFINE_MUTEX(fcoe_config_mutex);
 
 /* fcoe host list */
+/* must only by accessed under the RTNL mutex */
 LIST_HEAD(fcoe_hostlist);
-DEFINE_RWLOCK(fcoe_hostlist_lock);
 DEFINE_PER_CPU(struct fcoe_percpu_s, fcoe_percpu);
 
 /* Function Prototypes */
@@ -527,8 +527,6 @@ bool fcoe_oem_match(struct fc_frame *fp)
  * fcoe_em_config() - allocates em for this lport
  * @lp: the fcoe that em is to allocated for
  *
- * Called with write fcoe_hostlist_lock held.
- *
  * Returns : 0 on success
  */
 static inline int fcoe_em_config(struct fc_lport *lp)
@@ -1539,7 +1537,6 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	u32 mfs;
 	int rc = NOTIFY_OK;
 
-	write_lock(&fcoe_hostlist_lock);
 	list_for_each_entry(fcoe, &fcoe_hostlist, list) {
 		if (fcoe->netdev == netdev) {
 			lp = fcoe->ctlr.lp;
@@ -1586,7 +1583,6 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		fcoe_clean_pending_queue(lp);
 	}
 out:
-	write_unlock(&fcoe_hostlist_lock);
 	return rc;
 }
 
@@ -1643,16 +1639,14 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		goto out_nodev;
 	}
 
-	write_lock(&fcoe_hostlist_lock);
+	rtnl_lock();
 	fcoe = fcoe_hostlist_lookup_port(netdev);
 	if (!fcoe) {
-		write_unlock(&fcoe_hostlist_lock);
+		rtnl_unlock();
 		rc = -ENODEV;
 		goto out_putdev;
 	}
 	list_del(&fcoe->list);
-	write_unlock(&fcoe_hostlist_lock);
-	rtnl_lock();
 	fcoe_interface_cleanup(fcoe);
 	rtnl_unlock();
 	fcoe_if_destroy(fcoe->ctlr.lp);
@@ -1870,9 +1864,8 @@ int fcoe_reset(struct Scsi_Host *shost)
  * fcoe_hostlist_lookup_port() - find the corresponding lport by a given device
  * @dev: this is currently ptr to net_device
  *
- * Called with fcoe_hostlist_lock held.
- *
  * Returns: NULL or the located fcoe_port
+ * Locking: must be called with the RNL mutex held
  */
 static struct fcoe_interface *
 fcoe_hostlist_lookup_port(const struct net_device *dev)
@@ -1891,15 +1884,13 @@ fcoe_hostlist_lookup_port(const struct net_device *dev)
  * @netdev: ptr to net_device
  *
  * Returns: 0 for success
+ * Locking: must be called with the RTNL mutex held
  */
-struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
+static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
 {
 	struct fcoe_interface *fcoe;
 
-	read_lock(&fcoe_hostlist_lock);
 	fcoe = fcoe_hostlist_lookup_port(netdev);
-	read_unlock(&fcoe_hostlist_lock);
-
 	return (fcoe) ? fcoe->ctlr.lp : NULL;
 }
 
@@ -1908,20 +1899,19 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
  * @lp: ptr to the fc_lport to be added
  *
  * Returns: 0 for success
+ * Locking: must be called with the RTNL mutex held
  */
-int fcoe_hostlist_add(const struct fc_lport *lport)
+static int fcoe_hostlist_add(const struct fc_lport *lport)
 {
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
 
-	write_lock_bh(&fcoe_hostlist_lock);
 	fcoe = fcoe_hostlist_lookup_port(fcoe_netdev(lport));
 	if (!fcoe) {
 		port = lport_priv(lport);
 		fcoe = port->fcoe;
 		list_add_tail(&fcoe->list, &fcoe_hostlist);
 	}
-	write_unlock_bh(&fcoe_hostlist_lock);
 	return 0;
 }
 
@@ -1979,7 +1969,6 @@ static void __exit fcoe_exit(void)
 {
 	unsigned int cpu;
 	struct fcoe_interface *fcoe, *tmp;
-	LIST_HEAD(local_list);
 	struct fcoe_port *port;
 
 	mutex_lock(&fcoe_config_mutex);
@@ -1987,18 +1976,14 @@ static void __exit fcoe_exit(void)
 	fcoe_dev_cleanup();
 
 	/* releases the associated fcoe hosts */
-	write_lock_bh(&fcoe_hostlist_lock);
-	list_splice_init(&fcoe_hostlist, &local_list);
-	write_unlock_bh(&fcoe_hostlist_lock);
-
-	list_for_each_entry_safe(fcoe, tmp, &local_list, list) {
+	rtnl_lock();
+	list_for_each_entry_safe(fcoe, tmp, &fcoe_hostlist, list) {
 		list_del(&fcoe->list);
 		port = lport_priv(fcoe->ctlr.lp);
-		rtnl_lock();
 		fcoe_interface_cleanup(fcoe);
-		rtnl_unlock();
 		schedule_work(&port->destroy_work);
 	}
+	rtnl_unlock();
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 

