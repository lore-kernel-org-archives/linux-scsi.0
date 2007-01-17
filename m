From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] libsas: Clean up discovery failure handler code
Date: Wed, 17 Jan 2007 11:25:29 -0800
Message-ID: <20070117192529.4551.23926.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35729 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXAQTZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Jan 2007 14:25:32 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0HJPNSr002572
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2007 14:25:23 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0HJPNF0294716
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2007 14:25:23 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0HJPMwe019387
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jan 2007 14:25:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


sas_rphy_delete does two things: it removes the sas_rphy from the transport
layer and frees the sas_rphy.  This can be broken down into two functions,
sas_rphy_remove and sas_rphy_free; sas_rphy_remove is of interest to
sas_discover_root_expander because it calls functions that require
sas_rphy_add as a prerequisite and can fail (namely sas_discover_expander).
In that case, sas_discover_root_expander needs to be able to undo the effects
of sas_rphy_add yet leave the job of freeing the sas_rphy to the caller of
sas_discover_root_expander.

This patch also removes some unnecessary code from sas_discover_end_dev
to eliminate an unnecessary cycle of sas_notify_lldd_gone/found for SAS
devices, thus eliminating a sas_rphy_remove call (and fixing a race condition
where a SCSI target scan can come in between the gone and found call).
It also moves the sas_rphy_free calls into sas_discover_domain and
sas_ex_discover_end_dev to complement the sas_rphy_allocation via
sas_get_port_device.

This patch does not change the semantics of sas_rphy_delete.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_discover.c |   45 ++++++++++++++----------------------
 drivers/scsi/libsas/sas_expander.c |    8 ++----
 drivers/scsi/scsi_transport_sas.c  |   33 +++++++++++++++-----------
 include/scsi/scsi_transport_sas.h  |    1 +
 4 files changed, 40 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index b6ba0e0..a65598b 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -577,8 +577,6 @@ int sas_discover_sata(struct domain_devi
 out_err:
 	sas_notify_lldd_dev_gone(dev);
 out_err2:
-	sas_rphy_free(dev->rphy);
-	dev->rphy = NULL;
 	return res;
 }
 
@@ -600,24 +598,11 @@ int sas_discover_end_dev(struct domain_d
 	if (res)
 		goto out_err;
 
-	/* do this to get the end device port attributes which will have
-	 * been scanned in sas_rphy_add */
-	sas_notify_lldd_dev_gone(dev);
-	res = sas_notify_lldd_dev_found(dev);
-	if (res)
-		goto out_err3;
-
 	return 0;
 
 out_err:
 	sas_notify_lldd_dev_gone(dev);
 out_err2:
-	sas_rphy_free(dev->rphy);
-	dev->rphy = NULL;
-	return res;
-out_err3:
-	sas_rphy_delete(dev->rphy);
-	dev->rphy = NULL;
 	return res;
 }
 
@@ -672,6 +657,7 @@ void sas_unregister_domain_devices(struc
  */
 static void sas_discover_domain(struct work_struct *work)
 {
+	struct domain_device *dev;
 	int error = 0;
 	struct sas_discovery_event *ev =
 		container_of(work, struct sas_discovery_event, work);
@@ -681,39 +667,42 @@ static void sas_discover_domain(struct w
 			&port->disc.pending);
 
 	if (port->port_dev)
-		return ;
-	else {
-		error = sas_get_port_device(port);
-		if (error)
-			return;
-	}
+		return;
+
+	error = sas_get_port_device(port);
+	if (error)
+		return;
+	dev = port->port_dev;
 
 	SAS_DPRINTK("DOING DISCOVERY on port %d, pid:%d\n", port->id,
 		    current->pid);
 
-	switch (port->port_dev->dev_type) {
+	switch (dev->dev_type) {
 	case SAS_END_DEV:
-		error = sas_discover_end_dev(port->port_dev);
+		error = sas_discover_end_dev(dev);
 		break;
 	case EDGE_DEV:
 	case FANOUT_DEV:
-		error = sas_discover_root_expander(port->port_dev);
+		error = sas_discover_root_expander(dev);
 		break;
 	case SATA_DEV:
 	case SATA_PM:
-		error = sas_discover_sata(port->port_dev);
+		error = sas_discover_sata(dev);
 		break;
 	default:
-		SAS_DPRINTK("unhandled device %d\n", port->port_dev->dev_type);
+		SAS_DPRINTK("unhandled device %d\n", dev->dev_type);
 		break;
 	}
 
 	if (error) {
+		sas_rphy_free(dev->rphy);
+		dev->rphy = NULL;
+
 		spin_lock(&port->dev_list_lock);
-		list_del_init(&port->port_dev->dev_list_node);
+		list_del_init(&dev->dev_list_node);
 		spin_unlock(&port->dev_list_lock);
 
-		kfree(port->port_dev); /* not kobject_register-ed yet */
+		kfree(dev); /* not kobject_register-ed yet */
 		port->port_dev = NULL;
 	}
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 0dfd97e..d9b9a00 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -667,6 +667,8 @@ static struct domain_device *sas_ex_disc
 	return child;
 
  out_list_del:
+	sas_rphy_free(child->rphy);
+	child->rphy = NULL;
 	list_del(&child->dev_list_node);
  out_free:
 	sas_port_delete(phy->port);
@@ -1444,12 +1446,8 @@ int sas_discover_root_expander(struct do
 	return res;
 
 out_err2:
-	sas_rphy_delete(dev->rphy);
-	dev->rphy = NULL;
-	return res;
+	sas_rphy_remove(dev->rphy);
 out_err:
-	sas_rphy_free(dev->rphy);
-	dev->rphy = NULL;
 	return res;
 }
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index bfbcf5f..a5142eb 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1299,7 +1299,7 @@ EXPORT_SYMBOL(sas_rphy_add);
  * Note:
  *   This function must only be called on a remote
  *   PHY that has not sucessfully been added using
- *   sas_rphy_add().
+ *   sas_rphy_add() (or has been sas_rphy_remove()'d)
  */
 void sas_rphy_free(struct sas_rphy *rphy)
 {
@@ -1318,18 +1318,30 @@ void sas_rphy_free(struct sas_rphy *rphy
 EXPORT_SYMBOL(sas_rphy_free);
 
 /**
- * sas_rphy_delete  --  remove SAS remote PHY
- * @rphy:	SAS remote PHY to remove
+ * sas_rphy_delete  --  remove and free SAS remote PHY
+ * @rphy:	SAS remote PHY to remove and free
  *
- * Removes the specified SAS remote PHY.
+ * Removes the specified SAS remote PHY and frees it.
  */
 void
 sas_rphy_delete(struct sas_rphy *rphy)
 {
+	sas_rphy_remove(rphy);
+	sas_rphy_free(rphy);
+}
+EXPORT_SYMBOL(sas_rphy_delete);
+
+/**
+ * sas_rphy_remove  --  remove SAS remote PHY
+ * @rphy:	SAS remote phy to remove
+ *
+ * Removes the specified SAS remote PHY.
+ */
+void
+sas_rphy_remove(struct sas_rphy *rphy)
+{
 	struct device *dev = &rphy->dev;
 	struct sas_port *parent = dev_to_sas_port(dev->parent);
-	struct Scsi_Host *shost = dev_to_shost(parent->dev.parent);
-	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 
 	switch (rphy->identify.device_type) {
 	case SAS_END_DEVICE:
@@ -1345,17 +1357,10 @@ sas_rphy_delete(struct sas_rphy *rphy)
 
 	transport_remove_device(dev);
 	device_del(dev);
-	transport_destroy_device(dev);
-
-	mutex_lock(&sas_host->lock);
-	list_del(&rphy->list);
-	mutex_unlock(&sas_host->lock);
 
 	parent->rphy = NULL;
-
-	put_device(dev);
 }
-EXPORT_SYMBOL(sas_rphy_delete);
+EXPORT_SYMBOL(sas_rphy_remove);
 
 /**
  * scsi_is_sas_rphy  --  check if a struct device represents a SAS remote PHY
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 45d5859..9aedc19 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -182,6 +182,7 @@ extern struct sas_rphy *sas_end_device_a
 extern struct sas_rphy *sas_expander_alloc(struct sas_port *, enum sas_device_type);
 void sas_rphy_free(struct sas_rphy *);
 extern int sas_rphy_add(struct sas_rphy *);
+extern void sas_rphy_remove(struct sas_rphy *);
 extern void sas_rphy_delete(struct sas_rphy *);
 extern int scsi_is_sas_rphy(const struct device *);
 
