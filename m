From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sas: add support for enclosure and bad ID rphy attributes
Date: Thu, 16 Feb 2006 13:31:47 +0100
Message-ID: <20060216123147.GA1637@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20363 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1030584AbWBPMbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 07:31:50 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-02-14 16:23:30.000000000 +0100
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c	2006-02-16 13:22:32.000000000 +0100
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2005 Dell Inc.
+ * Copyright (C) 2005-2006 Dell Inc.
  *	Released under GPL v2.
  *
  * Serial Attached SCSI (SAS) transport class.
@@ -38,7 +38,7 @@
 
 #define SAS_HOST_ATTRS		0
 #define SAS_PORT_ATTRS		17
-#define SAS_RPORT_ATTRS		5
+#define SAS_RPORT_ATTRS		7
 
 struct sas_internal {
 	struct scsi_transport_template t;
@@ -534,6 +534,53 @@
 static SAS_CLASS_DEVICE_ATTR(rphy, device_type, S_IRUGO,
 		show_sas_rphy_device_type, NULL);
 
+static ssize_t
+show_sas_rphy_enclosure_identifier(struct class_device *cdev, char *buf)
+{
+	struct sas_rphy *rphy = transport_class_to_rphy(cdev);
+	struct sas_phy *phy = dev_to_phy(rphy->dev.parent);
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+	u64 identifier;
+	int error;
+
+	/*
+	 * Only devices behind an expander are supported, because the
+	 * enclosure identifier is a SMP feature.
+	 */
+	if (phy->local_attached)
+		return -EINVAL;
+
+	error = i->f->get_enclosure_identifier(rphy, &identifier);
+	if (error)
+		return error;
+	return sprintf(buf, "0x%llx\n", (unsigned long long)identifier);
+}
+
+static SAS_CLASS_DEVICE_ATTR(rphy, enclosure_identifier, S_IRUGO,
+		show_sas_rphy_enclosure_identifier, NULL);
+
+static ssize_t
+show_sas_rphy_bay_identifier(struct class_device *cdev, char *buf)
+{
+	struct sas_rphy *rphy = transport_class_to_rphy(cdev);
+	struct sas_phy *phy = dev_to_phy(rphy->dev.parent);
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+	int val;
+
+	if (phy->local_attached)
+		return -EINVAL;
+
+	val = i->f->get_bay_identifier(rphy);
+	if (val < 0)
+		return val;
+	return sprintf(buf, "%d\n", val);
+}
+
+static SAS_CLASS_DEVICE_ATTR(rphy, bay_identifier, S_IRUGO,
+		show_sas_rphy_bay_identifier, NULL);
+
 sas_rphy_protocol_attr(identify.initiator_port_protocols,
 		initiator_port_protocols);
 sas_rphy_protocol_attr(identify.target_port_protocols, target_port_protocols);
@@ -848,6 +895,8 @@
 	SETUP_RPORT_ATTRIBUTE(rphy_device_type);
 	SETUP_RPORT_ATTRIBUTE(rphy_sas_address);
 	SETUP_RPORT_ATTRIBUTE(rphy_phy_identifier);
+	SETUP_RPORT_ATTRIBUTE(rphy_enclosure_identifier);
+	SETUP_RPORT_ATTRIBUTE(rphy_bay_identifier);
 	i->rphy_attrs[count] = NULL;
 
 	return &i->t;
Index: linux-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_transport_sas.h	2006-02-14 16:23:30.000000000 +0100
+++ linux-2.6/include/scsi/scsi_transport_sas.h	2006-02-16 12:58:19.000000000 +0100
@@ -94,6 +94,8 @@
 /* The functions by which the transport class and the driver communicate */
 struct sas_function_template {
 	int (*get_linkerrors)(struct sas_phy *);
+	int (*get_enclosure_identifier)(struct sas_rphy *, u64 *);
+	int (*get_bay_identifier)(struct sas_rphy *);
 	int (*phy_reset)(struct sas_phy *, int);
 };
 
