From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 01/20] cciss: Remove sysfs entries for logical drives on
	driver cleanup.
Date: Thu, 17 Sep 2009 13:46:53 -0500
Message-ID: <20090917184653.15105.99513.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759299AbZIQSqd@vger.kernel.org>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Andrew Patterson <andrew.patterson@hp.com>

Sysfs entries for logical drives need to be removed when a drive is
deleted during driver cleanup.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
---

 drivers/block/cciss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a52cc7f..970c896 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1977,7 +1977,6 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 			return_code = deregister_disk(h, i, 1);
-			cciss_destroy_ld_sysfs_entry(&h->drv[i]);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -2118,6 +2117,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
+	cciss_destroy_ld_sysfs_entry(drv);
 
 	if (clear_all) {
 		/* check to see if it was the last disk */
@@ -4141,6 +4141,9 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 			if (q)
 				blk_cleanup_queue(q);
 		}
+		if (hba[i]->drv[j].raid_level != -1)
+			cciss_destroy_ld_sysfs_entry(&hba[i]->drv[j]);
+
 	}
 
 #ifdef CONFIG_CISS_SCSI_TAPE
