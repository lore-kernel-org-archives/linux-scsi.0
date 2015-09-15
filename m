From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 14/17] Update the rsxx flash adapter driver to use ida helper functions.
Date: Tue, 15 Sep 2015 09:46:14 -0700
Message-ID: <049a0c72418d1e2854d315bf8b583a562dbd9264.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>, Joshua Morris <josh.h.morris@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/block/rsxx/core.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index d8b2488aaade..dd23a0e85040 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -774,17 +774,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	card->dev = dev;
 	pci_set_drvdata(dev, card);
 
-	do {
-		if (!ida_pre_get(&rsxx_disk_ida, GFP_KERNEL)) {
-			st = -ENOMEM;
-			goto failed_ida_get;
-		}
-
-		spin_lock(&rsxx_ida_lock);
-		st = ida_get_new(&rsxx_disk_ida, &card->disk_id);
-		spin_unlock(&rsxx_ida_lock);
-	} while (st == -EAGAIN);
-
+	st = ida_get_index(&rsxx_disk_ida, &rsxx_ida_lock, &card->disk_id);
 	if (st)
 		goto failed_ida_get;
 
@@ -987,9 +977,7 @@ failed_request_regions:
 failed_dma_mask:
 	pci_disable_device(dev);
 failed_enable:
-	spin_lock(&rsxx_ida_lock);
-	ida_remove(&rsxx_disk_ida, card->disk_id);
-	spin_unlock(&rsxx_ida_lock);
+	ida_put_index(&rsxx_disk_ida, &rsxx_ida_lock, card->disk_id);
 failed_ida_get:
 	kfree(card);
 
-- 
2.1.4
