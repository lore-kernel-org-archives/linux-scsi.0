From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 6/6] Update rsxx core driver to use new ida helper functions
Date: Sun,  6 Sep 2015 10:59:34 -0700
Message-ID: <c2521b7f871e4fe6ce600b6eaaea299016e90a10.1441416572.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbbIFR7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Sep 2015 13:59:49 -0400
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
In-Reply-To: <cover.1441416571.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

This simplifies the calling sequence to
acquire and to release an ida-managed index.

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

