From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 5/5] base: soc: siplify ida usage
Date: Thu,  1 Oct 2015 11:59:09 -0700
Message-ID: <bdf9231610686622d6a422e3c9dd8a615535afeb.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
References: <cover.1443723136.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

Simplify ida index allocation and removal by
using the ida_simple_* helper functions

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/base/soc.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index 39fca01c8fa1..75b98aad6faf 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -16,7 +16,6 @@
 #include <linux/err.h>
 
 static DEFINE_IDA(soc_ida);
-static DEFINE_SPINLOCK(soc_lock);
 
 static ssize_t soc_info_get(struct device *dev,
 			    struct device_attribute *attr,
@@ -122,20 +121,10 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
 	}
 
 	/* Fetch a unique (reclaimable) SOC ID. */
-	do {
-		if (!ida_pre_get(&soc_ida, GFP_KERNEL)) {
-			ret = -ENOMEM;
-			goto out2;
-		}
-
-		spin_lock(&soc_lock);
-		ret = ida_get_new(&soc_ida, &soc_dev->soc_dev_num);
-		spin_unlock(&soc_lock);
-
-	} while (ret == -EAGAIN);
-
-	if (ret)
+	ret = ida_simple_get(&soc_ida, 0, 0, GFP_KERNEL);
+	if (ret < 0)
 		goto out2;
+	soc_dev->soc_dev_num = ret;
 
 	soc_dev->attr = soc_dev_attr;
 	soc_dev->dev.bus = &soc_bus_type;
@@ -151,7 +140,7 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
 	return soc_dev;
 
 out3:
-	ida_remove(&soc_ida, soc_dev->soc_dev_num);
+	ida_simple_remove(&soc_ida, soc_dev->soc_dev_num);
 out2:
 	kfree(soc_dev);
 out1:
@@ -161,7 +150,7 @@ out1:
 /* Ensure soc_dev->attr is freed prior to calling soc_device_unregister. */
 void soc_device_unregister(struct soc_device *soc_dev)
 {
-	ida_remove(&soc_ida, soc_dev->soc_dev_num);
+	ida_simple_remove(&soc_ida, soc_dev->soc_dev_num);
 
 	device_unregister(&soc_dev->dev);
 }
-- 
2.1.4
