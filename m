From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] Fix for aacraid and high memory on 2.6.1
Date: Thu, 22 Jan 2004 13:15:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074806131.2084.22.camel@markh1.pdx.osdl.net>
References: <1074113037.7662.45.camel@markh1.pdx.osdl.net>
	 <1074115078.2054.166.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:27350 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265114AbUAVVPj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 16:15:39 -0500
In-Reply-To: <1074115078.2054.166.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2004-01-14 at 13:17, James Bottomley wrote:
> On Wed, 2004-01-14 at 15:43, Mark Haverkamp wrote:
> > +	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT) {
> > +		if (pci_set_dma_mask(pdev, 0x7FFFFFFFULL))
> [...]
> > +	/*
> > +	 * If we had set a smaller DMA mask earlier, set it to 4gig
> > +	 * now since the adapter can dma data to at least a 4gig
> > +	 * address space.
> > +	 */
> > +	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT)
> > +		if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
> > +			goto out_free_fibs;
> 
> Rather than doing this, could you just do a 
> 
> pci_set_consistent_dma_mask()?
> 
> Unfortunately, it's currently not correctly implemented for this case on
> x86 (and you don't seem to be able to do what you want on many non-x86
> archs), but I think we can get the implementation fixed.
> 
> James
> 

James,
Here is an update to use pci_set_consistent_dma_mask.  But since
dma_alloc_coherent uses dma_mask instead of consistent one, I left in
setting dma_mask as well until the alloc routine changes.

Mark.

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
+++ edited/drivers/scsi/aacraid/linit.c	Thu Jan 22 09:57:36 2004
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
+	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL) || 
+			pci_set_consistent_dma_mask(pdev, 0xFFFFFFFFULL))
 		goto out;
+	/*
+	 * If the quirk31 bit is set, the adapter needs adapter
+	 * to driver communication memory to be allocated below 2gig
+	 */
+	if (aac_drivers[index].quirks & AAC_QUIRK_31BIT) 
+		if (pci_set_dma_mask(pdev, 0x7FFFFFFFULL) ||
+				pci_set_consistent_dma_mask(pdev, 0x7FFFFFFFULL))
+			goto out;
 	
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

