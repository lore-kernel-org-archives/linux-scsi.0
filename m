From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/5] cciss: fix call to put_controller_in_performant_mode
Date: Fri, 4 Jun 2010 15:05:11 -0500
Message-ID: <20100604200511.GA30870@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, dab@hp.com, scameron@beardog.cce.hp.com, gerry.morong@hp.com, mike.miller@hp.com, scott.benesh@hp.com, scott.stacy.teel@hp.com, tom.lawler@hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Patch 1 of 5
cciss: call to put_controller_in_performant_mode was in the wrong place
The call inadvertently ended up in an error path.

From: Mike Miller <mike.miller@hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5e215ff..cdc671c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4150,6 +4150,7 @@ static int __devinit cciss_pci_init(ctlr_info_t *c, struct pci_dev *pdev)
 #ifdef CCISS_DEBUG
 	printk(KERN_WARNING "Trying to put board into Performant mode\n");
 #endif				/* CCISS_DEBUG */
+	cciss_put_controller_into_performant_mode(c);
 	return 0;
 
 err_out_free_res:
@@ -4158,7 +4159,6 @@ err_out_free_res:
 	 * Smart Array controllers that pci_enable_device does not undo
 	 */
 	pci_release_regions(pdev);
-	cciss_put_controller_into_performant_mode(c);
 	return err;
 }
 
