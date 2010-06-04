From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/5] cciss: make sure we request the performant mode irq
Date: Fri, 4 Jun 2010 15:08:17 -0500
Message-ID: <20100604200817.GB30870@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, dab@hp.com, scameron@beardog.cce.hp.com, gerry.morong@hp.com, mike.miller@hp.com, scott.benesh@hp.com, scott.stacy.teel@hp.com, tom.lawler@hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Patch 2 of 5
cciss: make sure we register the performant mode interrupt
Another blunder. Seemed to work because the call to
put_controller_into_performant_mode was never called.

From: Mike Miller <mike.miller@hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com
---
 drivers/block/cciss.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cdc671c..156ea36 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4483,18 +4483,18 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	/* make sure the board interrupts are off */
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_OFF);
 	if (hba[i]->msi_vector || hba[i]->msix_vector) {
-		if (request_irq(hba[i]->intr[SIMPLE_MODE_INT],
+		if (request_irq(hba[i]->intr[PERF_MODE_INT],
 				do_cciss_msix_intr,
 				IRQF_DISABLED, hba[i]->devname, hba[i])) {
 			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
-			       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
+			       hba[i]->intr[PERF_MODE_INT], hba[i]->devname);
 			goto clean2;
 		}
 	} else {
-		if (request_irq(hba[i]->intr[SIMPLE_MODE_INT], do_cciss_intx,
+		if (request_irq(hba[i]->intr[PERF_MODE_INT], do_cciss_intx,
 				IRQF_DISABLED, hba[i]->devname, hba[i])) {
 			printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
-			       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
+			       hba[i]->intr[PERF_MODE_INT], hba[i]->devname);
 			goto clean2;
 		}
 	}
