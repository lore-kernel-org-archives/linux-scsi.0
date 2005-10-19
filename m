From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] sas: add support for PHY resets
Date: Wed, 19 Oct 2005 20:01:31 +0200
Message-ID: <20051019180131.GC21488@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28040 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751204AbVJSSBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 14:01:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c	2005-10-19 19:50:55.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c	2005-10-19 19:55:18.000000000 +0200
@@ -34,7 +34,7 @@
 
 
 #define SAS_HOST_ATTRS		0
-#define SAS_PORT_ATTRS		15
+#define SAS_PORT_ATTRS		17
 #define SAS_RPORT_ATTRS		5
 
 struct sas_internal {
@@ -289,9 +289,39 @@
 		return snprintf(buf, 20, "none\n");
 	return get_sas_device_type_names(phy->identify.device_type, buf);
 }
-
 static CLASS_DEVICE_ATTR(device_type, S_IRUGO, show_sas_device_type, NULL);
 
+static ssize_t do_sas_phy_reset(struct class_device *cdev,
+		size_t count, int hard_reset)
+{
+	struct sas_phy *phy = transport_class_to_phy(cdev);
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+	struct sas_internal *i = to_sas_internal(shost->transportt);
+	int error;
+
+	if (!phy->local_attached)
+		return -EINVAL;
+
+	error = i->f->phy_reset(phy, hard_reset);
+	if (error)
+		return error;
+	return count;
+};
+
+static ssize_t store_sas_link_reset(struct class_device *cdev,
+		const char *buf, size_t count)
+{
+	return do_sas_phy_reset(cdev, count, 0);
+}
+static CLASS_DEVICE_ATTR(link_reset, S_IWUSR, NULL, store_sas_link_reset);
+
+static ssize_t store_sas_hard_reset(struct class_device *cdev,
+		const char *buf, size_t count)
+{
+	return do_sas_phy_reset(cdev, count, 1);
+}
+static CLASS_DEVICE_ATTR(hard_reset, S_IWUSR, NULL, store_sas_hard_reset);
+
 sas_phy_protocol_attr(identify.initiator_port_protocols,
 		initiator_port_protocols);
 sas_phy_protocol_attr(identify.target_port_protocols,
@@ -725,6 +755,13 @@
         i->phy_attrs[count] = &i->private_phy_attrs[count];		\
 	count++
 
+#define SETUP_PORT_ATTRIBUTE_WRONLY(field)				\
+	i->private_phy_attrs[count] = class_device_attr_##field;	\
+	i->private_phy_attrs[count].attr.mode = S_IWUGO;		\
+	i->private_phy_attrs[count].show = NULL;			\
+	i->phy_attrs[count] = &i->private_phy_attrs[count];		\
+	count++
+
 
 /**
  * sas_attach_transport  --  instantiate SAS transport template
@@ -781,6 +818,8 @@
 	SETUP_PORT_ATTRIBUTE(running_disparity_error_count);
 	SETUP_PORT_ATTRIBUTE(loss_of_dword_sync_count);
 	SETUP_PORT_ATTRIBUTE(phy_reset_problem_count);
+	SETUP_PORT_ATTRIBUTE_WRONLY(link_reset);
+	SETUP_PORT_ATTRIBUTE_WRONLY(hard_reset);
 	i->phy_attrs[count] = NULL;
 
 	count = 0;
Index: linux-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_transport_sas.h	2005-10-19 19:49:35.000000000 +0200
+++ linux-2.6/include/scsi/scsi_transport_sas.h	2005-10-19 19:51:01.000000000 +0200
@@ -94,6 +94,7 @@
 /* The functions by which the transport class and the driver communicate */
 struct sas_function_template {
 	int (*get_linkerrors)(struct sas_phy *);
+	int (*phy_reset)(struct sas_phy *, int);
 };
 
 
