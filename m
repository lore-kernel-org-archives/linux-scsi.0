From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_transport_sas: support link error attributes
Date: Mon, 19 Sep 2005 21:59:42 +0200
Message-ID: <20050919195942.GA18616@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43701 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932623AbVIST7q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 15:59:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

For now supporting the ->get_linkerrors method is mandatory.  I'll
probably be beaten to implement the .show_foo variables and different
types of attributes soon..


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_transport_sas.c	2005-09-18 13:47:25.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_transport_sas.c	2005-09-19 19:55:23.000000000 +0200
@@ -34,7 +34,7 @@
 
 
 #define SAS_HOST_ATTRS		0
-#define SAS_PORT_ATTRS		11
+#define SAS_PORT_ATTRS		15
 #define SAS_RPORT_ATTRS		5
 
 struct sas_internal {
@@ -257,6 +257,26 @@
 	sas_phy_show_linkspeed(field)					\
 static CLASS_DEVICE_ATTR(field, S_IRUGO, show_sas_phy_##field, NULL)
 
+#define sas_phy_show_linkerror(field)					\
+static ssize_t								\
+show_sas_phy_##field(struct class_device *cdev, char *buf)		\
+{									\
+	struct sas_phy *phy = transport_class_to_phy(cdev);		\
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);	\
+	struct sas_internal *i = to_sas_internal(shost->transportt);	\
+	int error;							\
+									\
+	error = i->f->get_linkerrors(phy);				\
+	if (error)							\
+		return error;						\
+	return snprintf(buf, 20, "%u\n", phy->field);			\
+}
+
+#define sas_phy_linkerror_attr(field)					\
+	sas_phy_show_linkerror(field)					\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_sas_phy_##field, NULL)
+
+
 static ssize_t
 show_sas_device_type(struct class_device *cdev, char *buf)
 {
@@ -282,6 +302,10 @@
 sas_phy_linkspeed_attr(minimum_linkrate);
 sas_phy_linkspeed_attr(maximum_linkrate_hw);
 sas_phy_linkspeed_attr(maximum_linkrate);
+sas_phy_linkerror_attr(invalid_dword_count);
+sas_phy_linkerror_attr(running_disparity_error_count);
+sas_phy_linkerror_attr(loss_of_dword_sync_count);
+sas_phy_linkerror_attr(phy_reset_problem_count);
 
 
 static DECLARE_TRANSPORT_CLASS(sas_phy_class,
@@ -750,6 +774,11 @@
 	SETUP_PORT_ATTRIBUTE(minimum_linkrate);
 	SETUP_PORT_ATTRIBUTE(maximum_linkrate_hw);
 	SETUP_PORT_ATTRIBUTE(maximum_linkrate);
+
+	SETUP_PORT_ATTRIBUTE(invalid_dword_count);
+	SETUP_PORT_ATTRIBUTE(running_disparity_error_count);
+	SETUP_PORT_ATTRIBUTE(loss_of_dword_sync_count);
+	SETUP_PORT_ATTRIBUTE(phy_reset_problem_count);
 	i->phy_attrs[count] = NULL;
 
 	count = 0;
Index: linux-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_transport_sas.h	2005-09-18 13:47:45.000000000 +0200
+++ linux-2.6/include/scsi/scsi_transport_sas.h	2005-09-19 18:31:14.000000000 +0200
@@ -41,20 +41,28 @@
 	u8			phy_identifier;
 };
 
-/* The functions by which the transport class and the driver communicate */
-struct sas_function_template {
-};
-
 struct sas_phy {
 	struct device		dev;
 	int			number;
+
+	/* phy identification */
 	struct sas_identify	identify;
+
+	/* phy attributes */
 	enum sas_linkrate	negotiated_linkrate;
 	enum sas_linkrate	minimum_linkrate_hw;
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate_hw;
 	enum sas_linkrate	maximum_linkrate;
 	u8			port_identifier;
+
+	/* link error statistics */
+	u32			invalid_dword_count;
+	u32			running_disparity_error_count;
+	u32			loss_of_dword_sync_count;
+	u32			phy_reset_problem_count;
+
+	/* the other end of the link */
 	struct sas_rphy		*rphy;
 };
 
@@ -79,6 +87,13 @@
 #define rphy_to_shost(rphy) \
 	dev_to_shost((rphy)->dev.parent)
 
+
+/* The functions by which the transport class and the driver communicate */
+struct sas_function_template {
+	int (*get_linkerrors)(struct sas_phy *);
+};
+
+
 extern void sas_remove_host(struct Scsi_Host *);
 
 extern struct sas_phy *sas_phy_alloc(struct device *, int);
