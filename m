From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix HBA removal problem with transport classes
Date: Tue, 01 Feb 2005 14:50:02 -0600
Message-ID: <1107291002.4800.67.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:24551 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262120AbVBAUuJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2005 15:50:09 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j11Ko8C00521
	for <linux-scsi@vger.kernel.org>; Tue, 1 Feb 2005 15:50:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Smart pointed out that if you insert and remove a HBA driver a few
times, eventually the system oopses.

The reason is that the transport classes all kfree their attribute
containers, but don't actually unregister them first (so we have freed
memory on the container list).  The attached should fix this.

James

===== drivers/scsi/scsi_transport_fc.c 1.15 vs edited =====
--- 1.15/drivers/scsi/scsi_transport_fc.c	2005-02-01 10:45:41 -06:00
+++ edited/drivers/scsi/scsi_transport_fc.c	2005-02-01 13:24:03 -06:00
@@ -846,6 +846,9 @@
 void fc_release_transport(struct scsi_transport_template *t)
 {
 	struct fc_internal *i = to_fc_internal(t);
+
+	attribute_container_unregister(&i->t.target_attrs);
+	attribute_container_unregister(&i->t.host_attrs);
 
 	kfree(i);
 }
===== drivers/scsi/scsi_transport_iscsi.c 1.3 vs edited =====
--- 1.3/drivers/scsi/scsi_transport_iscsi.c	2005-02-01 10:45:41 -06:00
+++ edited/drivers/scsi/scsi_transport_iscsi.c	2005-02-01 13:23:55 -06:00
@@ -356,6 +356,10 @@
 void iscsi_release_transport(struct scsi_transport_template *t)
 {
 	struct iscsi_internal *i = to_iscsi_internal(t);
+
+	attribute_container_unregister(&i->t.target_attrs);
+	attribute_container_unregister(&i->t.host_attrs);
+
 	kfree(i);
 }
 
===== drivers/scsi/scsi_transport_spi.c 1.24 vs edited =====
--- 1.24/drivers/scsi/scsi_transport_spi.c	2005-02-01 10:45:41 -06:00
+++ edited/drivers/scsi/scsi_transport_spi.c	2005-02-01 13:24:05 -06:00
@@ -921,6 +921,9 @@
 {
 	struct spi_internal *i = to_spi_internal(t);
 
+	attribute_container_unregister(&i->t.target_attrs);
+	attribute_container_unregister(&i->t.host_attrs);
+
 	kfree(i);
 }
 EXPORT_SYMBOL(spi_release_transport);


