From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] eliminate rphy allocation in favour of expander/end device
	allocation
Date: Sat, 18 Mar 2006 15:00:50 -0600
Message-ID: <1142715650.3773.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32197 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750989AbWCRVAw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 16:00:52 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k2IL0p224821
	for <linux-scsi@vger.kernel.org>; Sat, 18 Mar 2006 16:00:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This allows the removal of the contained flag and also does a bit of
class renaming (sas_rphy->sas_device).

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -699,7 +699,7 @@ sas_expander_simple_attr(component_revis
 sas_expander_simple_attr(level, level, "%d\n", int);
 
 static DECLARE_TRANSPORT_CLASS(sas_rphy_class,
-		"sas_rphy", NULL, NULL, NULL);
+		"sas_device", NULL, NULL, NULL);
 
 static int sas_rphy_match(struct attribute_container *cont, struct device *dev)
 {
@@ -740,9 +740,7 @@ static int sas_end_dev_match(struct attr
 
 	i = to_sas_internal(shost->transportt);
 	return &i->end_dev_attr_cont.ac == cont &&
-		rphy->identify.device_type == SAS_END_DEVICE &&
-		/* FIXME: remove contained eventually */
-		rphy->contained;
+		rphy->identify.device_type == SAS_END_DEVICE;
 }
 
 static int sas_expander_match(struct attribute_container *cont,
@@ -766,49 +764,26 @@ static int sas_expander_match(struct att
 	i = to_sas_internal(shost->transportt);
 	return &i->expander_attr_cont.ac == cont &&
 		(rphy->identify.device_type == SAS_EDGE_EXPANDER_DEVICE ||
-		 rphy->identify.device_type == SAS_FANOUT_EXPANDER_DEVICE) &&
-		/* FIXME: remove contained eventually */
-		rphy->contained;
+		 rphy->identify.device_type == SAS_FANOUT_EXPANDER_DEVICE);
 }
 
-static void sas_rphy_release(struct device *dev)
+static void sas_expander_release(struct device *dev)
 {
 	struct sas_rphy *rphy = dev_to_rphy(dev);
+	struct sas_expander_device *edev = rphy_to_expander_device(rphy);
 
 	put_device(dev->parent);
-	kfree(rphy);
+	kfree(edev);
 }
 
-/**
- * sas_rphy_alloc  --  allocates and initialize a SAS remote PHY structure
- * @parent:		SAS PHY this remote PHY is conneted to
- *
- * Allocates an SAS remote PHY structure, connected to @parent.
- *
- * Returns:
- *	SAS PHY allocated or %NULL if the allocation failed.
- */
-struct sas_rphy *sas_rphy_alloc(struct sas_phy *parent)
+static void sas_end_device_release(struct device *dev)
 {
-	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
-	struct sas_rphy *rphy;
-
-	rphy = kzalloc(sizeof(*rphy), GFP_KERNEL);
-	if (!rphy) {
-		put_device(&parent->dev);
-		return NULL;
-	}
-
-	device_initialize(&rphy->dev);
-	rphy->dev.parent = get_device(&parent->dev);
-	rphy->dev.release = sas_rphy_release;
-	sprintf(rphy->dev.bus_id, "rphy-%d:%d-%d",
-		shost->host_no, parent->port_identifier, parent->number);
-	transport_setup_device(&rphy->dev);
+	struct sas_rphy *rphy = dev_to_rphy(dev);
+	struct sas_end_device *edev = rphy_to_end_device(rphy);
 
-	return rphy;
+	put_device(dev->parent);
+	kfree(edev);
 }
-EXPORT_SYMBOL(sas_rphy_alloc);
 
 /**
  * sas_end_device_alloc - allocate an rphy for an end device
@@ -831,12 +806,10 @@ struct sas_rphy *sas_end_device_alloc(st
 
 	device_initialize(&rdev->rphy.dev);
 	rdev->rphy.dev.parent = get_device(&parent->dev);
-	rdev->rphy.dev.release = sas_rphy_release;
-	sprintf(rdev->rphy.dev.bus_id, "rphy-%d:%d-%d",
+	rdev->rphy.dev.release = sas_end_device_release;
+	sprintf(rdev->rphy.dev.bus_id, "end_device-%d:%d-%d",
 		shost->host_no, parent->port_identifier, parent->number);
 	rdev->rphy.identify.device_type = SAS_END_DEVICE;
-	/* FIXME: mark the rphy as being contained in a larger structure */
-	rdev->rphy.contained = 1;
 	transport_setup_device(&rdev->rphy.dev);
 
 	return &rdev->rphy;
@@ -869,15 +842,13 @@ struct sas_rphy *sas_expander_alloc(stru
 
 	device_initialize(&rdev->rphy.dev);
 	rdev->rphy.dev.parent = get_device(&parent->dev);
-	rdev->rphy.dev.release = sas_rphy_release;
+	rdev->rphy.dev.release = sas_expander_release;
 	mutex_lock(&sas_host->lock);
 	rdev->rphy.scsi_target_id = sas_host->next_expander_id++;
 	mutex_unlock(&sas_host->lock);
 	sprintf(rdev->rphy.dev.bus_id, "expander-%d:%d",
 		shost->host_no, rdev->rphy.scsi_target_id);
 	rdev->rphy.identify.device_type = type;
-	/* FIXME: mark the rphy as being contained in a larger structure */
-	rdev->rphy.contained = 1;
 	transport_setup_device(&rdev->rphy.dev);
 
 	return &rdev->rphy;
@@ -950,7 +921,17 @@ void sas_rphy_free(struct sas_rphy *rphy
 	put_device(rphy->dev.parent);
 	put_device(rphy->dev.parent);
 	put_device(rphy->dev.parent);
-	kfree(rphy);
+	if (rphy->identify.device_type == SAS_END_DEVICE) {
+		struct sas_end_device *edev = rphy_to_end_device(rphy);
+
+		kfree(edev);
+	} else {
+		/* must be expander */
+		struct sas_expander_device *edev =
+			rphy_to_expander_device(rphy);
+
+		kfree(edev);
+	}
 }
 EXPORT_SYMBOL(sas_rphy_free);
 
@@ -1003,7 +984,8 @@ EXPORT_SYMBOL(sas_rphy_delete);
  */
 int scsi_is_sas_rphy(const struct device *dev)
 {
-	return dev->release == sas_rphy_release;
+	return dev->release == sas_end_device_release ||
+		dev->release == sas_expander_release;
 }
 EXPORT_SYMBOL(scsi_is_sas_rphy);
 
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -82,10 +82,6 @@ struct sas_rphy {
 	struct sas_identify	identify;
 	struct list_head	list;
 	u32			scsi_target_id;
-	/* temporary expedient: mark the rphy as being contained
-	 * within a type specific rphy
-	 * FIXME: pull this out when everything uses the containers */
-	unsigned		contained:1;
 };
 
 #define dev_to_rphy(d) \
@@ -145,7 +141,6 @@ extern int sas_phy_add(struct sas_phy *)
 extern void sas_phy_delete(struct sas_phy *);
 extern int scsi_is_sas_phy(const struct device *);
 
-extern struct sas_rphy *sas_rphy_alloc(struct sas_phy *);
 extern struct sas_rphy *sas_end_device_alloc(struct sas_phy *);
 extern struct sas_rphy *sas_expander_alloc(struct sas_phy *, enum sas_device_type);
 void sas_rphy_free(struct sas_rphy *);


