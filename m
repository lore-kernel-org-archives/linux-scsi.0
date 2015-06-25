From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] scsi: remove check around pci_dev_put
Date: Thu, 25 Jun 2015 15:25:05 +0530
Message-ID: <1435226105-39462-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>
List-Id: linux-scsi@vger.kernel.org

pci_dev_put checks for NULL Pointer itself.

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
---
 drivers/scsi/eata_pio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index ca8003f..481ecac 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -122,8 +122,7 @@ static int eata_pio_release(struct Scsi_Host *sh)
 			release_region(sh->io_port, sh->n_io_port);
 	}
 	/* At this point the PCI reference can go */
-	if (hd->pdev)
-		pci_dev_put(hd->pdev);
+	pci_dev_put(hd->pdev);
 	return 1;
 }
 
-- 
1.7.9.5
