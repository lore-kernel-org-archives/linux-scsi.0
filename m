From: James.Smart@Emulex.Com
Subject: [PATCH] LLDD dynamic scan aids
Date: Wed, 17 Nov 2004 14:03:01 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F27B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56772 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262497AbUKQTDF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 14:03:05 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id iAHJ31ni010354
	for <linux-scsi@vger.kernel.org>; Wed, 17 Nov 2004 11:03:02 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch contains the following 2 modifications:

- Allows scsi_scan_host() to be called at times other than just first attachment.

- Provides a new interface to scan a single target entity.

This allows our LLDD to automatically detect new device additions after a cable/fabric change, or upon insertion of a new FC device.

Note: We opted for a "scan target" interface as, on large configurations, scanning everything on the link via scsi_scan_host() was overkill.

-- James S


diff -uNr linux-2.6.10-rc2/drivers/scsi/scsi_scan.c linux-2.6.10-rc2.patch/drivers/scsi/scsi_scan.c
--- linux-2.6.10-rc2/drivers/scsi/scsi_scan.c	2004-11-17 13:58:40.370677976 -0500
+++ linux-2.6.10-rc2.patch/drivers/scsi/scsi_scan.c	2004-11-17 13:58:40.378676760 -0500
@@ -1223,7 +1223,20 @@
 void scsi_scan_host(struct Scsi_Host *shost)
 {
 	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
-				SCAN_WILD_CARD, 0);
+				SCAN_WILD_CARD, shost->rescan);
+	shost->rescan=1;
+}
+
+/**
+ * scsi_scan_single_target - scan the given SCSI target
+ * @shost:         adapter to scan
+ * @chan:          channel to scan
+ * @id:            target id to scan
+ **/
+void scsi_scan_single_target(struct Scsi_Host *shost, 
+	unsigned int chan, unsigned int id)
+{
+	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 1);
 }
 
 void scsi_forget_host(struct Scsi_Host *shost)
diff -uNr linux-2.6.10-rc2/drivers/scsi/scsi_syms.c linux-2.6.10-rc2.patch/drivers/scsi/scsi_syms.c
--- linux-2.6.10-rc2/drivers/scsi/scsi_syms.c	2004-11-17 13:58:40.390674936 -0500
+++ linux-2.6.10-rc2.patch/drivers/scsi/scsi_syms.c	2004-11-17 13:58:40.398673720 -0500
@@ -27,6 +27,7 @@
 EXPORT_SYMBOL(scsi_host_alloc);
 EXPORT_SYMBOL(scsi_add_host);
 EXPORT_SYMBOL(scsi_scan_host);
+EXPORT_SYMBOL(scsi_scan_single_target);
 EXPORT_SYMBOL(scsi_remove_host);
 EXPORT_SYMBOL(scsi_host_get);
 EXPORT_SYMBOL(scsi_host_put);
diff -uNr linux-2.6.10-rc2/include/scsi/scsi_host.h linux-2.6.10-rc2.patch/include/scsi/scsi_host.h
--- linux-2.6.10-rc2/include/scsi/scsi_host.h	2004-11-17 13:58:40.353680560 -0500
+++ linux-2.6.10-rc2.patch/include/scsi/scsi_host.h	2004-11-17 13:58:40.361679344 -0500
@@ -454,6 +454,7 @@
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
+	unsigned rescan:1;
 
 	/*
 	 * Host has requested that no further requests come through for the
@@ -527,6 +528,8 @@
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int __must_check scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
+extern void scsi_scan_single_target(struct Scsi_Host *, unsigned int,
+	unsigned int);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
