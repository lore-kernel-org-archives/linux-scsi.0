From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 08/17] Update the mmc driver to use idr helper functions.
Date: Tue, 15 Sep 2015 09:46:08 -0700
Message-ID: <5e015e43f03ba302ded85e71db48a8ed6fdc1ac6.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbbIOQru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2015 12:47:50 -0400
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
In-Reply-To: <cover.1442263512.git.lduncan@suse.com>
References: <cover.1442263512.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Lee Duncan <lduncan@suse.com>, Ulf Hansson <ulf.hansson@linaro.org>

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/mmc/core/host.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 99a9c9011c50..5aa2330f074c 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -40,9 +40,8 @@ static DEFINE_SPINLOCK(mmc_host_lock);
 static void mmc_host_classdev_release(struct device *dev)
 {
 	struct mmc_host *host = cls_dev_to_mmc_host(dev);
-	spin_lock(&mmc_host_lock);
-	idr_remove(&mmc_host_idr, host->index);
-	spin_unlock(&mmc_host_lock);
+
+	idr_put_index(&mmc_host_idr, &mmc_host_lock, host->index);
 	kfree(host);
 }
 
@@ -559,17 +558,12 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 
 	/* scanning will be enabled when we're ready */
 	host->rescan_disable = 1;
-	idr_preload(GFP_KERNEL);
-	spin_lock(&mmc_host_lock);
-	err = idr_alloc(&mmc_host_idr, host, 0, 0, GFP_NOWAIT);
-	if (err >= 0)
-		host->index = err;
-	spin_unlock(&mmc_host_lock);
-	idr_preload_end();
+	err = idr_get_index(&mmc_host_idr, &mmc_host_lock, host);
 	if (err < 0) {
 		kfree(host);
 		return NULL;
 	}
+	host->index = err;
 
 	dev_set_name(&host->class_dev, "mmc%d", host->index);
 
-- 
2.1.4

