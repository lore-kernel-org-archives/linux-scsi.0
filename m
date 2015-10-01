From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 2/5] block: rsxx: core: simplify ida usage
Date: Thu,  1 Oct 2015 11:59:06 -0700
Message-ID: <8d2f1dca7162a499d82de53be88110695334d8ef.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Simplify ida index allocation and removal by
using the ida_simple_* helper functions.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/block/rsxx/core.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index d8b2488aaade..d2279a759b2e 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -58,7 +58,6 @@ MODULE_PARM_DESC(sync_start, "On by Default: Driver load will not complete "
 			     "until the card startup has completed.");
 
 static DEFINE_IDA(rsxx_disk_ida);
-static DEFINE_SPINLOCK(rsxx_ida_lock);
 
 /* --------------------Debugfs Setup ------------------- */
 
@@ -774,19 +773,10 @@ static int rsxx_pci_probe(struct pci_dev *dev,
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
-	if (st)
+	st = ida_simple_get(&rsxx_disk_ida, 0, 0, GFP_KERNEL);
+	if (st < 0)
 		goto failed_ida_get;
+	card->disk_id = st;
 
 	st = pci_enable_device(dev);
 	if (st)
@@ -987,9 +977,7 @@ failed_request_regions:
 failed_dma_mask:
 	pci_disable_device(dev);
 failed_enable:
-	spin_lock(&rsxx_ida_lock);
-	ida_remove(&rsxx_disk_ida, card->disk_id);
-	spin_unlock(&rsxx_ida_lock);
+	ida_simple_remove(&rsxx_disk_ida, card->disk_id);
 failed_ida_get:
 	kfree(card);
 
-- 
2.1.4
