From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix multiple HBA problem with transport classes
Date: Sat, 29 Jan 2005 19:37:59 -0600
Message-ID: <1107049079.4535.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38545 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261628AbVA3BiG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2005 20:38:06 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j0U1c5b13076
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jan 2005 20:38:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

All of the transport class patches contain a thinko in device matching
(and, unfortunately, one I exhorted everyone not to make in the generic
transport class comments): The match matches every container in the
class instead of the specific container belonging to the HBA.  This
causes a oops when there are two or more HBAs in the system.

James

===== drivers/scsi/scsi_transport_fc.c 1.14 vs edited =====
--- 1.14/drivers/scsi/scsi_transport_fc.c	2005-01-18 13:15:07 -06:00
+++ edited/drivers/scsi/scsi_transport_fc.c	2005-01-29 18:53:19 -06:00
@@ -728,6 +728,7 @@
 			  struct device *dev)
 {
 	struct Scsi_Host *shost;
+	struct fc_internal *i;
 
 	if (!scsi_is_host_device(dev))
 		return 0;
@@ -736,13 +737,17 @@
 	if (!shost->transportt  || shost->transportt->host_attrs.class
 	    != &fc_host_class.class)
 		return 0;
-	return 1;
+
+	i = to_fc_internal(shost->transportt);
+	
+	return &i->t.host_attrs == cont;
 }
 
 static int fc_target_match(struct attribute_container *cont,
 			    struct device *dev)
 {
 	struct Scsi_Host *shost;
+	struct fc_internal *i;
 
 	if (!scsi_is_target_device(dev))
 		return 0;
@@ -751,7 +756,10 @@
 	if (!shost->transportt  || shost->transportt->host_attrs.class
 	    != &fc_host_class.class)
 		return 0;
-	return 1;
+
+	i = to_fc_internal(shost->transportt);
+	
+	return &i->t.host_attrs == cont;
 }
 
 
===== drivers/scsi/scsi_transport_iscsi.c 1.2 vs edited =====
--- 1.2/drivers/scsi/scsi_transport_iscsi.c	2005-01-18 13:15:07 -06:00
+++ edited/drivers/scsi/scsi_transport_iscsi.c	2005-01-29 18:56:01 -06:00
@@ -258,6 +258,7 @@
 			  struct device *dev)
 {
 	struct Scsi_Host *shost;
+	struct iscsi_internal *i;
 
 	if (!scsi_is_host_device(dev))
 		return 0;
@@ -266,13 +267,17 @@
 	if (!shost->transportt  || shost->transportt->host_attrs.class
 	    != &iscsi_host_class.class)
 		return 0;
-	return 1;
+
+	i = to_iscsi_internal(shost->transportt);
+	
+	return &i->t.host_attrs == cont;
 }
 
 static int iscsi_target_match(struct attribute_container *cont,
 			    struct device *dev)
 {
 	struct Scsi_Host *shost;
+	struct iscsi_internal *i;
 
 	if (!scsi_is_target_device(dev))
 		return 0;
@@ -281,7 +286,10 @@
 	if (!shost->transportt  || shost->transportt->host_attrs.class
 	    != &iscsi_host_class.class)
 		return 0;
-	return 1;
+
+	i = to_iscsi_internal(shost->transportt);
+	
+	return &i->t.host_attrs == cont;
 }
 
 struct scsi_transport_template *
===== drivers/scsi/scsi_transport_spi.c 1.23 vs edited =====
--- 1.23/drivers/scsi/scsi_transport_spi.c	2005-01-18 13:15:07 -06:00
+++ edited/drivers/scsi/scsi_transport_spi.c	2005-01-29 18:33:18 -06:00
@@ -136,6 +136,7 @@
 			  struct device *dev)
 {
 	struct Scsi_Host *shost;
+	struct spi_internal *i;
 
 	if (!scsi_is_host_device(dev))
 		return 0;
@@ -144,7 +145,10 @@
 	if (!shost->transportt  || shost->transportt->host_attrs.class
 	    != &spi_host_class.class)
 		return 0;
-	return 1;
+
+	i = to_spi_internal(shost->transportt);
+	
+	return &i->t.target_attrs == cont;
 }
 
 static int spi_device_configure(struct device *dev)
@@ -831,6 +835,7 @@
 			    struct device *dev)
 {
 	struct Scsi_Host *shost;
+	struct spi_internal *i;
 
 	if (!scsi_is_target_device(dev))
 		return 0;
@@ -839,7 +844,10 @@
 	if (!shost->transportt  || shost->transportt->host_attrs.class
 	    != &spi_host_class.class)
 		return 0;
-	return 1;
+
+	i = to_spi_internal(shost->transportt);
+	
+	return &i->t.target_attrs == cont;
 }
 
 static DECLARE_TRANSPORT_CLASS(spi_transport_class,


