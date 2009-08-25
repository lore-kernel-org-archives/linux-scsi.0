From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/64] fcoe: fcoe_interface create, destroy and refcounting
Date: Tue, 25 Aug 2009 14:00:02 -0700
Message-ID: <20090825210002.1553.38887.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbZHYVAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:00 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Up to this point the fcoe_instance structure was simply kzalloc/kfreed.  This
patch introduces create and destroy functions as well as kref based reference
counting.  The create function will grow as the initialization code is moved
there.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   97 +++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/fcoe/fcoe.h |    1 
 2 files changed, 79 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 7f14c63..d1d6b3b 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -139,6 +139,58 @@ static struct scsi_host_template fcoe_shost_template = {
 };
 
 /**
+ * fcoe_interface_create()
+ * @netdev: network interface
+ *
+ * Returns: pointer to a struct fcoe_interface or NULL on error
+ */
+static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
+{
+	struct fcoe_interface *fcoe;
+
+	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
+	if (!fcoe) {
+		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
+		return NULL;
+	}
+
+	kref_init(&fcoe->kref);
+	fcoe->netdev = netdev;
+
+	return fcoe;
+}
+
+/**
+ * fcoe_interface_release() - fcoe_port kref release function
+ * @kref: embedded reference count in an fcoe_interface struct
+ */
+static void fcoe_interface_release(struct kref *kref)
+{
+	struct fcoe_interface *fcoe;
+
+	fcoe = container_of(kref, struct fcoe_interface, kref);
+	kfree(fcoe);
+}
+
+/**
+ * fcoe_interface_get()
+ * @fcoe:
+ */
+static inline void fcoe_interface_get(struct fcoe_interface *fcoe)
+{
+	kref_get(&fcoe->kref);
+}
+
+/**
+ * fcoe_interface_put()
+ * @fcoe:
+ */
+static inline void fcoe_interface_put(struct fcoe_interface *fcoe)
+{
+	kref_put(&fcoe->kref, fcoe_interface_release);
+}
+
+/**
  * fcoe_fip_recv - handle a received FIP frame.
  * @skb: the receive skb
  * @dev: associated &net_device
@@ -558,7 +610,7 @@ static void fcoe_if_destroy(struct fc_lport *lport)
 	/* Release the net_device and Scsi_Host */
 	dev_put(netdev);
 	scsi_host_put(lport->host);
-	kfree(fcoe);		/* TODO, should be refcounted */
+	fcoe_interface_put(fcoe);
 }
 
 /*
@@ -604,8 +656,8 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 };
 
 /**
- * fcoe_if_create() - this function creates the fcoe interface
- * @netdev: pointer the associated netdevice
+ * fcoe_if_create() - this function creates the fcoe port
+ * @fcoe: fcoe_interface structure to create an fc_lport instance on
  * @parent: device pointer to be the parent in sysfs for the SCSI host
  *
  * Creates fc_lport struct and scsi_host for lport, configures lport
@@ -613,30 +665,23 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
  *
  * Returns : The allocated fc_lport or an error pointer
  */
-static struct fc_lport *fcoe_if_create(struct net_device *netdev,
+static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 				       struct device *parent)
 {
 	int rc;
 	struct fc_lport *lport = NULL;
 	struct fcoe_port *port;
-	struct fcoe_interface *fcoe;
 	struct Scsi_Host *shost;
+	struct net_device *netdev = fcoe->netdev;
 
 	FCOE_NETDEV_DBG(netdev, "Create Interface\n");
 
-	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
-	if (!fcoe) {
-		FCOE_NETDEV_DBG(netdev, "Could not allocate fcoe structure\n");
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	shost = libfc_host_alloc(&fcoe_shost_template,
 				 sizeof(struct fcoe_port));
 	if (!shost) {
 		FCOE_NETDEV_DBG(netdev, "Could not allocate host structure\n");
 		rc = -ENOMEM;
-		goto out_kfree_port;
+		goto out;
 	}
 	lport = shost_priv(shost);
 	port = lport_priv(lport);
@@ -708,7 +753,7 @@ static struct fc_lport *fcoe_if_create(struct net_device *netdev,
 		fcoe_ctlr_link_up(&fcoe->ctlr);
 
 	dev_hold(netdev);
-
+	fcoe_interface_get(fcoe);
 	return lport;
 
 out_lp_destroy:
@@ -717,8 +762,6 @@ out_netdev_cleanup:
 	fcoe_netdev_cleanup(port);
 out_host_put:
 	scsi_host_put(lport->host);
-out_kfree_port:
-	kfree(fcoe);
 out:
 	return ERR_PTR(rc);
 }
@@ -1620,6 +1663,8 @@ static int fcoe_ethdrv_put(const struct net_device *netdev)
 static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 {
 	struct net_device *netdev;
+	struct fcoe_interface *fcoe;
+	struct fcoe_port *port;
 	struct fc_lport *lport;
 	int rc;
 
@@ -1634,6 +1679,8 @@ static int fcoe_destroy(const char *buffer, struct kernel_param *kp)
 		rc = -ENODEV;
 		goto out_putdev;
 	}
+	port = lport_priv(lport);
+	fcoe = port->fcoe;
 	fcoe_if_destroy(lport);
 	fcoe_ethdrv_put(netdev);
 	rc = 0;
@@ -1653,6 +1700,7 @@ out_nodev:
 static int fcoe_create(const char *buffer, struct kernel_param *kp)
 {
 	int rc;
+	struct fcoe_interface *fcoe;
 	struct fc_lport *lport;
 	struct net_device *netdev;
 
@@ -1668,15 +1716,26 @@ static int fcoe_create(const char *buffer, struct kernel_param *kp)
 	}
 	fcoe_ethdrv_get(netdev);
 
-	lport = fcoe_if_create(netdev, &netdev->dev);
+	fcoe = fcoe_interface_create(netdev);
+	if (!fcoe) {
+		rc = -ENOMEM;
+		goto out_putdev;
+	}
+
+	lport = fcoe_if_create(fcoe, &netdev->dev);
 	if (IS_ERR(lport)) {
 		printk(KERN_ERR "fcoe: Failed to create interface (%s)\n",
 		       netdev->name);
 		fcoe_ethdrv_put(netdev);
 		rc = -EIO;
-		goto out_putdev;
+		goto out_free;
 	}
-	rc = 0;
+
+	dev_put(netdev);
+	return 0;
+
+out_free:
+	fcoe_interface_put(fcoe);
 out_putdev:
 	dev_put(netdev);
 out_nodev:
diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index 673e70e..ff22928 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -84,6 +84,7 @@ struct fcoe_interface {
 	struct packet_type  fip_packet_type;
 	struct fcoe_ctlr ctlr;
 	struct fc_exch_mgr *oem;		/* offload exchange manager */
+	struct kref kref;
 };
 
 /*

