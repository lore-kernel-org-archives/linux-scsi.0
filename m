From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/17] hpsa: call pci_disable_device on driver unload
Date: Fri, 20 Apr 2012 10:06:18 -0500
Message-ID: <20120420150618.10596.86451.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41536 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab2DTPN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2012 11:13:57 -0400
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

As Jenx Axboe explained to me: "In earlier times (2.6.18 and pre, iirc), Linux
disabled IO and mem bars on pci_disable_device(). Now in newer kernel it does
not. And in the newer kernels you run into problems if you DON'T disable the
device on exit, since when it later loads the device is already in the enabled
state - and pci_enable_device() then does nothing. This typically screws
MSI/MSI-X." This is what the big scary comment that says pci_disable_device
does "something nasty" to smart arrays was evidently referring to.

If pci_disable_device is not called on driver rmmod, subsequently insmod'ing
the driver may in result in some cases fail to be able to receive interrupts,
esp.  if other drivers are loaded between unloading and loading hpsa.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 500e20d..1a6c319 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3987,10 +3987,7 @@ err_out_free_res:
 		iounmap(h->cfgtable);
 	if (h->vaddr)
 		iounmap(h->vaddr);
-	/*
-	 * Deliberately omit pci_disable_device(): it does something nasty to
-	 * Smart Array controllers that pci_enable_device does not undo
-	 */
+	pci_disable_device(h->pdev);
 	pci_release_regions(h->pdev);
 	return err;
 }
@@ -4529,10 +4526,7 @@ static void __devexit hpsa_remove_one(struct pci_dev *pdev)
 	kfree(h->cmd_pool_bits);
 	kfree(h->blockFetchTable);
 	kfree(h->hba_inquiry_data);
-	/*
-	 * Deliberately omit pci_disable_device(): it does something nasty to
-	 * Smart Array controllers that pci_enable_device does not undo
-	 */
+	pci_disable_device(pdev);
 	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 	kfree(h);

