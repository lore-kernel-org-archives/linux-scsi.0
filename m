From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] initio: Merge fallout
Date: Mon, 15 Oct 2007 20:51:32 +0100
Message-ID: <20071015205132.4edbffbd@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42796 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756554AbXJOTsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 15:48:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Fix IRQ reporting - just assign the ->pci_dev pointer earlier and use the
pci_dev irq field rather than keeping a private one

Init the spinlock as it works better on SMP that way

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/drivers/scsi/initio.c linux-2.6.23-mm1/drivers/scsi/initio.c
--- linux.vanilla-2.6.23-mm1/drivers/scsi/initio.c	2007-10-15 15:03:36.000000000 +0100
+++ linux-2.6.23-mm1/drivers/scsi/initio.c	2007-10-15 15:19:48.000000000 +0100
@@ -665,7 +665,7 @@
 		host->max_tags[i] = 0xFF;
 	}			/* for                          */
 	printk("i91u: PCI Base=0x%04X, IRQ=%d, BIOS=0x%04X0, SCSI ID=%d\n",
-	       host->addr, host->irq,
+	       host->addr, host->pci_dev->irq,
 	       host->bios_addr, host->scsi_id);
 	/* Reset SCSI Bus */
 	if (host->config & HCC_SCSI_RESET) {
@@ -2892,6 +2892,8 @@
 		goto out_release_region;
 	}
 
+	host->pci_dev = pdev;
+
 	host->num_scbs = num_scb;
 	host->scb = scb;
 	host->next_pending = scb;
@@ -2906,6 +2908,7 @@
 	host->scb_end = tmp;
 	host->first_avail = scb;
 	host->last_avail = prev;
+	spin_lock_init(&host->avail_lock);
 
 	initio_init(host, phys_to_virt(bios_seg << 4));
 
@@ -2929,7 +2932,6 @@
 	}
 
 	pci_set_drvdata(pdev, shost);
-	host->pci_dev = pdev;
 
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
