From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_transport_sas: add unindexed ports
Date: Sun, 02 Jul 2006 11:10:18 -0500
Message-ID: <1151856619.3558.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14797 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932511AbWGBQKU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 12:10:20 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k62GAJY02985
	for <linux-scsi@vger.kernel.org>; Sun, 2 Jul 2006 12:10:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Some SAS HBAs don't want to go to the trouble of tracking port numbers,
so they'd simply like to say "add this port and give it a number".
This is especially beneficial from the hotplug point of view, since
tracking ports and the available number space can be a real pain.

The current implementation uses an incrementing number per expander to
add the port on.  However, since there can never be more ports than
there are phys, a later implementation will try to be more intelligent
about this.

James

Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-06-30 21:40:34.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2006-07-01 08:52:35.000000000 -0500
@@ -41,6 +41,7 @@
 	struct mutex lock;
 	u32 next_target_id;
 	u32 next_expander_id;
+	int next_port_id;
 };
 #define to_sas_host_attrs(host)	((struct sas_host_attrs *)(host)->shost_data)
 
@@ -146,6 +147,7 @@
 	mutex_init(&sas_host->lock);
 	sas_host->next_target_id = 0;
 	sas_host->next_expander_id = 0;
+	sas_host->next_port_id = 0;
 	return 0;
 }
 
@@ -327,7 +329,7 @@
 sas_phy_simple_attr(identify.sas_address, sas_address, "0x%016llx\n",
 		unsigned long long);
 sas_phy_simple_attr(identify.phy_identifier, phy_identifier, "%d\n", u8);
-//sas_phy_simple_attr(port_identifier, port_identifier, "%d\n", u8);
+//sas_phy_simple_attr(port_identifier, port_identifier, "%d\n", int);
 sas_phy_linkspeed_attr(negotiated_linkrate);
 sas_phy_linkspeed_attr(minimum_linkrate_hw);
 sas_phy_linkspeed_attr(minimum_linkrate);
@@ -590,6 +592,38 @@
 }
 EXPORT_SYMBOL(sas_port_alloc);
 
+/** sas_port_alloc_num - allocate and initialize a SAS port structure
+ *
+ * @parent:	parent device
+ *
+ * Allocates a SAS port structure and a number to go with it.  This
+ * interface is really for adapters where the port number has no
+ * meansing, so the sas class should manage them.  It will be added to
+ * the device tree below the device specified by @parent which must be
+ * either a Scsi_Host or a sas_expander_device.
+ *
+ * Returns %NULL on error
+ */
+struct sas_port *sas_port_alloc_num(struct device *parent)
+{
+	int index;
+	struct Scsi_Host *shost = dev_to_shost(parent);
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+
+	/* FIXME: use idr for this eventually */
+	mutex_lock(&sas_host->lock);
+	if (scsi_is_sas_expander_device(parent)) {
+		struct sas_rphy *rphy = dev_to_rphy(parent);
+		struct sas_expander_device *exp = rphy_to_expander_device(rphy);
+
+		index = exp->next_port_id++;
+	} else
+		index = sas_host->next_port_id++;
+	mutex_unlock(&sas_host->lock);
+	return sas_port_alloc(parent, index);
+}
+EXPORT_SYMBOL(sas_port_alloc_num);
+
 /**
  * sas_port_add - add a SAS port to the device hierarchy
  *
Index: BUILD-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_transport_sas.h	2006-06-30 21:40:34.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_transport_sas.h	2006-07-01 08:39:30.000000000 -0500
@@ -106,6 +106,7 @@
 
 struct sas_expander_device {
 	int    level;
+	int    next_port_id;
 
 	#define SAS_EXPANDER_VENDOR_ID_LEN	8
 	char   vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
@@ -127,7 +128,7 @@
 struct sas_port {
 	struct device		dev;
 
-	u8			port_identifier;
+	int			port_identifier;
 	int			num_phys;
 
 	/* the other end of the link */
@@ -168,6 +169,7 @@
 extern int scsi_is_sas_rphy(const struct device *);
 
 struct sas_port *sas_port_alloc(struct device *, int);
+struct sas_port *sas_port_alloc_num(struct device *);
 int sas_port_add(struct sas_port *);
 void sas_port_free(struct sas_port *);
 void sas_port_delete(struct sas_port *);


