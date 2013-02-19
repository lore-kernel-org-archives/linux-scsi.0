From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/21] fcoe: close race on link speed detection in fcoe code
Date: Tue, 19 Feb 2013 11:32:10 -0800
Message-ID: <20130219193210.10192.26226.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:58462 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397Ab3BSTcV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:32:21 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Yi Zou <yi.zou@intel.com>

From: Neil Horman <nhorman@tuxdriver.com>

When creating an fcoe interfce, we call fcoe_link_speed_update before we add the
lports fcoe interface to the fc_hostlist.  Since network device events like
NETDEV_CHANGE are only processed if an fcoe interface is found with an
underlying netdev that matches the netdev of the event.  Since this processing
in fcoe_device_notification is how link_speed changes get communicated to the
libfc  code (via fcoe_link_speed_update), we have a race condition - if a
NETDEV_CHANGE event is sent after the call to fcoe_link_speed_update in
fcoe_netdev_config, but before we add the interface to the fc_hostlist, we will
loose the event and attributes like /sys/class/fc_host/hostX/speed will not get
updated properly.

Fix this by moving the add to the fc_hostlist above the serialized call to
fcoe_netdev_config, ensuring that we catch netdev envents before we make a
direct call to fcoe_link_speed_update.

Also use this opportunity to clean up access to the fc_hostlist a bit by
creating a fcoe_hostlist_del accessor and replacing the cleanup in fcoe_exit to
use it properly.

Tested by myself successfully

[ Comment over 80 chars broken into multi-line by Robert Love to
  satisfy checkpatch.pl ]

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 0b33368..d605700 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -86,6 +86,7 @@ static int fcoe_link_ok(struct fc_lport *);
 
 static struct fc_lport *fcoe_hostlist_lookup(const struct net_device *);
 static int fcoe_hostlist_add(const struct fc_lport *);
+static void fcoe_hostlist_del(const struct fc_lport *);
 
 static int fcoe_device_notification(struct notifier_block *, ulong, void *);
 static void fcoe_dev_setup(void);
@@ -1119,6 +1120,12 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	port->min_queue_depth = FCOE_MIN_QUEUE_DEPTH;
 	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
 
+	/*
+	 * Need to add the lport to the hostlist
+	 * so we catch NETDEV_CHANGE events.
+	 */
+	fcoe_hostlist_add(lport);
+
 	/* configure a fc_lport including the exchange manager */
 	rc = fcoe_lport_config(lport);
 	if (rc) {
@@ -1190,6 +1197,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 out_lp_destroy:
 	fc_exch_mgr_free(lport);
 out_host_put:
+	fcoe_hostlist_del(lport);
 	scsi_host_put(lport->host);
 out:
 	return ERR_PTR(rc);
@@ -2313,9 +2321,6 @@ static int _fcoe_create(struct net_device *netdev, enum fip_state fip_mode,
 	/* setup DCB priority attributes. */
 	fcoe_dcb_create(fcoe);
 
-	/* add to lports list */
-	fcoe_hostlist_add(lport);
-
 	/* start FIP Discovery and FLOGI */
 	lport->boot_time = jiffies;
 	fc_fabric_login(lport);
@@ -2523,6 +2528,24 @@ static int fcoe_hostlist_add(const struct fc_lport *lport)
 	return 0;
 }
 
+/**
+ * fcoe_hostlist_del() - Remove the FCoE interface identified by a local
+ *			 port to the hostlist
+ * @lport: The local port that identifies the FCoE interface to be added
+ *
+ * Locking: must be called with the RTNL mutex held
+ *
+ */
+static void fcoe_hostlist_del(const struct fc_lport *lport)
+{
+	struct fcoe_interface *fcoe;
+	struct fcoe_port *port;
+
+	port = lport_priv(lport);
+	fcoe = port->priv;
+	list_del(&fcoe->list);
+	return;
+}
 
 static struct fcoe_transport fcoe_sw_transport = {
 	.name = {FCOE_TRANSPORT_DEFAULT},
@@ -2613,9 +2636,9 @@ static void __exit fcoe_exit(void)
 	/* releases the associated fcoe hosts */
 	rtnl_lock();
 	list_for_each_entry_safe(fcoe, tmp, &fcoe_hostlist, list) {
-		list_del(&fcoe->list);
 		ctlr = fcoe_to_ctlr(fcoe);
 		port = lport_priv(ctlr->lp);
+		fcoe_hostlist_del(port->lport);
 		queue_work(fcoe_wq, &port->destroy_work);
 	}
 	rtnl_unlock();

