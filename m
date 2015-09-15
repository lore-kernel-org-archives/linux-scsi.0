From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 17/17] Update the ARM soc base driver to use ida helper functions.
Date: Tue, 15 Sep 2015 09:46:17 -0700
Message-ID: <522c5aff9c4fe616a39115624ac09484446a6bed.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbbIOQrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2015 12:47:55 -0400
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/base/soc.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/base/soc.c b/drivers/base/soc.c
index 39fca01c8fa1..cf70c3246123 100644
--- a/drivers/base/soc.c
+++ b/drivers/base/soc.c
@@ -122,18 +122,7 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
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
+	ret = ida_get_index(&soc_ida, &soc_lock, &soc_dev->soc_dev_num);
 	if (ret)
 		goto out2;
 
@@ -151,7 +140,7 @@ struct soc_device *soc_device_register(struct soc_device_attribute *soc_dev_attr
 	return soc_dev;
 
 out3:
-	ida_remove(&soc_ida, soc_dev->soc_dev_num);
+	ida_put_index(&soc_ida, &soc_lock, soc_dev->soc_dev_num);
 out2:
 	kfree(soc_dev);
 out1:
@@ -161,7 +150,7 @@ out1:
 /* Ensure soc_dev->attr is freed prior to calling soc_device_unregister. */
 void soc_device_unregister(struct soc_device *soc_dev)
 {
-	ida_remove(&soc_ida, soc_dev->soc_dev_num);
+	ida_put_index(&soc_ida, &soc_lock, soc_dev->soc_dev_num);
 
 	device_unregister(&soc_dev->dev);
 }
-- 
2.1.4

