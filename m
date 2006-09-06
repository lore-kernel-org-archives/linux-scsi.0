From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] SAS: consolidate linkspeed definitions
Date: Wed, 06 Sep 2006 17:36:13 -0500
Message-ID: <1157582173.3469.28.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:62873 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751765AbWIFWgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 18:36:15 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k86MaE500895
	for <linux-scsi@vger.kernel.org>; Wed, 6 Sep 2006 18:36:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

At the moment we have two separate linkspeed enumerations covering
roughly the same values.  This patch consolidates on a single one enum
sas_linkspeed in scsi_transport_sas.h and uses it everywhere in the
aic94xx driver.  Eventually I'll get around to removing the duplicated
fields in asd_sas_phy and sas_phy ...

James

Index: BUILD-2.6/include/scsi/libsas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/libsas.h	2006-09-06 14:03:42.000000000 -0500
+++ BUILD-2.6/include/scsi/libsas.h	2006-09-06 16:32:08.000000000 -0500
@@ -115,7 +115,7 @@ struct ex_phy {
 	enum ex_phy_state phy_state;
 
 	enum sas_dev_type attached_dev_type;
-	enum sas_phy_linkrate linkrate;
+	enum sas_linkrate linkrate;
 
 	u8   attached_sata_host:1;
 	u8   attached_sata_dev:1;
@@ -178,9 +178,9 @@ struct sata_device {
 struct domain_device {
         enum sas_dev_type dev_type;
 
-        enum sas_phy_linkrate linkrate;
-        enum sas_phy_linkrate min_linkrate;
-        enum sas_phy_linkrate max_linkrate;
+        enum sas_linkrate linkrate;
+        enum sas_linkrate min_linkrate;
+        enum sas_linkrate max_linkrate;
 
         int  pathways;
 
@@ -228,7 +228,7 @@ struct asd_sas_port {
 	struct domain_device *port_dev;
 	spinlock_t dev_list_lock;
 	struct list_head dev_list;
-	enum   sas_phy_linkrate linkrate;
+	enum   sas_linkrate linkrate;
 
 	struct sas_phy *phy;
 	struct work_struct work;
@@ -284,7 +284,7 @@ struct asd_sas_phy {
 	enum sas_phy_type  type;
 	enum sas_phy_role  role;
 	enum sas_oob_mode  oob_mode;
-	enum sas_phy_linkrate linkrate;
+	enum sas_linkrate linkrate;
 
 	u8   *sas_addr;		  /* must be set */
 	u8   attached_sas_addr[SAS_ADDR_SIZE]; /* class:RO, driver: R/W */
@@ -376,7 +376,7 @@ void sas_hash_addr(u8 *hashed, const u8 
 static inline void sas_phy_disconnected(struct asd_sas_phy *phy)
 {
 	phy->oob_mode = OOB_NOT_CONNECTED;
-	phy->linkrate = PHY_LINKRATE_NONE;
+	phy->linkrate = SAS_LINK_RATE_UNKNOWN;
 }
 
 /* ---------- Tasks ---------- */
Index: BUILD-2.6/include/scsi/sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sas.h	2006-09-06 14:03:19.000000000 -0500
+++ BUILD-2.6/include/scsi/sas.h	2006-09-06 16:32:08.000000000 -0500
@@ -102,20 +102,6 @@ enum sas_dev_type {
 	SATA_PM_PORT= 8,
 };
 
-enum sas_phy_linkrate {
-	PHY_LINKRATE_NONE = 0,
-	PHY_LINKRATE_UNKNOWN = 0,
-	PHY_DISABLED,
-	PHY_RESET_PROBLEM,
-	PHY_SPINUP_HOLD,
-	PHY_PORT_SELECTOR,
-	PHY_LINKRATE_1_5 = 0x08,
-	PHY_LINKRATE_G1  = PHY_LINKRATE_1_5,
-	PHY_LINKRATE_3   = 0x09,
-	PHY_LINKRATE_G2  = PHY_LINKRATE_3,
-	PHY_LINKRATE_6   = 0x0A,
-};
-
 /* Partly from IDENTIFY address frame. */
 enum sas_proto {
 	SATA_PROTO    = 1,
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_init.c	2006-09-06 15:48:55.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_init.c	2006-09-06 15:57:27.000000000 -0500
@@ -243,10 +243,14 @@ static int __devinit asd_common_setup(st
 	/* All phys are enabled, by default. */
 	asd_ha->hw_prof.enabled_phys = 0xFF;
 	for (i = 0; i < ASD_MAX_PHYS; i++) {
-		asd_ha->hw_prof.phy_desc[i].max_sas_lrate = PHY_LINKRATE_3;
-		asd_ha->hw_prof.phy_desc[i].min_sas_lrate = PHY_LINKRATE_1_5;
-		asd_ha->hw_prof.phy_desc[i].max_sata_lrate= PHY_LINKRATE_1_5;
-		asd_ha->hw_prof.phy_desc[i].min_sata_lrate= PHY_LINKRATE_1_5;
+		asd_ha->hw_prof.phy_desc[i].max_sas_lrate =
+			SAS_LINK_RATE_3_0_GBPS;
+		asd_ha->hw_prof.phy_desc[i].min_sas_lrate =
+			SAS_LINK_RATE_1_5_GBPS;
+		asd_ha->hw_prof.phy_desc[i].max_sata_lrate =
+			SAS_LINK_RATE_1_5_GBPS;
+		asd_ha->hw_prof.phy_desc[i].min_sata_lrate =
+			SAS_LINK_RATE_1_5_GBPS;
 	}
 
 	return 0;
Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-09-06 15:53:53.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-09-06 15:56:09.000000000 -0500
@@ -191,20 +191,7 @@ static void sas_set_ex_phy(struct domain
 	phy->phy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
 	phy->phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
 	phy->phy->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
-	switch (phy->linkrate) {
-	case PHY_LINKRATE_1_5:
-		phy->phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
-		break;
-	case PHY_LINKRATE_3:
-		phy->phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
-		break;
-	case PHY_LINKRATE_6:
-		phy->phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
-		break;
-	default:
-		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
-		break;
-	}
+	phy->phy->negotiated_linkrate = phy->linkrate;
 
 	if (!rediscover)
 		sas_phy_add(phy->phy);
@@ -472,7 +459,7 @@ static void sas_ex_disable_phy(struct do
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 
 	sas_smp_phy_control(dev, phy_id, PHY_FUNC_DISABLE);
-	phy->linkrate = PHY_DISABLED;
+	phy->linkrate = SAS_PHY_DISABLED;
 }
 
 static void sas_ex_disable_port(struct domain_device *dev, u8 *sas_addr)
@@ -808,7 +795,7 @@ static int sas_ex_discover_dev(struct do
 	int res = 0;
 
 	/* Phy state */
-	if (ex_phy->linkrate == PHY_SPINUP_HOLD) {
+	if (ex_phy->linkrate == SAS_SATA_SPINUP_HOLD) {
 		if (!sas_smp_phy_control(dev, phy_id, PHY_FUNC_LINK_RESET))
 			res = sas_ex_phy_discover(dev, phy_id);
 		if (res)
@@ -838,7 +825,7 @@ static int sas_ex_discover_dev(struct do
 			sas_configure_routing(dev, ex_phy->attached_sas_addr);
 		}
 		return 0;
-	} else if (ex_phy->linkrate == PHY_LINKRATE_UNKNOWN)
+	} else if (ex_phy->linkrate == SAS_LINK_RATE_UNKNOWN)
 		return 0;
 
 	if (ex_phy->attached_dev_type != SAS_END_DEV &&
@@ -987,9 +974,9 @@ static int sas_ex_discover_devices(struc
 			continue;
 
 		switch (ex_phy->linkrate) {
-		case PHY_DISABLED:
-		case PHY_RESET_PROBLEM:
-		case PHY_PORT_SELECTOR:
+		case SAS_PHY_DISABLED:
+		case SAS_PHY_RESET_PROBLEM:
+		case SAS_SATA_PORT_SELECTOR:
 			continue;
 		default:
 			res = sas_ex_discover_dev(dev, i);
Index: BUILD-2.6/drivers/scsi/libsas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_internal.h	2006-09-06 15:50:59.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_internal.h	2006-09-06 15:51:22.000000000 -0500
@@ -43,7 +43,7 @@ void sas_scsi_recover_host(struct Scsi_H
 
 int sas_show_class(enum sas_class class, char *buf);
 int sas_show_proto(enum sas_proto proto, char *buf);
-int sas_show_linkrate(enum sas_phy_linkrate linkrate, char *buf);
+int sas_show_linkrate(enum sas_linkrate linkrate, char *buf);
 int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
 
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_hwi.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-09-06 15:57:47.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_hwi.c	2006-09-06 15:58:09.000000000 -0500
@@ -96,7 +96,7 @@ static int asd_init_phy(struct asd_phy *
 	sas_phy->type = PHY_TYPE_PHYSICAL;
 	sas_phy->role = PHY_ROLE_INITIATOR;
 	sas_phy->oob_mode = OOB_NOT_CONNECTED;
-	sas_phy->linkrate = PHY_LINKRATE_NONE;
+	sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;
 
 	phy->id_frm_tok = asd_alloc_coherent(asd_ha,
 					     sizeof(*phy->identify_frame),
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_scb.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_scb.c	2006-09-06 16:00:59.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_scb.c	2006-09-06 16:32:08.000000000 -0500
@@ -55,15 +55,15 @@ static inline void get_lrate_mode(struct
 	switch (oob_mode & 7) {
 	case PHY_SPEED_60:
 		/* FIXME: sas transport class doesn't have this */
-		phy->sas_phy.linkrate = PHY_LINKRATE_6;
+		phy->sas_phy.linkrate = SAS_LINK_RATE_6_0_GBPS;
 		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
 		break;
 	case PHY_SPEED_30:
-		phy->sas_phy.linkrate = PHY_LINKRATE_3;
+		phy->sas_phy.linkrate = SAS_LINK_RATE_3_0_GBPS;
 		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
 		break;
 	case PHY_SPEED_15:
-		phy->sas_phy.linkrate = PHY_LINKRATE_1_5;
+		phy->sas_phy.linkrate = SAS_LINK_RATE_1_5_GBPS;
 		phy->sas_phy.phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
 		break;
 	}
@@ -540,39 +540,39 @@ static inline void set_speed_mask(u8 *sp
 		| SATA_SPEED_30_DIS | SATA_SPEED_15_DIS;
 
 	switch (pd->max_sas_lrate) {
-	case PHY_LINKRATE_6:
+	case SAS_LINK_RATE_6_0_GBPS:
 		*speed_mask &= ~SAS_SPEED_60_DIS;
 	default:
-	case PHY_LINKRATE_3:
+	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask &= ~SAS_SPEED_30_DIS;
-	case PHY_LINKRATE_1_5:
+	case SAS_LINK_RATE_1_5_GBPS:
 		*speed_mask &= ~SAS_SPEED_15_DIS;
 	}
 
 	switch (pd->min_sas_lrate) {
-	case PHY_LINKRATE_6:
+	case SAS_LINK_RATE_6_0_GBPS:
 		*speed_mask |= SAS_SPEED_30_DIS;
-	case PHY_LINKRATE_3:
+	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask |= SAS_SPEED_15_DIS;
 	default:
-	case PHY_LINKRATE_1_5:
+	case SAS_LINK_RATE_1_5_GBPS:
 		/* nothing to do */
 		;
 	}
 
 	switch (pd->max_sata_lrate) {
-	case PHY_LINKRATE_3:
+	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask &= ~SATA_SPEED_30_DIS;
 	default:
-	case PHY_LINKRATE_1_5:
+	case SAS_LINK_RATE_1_5_GBPS:
 		*speed_mask &= ~SATA_SPEED_15_DIS;
 	}
 
 	switch (pd->min_sata_lrate) {
-	case PHY_LINKRATE_3:
+	case SAS_LINK_RATE_3_0_GBPS:
 		*speed_mask |= SATA_SPEED_15_DIS;
 	default:
-	case PHY_LINKRATE_1_5:
+	case SAS_LINK_RATE_1_5_GBPS:
 		/* nothing to do */
 		;
 	}


