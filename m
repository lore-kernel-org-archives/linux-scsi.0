From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aci94xx: implement link rate setting
Date: Wed, 06 Sep 2006 19:28:07 -0500
Message-ID: <1157588887.3469.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:52123 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161026AbWIGA2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 20:28:09 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k870S8506948
	for <linux-scsi@vger.kernel.org>; Wed, 6 Sep 2006 20:28:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch implements the ability to set the minimum and maximum
linkrates for both libsas (for expanders) and aic94xx (for the host
phys).  It also tidies up the setting of the hardware min and max to
make sure they're updated when the expander emits a change broadcast.

James

Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_scb.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_scb.c	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_scb.c	2006-09-06 18:11:18.000000000 -0500
@@ -52,6 +52,8 @@
 
 static inline void get_lrate_mode(struct asd_phy *phy, u8 oob_mode)
 {
+	struct sas_phy *sas_phy = phy->sas_phy.phy;
+
 	switch (oob_mode & 7) {
 	case PHY_SPEED_60:
 		/* FIXME: sas transport class doesn't have this */
@@ -67,6 +69,12 @@ static inline void get_lrate_mode(struct
 		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	}
+	sas_phy->negotiated_linkrate = phy->sas_phy.linkrate;
+	sas_phy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+	sas_phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+	sas_phy->maximum_linkrate = phy->phy_desc->max_sas_lrate;
+	sas_phy->minimum_linkrate = phy->phy_desc->min_sas_lrate;
+
 	if (oob_mode & SAS_MODE)
 		phy->sas_phy.oob_mode = SAS_OOB_MODE;
 	else if (oob_mode & SATA_MODE)
@@ -710,14 +718,32 @@ static const int phy_func_table[] = {
 	[PHY_FUNC_RELEASE_SPINUP_HOLD] = RELEASE_SPINUP_HOLD,
 };
 
-int asd_control_phy(struct asd_sas_phy *phy, enum phy_func func)
+int asd_control_phy(struct asd_sas_phy *phy, enum phy_func func, void *arg)
 {
 	struct asd_ha_struct *asd_ha = phy->ha->lldd_ha;
+	struct asd_phy_desc *pd = asd_ha->phys[phy->id].phy_desc;
 	struct asd_ascb *ascb;
+	struct sas_phy_linkrates *rates;
 	int res = 1;
 
-	if (func == PHY_FUNC_CLEAR_ERROR_LOG)
+	switch (func) {
+	case PHY_FUNC_CLEAR_ERROR_LOG:
 		return -ENOSYS;
+	case PHY_FUNC_SET_LINK_RATE:
+		rates = arg;
+		if (rates->minimum_linkrate) {
+			pd->min_sas_lrate = rates->minimum_linkrate;
+			pd->min_sata_lrate = rates->minimum_linkrate;
+		}
+		if (rates->maximum_linkrate) {
+			pd->max_sas_lrate = rates->maximum_linkrate;
+			pd->max_sata_lrate = rates->maximum_linkrate;
+		}
+		func = PHY_FUNC_LINK_RESET;
+		break;
+	default:
+		break;
+	}
 
 	ascb = asd_ascb_alloc_list(asd_ha, &res, GFP_KERNEL);
 	if (!ascb)
Index: BUILD-2.6/drivers/scsi/libsas/sas_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_init.c	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_init.c	2006-09-06 18:11:18.000000000 -0500
@@ -159,17 +159,57 @@ static int sas_phy_reset(struct sas_phy 
 		struct sas_internal *i =
 			to_sas_internal(sas_ha->core.shost->transportt);
 
-		ret = i->dft->lldd_control_phy(asd_phy, reset_type);
+		ret = i->dft->lldd_control_phy(asd_phy, reset_type, NULL);
 	} else {
 		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
-		ret = sas_smp_phy_control(ddev, phy->number, reset_type);
+		ret = sas_smp_phy_control(ddev, phy->number, reset_type, NULL);
 	}
 	return ret;
 }
 
+static int sas_set_phy_speed(struct sas_phy *phy,
+			     struct sas_phy_linkrates *rates)
+{
+	int ret;
+
+	if ((rates->minimum_linkrate &&
+	     rates->minimum_linkrate > phy->maximum_linkrate) ||
+	    (rates->maximum_linkrate &&
+	     rates->maximum_linkrate < phy->minimum_linkrate))
+		return -EINVAL;
+
+	if (rates->minimum_linkrate &&
+	    rates->minimum_linkrate < phy->minimum_linkrate_hw)
+		rates->minimum_linkrate = phy->minimum_linkrate_hw;
+
+	if (rates->maximum_linkrate &&
+	    rates->maximum_linkrate > phy->maximum_linkrate_hw)
+		rates->maximum_linkrate = phy->maximum_linkrate_hw;
+
+	if (scsi_is_sas_phy_local(phy)) {
+		struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+		struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+		struct asd_sas_phy *asd_phy = sas_ha->sas_phy[phy->number];
+		struct sas_internal *i =
+			to_sas_internal(sas_ha->core.shost->transportt);
+
+		ret = i->dft->lldd_control_phy(asd_phy, PHY_FUNC_SET_LINK_RATE,
+					       rates);
+	} else {
+		struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
+		struct domain_device *ddev = sas_find_dev_by_rphy(rphy);
+		ret = sas_smp_phy_control(ddev, phy->number,
+					  PHY_FUNC_LINK_RESET, rates);
+
+	}
+
+	return ret;
+}
+
 static struct sas_function_template sft = {
 	.phy_reset = sas_phy_reset,
+	.set_phy_speed = sas_set_phy_speed,
 	.get_linkerrors = sas_get_linkerrors,
 };
 
Index: BUILD-2.6/drivers/scsi/libsas/sas_phy.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_phy.c	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_phy.c	2006-09-06 18:11:18.000000000 -0500
@@ -67,13 +67,14 @@ static void sas_phye_oob_error(void *dat
 		switch (phy->error) {
 		case 1:
 		case 2:
-			i->dft->lldd_control_phy(phy, PHY_FUNC_HARD_RESET);
+			i->dft->lldd_control_phy(phy, PHY_FUNC_HARD_RESET,
+						 NULL);
 			break;
 		case 3:
 		default:
 			phy->error = 0;
 			phy->enabled = 0;
-			i->dft->lldd_control_phy(phy, PHY_FUNC_DISABLE);
+			i->dft->lldd_control_phy(phy, PHY_FUNC_DISABLE, NULL);
 			break;
 		}
 	}
@@ -90,7 +91,7 @@ static void sas_phye_spinup_hold(void *d
 			&phy->phy_events_pending);
 
 	phy->error = 0;
-	i->dft->lldd_control_phy(phy, PHY_FUNC_RELEASE_SPINUP_HOLD);
+	i->dft->lldd_control_phy(phy, PHY_FUNC_RELEASE_SPINUP_HOLD, NULL);
 }
 
 /* ---------- Phy class registration ---------- */
@@ -144,10 +145,10 @@ int sas_register_phys(struct sas_ha_stru
 		phy->phy->identify.target_port_protocols = phy->tproto;
 		phy->phy->identify.sas_address = SAS_ADDR(sas_ha->sas_addr);
 		phy->phy->identify.phy_identifier = i;
-		phy->phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
-		phy->phy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
-		phy->phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
-		phy->phy->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		phy->phy->minimum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
+		phy->phy->maximum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
+		phy->phy->minimum_linkrate = SAS_LINK_RATE_UNKNOWN;
+		phy->phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
 		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
 
 		sas_phy_add(phy->phy);
Index: BUILD-2.6/include/scsi/libsas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/libsas.h	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/include/scsi/libsas.h	2006-09-06 18:11:18.000000000 -0500
@@ -594,7 +594,7 @@ struct sas_domain_function_template {
 	int (*lldd_clear_nexus_ha)(struct sas_ha_struct *);
 
 	/* Phy management */
-	int (*lldd_control_phy)(struct asd_sas_phy *, enum phy_func);
+	int (*lldd_control_phy)(struct asd_sas_phy *, enum phy_func, void *);
 };
 
 extern int sas_register_ha(struct sas_ha_struct *);
Index: BUILD-2.6/include/scsi/sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sas.h	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/include/scsi/sas.h	2006-09-06 18:11:18.000000000 -0500
@@ -121,6 +121,7 @@ enum phy_func {
 	PHY_FUNC_CLEAR_AFFIL,
 	PHY_FUNC_TX_SATA_PS_SIGNAL,
 	PHY_FUNC_RELEASE_SPINUP_HOLD = 0x10, /* LOCAL PORT ONLY! */
+	PHY_FUNC_SET_LINK_RATE,
 };
 
 /* SAS LLDD would need to report only _very_few_ of those, like BROADCAST.
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx.h	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx.h	2006-09-06 18:11:18.000000000 -0500
@@ -109,6 +109,6 @@ int  asd_clear_nexus_port(struct asd_sas
 int  asd_clear_nexus_ha(struct sas_ha_struct *sas_ha);
 
 /* ---------- Phy Management ---------- */
-int  asd_control_phy(struct asd_sas_phy *phy, enum phy_func func);
+int  asd_control_phy(struct asd_sas_phy *phy, enum phy_func func, void *arg);
 
 #endif
Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-09-06 18:11:18.000000000 -0500
@@ -187,10 +187,10 @@ static void sas_set_ex_phy(struct domain
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
 	phy->phy->identify.phy_identifier = phy_id;
-	phy->phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
-	phy->phy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
-	phy->phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
-	phy->phy->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+	phy->phy->minimum_linkrate_hw = dr->hmin_linkrate;
+	phy->phy->maximum_linkrate_hw = dr->hmax_linkrate;
+	phy->phy->minimum_linkrate = dr->pmin_linkrate;
+	phy->phy->maximum_linkrate = dr->pmax_linkrate;
 	phy->phy->negotiated_linkrate = phy->linkrate;
 
 	if (!rediscover)
@@ -231,7 +231,7 @@ static int sas_ex_phy_discover_helper(st
 			break;
 		/* In order to generate the dev to host FIS, we
 		 * send a link reset to the expander port */
-		sas_smp_phy_control(dev, single, PHY_FUNC_LINK_RESET);
+		sas_smp_phy_control(dev, single, PHY_FUNC_LINK_RESET, NULL);
 		/* Wait for the reset to trigger the negotiation */
 		msleep(500);
 	}
@@ -426,7 +426,8 @@ out:
 #define PC_RESP_SIZE 8
 
 int sas_smp_phy_control(struct domain_device *dev, int phy_id,
-			enum phy_func phy_func)
+			enum phy_func phy_func,
+			struct sas_phy_linkrates *rates)
 {
 	u8 *pc_req;
 	u8 *pc_resp;
@@ -445,6 +446,10 @@ int sas_smp_phy_control(struct domain_de
 	pc_req[1] = SMP_PHY_CONTROL;
 	pc_req[9] = phy_id;
 	pc_req[10]= phy_func;
+	if (rates) {
+		pc_req[32] = rates->minimum_linkrate << 4;
+		pc_req[33] = rates->maximum_linkrate << 4;
+	}
 
 	res = smp_execute_task(dev, pc_req, PC_REQ_SIZE, pc_resp,PC_RESP_SIZE);
 
@@ -458,7 +463,7 @@ static void sas_ex_disable_phy(struct do
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 
-	sas_smp_phy_control(dev, phy_id, PHY_FUNC_DISABLE);
+	sas_smp_phy_control(dev, phy_id, PHY_FUNC_DISABLE, NULL);
 	phy->linkrate = SAS_PHY_DISABLED;
 }
 
@@ -796,7 +801,7 @@ static int sas_ex_discover_dev(struct do
 
 	/* Phy state */
 	if (ex_phy->linkrate == SAS_SATA_SPINUP_HOLD) {
-		if (!sas_smp_phy_control(dev, phy_id, PHY_FUNC_LINK_RESET))
+		if (!sas_smp_phy_control(dev, phy_id, PHY_FUNC_LINK_RESET, NULL))
 			res = sas_ex_phy_discover(dev, phy_id);
 		if (res)
 			return res;
@@ -1771,6 +1776,7 @@ static int sas_rediscover_dev(struct dom
 		   SAS_ADDR(phy->attached_sas_addr)) {
 		SAS_DPRINTK("ex %016llx phy 0x%x broadcast flutter\n",
 			    SAS_ADDR(dev->sas_addr), phy_id);
+		sas_ex_phy_discover(dev, phy_id);
 	} else
 		res = sas_discover_new(dev, phy_id);
 out:
Index: BUILD-2.6/drivers/scsi/libsas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_internal.h	2006-09-06 18:11:13.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_internal.h	2006-09-06 18:11:18.000000000 -0500
@@ -70,7 +70,7 @@ int sas_notify_lldd_dev_found(struct dom
 void sas_notify_lldd_dev_gone(struct domain_device *);
 
 int sas_smp_phy_control(struct domain_device *dev, int phy_id,
-			enum phy_func phy_func);
+			enum phy_func phy_func, struct sas_phy_linkrates *);
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);


