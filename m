From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/5] tcm: Unify UNMAP and WRITE_SAME w/ UNMAP=1 subsystem plugin handling
Date: Wed, 13 Oct 2010 01:48:20 -0700
Message-ID: <1286959700-3489-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the following struct se_subsystem_api function pointer
op for UNMAP and WRITE_SAME w/ UNMAP=1 handling mapped to Linux/Block
layer generic Discard to underlying SCSI *_UNMAP and ATA TRIM operation:

       /*
        * Used by virtual subsystem plugins IBLOCK and FILEIO to emulate
        * UNMAP and WRITE_SAME_* w/ UNMAP=1 <-> Linux/Block Discard
        */
       int (*do_discard)(struct se_task *, enum blk_discard_type);

and updates IBLOCK and FILEIO to execute their respective -> Linux/Block
DISCARD ops based on the passed blk_discard_type.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c      |   17 +++++++++++++++--
 drivers/target/target_core_iblock.c    |   30 +++++++++++++++++++-----------
 drivers/target/target_core_rd.c        |    6 ------
 drivers/target/target_core_transport.c |   12 ++++++------
 include/target/target_core_transport.h |   12 ++++++++++--
 5 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index dd7abef..adac070 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -774,6 +774,20 @@ static int fd_do_task(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
+static int fd_do_discard(struct se_task *task, enum blk_discard_type type)
+{
+	if (type == DISCARD_UNMAP)
+		return fd_emulate_unmap(task);
+	else if (type == DISCARD_WRITE_SAME_UNMAP)
+		return fd_emulate_write_same_unmap(task);
+	else {
+		printk(KERN_ERR "Unsupported discard_type_t: %d\n", type);
+		return -ENOSYS;
+	}
+
+	return -ENOSYS;
+}
+
 /*	fd_free_task(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1158,6 +1172,7 @@ static struct se_subsystem_api fileio_template = {
 	.transport_complete	= fd_transport_complete,
 	.allocate_request	= fd_allocate_request,
 	.do_task		= fd_do_task,
+	.do_discard		= fd_do_discard,
 	.free_task		= fd_free_task,
 	.check_configfs_dev_params = fd_check_configfs_dev_params,
 	.set_configfs_dev_params = fd_set_configfs_dev_params,
@@ -1183,8 +1198,6 @@ static struct se_subsystem_api fileio_template = {
 };
 
 static struct se_subsystem_api_cdb fileio_cdb_template = {
-	.emulate_unmap		= fd_emulate_unmap,
-	.emulate_write_same	= fd_emulate_write_same_unmap,
 	.emulate_sync_cache	= fd_emulate_sync_cache,
 };
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index cb53fbf..e1d945f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -419,15 +419,6 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	return blocks_long;
 }
 
-static int iblock_emulate_unmap(struct se_task *task)
-{
-	struct iblock_dev *ibd = task->se_dev->dev_ptr;
-	struct block_device *bd = ibd->ibd_bd;
-	struct se_cmd *cmd = TASK_CMD(task);
-	
-	return transport_generic_unmap(cmd, bd);
-}
-
 static int iblock_emulate_write_same_unmap(struct se_task *task)
 {
 	struct iblock_dev *ibd = task->se_dev->dev_ptr;
@@ -568,6 +559,24 @@ static int iblock_do_task(struct se_task *task)
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
 
+static int iblock_do_discard(struct se_task *task, enum blk_discard_type type)
+{
+	struct iblock_dev *ibd = task->se_dev->dev_ptr;
+	struct block_device *bd = ibd->ibd_bd;
+	struct se_cmd *cmd = TASK_CMD(task);
+
+	if (type == DISCARD_UNMAP)
+		return transport_generic_unmap(cmd, bd);	
+	else if (type == DISCARD_WRITE_SAME_UNMAP)
+		return iblock_emulate_write_same_unmap(task);	
+	else {
+		printk(KERN_ERR "Unsupported discard_type_t: %d\n", type);
+		return -ENOSYS;
+	}
+
+	return -ENOSYS;
+}
+
 static void iblock_free_task(struct se_task *task)
 {
 	struct iblock_req *req = task->transport_req;
@@ -1078,6 +1087,7 @@ static struct se_subsystem_api iblock_template = {
 	.transport_complete	= iblock_transport_complete,
 	.allocate_request	= iblock_allocate_request,
 	.do_task		= iblock_do_task,
+	.do_discard		= iblock_do_discard,
 	.free_task		= iblock_free_task,
 	.check_configfs_dev_params = iblock_check_configfs_dev_params,
 	.set_configfs_dev_params = iblock_set_configfs_dev_params,
@@ -1104,8 +1114,6 @@ static struct se_subsystem_api iblock_template = {
 };
 
 static struct se_subsystem_api_cdb iblock_cdb_template = {
-	.emulate_unmap		= iblock_emulate_unmap,
-	.emulate_write_same	= iblock_emulate_write_same_unmap,
 	.emulate_sync_cache	= iblock_emulate_sync_cache,
 };
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index c84213f..61f4a1c 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -1433,18 +1433,12 @@ static struct se_subsystem_api rd_mcp_template = {
 	.write_pending		= NULL,
 };
 
-static struct se_subsystem_api_cdb rd_cdb_template = {
-	.emulate_unmap		= NULL,
-};
-
 int __init rd_module_init(void)
 {
 	int ret;
 
 	INIT_LIST_HEAD(&rd_dr_template.sub_api_list);
-	rd_dr_template.sub_cdb = &rd_cdb_template;
 	INIT_LIST_HEAD(&rd_mcp_template.sub_api_list);
-	rd_mcp_template.sub_cdb = &rd_cdb_template;
 
 	ret = transport_subsystem_register(&rd_dr_template, NULL);
 	if (ret < 0)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3fb56d5..469f46f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5606,22 +5606,22 @@ int transport_emulate_control_cdb(struct se_task *task)
 			return ret;
 		break;
 	case UNMAP:
-		if (!(api_cdb->emulate_unmap)) {
+		if (!(TRANSPORT(dev)->do_discard)) {
 			printk(KERN_ERR "UNMAP emulation not supported for: %s\n",
 					TRANSPORT(dev)->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
-		ret = api_cdb->emulate_unmap(task);
+		ret = TRANSPORT(dev)->do_discard(task, DISCARD_UNMAP);
 		if (ret < 0)
 			return ret;
 		break;
 	case WRITE_SAME_16:
-		if (!(api_cdb->emulate_write_same)) {
+		if (!(TRANSPORT(dev)->do_discard)) {
 			printk(KERN_ERR "WRITE_SAME_16 emulation not supported"
 					" for: %s\n", TRANSPORT(dev)->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
-		ret = api_cdb->emulate_write_same(task);
+		ret = TRANSPORT(dev)->do_discard(task, DISCARD_WRITE_SAME_UNMAP);
 		if (ret < 0)
 			return ret;
 		break;
@@ -5629,12 +5629,12 @@ int transport_emulate_control_cdb(struct se_task *task)
 		service_action = get_unaligned_be16(&T_TASK(cmd)->t_task_cdb[8]);
 		switch (service_action) {
 		case WRITE_SAME_32:
-			if (!(api_cdb->emulate_write_same)) {
+			if (!(TRANSPORT(dev)->do_discard)) {
 				printk(KERN_ERR "WRITE_SAME_32 SA emulation not"
 					" supported for: %s\n", TRANSPORT(dev)->name);
 				return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 			}
-			ret = api_cdb->emulate_write_same(task);
+			ret = TRANSPORT(dev)->do_discard(task, DISCARD_WRITE_SAME_UNMAP);
 			if (ret < 0)
 				return ret;
 			break;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 1c62d8c..dd0448b 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -127,6 +127,11 @@
 
 #define MOD_MAX_SECTORS(ms, bs)			(ms % (PAGE_SIZE / bs))
 
+enum blk_discard_type {
+	DISCARD_UNMAP,
+	DISCARD_WRITE_SAME_UNMAP,
+};
+
 struct se_mem;
 struct se_subsystem_api;
 
@@ -318,8 +323,6 @@ struct se_mem {
  * subsystem plugins.for those CDBs that cannot be emulated generically.
  */
 struct se_subsystem_api_cdb {
-	int (*emulate_unmap)(struct se_task *);
-	int (*emulate_write_same)(struct se_task *);
 	void (*emulate_sync_cache)(struct se_task *);
 };
 
@@ -478,6 +481,11 @@ struct se_subsystem_api {
 	 */
 	int (*do_task)(struct se_task *);
 	/*
+	 * Used by virtual subsystem plugins IBLOCK and FILEIO to emulate
+	 * UNMAP and WRITE_SAME_* w/ UNMAP=1 <-> Linux/Block Discard
+	 */
+	int (*do_discard)(struct se_task *, enum blk_discard_type);
+	/*
 	 * free_task():
 	 */
 	void (*free_task)(struct se_task *);
-- 
1.5.6.5
