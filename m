From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/17] hpsa: call pci_disable_device on driver unload
Date: Tue, 01 May 2012 11:42:09 -0500
Message-ID: <20120501164209.11705.3671.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

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
