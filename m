From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 10/17] Update the DCA DMA driver to use idr helper functions.
Date: Wed, 16 Sep 2015 10:50:28 -0700
Message-ID: <77238f931cd168e25f836e0d0fdf0eeab4eb9056.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbbIPRvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2015 13:51:19 -0400
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org, Lee Duncan <lduncan@suse.com>

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/dca/dca-sysfs.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
index 126cf295b198..8930707df295 100644
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -55,23 +55,14 @@ int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
 	struct device *cd;
 	int ret;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&dca_idr_lock);
-
-	ret = idr_alloc(&dca_idr, dca, 0, 0, GFP_NOWAIT);
-	if (ret >= 0)
-		dca->id = ret;
-
-	spin_unlock(&dca_idr_lock);
-	idr_preload_end();
+	ret = idr_get_index(&dca_idr, &dca_idr_lock, dca);
 	if (ret < 0)
 		return ret;
+	dca->id = ret;
 
 	cd = device_create(dca_class, dev, MKDEV(0, 0), NULL, "dca%d", dca->id);
 	if (IS_ERR(cd)) {
-		spin_lock(&dca_idr_lock);
-		idr_remove(&dca_idr, dca->id);
-		spin_unlock(&dca_idr_lock);
+		idr_put_index(&dca_idr, &dca_idr_lock, dca->id);
 		return PTR_ERR(cd);
 	}
 	dca->cd = cd;
@@ -82,9 +73,7 @@ void dca_sysfs_remove_provider(struct dca_provider *dca)
 {
 	device_unregister(dca->cd);
 	dca->cd = NULL;
-	spin_lock(&dca_idr_lock);
-	idr_remove(&dca_idr, dca->id);
-	spin_unlock(&dca_idr_lock);
+	idr_put_index(&dca_idr, &dca_idr_lock, dca->id);
 }
 
 int __init dca_sysfs_init(void)
-- 
2.1.4

