From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 03/10] fcoe: Remove reference counting on 'stuct
 fcoe_interface'
Date: Mon, 22 Aug 2011 15:48:37 -0700
Message-ID: <20110822224837.1854.76107.stgit@localhost6.localdomain6>
References: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab1HVWsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:48:42 -0400
In-Reply-To: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The reference counting was necessary on these instances
because it was possible for NPIV ports to be destroyed
after the N_Port. A previous patch ensures that all NPIV
ports are destroyed before the N_Port making the need to
track references on the interface unnecessary.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   48 +++++-----------------------------------------
 drivers/scsi/fcoe/fcoe.h |    3 ---
 2 files changed, 5 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 30ead6f..f61e1dc 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -356,7 +356,6 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 	}
 
 	dev_hold(netdev);
-	kref_init(&fcoe->kref);
 
 	/*
 	 * Initialize FIP.
@@ -384,42 +383,6 @@ out:
 }
 
 /**
- * fcoe_interface_release() - fcoe_port kref release function
- * @kref: Embedded reference count in an fcoe_interface struct
- */
-static void fcoe_interface_release(struct kref *kref)
-{
-	struct fcoe_interface *fcoe;
-	struct net_device *netdev;
-
-	fcoe = container_of(kref, struct fcoe_interface, kref);
-	netdev = fcoe->netdev;
-	/* tear-down the FCoE controller */
-	fcoe_ctlr_destroy(&fcoe->ctlr);
-	kfree(fcoe);
-	dev_put(netdev);
-	module_put(THIS_MODULE);
-}
-
-/**
- * fcoe_interface_get() - Get a reference to a FCoE interface
- * @fcoe: The FCoE interface to be held
- */
-static inline void fcoe_interface_get(struct fcoe_interface *fcoe)
-{
-	kref_get(&fcoe->kref);
-}
-
-/**
- * fcoe_interface_put() - Put a reference to a FCoE interface
- * @fcoe: The FCoE interface to be released
- */
-static inline void fcoe_interface_put(struct fcoe_interface *fcoe)
-{
-	kref_put(&fcoe->kref, fcoe_interface_release);
-}
-
-/**
  * fcoe_interface_cleanup() - Clean up a FCoE interface
  * @fcoe: The FCoE interface to be cleaned up
  *
@@ -466,7 +429,11 @@ void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
 	rtnl_unlock();
 
 	/* Release the self-reference taken during fcoe_interface_create() */
-	fcoe_interface_put(fcoe);
+	/* tear-down the FCoE controller */
+	fcoe_ctlr_destroy(fip);
+	kfree(fcoe);
+	dev_put(netdev);
+	module_put(THIS_MODULE);
 }
 
 /**
@@ -885,9 +852,6 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 		dev_uc_del(netdev, port->data_src_addr);
 	rtnl_unlock();
 
-	/* Release reference held in fcoe_if_create() */
-	fcoe_interface_put(fcoe);
-
 	/* Free queued packets for the per-CPU receive threads */
 	fcoe_percpu_clean(lport);
 
@@ -1074,7 +1038,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_lp_destroy;
 	}
 
-	fcoe_interface_get(fcoe);
 	return lport;
 
 out_lp_destroy:
@@ -1946,7 +1909,6 @@ static void fcoe_destroy_work(struct work_struct *work)
 	struct fcoe_interface *fcoe = port->priv;
 
 	fcoe_if_destroy(port->lport);
-
 	fcoe_interface_cleanup(fcoe);
 }
 
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index c4a9399..a1c3b54 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -73,8 +73,6 @@ do {                                                            	\
  * @ctlr:	      The FCoE controller (for FIP)
  * @oem:	      The offload exchange manager for all local port
  *		      instances associated with this port
- * @kref:	      The kernel reference
- *
  * This structure is 1:1 with a net devive.
  */
 struct fcoe_interface {
@@ -84,7 +82,6 @@ struct fcoe_interface {
 	struct packet_type fip_packet_type;
 	struct fcoe_ctlr   ctlr;
 	struct fc_exch_mgr *oem;
-	struct kref	   kref;
 };
 
 #define fcoe_from_ctlr(fip) container_of(fip, struct fcoe_interface, ctlr)

