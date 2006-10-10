From: akpm@osdl.org
Subject: [patch 24/36] ioremap balanced with iounmap for drivers/scsi/3w-9xxx.c
Date: Tue, 10 Oct 2006 14:41:41 -0700
Message-ID: <200610102141.k9ALffof025432@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:10655 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030475AbWJJVnI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:43:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com, aradford@gmail.com

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: adam radford <aradford@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/3w-9xxx.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/scsi/3w-9xxx.c~ioremap-balanced-with-iounmap-drivers-scsi-3w-9xxxc drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~ioremap-balanced-with-iounmap-drivers-scsi-3w-9xxxc
+++ a/drivers/scsi/3w-9xxx.c
@@ -2147,6 +2147,8 @@ out_remove_host:
 	scsi_remove_host(host);
 out_release_mem_region:
 	pci_release_regions(pdev);
+	if (tw_dev->base_addr)
+		iounmap(tw_dev->base_addr);
 out_free_device_extension:
 	twa_free_device_extension(tw_dev);
 	scsi_host_put(host);
@@ -2173,6 +2175,9 @@ static void twa_remove(struct pci_dev *p
 	/* Free up the IRQ */
 	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
 
+	/* Free IO mem */
+	iounmap(tw_dev->base_addr);
+
 	/* Shutdown the card */
 	__twa_shutdown(tw_dev);
 
_
