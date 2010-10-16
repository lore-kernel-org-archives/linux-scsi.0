From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Add struct se_dev_limits for subsystem ->create_virtdevice()
Date: Sat, 16 Oct 2010 16:09:45 -0700
Message-ID: <1287270585-29061-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:38467 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756767Ab0JPXJu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2010 19:09:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for passing a new struct se_dev_limits containing
a struct queue_limits into the transport_add_device_to_core_hba() from
IBLOCK, FILEIO, PSCSI, RAMDISK and STGT subsystem plugins used to register
TCM storage backstores.   The struct se_dev_limits currently contains:

	struct se_dev_limits {
	        /* Max supported SCSI CDB length */
	        int             max_cdb_len;
	        /* Max supported HW queue depth */
	        u32             hw_queue_depth;
	        /* Max supported virtual queue depth */
	        u32             queue_depth;
	        /* From include/linux/blkdev.h for the other HW/SW limits. */
	        struct queue_limits limits;
	} ____cacheline_aligned;

Once this structure has been populated by the subsystem ->create_virtdevice()
call for either A) a real struct block_device and struct request_queue->limits
(iblock, pscsi, fileio w/ BD), B) or the virtual defaults limits (fileio w/o BD,
rd_dr, rd_mcp) imposed by the subsystem backstore and then passed into
transport_add_device_to_core_hba() in TCM Core code.

>From inside transport_add_device_to_core_hba(), se_dev_set_default_attribs()
is passed the new struct se_dev_limits and the v4.0 struct se_dev_attrib
values are populated directly from struct se_dev_limits and dev_limits->limits.
Using this method allows us to drop these five legacy APIs callers that have
been removed all together from target_core_transport.h:struct se_subsystem_api
and TCM code:

	->get_max_cdb_len()
	->get_blocksize()
	->get_max_sectors()
	->get_queue_depth()
	->get_max_queue_depth()

A huge thanks again to hch for his feedback on moving in this direction,
and allowing us to drop yet another ~200 LOC and the legacy struct se_subsystem_api
callers!!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_configfs.c  |    4 ++
 drivers/target/target_core_device.c    |   72 ++++++++++++++------------------
 drivers/target/target_core_file.c      |   72 +++++++++++---------------------
 drivers/target/target_core_iblock.c    |   53 +++++++----------------
 drivers/target/target_core_pscsi.c     |   66 ++++++++---------------------
 drivers/target/target_core_rd.c        |   58 +++++---------------------
 drivers/target/target_core_stgt.c      |   45 --------------------
 drivers/target/target_core_transport.c |   64 ++++++----------------------
 include/target/target_core_base.h      |   12 +++++
 include/target/target_core_device.h    |    2 +-
 include/target/target_core_transport.h |   25 +----------
 11 files changed, 134 insertions(+), 339 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index bd2d4af..b9b756d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -751,6 +751,9 @@ SE_DEV_ATTR(emulate_tpws, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
+DEF_DEV_ATTRIB_RO(max_cdb_len);
+SE_DEV_ATTR_RO(max_cdb_len);
+
 DEF_DEV_ATTRIB_RO(hw_block_size);
 SE_DEV_ATTR_RO(hw_block_size);
 
@@ -799,6 +802,7 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_tpu.attr,
 	&target_core_dev_attrib_emulate_tpws.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
+	&target_core_dev_attrib_max_cdb_len.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
 	&target_core_dev_attrib_hw_max_sectors.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 5364259..da30552 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -995,8 +995,12 @@ int se_dev_check_shutdown(struct se_device *dev)
 	return ret;
 }
 
-void se_dev_set_default_attribs(struct se_device *dev)
+void se_dev_set_default_attribs(
+	struct se_device *dev,
+	struct se_dev_limits *dev_limits)
 {
+	struct queue_limits *limits = &dev_limits->limits;
+
 	DEV_ATTRIB(dev)->emulate_dpo = DA_EMULATE_DPO;
 	DEV_ATTRIB(dev)->emulate_fua_write = DA_EMULATE_FUA_WRITE;
 	DEV_ATTRIB(dev)->emulate_fua_read = DA_EMULATE_FUA_READ;
@@ -1008,6 +1012,11 @@ void se_dev_set_default_attribs(struct se_device *dev)
 	DEV_ATTRIB(dev)->emulate_reservations = DA_EMULATE_RESERVATIONS;
 	DEV_ATTRIB(dev)->emulate_alua = DA_EMULATE_ALUA;
 	DEV_ATTRIB(dev)->enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
+	/*
+	 * The TPU=1 and TPWS=1 settings will be set in TCM/IBLOCK
+	 * iblock_create_virtdevice() from struct queue_limits values
+	 * if blk_queue_discard()==1
+	 */
 	DEV_ATTRIB(dev)->max_unmap_lba_count = DA_MAX_UNMAP_LBA_COUNT;
 	DEV_ATTRIB(dev)->max_unmap_block_desc_count =
 				DA_MAX_UNMAP_BLOCK_DESC_COUNT;
@@ -1015,38 +1024,29 @@ void se_dev_set_default_attribs(struct se_device *dev)
 	DEV_ATTRIB(dev)->unmap_granularity_alignment =
 				DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT;
 	/*
+	 * max_cdb_len is based on subsystem plugin dependent requirements.
+	 */
+	DEV_ATTRIB(dev)->max_cdb_len = dev_limits->max_cdb_len;
+	/*
 	 * block_size is based on subsystem plugin dependent requirements.
 	 */
-	DEV_ATTRIB(dev)->hw_block_size = TRANSPORT(dev)->get_blocksize(dev);
-	DEV_ATTRIB(dev)->block_size = TRANSPORT(dev)->get_blocksize(dev);
+	DEV_ATTRIB(dev)->hw_block_size = limits->logical_block_size;
+	DEV_ATTRIB(dev)->block_size = limits->logical_block_size;
 	/*
 	 * max_sectors is based on subsystem plugin dependent requirements.
 	 */
-	DEV_ATTRIB(dev)->hw_max_sectors = TRANSPORT(dev)->get_max_sectors(dev);
-	DEV_ATTRIB(dev)->max_sectors = TRANSPORT(dev)->get_max_sectors(dev);
+	DEV_ATTRIB(dev)->hw_max_sectors = limits->max_hw_sectors;
+	DEV_ATTRIB(dev)->max_sectors = limits->max_sectors;
 	/*
 	 * Set optimal_sectors from max_sectors, which can be lowered via
 	 * configfs.
 	 */
-	DEV_ATTRIB(dev)->optimal_sectors = DEV_ATTRIB(dev)->max_sectors;
+	DEV_ATTRIB(dev)->optimal_sectors = limits->max_sectors;
 	/*
 	 * queue_depth is based on subsystem plugin dependent requirements.
 	 */
-	DEV_ATTRIB(dev)->hw_queue_depth = TRANSPORT(dev)->get_queue_depth(dev);
-	DEV_ATTRIB(dev)->queue_depth = TRANSPORT(dev)->get_queue_depth(dev);
-	/*
-	 * task_timeout is based on device type.
-	 */
-#if 1
-	/*
-	 * Disabled by default due to known BUG in some cases when task_timeout
-	 * fires..  task_timeout, status_thread and status_thread_tur may end
-	 * up being removed in v3.0.
-	 */
-	DEV_ATTRIB(dev)->task_timeout = 0;
-#else
-	DEV_ATTRIB(dev)->task_timeout = transport_get_default_task_timeout(dev);
-#endif
+	DEV_ATTRIB(dev)->hw_queue_depth = dev_limits->hw_queue_depth;
+	DEV_ATTRIB(dev)->queue_depth = dev_limits->queue_depth;
 }
 
 int se_dev_set_task_timeout(struct se_device *dev, u32 task_timeout)
@@ -1278,6 +1278,7 @@ int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
 		(DEV_ATTRIB(dev)->enforce_pr_isids) ? "Enabled" : "Disabled");
 	return 0;
 }
+
 /*
  * Note, this can only be called on unexported SE Device Object.
  */
@@ -1298,28 +1299,20 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 	}
 
 	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		if (queue_depth > TRANSPORT(dev)->get_queue_depth(dev)) {
+		if (queue_depth > DEV_ATTRIB(dev)->hw_queue_depth) {
 			printk(KERN_ERR "dev[%p]: Passed queue_depth: %u"
 				" exceeds TCM/SE_Device TCQ: %u\n",
 				dev, queue_depth,
-				TRANSPORT(dev)->get_queue_depth(dev));
+				DEV_ATTRIB(dev)->hw_queue_depth);
 			return -1;
 		}
 	} else {
-		if (queue_depth > TRANSPORT(dev)->get_queue_depth(dev)) {
-			if (!(TRANSPORT(dev)->get_max_queue_depth)) {
-				printk(KERN_ERR "dev[%p]: Unable to locate "
-					"get_max_queue_depth() function"
-					" pointer\n", dev);
-				return -1;
-			}
-			if (queue_depth > TRANSPORT(dev)->get_max_queue_depth(
-					dev)) {
+		if (queue_depth > DEV_ATTRIB(dev)->queue_depth) {
+			if (queue_depth > DEV_ATTRIB(dev)->hw_queue_depth) {
 				printk(KERN_ERR "dev[%p]: Passed queue_depth:"
 					" %u exceeds TCM/SE_Device MAX"
 					" TCQ: %u\n", dev, queue_depth,
-					TRANSPORT(dev)->get_max_queue_depth(
-						dev));
+					DEV_ATTRIB(dev)->hw_queue_depth);
 				return -1;
 			}
 		}
@@ -1336,8 +1329,6 @@ int se_dev_set_queue_depth(struct se_device *dev, u32 queue_depth)
 	return 0;
 }
 
-/* #warning FIXME: Forcing max_sectors greater than
-	get_max_sectors() disabled */
 int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 {
 	int force = 0; /* Force setting for VDEVS */
@@ -1360,21 +1351,20 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 		return -1;
 	}
 	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
-		if (max_sectors > TRANSPORT(dev)->get_max_sectors(dev)) {
+		if (max_sectors > DEV_ATTRIB(dev)->hw_max_sectors) {
 			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
 				" greater than TCM/SE_Device max_sectors:"
 				" %u\n", dev, max_sectors,
-				TRANSPORT(dev)->get_max_sectors(dev));
+				DEV_ATTRIB(dev)->hw_max_sectors);
 			 return -1;
 		}
 	} else {
 		if (!(force) && (max_sectors >
-				 TRANSPORT(dev)->get_max_sectors(dev))) {
+				 DEV_ATTRIB(dev)->hw_max_sectors)) {
 			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u"
 				" greater than TCM/SE_Device max_sectors"
 				": %u, use force=1 to override.\n", dev,
-				max_sectors,
-				TRANSPORT(dev)->get_max_sectors(dev));
+				max_sectors, DEV_ATTRIB(dev)->hw_max_sectors);
 			return -1;
 		}
 		if (max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 7a1dec9..f32a1fc 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -141,6 +141,8 @@ static struct se_device *fd_create_virtdevice(
 {
 	char *dev_p = NULL;
 	struct se_device *dev;
+	struct se_dev_limits dev_limits;
+	struct queue_limits *limits;
 	struct fd_dev *fd_dev = (struct fd_dev *) p;
 	struct fd_host *fd_host = (struct fd_host *) hba->hba_ptr;
 	mm_segment_t old_fs;
@@ -148,6 +150,8 @@ static struct se_device *fd_create_virtdevice(
 	struct inode *inode = NULL;
 	int dev_flags = 0, flags;
 
+	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
+
 	old_fs = get_fs();
 	set_fs(get_ds());
 	dev_p = getname(fd_dev->fd_dev_name);
@@ -189,6 +193,16 @@ static struct se_device *fd_create_virtdevice(
 	 */
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
+		struct request_queue *q;
+		/*
+		 * Setup the local scope queue_limits from struct request_queue->limits
+		 * to pass into transport_add_device_to_core_hba() as struct se_dev_limits.
+		 */
+		q = bdev_get_queue(inode->i_bdev);
+		limits = &dev_limits.limits;
+		limits->logical_block_size = bdev_logical_block_size(inode->i_bdev);
+		limits->max_hw_sectors = queue_max_hw_sectors(q);
+		limits->max_sectors = queue_max_sectors(q);
 		/*
 		 * Determine the number of bytes from i_size_read() minus
 		 * one (1) logical sector from underlying struct block_device
@@ -209,8 +223,17 @@ static struct se_device *fd_create_virtdevice(
 				" block_device\n");
 			goto fail;
 		}
+
+		limits = &dev_limits.limits;
+		limits->logical_block_size = FD_BLOCKSIZE;
+		limits->max_hw_sectors = FD_MAX_SECTORS;
+		limits->max_sectors = FD_MAX_SECTORS;
 		fd_dev->fd_block_size = FD_BLOCKSIZE;
 	}
+
+	dev_limits.max_cdb_len = TCM_MAX_COMMAND_SIZE;
+	dev_limits.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
+	dev_limits.queue_depth = FD_DEVICE_QUEUE_DEPTH;
 	/*
 	 * Pass dev_flags for linux_blockdevice_claim_bd or
 	 * linux_blockdevice_claim() from the usage above.
@@ -221,7 +244,7 @@ static struct se_device *fd_create_virtdevice(
 	 */
 	dev = transport_add_device_to_core_hba(hba, &fileio_template,
 				se_dev, dev_flags, (void *)fd_dev,
-				"FILEIO", FD_VERSION);
+				&dev_limits, "FILEIO", FD_VERSION);
 	if (!(dev))
 		goto fail;
 
@@ -924,22 +947,6 @@ static unsigned char *fd_get_cdb(struct se_task *task)
 	return req->fd_scsi_cdb;
 }
 
-static u32 fd_get_max_cdb_len(struct se_device *dev)
-{
-	return TCM_MAX_COMMAND_SIZE;
-}
-
-/*	fd_get_blocksize(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 fd_get_blocksize(struct se_device *dev)
-{
-	struct fd_dev *fd_dev = dev->dev_ptr;
-
-	return fd_dev->fd_block_size;
-}
-
 /*	fd_get_device_rev(): (Part of se_subsystem_api_t template)
  *
  *
@@ -967,15 +974,6 @@ static u32 fd_get_dma_length(u32 task_size, struct se_device *dev)
 	return PAGE_SIZE;
 }
 
-/*	fd_get_max_sectors(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 fd_get_max_sectors(struct se_device *dev)
-{
-	return FD_MAX_SECTORS;
-}
-
 static sector_t fd_get_blocks(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = dev->dev_ptr;
@@ -985,23 +983,6 @@ static sector_t fd_get_blocks(struct se_device *dev)
 	return blocks_long;
 }
 
-/*	fd_get_queue_depth(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 fd_get_queue_depth(struct se_device *dev)
-{
-	return FD_DEVICE_QUEUE_DEPTH;
-}
-
-static u32 fd_get_max_queue_depth(struct se_device *dev)
-{
-	return FD_MAX_DEVICE_QUEUE_DEPTH;
-}
-
-/*#warning FIXME v2.8: transport_type for FILEIO will need to change
-  with DIRECT_IO to blockdevs */
-
 static struct se_subsystem_api fileio_template = {
 	.name			= "fileio",
 	.type			= FILEIO,
@@ -1038,15 +1019,10 @@ static struct se_subsystem_api fileio_template = {
 	.check_lba		= fd_check_lba,
 	.check_for_SG		= fd_check_for_SG,
 	.get_cdb		= fd_get_cdb,
-	.get_max_cdb_len	= fd_get_max_cdb_len,
-	.get_blocksize		= fd_get_blocksize,
 	.get_device_rev		= fd_get_device_rev,
 	.get_device_type	= fd_get_device_type,
 	.get_dma_length		= fd_get_dma_length,
-	.get_max_sectors	= fd_get_max_sectors,
 	.get_blocks		= fd_get_blocks,
-	.get_queue_depth	= fd_get_queue_depth,
-	.get_max_queue_depth	= fd_get_max_queue_depth,
 	.write_pending		= NULL,
 };
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 4c2caa5..e7840da 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -139,13 +139,17 @@ static struct se_device *iblock_create_virtdevice(
 {
 	struct iblock_dev *ib_dev = p;
 	struct se_device *dev;
+	struct se_dev_limits dev_limits;
 	struct block_device *bd = NULL;
+	struct request_queue *q;
+	struct queue_limits *limits;
 	u32 dev_flags = 0;
 
 	if (!(ib_dev)) {
 		printk(KERN_ERR "Unable to locate struct iblock_dev parameter\n");
 		return 0;
 	}
+	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 	/*
 	 * These settings need to be made tunable..
 	 */
@@ -166,6 +170,18 @@ static struct se_device *iblock_create_virtdevice(
 			FMODE_WRITE|FMODE_READ, ib_dev);
 	if (!(bd))
 		goto failed;
+	/*
+	 * Setup the local scope queue_limits from struct request_queue->limits
+	 * to pass into transport_add_device_to_core_hba() as struct se_dev_limits.
+	 */
+	q = bdev_get_queue(bd);
+	limits = &dev_limits.limits;
+	limits->logical_block_size = bdev_logical_block_size(bd);	
+	limits->max_hw_sectors = queue_max_hw_sectors(q);
+	limits->max_sectors = queue_max_sectors(q);
+	dev_limits.max_cdb_len = TCM_MAX_COMMAND_SIZE;
+	dev_limits.hw_queue_depth = IBLOCK_MAX_DEVICE_QUEUE_DEPTH;
+	dev_limits.queue_depth = IBLOCK_DEVICE_QUEUE_DEPTH;
 
 	dev_flags = DF_CLAIMED_BLOCKDEV;
 	ib_dev->ibd_major = MAJOR(bd->bd_dev);
@@ -182,7 +198,7 @@ static struct se_device *iblock_create_virtdevice(
 	 */
 	dev = transport_add_device_to_core_hba(hba,
 			&iblock_template, se_dev, dev_flags, (void *)ib_dev,
-			"IBLOCK", IBLOCK_VERSION);
+			&dev_limits, "IBLOCK", IBLOCK_VERSION);
 	if (!(dev))
 		goto failed;
 
@@ -854,18 +870,6 @@ static unsigned char *iblock_get_cdb(struct se_task *task)
 	return req->ib_scsi_cdb;
 }
 
-static u32 iblock_get_max_cdb_len(struct se_device *dev)
-{
-	return TCM_MAX_COMMAND_SIZE;
-}
-
-static u32 iblock_get_blocksize(struct se_device *dev)
-{
-	struct iblock_dev *ibd = dev->dev_ptr;
-
-	return bdev_logical_block_size(ibd->ibd_bd);
-}
-
 static u32 iblock_get_device_rev(struct se_device *dev)
 {
 	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
@@ -881,14 +885,6 @@ static u32 iblock_get_dma_length(u32 task_size, struct se_device *dev)
 	return PAGE_SIZE;
 }
 
-static u32 iblock_get_max_sectors(struct se_device *dev)
-{
-	struct iblock_dev *ibd = dev->dev_ptr;
-	struct request_queue *q = bdev_get_queue(ibd->ibd_bd);
-
-	return q->limits.max_sectors;
-}
-
 static sector_t iblock_get_blocks(struct se_device *dev)
 {
 	struct iblock_dev *ibd = dev->dev_ptr;
@@ -898,16 +894,6 @@ static sector_t iblock_get_blocks(struct se_device *dev)
 	return iblock_emulate_read_cap_with_block_size(dev, bd, q);
 }
 
-static u32 iblock_get_queue_depth(struct se_device *dev)
-{
-	return IBLOCK_DEVICE_QUEUE_DEPTH;
-}
-
-static u32 iblock_get_max_queue_depth(struct se_device *dev)
-{
-	return IBLOCK_MAX_DEVICE_QUEUE_DEPTH;
-}
-
 static void iblock_bio_done(struct bio *bio, int err)
 {
 	struct se_task *task = (struct se_task *)bio->bi_private;
@@ -976,15 +962,10 @@ static struct se_subsystem_api iblock_template = {
 	.check_lba		= iblock_check_lba,
 	.check_for_SG		= iblock_check_for_SG,
 	.get_cdb		= iblock_get_cdb,
-	.get_max_cdb_len	= iblock_get_max_cdb_len,
-	.get_blocksize		= iblock_get_blocksize,
 	.get_device_rev		= iblock_get_device_rev,
 	.get_device_type	= iblock_get_device_type,
 	.get_dma_length		= iblock_get_dma_length,
-	.get_max_sectors	= iblock_get_max_sectors,
 	.get_blocks		= iblock_get_blocks,
-	.get_queue_depth	= iblock_get_queue_depth,
-	.get_max_queue_depth	= iblock_get_max_queue_depth,
 	.write_pending		= NULL,
 };
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index d0a9384..52b7bbd 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -198,7 +198,11 @@ static struct se_device *pscsi_add_device_to_list(
 	int dev_flags)
 {
 	struct se_device *dev;
+	struct se_dev_limits dev_limits;
+	struct request_queue *q;
+	struct queue_limits *limits;
 
+	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 	/*
 	 * Some pseudo SCSI HBAs do not fill in sector_size
 	 * correctly. (See ide-scsi.c)  So go ahead and setup sane
@@ -237,6 +241,20 @@ static struct se_device *pscsi_add_device_to_list(
 				sd->lun, sd->queue_depth);
 	}
 	/*
+	 * Setup the local scope queue_limits from struct request_queue->limits
+	 * to pass into transport_add_device_to_core_hba() as struct se_dev_limits.
+	 */
+	q = sd->request_queue;
+	limits = &dev_limits.limits;
+	limits->logical_block_size = sd->sector_size;
+	limits->max_hw_sectors = (sd->host->max_sectors > queue_max_hw_sectors(q)) ?
+				  queue_max_hw_sectors(q) : sd->host->max_sectors; 
+	limits->max_sectors = (sd->host->max_sectors > queue_max_sectors(q)) ?
+				  queue_max_sectors(q) : sd->host->max_sectors;
+	dev_limits.max_cdb_len = PSCSI_MAX_CDB_SIZE;
+	dev_limits.hw_queue_depth = sd->queue_depth;
+	dev_limits.queue_depth = sd->queue_depth;
+	/*
 	 * Set the pointer pdv->pdv_sd to from passed struct scsi_device,
 	 * which has already been referenced with Linux SCSI code with
 	 * scsi_device_get() in this file's pscsi_create_virtdevice().
@@ -253,7 +271,7 @@ static struct se_device *pscsi_add_device_to_list(
 
 	dev = transport_add_device_to_core_hba(hba, &pscsi_template,
 				se_dev, dev_flags, (void *)pdv,
-				NULL, NULL);
+				&dev_limits, NULL, NULL);
 	if (!(dev)) {
 		pdv->pdv_sd = NULL;
 		return NULL;
@@ -1403,11 +1421,6 @@ static unsigned char *pscsi_get_cdb(struct se_task *task)
 	return pt->pscsi_cdb;
 }
 
-static u32 pscsi_get_max_cdb_len(struct se_device *dev)
-{
-	return PSCSI_MAX_CDB_SIZE;
-}
-
 /*	pscsi_get_sense_buffer():
  *
  *
@@ -1419,18 +1432,6 @@ static unsigned char *pscsi_get_sense_buffer(struct se_task *task)
 	return (unsigned char *)&pt->pscsi_sense[0];
 }
 
-/*	pscsi_get_blocksize():
- *
- *
- */
-static u32 pscsi_get_blocksize(struct se_device *dev)
-{
-	struct pscsi_dev_virt *pdv = dev->dev_ptr;
-	struct scsi_device *sd = pdv->pdv_sd;
-
-	return sd->sector_size;
-}
-
 /*	pscsi_get_device_rev():
  *
  *
@@ -1464,31 +1465,6 @@ static u32 pscsi_get_dma_length(u32 task_size, struct se_device *dev)
 	return PAGE_SIZE;
 }
 
-/*	pscsi_get_max_sectors():
- *
- *
- */
-static u32 pscsi_get_max_sectors(struct se_device *dev)
-{
-	struct pscsi_dev_virt *pdv = dev->dev_ptr;
-	struct scsi_device *sd = pdv->pdv_sd;
-
-	return (sd->host->max_sectors > sd->request_queue->limits.max_sectors) ?
-		sd->request_queue->limits.max_sectors : sd->host->max_sectors;
-}
-
-/*	pscsi_get_queue_depth():
- *
- *
- */
-static u32 pscsi_get_queue_depth(struct se_device *dev)
-{
-	struct pscsi_dev_virt *pdv = dev->dev_ptr;
-	struct scsi_device *sd = pdv->pdv_sd;
-
-	return sd->queue_depth;
-}
-
 /*	pscsi_handle_SAM_STATUS_failures():
  *
  *
@@ -1574,14 +1550,10 @@ static struct se_subsystem_api pscsi_template = {
 	.check_lba		= pscsi_check_lba,
 	.check_for_SG		= pscsi_check_for_SG,
 	.get_cdb		= pscsi_get_cdb,
-	.get_max_cdb_len	= pscsi_get_max_cdb_len,
 	.get_sense_buffer	= pscsi_get_sense_buffer,
-	.get_blocksize		= pscsi_get_blocksize,
 	.get_device_rev		= pscsi_get_device_rev,
 	.get_device_type	= pscsi_get_device_type,
 	.get_dma_length		= pscsi_get_dma_length,
-	.get_max_sectors	= pscsi_get_max_sectors,
-	.get_queue_depth	= pscsi_get_queue_depth,
 	.write_pending		= NULL,
 };
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index c85101e..3597e1f 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -265,11 +265,14 @@ static struct se_device *rd_create_virtdevice(
 	int rd_direct)
 {
 	struct se_device *dev;
+	struct se_dev_limits dev_limits;
 	struct rd_dev *rd_dev = p;
 	struct rd_host *rd_host = hba->hba_ptr;
 	int dev_flags = 0;
 	char prod[16], rev[4];
 
+	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
+
 	if (rd_dev->rd_direct)
 		dev_flags |= DF_TRANSPORT_DMA_ALLOC;
 
@@ -280,10 +283,17 @@ static struct se_device *rd_create_virtdevice(
 	snprintf(rev, 4, "%s", (rd_dev->rd_direct) ? RD_DR_VERSION :
 						RD_MCP_VERSION);
 
+	dev_limits.limits.logical_block_size = RD_BLOCKSIZE;
+	dev_limits.limits.max_hw_sectors = RD_MAX_SECTORS;
+	dev_limits.limits.max_sectors = RD_MAX_SECTORS;
+	dev_limits.max_cdb_len = TCM_MAX_COMMAND_SIZE;
+	dev_limits.hw_queue_depth = RD_MAX_DEVICE_QUEUE_DEPTH;
+	dev_limits.queue_depth = RD_DEVICE_QUEUE_DEPTH;
+
 	dev = transport_add_device_to_core_hba(hba,
 			(rd_dev->rd_direct) ? &rd_dr_template :
 			&rd_mcp_template, se_dev, dev_flags, (void *)rd_dev,
-			prod, rev);
+			&dev_limits, prod, rev);
 	if (!(dev))
 		goto fail;
 
@@ -1271,20 +1281,6 @@ static unsigned char *rd_get_cdb(struct se_task *task)
 	return req->rd_scsi_cdb;
 }
 
-static u32 rd_get_max_cdb_len(struct se_device *dev)
-{
-	return TCM_MAX_COMMAND_SIZE;
-}
-
-/*	rd_get_blocksize(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 rd_get_blocksize(struct se_device *dev)
-{
-	return RD_BLOCKSIZE;
-}
-
 static u32 rd_get_device_rev(struct se_device *dev)
 {
 	return SCSI_SPC_2; /* Returns SPC-3 in Initiator Data */
@@ -1304,15 +1300,6 @@ static u32 rd_get_dma_length(u32 task_size, struct se_device *dev)
 	return PAGE_SIZE;
 }
 
-/*	rd_get_max_sectors(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 rd_get_max_sectors(struct se_device *dev)
-{
-	return RD_MAX_SECTORS;
-}
-
 static sector_t rd_get_blocks(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = dev->dev_ptr;
@@ -1322,20 +1309,6 @@ static sector_t rd_get_blocks(struct se_device *dev)
 	return blocks_long;
 }
 
-/*	rd_get_queue_depth(): (Part of se_subsystem_api_t template)
- *
- *
- */
-static u32 rd_get_queue_depth(struct se_device *dev)
-{
-	return RD_DEVICE_QUEUE_DEPTH;
-}
-
-static u32 rd_get_max_queue_depth(struct se_device *dev)
-{
-	return RD_MAX_DEVICE_QUEUE_DEPTH;
-}
-
 static struct se_subsystem_api rd_dr_template = {
 	.name			= "rd_dr",
 	.type			= RAMDISK_DR,
@@ -1368,15 +1341,10 @@ static struct se_subsystem_api rd_dr_template = {
 	.check_lba		= rd_DIRECT_check_lba,
 	.check_for_SG		= rd_check_for_SG,
 	.get_cdb		= rd_get_cdb,
-	.get_max_cdb_len	= rd_get_max_cdb_len,
-	.get_blocksize		= rd_get_blocksize,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
 	.get_dma_length		= rd_get_dma_length,
-	.get_max_sectors	= rd_get_max_sectors,
 	.get_blocks		= rd_get_blocks,
-	.get_queue_depth	= rd_get_queue_depth,
-	.get_max_queue_depth	= rd_get_max_queue_depth,
 	.do_se_mem_map		= rd_DIRECT_do_se_mem_map,
 	.write_pending		= NULL,
 };
@@ -1411,13 +1379,9 @@ static struct se_subsystem_api rd_mcp_template = {
 	.check_lba		= rd_MEMCPY_check_lba,
 	.check_for_SG		= rd_check_for_SG,
 	.get_cdb		= rd_get_cdb,
-	.get_blocksize		= rd_get_blocksize,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
 	.get_dma_length		= rd_get_dma_length,
-	.get_max_sectors	= rd_get_max_sectors,
-	.get_queue_depth	= rd_get_queue_depth,
-	.get_max_queue_depth	= rd_get_max_queue_depth,
 	.write_pending		= NULL,
 };
 
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index 2248468..5136a81 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -754,11 +754,6 @@ static unsigned char *stgt_get_cdb(struct se_task *task)
 	return pt->stgt_cdb;
 }
 
-static u32 stgt_get_max_cdb_len(struct se_device *dev)
-{
-	return TCM_MAX_COMMAND_SIZE;
-}
-
 /*	stgt_get_sense_buffer():
  *
  *
@@ -770,18 +765,6 @@ static unsigned char *stgt_get_sense_buffer(struct se_task *task)
 	return (unsigned char *)&pt->stgt_sense[0];
 }
 
-/*	stgt_get_blocksize():
- *
- *
- */
-static u32 stgt_get_blocksize(struct se_device *dev)
-{
-	struct stgt_dev_virt *sdv = dev->dev_ptr;
-	struct scsi_device *sd = sdv->sdv_sd;
-
-	return sd->sector_size;
-}
-
 /*	stgt_get_device_rev():
  *
  *
@@ -815,30 +798,6 @@ static u32 stgt_get_dma_length(u32 task_size, struct se_device *dev)
 	return PAGE_SIZE;
 }
 
-/*	stgt_get_max_sectors():
- *
- *
- */
-static u32 stgt_get_max_sectors(struct se_device *dev)
-{
-	struct stgt_dev_virt *sdv = dev->dev_ptr;
-	struct scsi_device *sd = sdv->sdv_sd;
-	return (sd->host->max_sectors > sd->request_queue->limits.max_sectors) ?
-		sd->request_queue->limits.max_sectors : sd->host->max_sectors;
-}
-
-/*	stgt_get_queue_depth():
- *
- *
- */
-static u32 stgt_get_queue_depth(struct se_device *dev)
-{
-	struct stgt_dev_virt *sdv = dev->dev_ptr;
-	struct scsi_device *sd = sdv->sdv_sd;
-
-	return sd->queue_depth;
-}
-
 /*	stgt_handle_SAM_STATUS_failures():
  *
  *
@@ -938,14 +897,10 @@ static struct se_subsystem_api stgt_template = {
 	.check_lba		= stgt_check_lba,
 	.check_for_SG		= stgt_check_for_SG,
 	.get_cdb		= stgt_get_cdb,
-	.get_max_cdb_len	= stgt_get_max_cdb_len,
 	.get_sense_buffer	= stgt_get_sense_buffer,
-	.get_blocksize		= stgt_get_blocksize,
 	.get_device_rev		= stgt_get_device_rev,
 	.get_device_type	= stgt_get_device_type,
 	.get_dma_length		= stgt_get_dma_length,
-	.get_max_sectors	= stgt_get_max_sectors,
-	.get_queue_depth	= stgt_get_queue_depth,
 	.write_pending		= NULL,
 };
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 612b078..05b18c2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2207,6 +2207,7 @@ struct se_device *transport_add_device_to_core_hba(
 	struct se_subsystem_dev *se_dev,
 	u32 device_flags,
 	void *transport_dev,
+	struct se_dev_limits *dev_limits,
 	const char *inquiry_prod,
 	const char *inquiry_rev)
 {
@@ -2264,11 +2265,11 @@ struct se_device *transport_add_device_to_core_hba(
 	spin_lock_init(&dev->se_port_lock);
 	spin_lock_init(&dev->se_tmr_lock);
 
-	dev->queue_depth	= TRANSPORT(dev)->get_queue_depth(dev);
+	dev->queue_depth	= dev_limits->queue_depth;
 	atomic_set(&dev->depth_left, dev->queue_depth);
 	atomic_set(&dev->dev_ordered_id, 0);
 
-	se_dev_set_default_attribs(dev);
+	se_dev_set_default_attribs(dev, dev_limits);
 
 	dev->write_pending = (transport->write_pending) ?
 		transport->write_pending : &transport_dev_write_pending_nop;
@@ -2499,44 +2500,6 @@ static inline void transport_generic_prepare_cdb(
 	}
 }
 
-static inline u32 transport_dev_max_sectors(struct se_device *dev)
-{
-	/*
-	 * Always enforce the underlying max_sectors for TCM/pSCSI
-	 */
-	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
-		return (DEV_ATTRIB(dev)->max_sectors >
-			TRANSPORT(dev)->get_max_sectors(dev) ?
-			TRANSPORT(dev)->get_max_sectors(dev) :
-			DEV_ATTRIB(dev)->max_sectors);
-
-	return DEV_ATTRIB(dev)->max_sectors;
-}
-
-/*	transport_check_device_cdb_sector_count():
- *
- *	returns:
- *	0 on supported request sector count.
- *	1 on unsupported request sector count.
- */
-static inline int transport_check_device_cdb_sector_count(
-	void *se_obj_ptr,
-	u32 sectors)
-{
-	u32 max_sectors;
-
-	max_sectors = transport_dev_max_sectors(se_obj_ptr);
-	if (!(max_sectors)) {
-		printk(KERN_ERR "transport_dev_max_sectors returned zero!\n");
-		return 1;
-	}
-
-	if (sectors > max_sectors)
-		return -1;
-
-	return 0;
-}
-
 /*	transport_generic_get_task():
  *
  *
@@ -5548,7 +5511,7 @@ static int transport_generic_write_same(struct se_task *task)
 	int ret;
 
 	lba = T_TASK(cmd)->t_task_lba;
-	range = (cmd->data_length / TRANSPORT(dev)->get_blocksize(dev));
+	range = (cmd->data_length / DEV_ATTRIB(dev)->block_size);
 
 	printk(KERN_INFO "WRITE_SAME UNMAP: LBA: %llu Range: %u\n",
                 (unsigned long long)lba, range);
@@ -5934,15 +5897,14 @@ static int transport_generic_cmd_sequencer(
 		service_action = get_unaligned_be16(&cdb[8]);
 		/*
 		 * Check the additional CDB length (+ 8 bytes for header) does
-		 * not exceed our backsores ->get_max_cdb_len()
+		 * not exceed our backsores ->max_cdb_len
 		 */
 		if (scsi_varlen_cdb_length(&cdb[0]) >
-				TRANSPORT(dev)->get_max_cdb_len(dev)) {
+				DEV_ATTRIB(dev)->max_cdb_len) {
 			printk(KERN_INFO "Only %u-byte extended CDBs currently"
 				" supported for VARIABLE_LENGTH_CMD backstore %s,"
 				" received: %d for service action: 0x%04x\n",
-				TRANSPORT(dev)->get_max_cdb_len(dev),
-				TRANSPORT(dev)->name,
+				DEV_ATTRIB(dev)->max_cdb_len, TRANSPORT(dev)->name,
 				scsi_varlen_cdb_length(&cdb[0]), service_action);
 			return TGCS_INVALID_CDB_FIELD;
 		}
@@ -7632,13 +7594,13 @@ static inline int transport_set_tasks_sectors_disk(
 	if ((lba + sectors) > transport_dev_end_lba(dev)) {
 		task->task_sectors = ((transport_dev_end_lba(dev) - lba) + 1);
 
-		if (task->task_sectors > transport_dev_max_sectors(dev)) {
-			task->task_sectors = transport_dev_max_sectors(dev);
+		if (task->task_sectors > DEV_ATTRIB(dev)->max_sectors) {
+			task->task_sectors = DEV_ATTRIB(dev)->max_sectors;
 			*max_sectors_set = 1;
 		}
 	} else {
-		if (sectors > transport_dev_max_sectors(dev)) {
-			task->task_sectors = transport_dev_max_sectors(dev);
+		if (sectors > DEV_ATTRIB(dev)->max_sectors) {
+			task->task_sectors = DEV_ATTRIB(dev)->max_sectors;
 			*max_sectors_set = 1;
 		} else
 			task->task_sectors = sectors;
@@ -7654,8 +7616,8 @@ static inline int transport_set_tasks_sectors_non_disk(
 	u32 sectors,
 	int *max_sectors_set)
 {
-	if (sectors > transport_dev_max_sectors(dev)) {
-		task->task_sectors = transport_dev_max_sectors(dev);
+	if (sectors > DEV_ATTRIB(dev)->max_sectors) {
+		task->task_sectors = DEV_ATTRIB(dev)->max_sectors;
 		*max_sectors_set = 1;
 	} else
 		task->task_sectors = sectors;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index eb546f4..ecd7143 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -744,6 +744,17 @@ struct se_dev_entry {
 	struct list_head	ua_list;
 }  ____cacheline_aligned;
 
+struct se_dev_limits {
+	/* Max supported SCSI CDB length */
+	int		max_cdb_len;
+	/* Max supported HW queue depth */
+	u32		hw_queue_depth;
+	/* Max supported virtual queue depth */
+	u32		queue_depth;
+	/* From include/linux/blkdev.h for the other HW/SW limits. */
+	struct queue_limits limits;
+} ____cacheline_aligned;
+
 struct se_dev_attrib {
 	int		emulate_dpo;
 	int		emulate_fua_write;
@@ -756,6 +767,7 @@ struct se_dev_attrib {
 	int		emulate_reservations;
 	int		emulate_alua;
 	int		enforce_pr_isids;
+	int		max_cdb_len;
 	u32		hw_block_size;
 	u32		block_size;
 	u32		hw_max_sectors;
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index 248d954..f440372 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -36,7 +36,7 @@ extern void se_dev_start(struct se_device *);
 extern void se_dev_stop(struct se_device *);
 extern int se_dev_check_online(struct se_device *);
 extern int se_dev_check_shutdown(struct se_device *);
-extern void se_dev_set_default_attribs(struct se_device *);
+extern void se_dev_set_default_attribs(struct se_device *, struct se_dev_limits *);
 extern int se_dev_set_task_timeout(struct se_device *, u32);
 extern int se_dev_set_max_unmap_lba_count(struct se_device *, u32);
 extern int se_dev_set_max_unmap_block_desc_count(struct se_device *, u32);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 330edb9..b902ea3 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -192,7 +192,8 @@ extern int transport_rescan_evpd_device_ident(struct se_device *);
 extern struct se_device *transport_add_device_to_core_hba(struct se_hba *,
 					struct se_subsystem_api *,
 					struct se_subsystem_dev *, u32,
-					void *, const char *, const char *);
+					void *, struct se_dev_limits *,
+					const char *, const char *);
 extern int transport_generic_activate_device(struct se_device *);
 extern void transport_generic_deactivate_device(struct se_device *);
 extern void transport_generic_free_device(struct se_device *);
@@ -521,15 +522,6 @@ struct se_subsystem_api {
 	 */
 	unsigned char *(*get_cdb)(struct se_task *);
 	/*
-	 * get_max_cdb_len(): Used by subsystems backstoers to signal the
-	 * maximum receivable SCSI CDB size.
-	 */
-	u32 (*get_max_cdb_len)(struct se_device *);
-	/*
-	 * get_blocksize():
-	 */
-	u32 (*get_blocksize)(struct se_device *);
-	/*
 	 * get_device_rev():
 	 */
 	u32 (*get_device_rev)(struct se_device *);
@@ -546,23 +538,10 @@ struct se_subsystem_api {
 	 */
 	u32 (*get_max_cdbs)(struct se_device *);
 	/*
-	 * get_max_sectors():
-	 */
-	 u32 (*get_max_sectors)(struct se_device *);
-	/*
 	 * Get the sector_t from a subsystem backstore..
 	 */
 	sector_t (*get_blocks)(struct se_device *);
 	/*
-	 * get_queue_depth():
-	 *
-	 */
-	u32 (*get_queue_depth)(struct se_device *);
-	/*
-	 * get_max_queue_depth():
-	 */
-	u32 (*get_max_queue_depth)(struct se_device *);
-	/*
 	 * do_se_mem_map():
 	 */
 	int (*do_se_mem_map)(struct se_task *, struct list_head *, void *,
-- 
1.5.6.5

