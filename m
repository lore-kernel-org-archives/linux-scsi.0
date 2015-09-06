From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 5/6] Update nvme-core driver to use new ida helper functions
Date: Sun,  6 Sep 2015 10:59:33 -0700
Message-ID: <90505dd4055db214efa70ad36b78d0c4b4d500ba.1441416572.git.lduncan@suse.com>
References: <cover.1441416571.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbbIFR7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
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

