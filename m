From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/4] aacraid: 17 element sg performance update
Date: Wed, 11 Jan 2006 09:28:29 -0800
Message-ID: <1137000509.20470.41.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29060 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932278AbWAKR2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 12:28:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received From Mark Salyzyn.

The Jaguar and Corsair class of adapters (2410, 2810, 2610, 21610, CERC)
perform better (about 10% better read performance, write performance
neutral) with current Firmware if the OS limits the number of scatter
gather elements to 17 per request.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-01-11 09:19:50.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-01-11 09:20:11.000000000 -0800
@@ -532,6 +532,13 @@
 #define AAC_QUIRK_MASTER 0x0008
 
 /*
+ * Some adapter firmware perform poorly when it must split up scatter gathers
+ * in order to deal with the limits of the underlying CHIM. This limit in this
+ * class of adapters is 17 scatter gather elements.
+ */
+#define AAC_QUIRK_17SG	0x0010
+
+/*
  *	The adapter interface specs all queues to be located in the same
  *	physically contigous block. The host structure that defines the
  *	commuication queues will assume they are each a separate physically
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-01-11 09:20:08.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-01-11 09:20:11.000000000 -0800
@@ -201,10 +201,10 @@
 	{ aac_rkt_init, "aacraid",  "ADAPTEC ", "Callisto        ", 2, AAC_QUIRK_MASTER }, /* Jupiter Platform */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020SA       ", 1 }, /* ASR-2020SA SATA PCI-X ZCR (Skyhawk) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2025SA       ", 1 }, /* ASR-2025SA SATA SO-DIMM PCI-X ZCR (Terminator) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 1 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
-	{ aac_rx_init, "aacraid",  "DELL    ", "CERC SR2        ", 1 }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2810SA SATA ", 1 }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-21610SA SATA", 1 }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 1, AAC_QUIRK_17SG }, /* AAR-2410SA PCI SATA 4ch (Jaguar II) */
+	{ aac_rx_init, "aacraid",  "DELL    ", "CERC SR2        ", 1, AAC_QUIRK_17SG }, /* CERC SATA RAID 2 PCI SATA 6ch (DellCorsair) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2810SA SATA ", 1, AAC_QUIRK_17SG }, /* AAR-2810SA PCI SATA 8ch (Corsair-8) */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-21610SA SATA", 1, AAC_QUIRK_17SG }, /* AAR-21610SA PCI SATA 16ch (Corsair-16) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2026ZCR     ", 1 }, /* ESD SO-DIMM PCI-X SATA ZCR (Prowler) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2610SA      ", 1 }, /* SATA 6Ch (Bearcat) */
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2240S       ", 1 }, /* ASR-2240S (SabreExpress) */
@@ -854,6 +854,13 @@
  		  = (aac->scsi_host_ptr->sg_tablesize * 8) + 112;
  	}
 
+ 	if ((aac_drivers[index].quirks & AAC_QUIRK_17SG) &&
+			(aac->scsi_host_ptr->sg_tablesize > 17)) {
+ 		aac->scsi_host_ptr->sg_tablesize = 17;
+ 		aac->scsi_host_ptr->max_sectors
+ 		  = (aac->scsi_host_ptr->sg_tablesize * 8) + 112;
+ 	}
+
 	/*
 	 * Firware printf works only with older firmware.
 	 */

-- 
Mark Haverkamp <markh@osdl.org>

