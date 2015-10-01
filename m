From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 3/5] block: nvme-core: simplify ida usage
Date: Thu,  1 Oct 2015 11:59:07 -0700
Message-ID: <cb1a4e9a77ed39c98072c70a0bebc9b98067852a.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Simplify ida index allocation and removal by
using the ida_simple_* helper functions.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/block/nvme-core.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index d1d6141920d3..d354a3391e4a 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -2713,18 +2713,10 @@ static DEFINE_IDA(nvme_instance_ida);
 
 static int nvme_set_instance(struct nvme_dev *dev)
 {
-	int instance, error;
+	int instance;
 
-	do {
-		if (!ida_pre_get(&nvme_instance_ida, GFP_KERNEL))
-			return -ENODEV;
-
-		spin_lock(&dev_list_lock);
-		error = ida_get_new(&nvme_instance_ida, &instance);
-		spin_unlock(&dev_list_lock);
-	} while (error == -EAGAIN);
-
-	if (error)
+	instance = ida_simple_get(&nvme_instance_ida, 0, 0, GFP_KERNEL);
+	if (instance < 0)
 		return -ENODEV;
 
 	dev->instance = instance;
@@ -2734,7 +2726,7 @@ static int nvme_set_instance(struct nvme_dev *dev)
 static void nvme_release_instance(struct nvme_dev *dev)
 {
 	spin_lock(&dev_list_lock);
-	ida_remove(&nvme_instance_ida, dev->instance);
+	ida_simple_remove(&nvme_instance_ida, dev->instance);
 	spin_unlock(&dev_list_lock);
 }
 
-- 
2.1.4
