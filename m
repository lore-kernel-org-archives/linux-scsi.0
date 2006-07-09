From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_transport_sas: add expander backlink
Date: Sun, 09 Jul 2006 12:38:19 -0500
Message-ID: <1152466699.784.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:42967 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964863AbWGIRiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 13:38:21 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k69HcKY11401
	for <linux-scsi@vger.kernel.org>; Sun, 9 Jul 2006 13:38:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch adds the ability to add a backlink to a particular port.  The
idea is to represent properly ports on expanders that are used
specifically for linking to the parent device in the topology.

James

Index: BUILD-2.6/drivers/scsi/scsi_transport_sas.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_transport_sas.c	2006-07-09 12:30:04.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_transport_sas.c	2006-07-09 12:31:37.000000000 -0500
@@ -692,6 +692,13 @@
 	}
 	mutex_unlock(&port->phy_list_mutex);
 
+	if (port->is_backlink) {
+		struct device *parent = port->dev.parent;
+
+		sysfs_remove_link(&port->dev.kobj, parent->bus_id);
+		port->is_backlink = 0;
+	}
+
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
@@ -776,6 +783,19 @@
 }
 EXPORT_SYMBOL(sas_port_delete_phy);
 
+void sas_port_mark_backlink(struct sas_port *port)
+{
+	struct device *parent = port->dev.parent->parent->parent;
+
+	if (port->is_backlink)
+		return;
+	port->is_backlink = 1;
+	sysfs_create_link(&port->dev.kobj, &parent->kobj,
+			  parent->bus_id);
+
+}
+EXPORT_SYMBOL(sas_port_mark_backlink);
+
 /*
  * SAS remote PHY attributes.
  */
Index: BUILD-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_transport_sas.h	2006-07-09 12:30:04.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_transport_sas.h	2006-07-09 12:32:53.000000000 -0500
@@ -130,6 +130,8 @@
 
 	int			port_identifier;
 	int			num_phys;
+	/* port flags */
+	unsigned int		is_backlink:1;
 
 	/* the other end of the link */
 	struct sas_rphy		*rphy;
@@ -175,6 +177,7 @@
 void sas_port_delete(struct sas_port *);
 void sas_port_add_phy(struct sas_port *, struct sas_phy *);
 void sas_port_delete_phy(struct sas_port *, struct sas_phy *);
+void sas_port_mark_backlink(struct sas_port *);
 int scsi_is_sas_port(const struct device *);
 
 extern struct scsi_transport_template *


