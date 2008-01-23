From: Stuart Swales <stuart.swales@croftnuisk.co.uk>
Subject: [PATCH 2.6.24-rc8-git6] initio module hangs on loading fix set
Date: Wed, 23 Jan 2008 20:00:48 +0000
Message-ID: <47979CF0.7060104@croftnuisk.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:57125 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYAWUAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 15:00:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've verified (on my Initio 9100 with a DAT drive) that the 
2.6.24-rc8-git6 initio module still hangs on loading.

These fixes (other than the printk) are needed to get the module to load 
ok (and work correctly) with my adapter & tape drive.

a) printk cosmetic fix

b) cblk->sglen needs setting for later DMA I/O routines to use

c) host->bios_addr needs setting for debug output correctness

d) semaph & semaph_lock initialisation had got lost since 2.6.22

e) since 2.6.22 the bios data address was truncated to 16 bits (needs 20 
when shifted left)

Stuart Swales

--- linux-2.6.24-rc8-git6/drivers/scsi/initio.c	2008-01-16 
04:22:48.000000000 +0000
+++ linux-2.6.24-rc8-git6-sks/drivers/scsi/initio.c	2008-01-23 
18:52:04.000000000 +0000
@@ -823,7 +823,7 @@ static void initio_append_busy_scb(struc
  {

  #if DEBUG_QUEUE
-	printk("append busy SCB %o; ", scbp);
+	printk("append busy SCB %p; ", scbp); /* SKS: not %o */
  #endif
  	if (scbp->tagmsg)
  		host->act_tags[scbp->target]++;
@@ -2609,6 +2609,7 @@ static void initio_build_scb(struct init
  		cblk->bufptr = cpu_to_le32((u32)dma_addr);
  		cmnd->SCp.dma_handle = dma_addr;

+		cblk->sglen = nseg; /* SKS: needs setting for DMA routine */

  		cblk->flags |= SCF_SG;	/* Turn on SG list flag       */
  		total_len = 0;
@@ -2869,6 +2870,7 @@ static int initio_probe_one(struct pci_d
  	host = (struct initio_host *)shost->hostdata;
  	memset(host, 0, sizeof(struct initio_host));
  	host->addr = pci_resource_start(pdev, 0);
+	host->bios_addr = bios_seg; /* SKS: required for debug output */

  	if (!request_region(host->addr, 256, "i91u")) {
  		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", 
host->addr);
@@ -2895,6 +2897,8 @@ static int initio_probe_one(struct pci_d

  	host->pci_dev = pdev;

+	host->semaph = 1; /* SKS */
+	spin_lock_init(&host->semaph_lock);
  	host->num_scbs = num_scb;
  	host->scb = scb;
  	host->next_pending = scb;
@@ -2911,7 +2915,7 @@ static int initio_probe_one(struct pci_d
  	host->last_avail = prev;
  	spin_lock_init(&host->avail_lock);

-	initio_init(host, phys_to_virt(bios_seg << 4));
+	initio_init(host, phys_to_virt(((u32) bios_seg << 4))); /* SKS: u16 
would lose bits when shifted left */

  	host->jsstatus0 = 0;


