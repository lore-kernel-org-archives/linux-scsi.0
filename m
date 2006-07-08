From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: fix cascaded expander properties
Date: Sat, 08 Jul 2006 11:08:36 -0500
Message-ID: <1152374916.12020.7.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:677 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964885AbWGHQIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 12:08:38 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k68G8bY00830
	for <linux-scsi@vger.kernel.org>; Sat, 8 Jul 2006 12:08:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The sas_device properties for a cascaded expander are always empty.  Fix
this by filling them in at the correct point (also refactor the code
since we do this in several places).

James

Index: BUILD-2.6/drivers/scsi/sas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_expander.c	2006-07-08 10:44:43.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_expander.c	2006-07-08 10:56:53.000000000 -0500
@@ -611,11 +611,7 @@
 		sas_init_dev(child);
 
 		child->rphy = rphy;
-		rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
-		rphy->identify.device_type = SAS_END_DEVICE;
-		rphy->identify.sas_address = SAS_ADDR(child->sas_addr);
-		rphy->identify.initiator_port_protocols = child->iproto;
-		rphy->identify.target_port_protocols = child->tproto;
+		sas_fill_in_rphy(child, rphy);
 
 		spin_lock(&parent->port->dev_list_lock);
 		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
@@ -698,7 +694,8 @@
 	parent->port->disc.max_level = max(parent->port->disc.max_level,
 					   edev->level);
 	sas_init_dev(child);
-	sas_rphy_add(child->rphy);
+	sas_fill_in_rphy(child, rphy);
+	sas_rphy_add(rphy);
 
 	spin_lock(&parent->port->dev_list_lock);
 	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
Index: BUILD-2.6/drivers/scsi/sas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_discover.c	2006-07-08 10:48:55.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_discover.c	2006-07-08 10:49:57.000000000 -0500
@@ -278,25 +278,7 @@
 	}
 	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
-	rphy->identify.sas_address = SAS_ADDR(dev->sas_addr);
-	rphy->identify.initiator_port_protocols = dev->iproto;
-	rphy->identify.target_port_protocols = dev->tproto;
-	switch (dev->dev_type) {
-	case SATA_DEV:
-		/* FIXME: need sata device type */
-	case SAS_END_DEV:
-		rphy->identify.device_type = SAS_END_DEVICE;
-		break;
-	case EDGE_DEV:
-		rphy->identify.device_type = SAS_EDGE_EXPANDER_DEVICE;
-		break;
-	case FANOUT_DEV:
-		rphy->identify.device_type = SAS_FANOUT_EXPANDER_DEVICE;
-		break;
-	default:
-		rphy->identify.device_type = SAS_PHY_UNUSED;
-		break;
-	}
+	sas_fill_in_rphy(dev, rphy);
 	sas_hash_addr(dev->hashed_sas_addr, dev->sas_addr);
 	port->port_dev = dev;
 	dev->port = port;
Index: BUILD-2.6/drivers/scsi/sas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_internal.h	2006-07-08 10:58:17.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_internal.h	2006-07-08 10:58:20.000000000 -0500
@@ -26,8 +26,9 @@
 #ifndef _SAS_INTERNAL_H_
 #define _SAS_INTERNAL_H_
 
-#include <scsi/libsas.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_sas.h>
+#include <scsi/libsas.h>
 
 #define sas_printk(fmt, ...) printk(KERN_NOTICE "sas: " fmt, ## __VA_ARGS__)
 
@@ -97,4 +98,28 @@
 	spin_unlock_irqrestore(lock, flags);
 }
 
+static inline void sas_fill_in_rphy(struct domain_device *dev,
+				    struct sas_rphy *rphy)
+{
+	rphy->identify.sas_address = SAS_ADDR(dev->sas_addr);
+	rphy->identify.initiator_port_protocols = dev->iproto;
+	rphy->identify.target_port_protocols = dev->tproto;
+	switch (dev->dev_type) {
+	case SATA_DEV:
+		/* FIXME: need sata device type */
+	case SAS_END_DEV:
+		rphy->identify.device_type = SAS_END_DEVICE;
+		break;
+	case EDGE_DEV:
+		rphy->identify.device_type = SAS_EDGE_EXPANDER_DEVICE;
+		break;
+	case FANOUT_DEV:
+		rphy->identify.device_type = SAS_FANOUT_EXPANDER_DEVICE;
+		break;
+	default:
+		rphy->identify.device_type = SAS_PHY_UNUSED;
+		break;
+	}
+}
+
 #endif /* _SAS_INTERNAL_H_ */


