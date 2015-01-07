From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/2] target: Drop left-over fabric_max_sectors attribute
Date: Wed,  7 Jan 2015 00:24:18 +0000
Message-ID: <1420590258-21122-2-git-send-email-nab@daterainc.com>
References: <1420590258-21122-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40461 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbbAGA41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 19:56:27 -0500
Received: by mail-ob0-f169.google.com with SMTP id vb8so959950obc.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2015 16:56:26 -0800 (PST)
In-Reply-To: <1420590258-21122-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that fabric_max_sectors is no longer used to enforce the maximum
I/O size, go ahead and drop it's left-over usage in target-core and
associated backend drivers.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c           | 46 ---------------------------
 drivers/target/target_core_file.c             |  1 -
 drivers/target/target_core_iblock.c           |  1 -
 drivers/target/target_core_rd.c               |  1 -
 drivers/target/target_core_user.c             |  1 -
 include/target/target_core_backend.h          |  1 -
 include/target/target_core_backend_configfs.h |  2 --
 include/target/target_core_base.h             |  3 --
 8 files changed, 56 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ee4b89f..58f49ff 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1103,51 +1103,6 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 }
 EXPORT_SYMBOL(se_dev_set_queue_depth);
 
-int se_dev_set_fabric_max_sectors(struct se_device *dev, u32 fabric_max_sectors)
-{
-	int block_size = dev->dev_attrib.block_size;
-
-	if (dev->export_count) {
-		pr_err("dev[%p]: Unable to change SE Device"
-			" fabric_max_sectors while export_count is %d\n",
-			dev, dev->export_count);
-		return -EINVAL;
-	}
-	if (!fabric_max_sectors) {
-		pr_err("dev[%p]: Illegal ZERO value for"
-			" fabric_max_sectors\n", dev);
-		return -EINVAL;
-	}
-	if (fabric_max_sectors < DA_STATUS_MAX_SECTORS_MIN) {
-		pr_err("dev[%p]: Passed fabric_max_sectors: %u less than"
-			" DA_STATUS_MAX_SECTORS_MIN: %u\n", dev, fabric_max_sectors,
-				DA_STATUS_MAX_SECTORS_MIN);
-		return -EINVAL;
-	}
-	if (fabric_max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
-		pr_err("dev[%p]: Passed fabric_max_sectors: %u"
-			" greater than DA_STATUS_MAX_SECTORS_MAX:"
-			" %u\n", dev, fabric_max_sectors,
-			DA_STATUS_MAX_SECTORS_MAX);
-		return -EINVAL;
-	}
-	/*
-	 * Align max_sectors down to PAGE_SIZE to follow transport_allocate_data_tasks()
-	 */
-	if (!block_size) {
-		block_size = 512;
-		pr_warn("Defaulting to 512 for zero block_size\n");
-	}
-	fabric_max_sectors = se_dev_align_max_sectors(fabric_max_sectors,
-						      block_size);
-
-	dev->dev_attrib.fabric_max_sectors = fabric_max_sectors;
-	pr_debug("dev[%p]: SE Device max_sectors changed to %u\n",
-			dev, fabric_max_sectors);
-	return 0;
-}
-EXPORT_SYMBOL(se_dev_set_fabric_max_sectors);
-
 int se_dev_set_optimal_sectors(struct se_device *dev, u32 optimal_sectors)
 {
 	if (dev->export_count) {
@@ -1553,7 +1508,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.unmap_granularity_alignment =
 				DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
-	dev->dev_attrib.fabric_max_sectors = DA_FABRIC_MAX_SECTORS;
 
 	xcopy_lun = &dev->xcopy_lun;
 	xcopy_lun->lun_se_dev = dev;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index c2aea09..8f11dcf 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -959,7 +959,6 @@ static struct configfs_attribute *fileio_backend_dev_attrs[] = {
 	&fileio_dev_attrib_hw_block_size.attr,
 	&fileio_dev_attrib_block_size.attr,
 	&fileio_dev_attrib_hw_max_sectors.attr,
-	&fileio_dev_attrib_fabric_max_sectors.attr,
 	&fileio_dev_attrib_optimal_sectors.attr,
 	&fileio_dev_attrib_hw_queue_depth.attr,
 	&fileio_dev_attrib_queue_depth.attr,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 5795cd8..78346b8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -883,7 +883,6 @@ static struct configfs_attribute *iblock_backend_dev_attrs[] = {
 	&iblock_dev_attrib_hw_block_size.attr,
 	&iblock_dev_attrib_block_size.attr,
 	&iblock_dev_attrib_hw_max_sectors.attr,
-	&iblock_dev_attrib_fabric_max_sectors.attr,
 	&iblock_dev_attrib_optimal_sectors.attr,
 	&iblock_dev_attrib_hw_queue_depth.attr,
 	&iblock_dev_attrib_queue_depth.attr,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 60ebd17..98e83ac 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -657,7 +657,6 @@ static struct configfs_attribute *rd_mcp_backend_dev_attrs[] = {
 	&rd_mcp_dev_attrib_hw_block_size.attr,
 	&rd_mcp_dev_attrib_block_size.attr,
 	&rd_mcp_dev_attrib_hw_max_sectors.attr,
-	&rd_mcp_dev_attrib_fabric_max_sectors.attr,
 	&rd_mcp_dev_attrib_optimal_sectors.attr,
 	&rd_mcp_dev_attrib_hw_queue_depth.attr,
 	&rd_mcp_dev_attrib_queue_depth.attr,
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8bfa61c..1157b55 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1118,7 +1118,6 @@ static struct configfs_attribute *tcmu_backend_dev_attrs[] = {
 	&tcmu_dev_attrib_hw_block_size.attr,
 	&tcmu_dev_attrib_block_size.attr,
 	&tcmu_dev_attrib_hw_max_sectors.attr,
-	&tcmu_dev_attrib_fabric_max_sectors.attr,
 	&tcmu_dev_attrib_optimal_sectors.attr,
 	&tcmu_dev_attrib_hw_queue_depth.attr,
 	&tcmu_dev_attrib_queue_depth.attr,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 430cfaf..db81c65 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -135,7 +135,6 @@ int	se_dev_set_is_nonrot(struct se_device *, int);
 int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
 int	se_dev_set_queue_depth(struct se_device *, u32);
 int	se_dev_set_max_sectors(struct se_device *, u32);
-int	se_dev_set_fabric_max_sectors(struct se_device *, u32);
 int	se_dev_set_optimal_sectors(struct se_device *, u32);
 int	se_dev_set_block_size(struct se_device *, u32);
 
diff --git a/include/target/target_core_backend_configfs.h b/include/target/target_core_backend_configfs.h
index 3247d75..186f7a9 100644
--- a/include/target/target_core_backend_configfs.h
+++ b/include/target/target_core_backend_configfs.h
@@ -98,8 +98,6 @@ static struct target_backend_dev_attrib_attribute _backend##_dev_attrib_##_name
 	TB_DEV_ATTR(_backend, block_size, S_IRUGO | S_IWUSR);		\
 	DEF_TB_DEV_ATTRIB_RO(_backend, hw_max_sectors);			\
 	TB_DEV_ATTR_RO(_backend, hw_max_sectors);			\
-	DEF_TB_DEV_ATTRIB(_backend, fabric_max_sectors);		\
-	TB_DEV_ATTR(_backend, fabric_max_sectors, S_IRUGO | S_IWUSR);	\
 	DEF_TB_DEV_ATTRIB(_backend, optimal_sectors);			\
 	TB_DEV_ATTR(_backend, optimal_sectors, S_IRUGO | S_IWUSR);	\
 	DEF_TB_DEV_ATTRIB_RO(_backend, hw_queue_depth);			\
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 397fb63..4a8795a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -77,8 +77,6 @@
 #define DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT	0
 /* Default max_write_same_len, disabled by default */
 #define DA_MAX_WRITE_SAME_LEN			0
-/* Default max transfer length */
-#define DA_FABRIC_MAX_SECTORS			8192
 /* Use a model alias based on the configfs backend device name */
 #define DA_EMULATE_MODEL_ALIAS			0
 /* Emulation for Direct Page Out */
@@ -694,7 +692,6 @@ struct se_dev_attrib {
 	u32		hw_block_size;
 	u32		block_size;
 	u32		hw_max_sectors;
-	u32		fabric_max_sectors;
 	u32		optimal_sectors;
 	u32		hw_queue_depth;
 	u32		queue_depth;
-- 
1.9.1

