From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/5] tcm: Unify READ_CAPACITY_* subsystem plugin handling
Date: Wed, 13 Oct 2010 01:48:10 -0700
Message-ID: <1286959690-3466-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the following struct se_subsystem_api function pointer
op for READ_CAPACITY and SA READ_CAPACITY_16 emulation reponse payload
blocks:

       /*
        * Get the sector_t from a subsystem backstore..
        */
       sector_t (*get_blocks)(struct se_device *);

and updates IBLOCK, FILEIO and RAMDISK_[DR,MCP] to return their
respective sector_t blocks for READ_CAPACITY_* emulation processing.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c      |   41 +++++++-----------------------
 drivers/target/target_core_iblock.c    |   43 +++++++------------------------
 drivers/target/target_core_rd.c        |   39 +++++++---------------------
 drivers/target/target_core_transport.c |   10 ++++++-
 include/target/target_core_transport.h |    6 +++-
 5 files changed, 42 insertions(+), 97 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 97e068f..dd7abef 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -358,35 +358,6 @@ static void *fd_allocate_request(
 	return (void *)fd_req;
 }
 
-/*	fd_emulate_read_cap():
- *
- *
- */
-static int fd_emulate_read_cap(struct se_task *task)
-{
-	struct fd_dev *fd_dev = task->se_dev->dev_ptr;
-	unsigned long long blocks_long = div_u64(fd_dev->fd_dev_size,
-				DEV_ATTRIB(task->se_dev)->block_size);
-	u32 blocks;
-
-	if (blocks_long >= 0x00000000ffffffff)
-		blocks = 0xffffffff;
-	else
-		blocks = (u32)blocks_long;
-
-	return transport_generic_emulate_readcapacity(TASK_CMD(task), blocks);
-}
-
-static int fd_emulate_read_cap16(struct se_task *task)
-{
-	struct fd_dev *fd_dev = task->se_dev->dev_ptr;
-	unsigned long long blocks_long = div_u64(fd_dev->fd_dev_size,
-				  DEV_ATTRIB(task->se_dev)->block_size);
-
-	return transport_generic_emulate_readcapacity_16(TASK_CMD(task),
-		blocks_long);
-}
-
 static int fd_emulate_unmap(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
@@ -1137,6 +1108,15 @@ static u32 fd_get_max_sectors(struct se_device *dev)
 	return FD_MAX_SECTORS;
 }
 
+static sector_t fd_get_blocks(struct se_device *dev)
+{
+	struct fd_dev *fd_dev = dev->dev_ptr;
+	unsigned long long blocks_long = div_u64(fd_dev->fd_dev_size,
+			DEV_ATTRIB(dev)->block_size);
+
+	return blocks_long;
+}
+
 /*	fd_get_queue_depth(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1196,14 +1176,13 @@ static struct se_subsystem_api fileio_template = {
 	.get_inquiry_rev	= fd_get_inquiry_rev,
 	.get_dma_length		= fd_get_dma_length,
 	.get_max_sectors	= fd_get_max_sectors,
+	.get_blocks		= fd_get_blocks,
 	.get_queue_depth	= fd_get_queue_depth,
 	.get_max_queue_depth	= fd_get_max_queue_depth,
 	.write_pending		= NULL,
 };
 
 static struct se_subsystem_api_cdb fileio_cdb_template = {
-	.emulate_read_cap	= fd_emulate_read_cap,
-	.emulate_read_cap16	= fd_emulate_read_cap16,
 	.emulate_unmap		= fd_emulate_unmap,
 	.emulate_write_same	= fd_emulate_write_same_unmap,
 	.emulate_sync_cache	= fd_emulate_sync_cache,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 4880891..cb53fbf 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -419,37 +419,6 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	return blocks_long;
 }
 
-static int iblock_emulate_read_cap(struct se_task *task)
-{
-	struct iblock_dev *ibd = task->se_dev->dev_ptr;
-	struct block_device *bd = ibd->ibd_bd;
-	struct request_queue *q = bdev_get_queue(bd);
-	unsigned long long blocks_long = 0;
-	u32 blocks = 0;
-
-	blocks_long = iblock_emulate_read_cap_with_block_size(
-				task->se_dev, bd, q);
-	if (blocks_long >= 0x00000000ffffffff)
-		blocks = 0xffffffff;
-	else
-		blocks = (u32)blocks_long;
-
-	return transport_generic_emulate_readcapacity(TASK_CMD(task), blocks);
-}
-
-static int iblock_emulate_read_cap16(struct se_task *task)
-{
-	struct iblock_dev *ibd = task->se_dev->dev_ptr;
-	struct block_device *bd = ibd->ibd_bd;
-	struct request_queue *q = bdev_get_queue(bd);
-	unsigned long long blocks_long;
-
-	blocks_long = iblock_emulate_read_cap_with_block_size(
-				task->se_dev, bd, q);
-	return transport_generic_emulate_readcapacity_16(
-				TASK_CMD(task), blocks_long);
-}
-
 static int iblock_emulate_unmap(struct se_task *task)
 {
 	struct iblock_dev *ibd = task->se_dev->dev_ptr;
@@ -1034,6 +1003,15 @@ static u32 iblock_get_max_sectors(struct se_device *dev)
 	return q->limits.max_sectors;
 }
 
+static sector_t iblock_get_blocks(struct se_device *dev)
+{
+	struct iblock_dev *ibd = dev->dev_ptr;
+	struct block_device *bd = ibd->ibd_bd;
+	struct request_queue *q = bdev_get_queue(bd);
+	
+	return iblock_emulate_read_cap_with_block_size(dev, bd, q);
+}
+
 static u32 iblock_get_queue_depth(struct se_device *dev)
 {
 	return IBLOCK_DEVICE_QUEUE_DEPTH;
@@ -1119,14 +1097,13 @@ static struct se_subsystem_api iblock_template = {
 	.get_inquiry_rev	= iblock_get_inquiry_rev,
 	.get_dma_length		= iblock_get_dma_length,
 	.get_max_sectors	= iblock_get_max_sectors,
+	.get_blocks		= iblock_get_blocks,
 	.get_queue_depth	= iblock_get_queue_depth,
 	.get_max_queue_depth	= iblock_get_max_queue_depth,
 	.write_pending		= NULL,
 };
 
 static struct se_subsystem_api_cdb iblock_cdb_template = {
-	.emulate_read_cap	= iblock_emulate_read_cap,
-	.emulate_read_cap16	= iblock_emulate_read_cap16,
 	.emulate_unmap		= iblock_emulate_unmap,
 	.emulate_write_same	= iblock_emulate_write_same_unmap,
 	.emulate_sync_cache	= iblock_emulate_sync_cache,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index e29fd09..c84213f 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -385,33 +385,6 @@ static void *rd_allocate_request(
 	return (void *)rd_req;
 }
 
-/*	rd_emulate_read_cap():
- *
- *
- */
-static int rd_emulate_read_cap(struct se_task *task)
-{
-	struct rd_dev *rd_dev = task->se_dev->dev_ptr;
-	u32 blocks = ((rd_dev->rd_page_count * PAGE_SIZE) /
-		       DEV_ATTRIB(task->se_dev)->block_size) - 1;
-
-	if ((((rd_dev->rd_page_count * PAGE_SIZE) /
-	       DEV_ATTRIB(task->se_dev)->block_size) - 1) >= 0x00000000ffffffff)
-		blocks = 0xffffffff;
-
-	return transport_generic_emulate_readcapacity(TASK_CMD(task), blocks);
-}
-
-static int rd_emulate_read_cap16(struct se_task *task)
-{
-	struct rd_dev *rd_dev = task->se_dev->dev_ptr;
-	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) /
-				   DEV_ATTRIB(task->se_dev)->block_size) - 1;
-
-	return transport_generic_emulate_readcapacity_16(TASK_CMD(task),
-				blocks_long);
-}
-
 /*	rd_get_sg_table():
  *
  *
@@ -1348,6 +1321,15 @@ static u32 rd_get_max_sectors(struct se_device *dev)
 	return RD_MAX_SECTORS;
 }
 
+static sector_t rd_get_blocks(struct se_device *dev)
+{
+	struct rd_dev *rd_dev = dev->dev_ptr;
+	unsigned long long blocks_long = ((rd_dev->rd_page_count * PAGE_SIZE) /
+			DEV_ATTRIB(dev)->block_size) - 1;
+
+	return blocks_long;
+}
+
 /*	rd_get_queue_depth(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1402,6 +1384,7 @@ static struct se_subsystem_api rd_dr_template = {
 	.get_inquiry_rev	= rd_get_inquiry_rev,
 	.get_dma_length		= rd_get_dma_length,
 	.get_max_sectors	= rd_get_max_sectors,
+	.get_blocks		= rd_get_blocks,
 	.get_queue_depth	= rd_get_queue_depth,
 	.get_max_queue_depth	= rd_get_max_queue_depth,
 	.do_se_mem_map		= rd_DIRECT_do_se_mem_map,
@@ -1451,8 +1434,6 @@ static struct se_subsystem_api rd_mcp_template = {
 };
 
 static struct se_subsystem_api_cdb rd_cdb_template = {
-	.emulate_read_cap	= rd_emulate_read_cap,
-	.emulate_read_cap16	= rd_emulate_read_cap16,
 	.emulate_unmap		= NULL,
 };
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a49c190..3fb56d5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5548,6 +5548,8 @@ int transport_emulate_control_cdb(struct se_task *task)
 	struct se_cmd *cmd = TASK_CMD(task);
 	struct se_device *dev = SE_DEV(cmd);
 	struct se_subsystem_api_cdb *api_cdb = TRANSPORT(dev)->sub_cdb;
+	sector_t blocks_long;
+	unsigned int blocks;
 	int ret;
 	unsigned short service_action;
 
@@ -5561,7 +5563,9 @@ int transport_emulate_control_cdb(struct se_task *task)
 			return ret;
 		break;
 	case READ_CAPACITY:
-		ret = api_cdb->emulate_read_cap(task);	
+		blocks = TRANSPORT(dev)->get_blocks(dev);
+		ret = transport_generic_emulate_readcapacity(cmd,
+					blocks);	
 		if (ret < 0)
 			return ret;
 		break;
@@ -5584,7 +5588,9 @@ int transport_emulate_control_cdb(struct se_task *task)
 	case SERVICE_ACTION_IN:
 		switch (T_TASK(cmd)->t_task_cdb[1] & 0x1f) {
 		case SAI_READ_CAPACITY_16:
-			ret = api_cdb->emulate_read_cap16(task);
+			blocks_long = TRANSPORT(dev)->get_blocks(dev);
+			ret = transport_generic_emulate_readcapacity_16(cmd,
+						blocks_long);
 			if (ret < 0)
 				return ret;
 			break;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index a949dab..1c62d8c 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -318,8 +318,6 @@ struct se_mem {
  * subsystem plugins.for those CDBs that cannot be emulated generically.
  */
 struct se_subsystem_api_cdb {
-	int (*emulate_read_cap)(struct se_task *);
-	int (*emulate_read_cap16)(struct se_task *);
 	int (*emulate_unmap)(struct se_task *);
 	int (*emulate_write_same)(struct se_task *);
 	void (*emulate_sync_cache)(struct se_task *);
@@ -572,6 +570,10 @@ struct se_subsystem_api {
 	 */
 	 u32 (*get_max_sectors)(struct se_device *);
 	/*
+	 * Get the sector_t from a subsystem backstore..
+	 */
+	sector_t (*get_blocks)(struct se_device *);
+	/*
 	 * get_queue_depth():
 	 *
 	 */
-- 
1.5.6.5
