From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] dm: call PR reserve/unreserve on each underlying device
Date: Fri,  8 Jul 2016 21:23:51 +0900
Message-ID: <1467980631-18945-3-git-send-email-hch@lst.de>
References: <1467980631-18945-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbcGHMYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2016 08:24:14 -0400
In-Reply-To: <1467980631-18945-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org

So far we tried to rely on the SCSI 'all target ports' bit to register
all path, but for many setups this didn't work properly as the different
path aren seen as separate initiators to the target instead of multiple
ports of the same initiator.  Because of that we'll stop setting the
'all target ports' bit in SCSI, and let device mapper handle iterating
over the device for each path and register it manually.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 70 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b2f962..e4e98b7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3601,26 +3601,81 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	kfree(pools);
 }
 
-static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
-			  u32 flags)
+struct dm_pr {
+	u64	old_key;
+	u64	new_key;
+	u32	flags;
+	bool	fail_early;
+};
+
+static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
+		void *data)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
-	const struct pr_ops *ops;
-	fmode_t mode;
-	int r;
+	struct dm_table *table;
+	struct dm_target *ti;
+	int ret = 0, srcu_idx;
 
-	r = dm_grab_bdev_for_ioctl(md, &bdev, &mode);
-	if (r < 0)
-		return r;
+	table = dm_get_live_table(md, &srcu_idx);
+	if (!table || !dm_table_get_size(table))
+		return -ENOTTY;
 
-	ops = bdev->bd_disk->fops->pr_ops;
-	if (ops && ops->pr_register)
-		r = ops->pr_register(bdev, old_key, new_key, flags);
-	else
-		r = -EOPNOTSUPP;
+	/* We only support devices that have a single target */
+	ret = -ENOTTY;
+	if (dm_table_get_num_targets(table) != 1)
+		goto out;
+	ti = dm_table_get_target(table, 0);
 
-	bdput(bdev);
-	return r;
+	ret = -EINVAL;
+	if (!ti->type->iterate_devices)
+		goto out;
+
+	ret = ti->type->iterate_devices(ti, fn, data);
+	if (ret)
+		goto out;
+
+	ret = 0;
+out:
+	dm_put_live_table(md, srcu_idx);
+	return ret;
+}
+
+/*
+ * For register / unregister we need to manually call out to every path.
+ */
+static int __dm_pr_register(struct dm_target *ti, struct dm_dev *dev,
+		sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_register)
+		return -EOPNOTSUPP;
+	return ops->pr_register(dev->bdev, pr->old_key, pr->new_key, pr->flags);
+}
+
+static int dm_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
+			  u32 flags)
+{
+	struct dm_pr pr = {
+		.old_key	= old_key,
+		.new_key	= new_key,
+		.flags		= flags,
+		.fail_early	= true,
+	};
+	int ret;
+
+	ret = dm_call_pr(bdev, __dm_pr_register, &pr);
+	if (ret && new_key) {
+		/* unregister all paths if we failed to register any path */
+		pr.old_key = new_key;
+		pr.new_key = 0;
+		pr.flags = 0;
+		pr.fail_early = false;
+		dm_call_pr(bdev, __dm_pr_register, &pr);
+	}
+
+	return ret;
 }
 
 static int dm_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
-- 
2.1.4

