From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: add backlink port
Date: Sat, 08 Jul 2006 12:52:17 -0500
Message-ID: <1152381138.12020.30.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56744 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964918AbWGHRwT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 13:52:19 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k68HqIY05768
	for <linux-scsi@vger.kernel.org>; Sat, 8 Jul 2006 13:52:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This brings the aic94xx topology directly equvalent to the mptsas one.
What was missing is the port that's formed on the expander to connect to
the parent device (i.e. connecting up rather than down).  This patch
adds a representation for that port.

It also gets rid of the port tracking in the expander device, since that
was totally unused.

James

Index: BUILD-2.6/drivers/scsi/sas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_discover.c	2006-07-08 12:19:31.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_discover.c	2006-07-08 12:20:56.000000000 -0500
@@ -639,8 +639,6 @@
 		/* remove the phys and ports, everything else should be gone */
 		kfree(dev->ex_dev.ex_phy);
 		dev->ex_dev.ex_phy = NULL;
-		kfree(dev->ex_dev.ex_port);
-		dev->ex_dev.ex_port = NULL;
 	}
 }
 
Index: BUILD-2.6/drivers/scsi/sas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_expander.c	2006-07-08 12:05:37.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_expander.c	2006-07-08 12:48:16.000000000 -0500
@@ -272,9 +272,6 @@
 	ex->ex_phy = kzalloc(sizeof(*ex->ex_phy)*ex->num_phys, GFP_KERNEL);
 	if (!ex->ex_phy)
 		return -ENOMEM;
-	ex->ex_port = kzalloc(sizeof(void *)*ex->num_phys, GFP_KERNEL);
-	if (!ex->ex_port)
-		goto out_free_phys;
 
 	res = sas_ex_phy_discover(dev, -1);
 	if (res)
@@ -282,9 +279,6 @@
 
 	return 0;
  out_err:
-	kfree(ex->ex_port);
-	ex->ex_port = NULL;
- out_free_phys:
 	kfree(ex->ex_phy);
 	ex->ex_phy = NULL;
 	return res;
@@ -520,11 +514,7 @@
 
 	child->pathways = 0;
 
-	for (i = 0; i < parent_ex->num_phys; i++)
-		if (!parent_ex->ex_port[i])
-			break;
-
-	parent_ex->ex_port[i] = port = parent_phy->port;
+	port = parent_phy->port;
 
 	for (i = 0; i < parent_ex->num_phys; i++) {
 		struct ex_phy *phy = &parent_ex->ex_phy[i];
@@ -729,11 +719,16 @@
 
 	/* Parent and domain coherency */
 	if (!dev->parent && (SAS_ADDR(ex_phy->attached_sas_addr) ==
-			     SAS_ADDR(dev->port->sas_addr)))
+			     SAS_ADDR(dev->port->sas_addr))) {
+		sas_add_parent_port(dev, phy_id);
 		return 0;
+	}
 	if (dev->parent && (SAS_ADDR(ex_phy->attached_sas_addr) ==
-			    SAS_ADDR(dev->parent->sas_addr)))
+			    SAS_ADDR(dev->parent->sas_addr))) {
+		sas_add_parent_port(dev, phy_id);
 		return 0;
+	}
+
 	if (sas_dev_present_in_domain(dev->port, ex_phy->attached_sas_addr))
 		sas_ex_disable_port(dev, ex_phy->attached_sas_addr);
 
Index: BUILD-2.6/include/scsi/libsas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/libsas.h	2006-07-08 12:19:40.000000000 -0500
+++ BUILD-2.6/include/scsi/libsas.h	2006-07-08 12:19:53.000000000 -0500
@@ -147,7 +147,7 @@
 	u8     enclosure_logical_id[8];
 
 	struct ex_phy *ex_phy;
-	struct sas_port **ex_port;
+	struct sas_port *parent_port;
 };
 
 /* ---------- SATA device ---------- */
Index: BUILD-2.6/drivers/scsi/sas/sas_internal.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_internal.h	2006-07-08 12:33:47.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_internal.h	2006-07-08 12:37:01.000000000 -0500
@@ -97,4 +97,18 @@
 	spin_unlock_irqrestore(lock, flags);
 }
 
+static inline void sas_add_parent_port(struct domain_device *dev, int phy_id)
+{
+	struct expander_device *ex = &dev->ex_dev;
+	struct ex_phy *ex_phy = &ex->ex_phy[phy_id];
+
+	if (!ex->parent_port) {
+		ex->parent_port = sas_port_alloc(&dev->rphy->dev, phy_id);
+		/* FIXME: error handling */
+		BUG_ON(!ex->parent_port);
+		BUG_ON(sas_port_add(ex->parent_port));
+	}
+	sas_port_add_phy(ex->parent_port, ex_phy->phy);
+}
+
 #endif /* _SAS_INTERNAL_H_ */


