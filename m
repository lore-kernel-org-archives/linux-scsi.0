From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 21/64] fcoe: move the host-list add/remove to keep out VN_Ports
Date: Tue, 25 Aug 2009 14:00:18 -0700
Message-ID: <20090825210018.1553.74393.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31537 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbZHYVAP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:15 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

We only want the FCoE create and destroy routines to deal with top level
N_Ports, the VN_Ports are tracked on the vport list (see scsi_transport_fc).

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 43added..c9a0346 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -616,9 +616,6 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Logout of the fabric */
 	fc_fabric_logoff(lport);
 
-	/* Remove the instance from fcoe's list */
-	fcoe_hostlist_remove(lport);
-
 	/* Cleanup the fc_lport */
 	fc_lport_destroy(lport);
 	fc_fcp_destroy(lport);
@@ -757,11 +754,13 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 
 	/*
 	 * fcoe_em_alloc() and fcoe_hostlist_add() both
-	 * need to be atomic under fcoe_hostlist_lock
+	 * need to be atomic with respect to other changes to the hostlist
 	 * since fcoe_em_alloc() looks for an existing EM
 	 * instance on host list updated by fcoe_hostlist_add().
+	 *
+	 * This is currently handled through the fcoe_config_mutex begin held.
 	 */
-	write_lock(&fcoe_hostlist_lock);
+
 	/* lport exch manager allocation */
 	rc = fcoe_em_config(lport);
 	if (rc) {
@@ -770,10 +769,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_lp_destroy;
 	}
 
-	/* add to lports list */
-	fcoe_hostlist_add(lport);
-	write_unlock(&fcoe_hostlist_lock);
-
 	dev_hold(netdev);
 	fcoe_interface_get(fcoe);
 	return lport;
@@ -1713,6 +1708,8 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		rc = -ENODEV;
 		goto out_putdev;
 	}
+	/* Remove the instance from fcoe's list */
+	fcoe_hostlist_remove(lport);
 	port = lport_priv(lport);
 	fcoe = port->fcoe;
 	fcoe_if_destroy(lport);
@@ -1782,6 +1779,9 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	/* Make this the "master" N_Port */
 	fcoe->ctlr.lp = lport;
 
+	/* add to lports list */
+	fcoe_hostlist_add(lport);
+
 	/* start FIP Discovery and FLOGI */
 	lport->boot_time = jiffies;
 	fc_fabric_login(lport);
@@ -1954,8 +1954,6 @@ struct fc_lport *fcoe_hostlist_lookup(const struct net_device *netdev)
  * fcoe_hostlist_add() - Add a lport to lports list
  * @lp: ptr to the fc_lport to be added
  *
- * Called with write fcoe_hostlist_lock held.
- *
  * Returns: 0 for success
  */
 int fcoe_hostlist_add(const struct fc_lport *lport)
@@ -1963,12 +1961,14 @@ int fcoe_hostlist_add(const struct fc_lport *lport)
 	struct fcoe_interface *fcoe;
 	struct fcoe_port *port;
 
+	write_lock_bh(&fcoe_hostlist_lock);
 	fcoe = fcoe_hostlist_lookup_port(fcoe_netdev(lport));
 	if (!fcoe) {
 		port = lport_priv(lport);
 		fcoe = port->fcoe;
 		list_add_tail(&fcoe->list, &fcoe_hostlist);
 	}
+	write_unlock_bh(&fcoe_hostlist_lock);
 	return 0;
 }
 
@@ -2045,14 +2045,21 @@ static void __exit fcoe_exit(void)
 {
 	unsigned int cpu;
 	struct fcoe_interface *fcoe, *tmp;
+	LIST_HEAD(local_list);
 
 	mutex_lock(&fcoe_config_mutex);
 
 	fcoe_dev_cleanup();
 
 	/* releases the associated fcoe hosts */
-	list_for_each_entry_safe(fcoe, tmp, &fcoe_hostlist, list)
+	write_lock_bh(&fcoe_hostlist_lock);
+	list_splice_init(&fcoe_hostlist, &local_list);
+	write_unlock_bh(&fcoe_hostlist_lock);
+
+	list_for_each_entry_safe(fcoe, tmp, &local_list, list) {
+		list_del(&fcoe->list);
 		fcoe_if_destroy(fcoe->ctlr.lp);
+	}
 
 	unregister_hotcpu_notifier(&fcoe_cpu_notifier);
 

