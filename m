From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] Fix for aacraid and high memory on 2.6.1
Date: Wed, 14 Jan 2004 12:43:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074113037.7662.45.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:55460 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263661AbUANUoA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 15:44:00 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

I am working on taking updates from the adaptec supported driver and
making patches for the kernel tree.  This one fixes a problem where the
driver needs to the allocate memory that it uses to communicate with the
card below 2 gig.  It only affects certain card types.

===== drivers/scsi/aacraid/aacraid.h 1.10 vs edited =====
--- 1.10/drivers/scsi/aacraid/aacraid.h	Wed Nov 19 11:17:01 2003
+++ edited/drivers/scsi/aacraid/aacraid.h	Mon Jan 12 15:29:39 2004
@@ -525,7 +525,15 @@
 	char *	vname;
 	char *	model;
 	u16	channels;
+	int	quirks;
 };
+/*
+ * Some adapter firmware needs communication memory 
+ * below 2gig. This tells the init function to set the
+ * dma mask such that fib memory will be allocated where the
+ * adapter firmware can get to it.
+ */
+#define AAC_QUIRK_31BIT	1
 
 /*
  *	The adapter interface specs all queues to be located in the same
===== drivers/scsi/aacraid/linit.c 1.23 vs edited =====
--- 1.23/drivers/scsi/aacraid/linit.c	Wed Nov 19 11:16:13 2003
+++ edited/drivers/scsi/aacraid/linit.c	Tue Jan 13 09:32:02 2004
@@ -119,22 +119,22 @@
  * for the card.  At that time we can remove the channels from here
  */
 static struct aac_driver_ident aac_drivers[] = {
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 2/Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2 }, /* catapult*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2 }, /* tomcat*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1 }, /* Adaptec 2120S (Crusader)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan)*/
-	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan-2m)*/
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1 }, /* Legend S220*/
-	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2 }, /* Legend S230*/
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 2/Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT }, /* PERC 3/Di */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT }, /* catapult*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT }, /* tomcat*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT }, /* Adaptec 2120S (Crusader)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT }, /* Adaptec 2200S (Vulcan-2m)*/
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT }, /* Legend S220*/
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT }, /* Legend S230*/
 
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier)*/
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado)*/
@@ -144,10 +144,10 @@
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Marco)*/
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Sebring)*/
 
-	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2 }, /* Perc 320/DC*/
+	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2, AAC_QUIRK_31BIT }, /* Perc 320/DC*/
 	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
 	{ aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4 }, /* Dell PERC2 "Quad Channel" */
+	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4, AAC_QUIRK_31BIT }, /* Dell PERC2 "Quad Channel" */
 	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }  /* HP NetRAID-4M */
 };
 
@@ -407,8 +407,17 @@
 	if (pci_enable_device(pdev))
 		goto out;
 
-	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
-		goto out;
+	/*
+	 * If the quirk31 bit is set, the adapter needs adapter
+	 * to driver communication memory to be allocated below 2gig
+	 */
+	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT) {
+		if (pci_set_dma_mask(pdev, 0x7FFFFFFFULL))
+			goto out;
+	} else {
+		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
+			goto out;
+	}
 	
 	pci_set_master(pdev);
 
@@ -442,6 +451,15 @@
 
 	if ((*aac_drivers[index].init)(aac , shost->unique_id))
 		goto out_free_fibs;
+
+	/*
+	 * If we had set a smaller DMA mask earlier, set it to 4gig
+	 * now since the adapter can dma data to at least a 4gig
+	 * address space.
+	 */
+	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
+		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
+			goto out_free_fibs;
 
 	aac_get_adapter_info(aac);
 

-- 
Mark Haverkamp <markh@osdl.org>

