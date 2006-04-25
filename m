From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] sas transport sysfs write attributes bug fix
Date: Tue, 25 Apr 2006 17:35:28 -0600
Message-ID: <20060425233528.GA9238@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:18932 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932305AbWDYXgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 19:36:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

The SAS Transport Layers SySFS write attributes were recently broke when
SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY was added.  This fix's the following
write attributes:

	/sys/class/sas_phy/phy-0:0/hard_reset
	/sys/class/sas_phy/phy-0:0/link_reset

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/scsi/scsi_transport_sas.c a/drivers/scsi/scsi_transport_sas.c
--- b/drivers/scsi/scsi_transport_sas.c	2006-04-20 17:23:04.000000000 -0600
+++ a/drivers/scsi/scsi_transport_sas.c	2006-04-25 17:13:21.000000000 -0600
@@ -982,6 +982,13 @@
 	if (test)							\
 		count++
 
+#define SETUP_TEMPLATE_WRONLY(attrb, field, perm, test)				\
+	i->private_##attrb[count] = class_device_attr_##field;		\
+	i->private_##attrb[count].attr.mode = perm;			\
+	i->private_##attrb[count].show = NULL;				\
+	i->attrb[count] = &i->private_##attrb[count];			\
+	if (test)							\
+		count++
 
 #define SETUP_RPORT_ATTRIBUTE(field) 					\
 	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, 1)
@@ -996,10 +1003,10 @@
 	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, i->f->func)
 
 #define SETUP_PORT_ATTRIBUTE_WRONLY(field)				\
-	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, 1)
+	SETUP_TEMPLATE_WRONLY(phy_attrs, field, S_IWUGO, 1)
 
 #define SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(field, func)		\
-	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, i->f->func)
+	SETUP_TEMPLATE_WRONLY(phy_attrs, field, S_IWUGO, i->f->func)
 
 #define SETUP_END_DEV_ATTRIBUTE(field)					\
 	SETUP_TEMPLATE(end_dev_attrs, field, S_IRUGO, 1)
