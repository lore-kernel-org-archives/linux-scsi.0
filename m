From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 15/17] Update the NVMe SSD driver to use ida helper functions.
Date: Tue, 15 Sep 2015 09:46:15 -0700
Message-ID: <7aa6d6793c6771b69a9cf093e80937669f5fcb4e.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>, Matthew Wilcox <willy@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/block/nvme-core.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index d1d6141920d3..ab13833d4fde 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -2715,15 +2715,7 @@ static int nvme_set_instance(struct nvme_dev *dev)
 {
 	int instance, error;
 
-	do {
-		if (!ida_pre_get(&nvme_instance_ida, GFP_KERNEL))
-			return -ENODEV;
-
-		spin_lock(&dev_list_lock);
-		error = ida_get_new(&nvme_instance_ida, &instance);
-		spin_unlock(&dev_list_lock);
-	} while (error == -EAGAIN);
-
+	error = ida_get_index(&nvme_instance_ida, &dev_list_lock, &instance);
 	if (error)
 		return -ENODEV;
 
@@ -2733,9 +2725,7 @@ static int nvme_set_instance(struct nvme_dev *dev)
 
 static void nvme_release_instance(struct nvme_dev *dev)
 {
-	spin_lock(&dev_list_lock);
-	ida_remove(&nvme_instance_ida, dev->instance);
-	spin_unlock(&dev_list_lock);
+	ida_put_index(&nvme_instance_ida, &dev_list_lock, dev->instance);
 }
 
 static void nvme_free_namespaces(struct nvme_dev *dev)
-- 
2.1.4
