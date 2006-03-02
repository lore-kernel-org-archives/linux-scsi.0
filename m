From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] make some sas class properties optional
Date: Thu, 02 Mar 2006 16:01:31 -0600
Message-ID: <1141336891.3238.68.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38328 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1752002AbWCBWBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 17:01:43 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k22M1V222171
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 17:01:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

aic94xx doesn't have a use for the bay or enclosure identifiers.
Also, I think it's not going to need a get_linkerrors(), so wire up
all of these exported properties as conditional on the underlying
function support.

James

---

Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-03-02 15:31:28.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2006-03-02 15:53:24.000000000 -0600
@@ -273,7 +273,7 @@
 	if (!phy->local_attached)					\
 		return -EINVAL;						\
 									\
-	error = i->f->get_linkerrors(phy);				\
+	error = i->f->get_linkerrors ? i->f->get_linkerrors(phy) : 0;	\
 	if (error)							\
 		return error;						\
 	return snprintf(buf, 20, "%u\n", phy->field);			\
@@ -814,6 +814,14 @@
 	i->rphy_attrs[count] = &i->private_rphy_attrs[count];	\
 	count++
 
+#define SETUP_OPTIONAL_RPORT_ATTRIBUTE(field, func)			\
+	i->private_rphy_attrs[count] = class_device_attr_##field;	\
+	i->private_rphy_attrs[count].attr.mode = S_IRUGO;		\
+	i->private_rphy_attrs[count].store = NULL;			\
+	i->rphy_attrs[count] = &i->private_rphy_attrs[count];		\
+	if (i->f->func)							\
+		count++
+
 #define SETUP_PORT_ATTRIBUTE(field)					\
 	i->private_phy_attrs[count] = class_device_attr_##field;	\
         i->private_phy_attrs[count].attr.mode = S_IRUGO;		\
@@ -821,6 +829,14 @@
         i->phy_attrs[count] = &i->private_phy_attrs[count];		\
 	count++
 
+#define SETUP_OPTIONAL_PORT_ATTRIBUTE(field, func)			\
+	i->private_phy_attrs[count] = class_device_attr_##field;	\
+        i->private_phy_attrs[count].attr.mode = S_IRUGO;		\
+        i->private_phy_attrs[count].store = NULL;			\
+        i->phy_attrs[count] = &i->private_phy_attrs[count];		\
+	if (i->f->func)							\
+		count++
+
 #define SETUP_PORT_ATTRIBUTE_WRONLY(field)				\
 	i->private_phy_attrs[count] = class_device_attr_##field;	\
 	i->private_phy_attrs[count].attr.mode = S_IWUGO;		\
@@ -828,6 +844,14 @@
 	i->phy_attrs[count] = &i->private_phy_attrs[count];		\
 	count++
 
+#define SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(field, func)		\
+	i->private_phy_attrs[count] = class_device_attr_##field;	\
+	i->private_phy_attrs[count].attr.mode = S_IWUGO;		\
+	i->private_phy_attrs[count].show = NULL;			\
+	i->phy_attrs[count] = &i->private_phy_attrs[count];		\
+	if (i->f->func)							\
+		count++
+
 
 /**
  * sas_attach_transport  --  instantiate SAS transport template
@@ -883,8 +907,8 @@
 	SETUP_PORT_ATTRIBUTE(running_disparity_error_count);
 	SETUP_PORT_ATTRIBUTE(loss_of_dword_sync_count);
 	SETUP_PORT_ATTRIBUTE(phy_reset_problem_count);
-	SETUP_PORT_ATTRIBUTE_WRONLY(link_reset);
-	SETUP_PORT_ATTRIBUTE_WRONLY(hard_reset);
+	SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(link_reset, phy_reset);
+	SETUP_OPTIONAL_PORT_ATTRIBUTE_WRONLY(hard_reset, phy_reset);
 	i->phy_attrs[count] = NULL;
 
 	count = 0;
@@ -893,8 +917,10 @@
 	SETUP_RPORT_ATTRIBUTE(rphy_device_type);
 	SETUP_RPORT_ATTRIBUTE(rphy_sas_address);
 	SETUP_RPORT_ATTRIBUTE(rphy_phy_identifier);
-	SETUP_RPORT_ATTRIBUTE(rphy_enclosure_identifier);
-	SETUP_RPORT_ATTRIBUTE(rphy_bay_identifier);
+	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_enclosure_identifier,
+				       get_enclosure_identifier);
+	SETUP_OPTIONAL_RPORT_ATTRIBUTE(rphy_bay_identifier,
+				       get_bay_identifier);
 	i->rphy_attrs[count] = NULL;
 
 	return &i->t;


