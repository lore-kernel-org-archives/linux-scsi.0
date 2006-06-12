From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_transport_sas: fix panic in sas_free_rphy
Date: Mon, 12 Jun 2006 09:09:18 -0500
Message-ID: <1150121358.3413.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38029 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751987AbWFLOJT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 10:09:19 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k5CE9Ia20988
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jun 2006 10:09:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a hold over from the end device/expander conversion.  Apparently
the rphy list pointer is never initialised, so list_del() on the
uninitialised pointer can panic the system

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

---

James

Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-06-12 08:58:19.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2006-06-12 09:05:18.000000000 -0500
@@ -1004,6 +1004,18 @@
 }
 
 /**
+ * sas_rphy_initialize - common rphy intialization
+ * @rphy:	rphy to initialise
+ *
+ * Used by both sas_end_device_alloc() and sas_expander_alloc() to
+ * initialise the common rphy component of each.
+ */
+static void sas_rphy_initialize(struct sas_rphy *rphy)
+{
+	INIT_LIST_HEAD(&rphy->list);
+}
+
+/**
  * sas_end_device_alloc - allocate an rphy for an end device
  *
  * Allocates an SAS remote PHY structure, connected to @parent.
@@ -1027,6 +1039,7 @@
 	sprintf(rdev->rphy.dev.bus_id, "end_device-%d:%d-%d",
 		shost->host_no, parent->port_identifier, parent->port_identifier);
 	rdev->rphy.identify.device_type = SAS_END_DEVICE;
+	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
 	return &rdev->rphy;
@@ -1065,6 +1078,7 @@
 	sprintf(rdev->rphy.dev.bus_id, "expander-%d:%d",
 		shost->host_no, rdev->rphy.scsi_target_id);
 	rdev->rphy.identify.device_type = type;
+	sas_rphy_initialize(&rdev->rphy);
 	transport_setup_device(&rdev->rphy.dev);
 
 	return &rdev->rphy;


