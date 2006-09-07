From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_transport_sas: make minimum and maximum linkrate
	settable quantities
Date: Wed, 06 Sep 2006 19:25:22 -0500
Message-ID: <1157588722.3469.33.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48539 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161022AbWIGAZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Sep 2006 20:25:24 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k870PN506703
	for <linux-scsi@vger.kernel.org>; Wed, 6 Sep 2006 20:25:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

According to SPEC, the minimum_linkrate and maximum_linkrate should be
settable by the user.  This patch introduces a callback that allows the
sas class to pass these settings on to the driver.

James

Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-09-06 16:32:11.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2006-09-06 17:51:15.000000000 -0500
@@ -77,6 +77,24 @@ get_sas_##title##_names(u32 table_key, c
 	return len;						\
 }
 
+#define sas_bitfield_name_set(title, table)			\
+static ssize_t							\
+set_sas_##title##_names(u32 *table_key, const char *buf)	\
+{								\
+	ssize_t len = 0;					\
+	int i;							\
+								\
+	for (i = 0; i < ARRAY_SIZE(table); i++) {		\
+		len = strlen(table[i].name);			\
+		if (strncmp(buf, table[i].name, len) == 0 &&	\
+		    (buf[len] == '\n' || buf[len] == '\0')) {	\
+			*table_key = table[i].value;		\
+			return 0;				\
+		}						\
+	}							\
+	return -EINVAL;						\
+}
+
 #define sas_bitfield_name_search(title, table)			\
 static ssize_t							\
 get_sas_##title##_names(u32 table_key, char *buf)		\
@@ -131,7 +149,7 @@ static struct {
 	{ SAS_LINK_RATE_6_0_GBPS,	"6.0 Gbit" },
 };
 sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
-
+sas_bitfield_name_set(linkspeed, sas_linkspeed_names)
 
 /*
  * SAS host attributes
@@ -253,10 +271,39 @@ show_sas_phy_##field(struct class_device
 	return get_sas_linkspeed_names(phy->field, buf);		\
 }
 
+/* Fudge to tell if we're minimum or maximum */
+#define sas_phy_store_linkspeed(field)					\
+static ssize_t								\
+store_sas_phy_##field(struct class_device *cdev, const char *buf,	\
+		      size_t count)					\
+{									\
+	struct sas_phy *phy = transport_class_to_phy(cdev);		\
+	struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);	\
+	struct sas_internal *i = to_sas_internal(shost->transportt);	\
+	u32 value;							\
+	struct sas_phy_linkrates rates = {0};				\
+	int error;							\
+									\
+	error = set_sas_linkspeed_names(&value, buf);			\
+	if (error)							\
+		return error;						\
+	rates.field = value;						\
+	error = i->f->set_phy_speed(phy, &rates);			\
+									\
+	return error ? error : count;					\
+}
+
+#define sas_phy_linkspeed_rw_attr(field)				\
+	sas_phy_show_linkspeed(field)					\
+	sas_phy_store_linkspeed(field)					\
+static CLASS_DEVICE_ATTR(field, S_IRUGO, show_sas_phy_##field,		\
+	store_sas_phy_##field)
+
 #define sas_phy_linkspeed_attr(field)					\
 	sas_phy_show_linkspeed(field)					\
 static CLASS_DEVICE_ATTR(field, S_IRUGO, show_sas_phy_##field, NULL)
 
+
 #define sas_phy_show_linkerror(field)					\
 static ssize_t								\
 show_sas_phy_##field(struct class_device *cdev, char *buf)		\
@@ -326,9 +373,9 @@ sas_phy_simple_attr(identify.phy_identif
 //sas_phy_simple_attr(port_identifier, port_identifier, "%d\n", int);
 sas_phy_linkspeed_attr(negotiated_linkrate);
 sas_phy_linkspeed_attr(minimum_linkrate_hw);
-sas_phy_linkspeed_attr(minimum_linkrate);
+sas_phy_linkspeed_rw_attr(minimum_linkrate);
 sas_phy_linkspeed_attr(maximum_linkrate_hw);
-sas_phy_linkspeed_attr(maximum_linkrate);
+sas_phy_linkspeed_rw_attr(maximum_linkrate);
 sas_phy_linkerror_attr(invalid_dword_count);
 sas_phy_linkerror_attr(running_disparity_error_count);
 sas_phy_linkerror_attr(loss_of_dword_sync_count);
@@ -1310,13 +1357,23 @@ static int sas_user_scan(struct Scsi_Hos
  * Setup / Teardown code
  */
 
-#define SETUP_TEMPLATE(attrb, field, perm, test)				\
+#define SETUP_TEMPLATE(attrb, field, perm, test)			\
 	i->private_##attrb[count] = class_device_attr_##field;		\
 	i->private_##attrb[count].attr.mode = perm;			\
 	i->attrb[count] = &i->private_##attrb[count];			\
 	if (test)							\
 		count++
 
+#define SETUP_TEMPLATE_RW(attrb, field, perm, test, ro_test, ro_perm)	\
+	i->private_##attrb[count] = class_device_attr_##field;		\
+	i->private_##attrb[count].attr.mode = perm;			\
+	if (ro_test) {							\
+		i->private_##attrb[count].attr.mode = ro_perm;		\
+		i->private_##attrb[count].store = NULL;			\
+	}								\
+	i->attrb[count] = &i->private_##attrb[count];			\
+	if (test)							\
+		count++
 
 #define SETUP_RPORT_ATTRIBUTE(field) 					\
 	SETUP_TEMPLATE(rphy_attrs, field, S_IRUGO, 1)
@@ -1327,6 +1384,10 @@ static int sas_user_scan(struct Scsi_Hos
 #define SETUP_PHY_ATTRIBUTE(field)					\
 	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, 1)
 
+#define SETUP_PHY_ATTRIBUTE_RW(field)					\
+	SETUP_TEMPLATE_RW(phy_attrs, field, S_IRUGO | S_IWUSR, 1,	\
+			!i->f->set_phy_speed, S_IRUGO)
+
 #define SETUP_PORT_ATTRIBUTE(field)					\
 	SETUP_TEMPLATE(port_attrs, field, S_IRUGO, 1)
 
@@ -1407,9 +1468,9 @@ sas_attach_transport(struct sas_function
 	//SETUP_PHY_ATTRIBUTE(port_identifier);
 	SETUP_PHY_ATTRIBUTE(negotiated_linkrate);
 	SETUP_PHY_ATTRIBUTE(minimum_linkrate_hw);
-	SETUP_PHY_ATTRIBUTE(minimum_linkrate);
+	SETUP_PHY_ATTRIBUTE_RW(minimum_linkrate);
 	SETUP_PHY_ATTRIBUTE(maximum_linkrate_hw);
-	SETUP_PHY_ATTRIBUTE(maximum_linkrate);
+	SETUP_PHY_ATTRIBUTE_RW(maximum_linkrate);
 
 	SETUP_PHY_ATTRIBUTE(invalid_dword_count);
 	SETUP_PHY_ATTRIBUTE(running_disparity_error_count);
Index: BUILD-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_transport_sas.h	2006-09-06 16:32:11.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_transport_sas.h	2006-09-06 17:48:02.000000000 -0500
@@ -150,12 +150,18 @@ struct sas_port {
 #define transport_class_to_sas_port(cdev) \
 	dev_to_sas_port((cdev)->dev)
 
+struct sas_phy_linkrates {
+	enum sas_linkrate maximum_linkrate;
+	enum sas_linkrate minimum_linkrate;
+};
+
 /* The functions by which the transport class and the driver communicate */
 struct sas_function_template {
 	int (*get_linkerrors)(struct sas_phy *);
 	int (*get_enclosure_identifier)(struct sas_rphy *, u64 *);
 	int (*get_bay_identifier)(struct sas_rphy *);
 	int (*phy_reset)(struct sas_phy *, int);
+	int (*set_phy_speed)(struct sas_phy *, struct sas_phy_linkrates *);
 };
 
 


