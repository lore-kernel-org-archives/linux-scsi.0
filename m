From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: add transport class phy reset capability
Date: Fri, 25 Aug 2006 14:26:14 -0500
Message-ID: <1156533974.3462.17.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:51908 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422754AbWHYT0R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 15:26:17 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7PJQF531324
	for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2006 15:26:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This wires in the transport class hard and link reset phy ability.  It
does local phy resets via the HBA callback functions, but it also does
expander phy resets vi the SMP PHY_CONTROL messages.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_init.c	2006-08-25 13:19:32.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_init.c	2006-08-25 14:13:34.000000000 -0500
@@ -132,7 +132,34 @@
 	return 0;
 }
 
+static int sas_phy_reset(struct sas_phy *phy, int hard_reset)
+{
+	int ret;
+	enum phy_func reset_type;
+
+	if (hard_reset)
+		reset_type = PHY_FUNC_HARD_RESET;
+	else
+		reset_type = PHY_FUNC_LINK_RESET;
+
+	if (scsi_is_host_device(phy->dev.parent)) {
+		struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+		struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+		struct asd_sas_phy *asd_phy = sas_ha->sas_phy[phy->number];
+		struct sas_internal *i =
+			to_sas_internal(sas_ha->core.shost->transportt);
+
+		ret = i->dft->lldd_control_phy(asd_phy, reset_type);
+	} else {
+		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
+		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
+		ret = sas_smp_phy_control(ddev, phy->number, reset_type);
+	}
+	return ret;
+}
+
 static struct sas_function_template sft = {
+	.phy_reset = sas_phy_reset,
 };
 
 extern struct scsi_transport_template *
Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-08-25 13:38:20.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-08-25 13:41:38.000000000 -0500
@@ -36,8 +36,6 @@
 static int sas_configure_phy(struct domain_device *dev, int phy_id,
 			     u8 *sas_addr, int include);
 static int sas_disable_routing(struct domain_device *dev,  u8 *sas_addr);
-static int smp_phy_control(struct domain_device *dev, int phy_id,
-			   enum phy_func phy_func);
 
 #if 0
 /* FIXME: smp needs to migrate into the sas class */
@@ -242,7 +240,7 @@
 			break;
 		/* In order to generate the dev to host FIS, we
 		 * send a link reset to the expander port */
-		smp_phy_control(dev, single, PHY_FUNC_LINK_RESET);
+		sas_smp_phy_control(dev, single, PHY_FUNC_LINK_RESET);
 		/* Wait for the reset to trigger the negotiation */
 		msleep(500);
 	}
@@ -436,8 +434,8 @@
 #define PC_REQ_SIZE  44
 #define PC_RESP_SIZE 8
 
-static int smp_phy_control(struct domain_device *dev, int phy_id,
-			   enum phy_func phy_func)
+int sas_smp_phy_control(struct domain_device *dev, int phy_id,
+			enum phy_func phy_func)
 {
 	u8 *pc_req;
 	u8 *pc_resp;
@@ -469,7 +467,7 @@
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 
-	smp_phy_control(dev, phy_id, PHY_FUNC_DISABLE);
+	sas_smp_phy_control(dev, phy_id, PHY_FUNC_DISABLE);
 	phy->linkrate = PHY_DISABLED;
 }
 
@@ -768,7 +766,7 @@
 
 	/* Phy state */
 	if (ex_phy->linkrate == PHY_SPINUP_HOLD) {
-		if (!smp_phy_control(dev, phy_id, PHY_FUNC_LINK_RESET))
+		if (!sas_smp_phy_control(dev, phy_id, PHY_FUNC_LINK_RESET))
 			res = sas_ex_phy_discover(dev, phy_id);
 		if (res)
 			return res;
Index: BUILD-2.6/drivers/scsi/libsas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_internal.h	2006-08-25 13:19:32.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_internal.h	2006-08-25 13:41:38.000000000 -0500
@@ -68,6 +68,10 @@
 int sas_notify_lldd_dev_found(struct domain_device *);
 void sas_notify_lldd_dev_gone(struct domain_device *);
 
+int sas_smp_phy_control(struct domain_device *dev, int phy_id,
+			enum phy_func phy_func);
+
+struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 
 void sas_hae_reset(void *);
 
Index: BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2006-08-25 13:19:32.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_scsi_host.c	2006-08-25 13:41:38.000000000 -0500
@@ -813,10 +813,9 @@
 	.port_ops = &sas_sata_ops
 };
 
-static inline struct domain_device *sas_find_dev(struct scsi_target *starget)
+struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy)
 {
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
+	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent);
 	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
 	struct domain_device *found_dev = NULL;
 	int i;
@@ -842,11 +841,18 @@
 	return found_dev;
 }
 
+static inline struct domain_device *sas_find_target(struct scsi_target *starget)
+{
+	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
+
+	return sas_find_dev_by_rphy(rphy);
+}
+
 int sas_target_alloc(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
-	struct domain_device *found_dev = sas_find_dev(starget);
+	struct domain_device *found_dev = sas_find_target(starget);
 
 	if (!found_dev)
 		return -ENODEV;
@@ -1098,7 +1104,7 @@
 
 void sas_target_destroy(struct scsi_target *starget)
 {
-	struct domain_device *found_dev = sas_find_dev(starget);
+	struct domain_device *found_dev = sas_find_target(starget);
 
 	if (!found_dev)
 		return;


