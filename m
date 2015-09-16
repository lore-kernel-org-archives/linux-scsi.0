From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 15/17] Update the NVMe SSD driver to use ida helper functions.
Date: Wed, 16 Sep 2015 10:50:33 -0700
Message-ID: <7aa6d6793c6771b69a9cf093e80937669f5fcb4e.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbbIPRvV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2015 13:51:21 -0400
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org, Lee Duncan <lduncan@suse.com>, Matthew Wilcox <willy@linux.intel.com>

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

