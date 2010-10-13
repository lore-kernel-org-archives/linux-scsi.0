From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/5] tcm: Unify SYNCHRONIZE_CACHE_* subsystem plugin handling
Date: Wed, 13 Oct 2010 01:48:29 -0700
Message-ID: <1286959709-3510-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the following struct se_subsystem_api function pointer
op for SYNCHRONIZE_CACHE and SYNCHRONIZE_CACHE_16 handling an explict
WriteCacheEnabled (WCE=1) flush:

       /*
        * Used  by virtual subsystem plugins IBLOCK and FILEIO to emulate
        * SYNCHRONIZE_CACHE_* <-> Linux/Block blkdev_issue_flush()
        */
       void (*do_sync_cache)(struct se_task *);

and updates IBLOCK and FILEIO to execute -> Linux/Block blkdev_issue_flush()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c      |    6 +-----
 drivers/target/target_core_iblock.c    |    6 +-----
 drivers/target/target_core_transport.c |    5 ++---
 include/target/target_core_transport.h |   18 +++++-------------
 4 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index adac070..3a68932 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -1173,6 +1173,7 @@ static struct se_subsystem_api fileio_template = {
 	.allocate_request	= fd_allocate_request,
 	.do_task		= fd_do_task,
 	.do_discard		= fd_do_discard,
+	.do_sync_cache		= fd_emulate_sync_cache,
 	.free_task		= fd_free_task,
 	.check_configfs_dev_params = fd_check_configfs_dev_params,
 	.set_configfs_dev_params = fd_set_configfs_dev_params,
@@ -1197,16 +1198,11 @@ static struct se_subsystem_api fileio_template = {
 	.write_pending		= NULL,
 };
 
-static struct se_subsystem_api_cdb fileio_cdb_template = {
-	.emulate_sync_cache	= fd_emulate_sync_cache,
-};
-
 int __init fileio_module_init(void)
 {
 	int ret;
 
 	INIT_LIST_HEAD(&fileio_template.sub_api_list);
-	fileio_template.sub_cdb = &fileio_cdb_template;
 
 	ret = transport_subsystem_register(&fileio_template, THIS_MODULE);
 	if (ret < 0)
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e1d945f..5e810ea 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -1088,6 +1088,7 @@ static struct se_subsystem_api iblock_template = {
 	.allocate_request	= iblock_allocate_request,
 	.do_task		= iblock_do_task,
 	.do_discard		= iblock_do_discard,
+	.do_sync_cache		= iblock_emulate_sync_cache,
 	.free_task		= iblock_free_task,
 	.check_configfs_dev_params = iblock_check_configfs_dev_params,
 	.set_configfs_dev_params = iblock_set_configfs_dev_params,
@@ -1113,16 +1114,11 @@ static struct se_subsystem_api iblock_template = {
 	.write_pending		= NULL,
 };
 
-static struct se_subsystem_api_cdb iblock_cdb_template = {
-	.emulate_sync_cache	= iblock_emulate_sync_cache,
-};
-
 int __init iblock_module_init(void)
 {
 	int ret;
 
 	INIT_LIST_HEAD(&iblock_template.sub_api_list);
-	iblock_template.sub_cdb = &iblock_cdb_template;
 
 	ret = transport_subsystem_register(&iblock_template, THIS_MODULE);
 	if (ret < 0)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 469f46f..4a30fb9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5547,7 +5547,6 @@ int transport_emulate_control_cdb(struct se_task *task)
 {
 	struct se_cmd *cmd = TASK_CMD(task);
 	struct se_device *dev = SE_DEV(cmd);
-	struct se_subsystem_api_cdb *api_cdb = TRANSPORT(dev)->sub_cdb;
 	sector_t blocks_long;
 	unsigned int blocks;
 	int ret;
@@ -5646,12 +5645,12 @@ int transport_emulate_control_cdb(struct se_task *task)
 		break;
 	case SYNCHRONIZE_CACHE:
 	case 0x91: /* SYNCHRONIZE_CACHE_16: */
-		if (!(api_cdb->emulate_sync_cache)) {
+		if (!(TRANSPORT(dev)->do_sync_cache)) {
 			printk(KERN_ERR "SYNCHRONIZE_CACHE emulation not supported"
 					" for: %s\n", TRANSPORT(dev)->name);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
-		api_cdb->emulate_sync_cache(task);
+		TRANSPORT(dev)->do_sync_cache(task);
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index dd0448b..b8182e3 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -319,14 +319,6 @@ struct se_mem {
 } ____cacheline_aligned;
 
 /*
- * Used as a minimal template for per CDB specific emulation into TCM
- * subsystem plugins.for those CDBs that cannot be emulated generically.
- */
-struct se_subsystem_api_cdb {
-	void (*emulate_sync_cache)(struct se_task *);
-};
-
-/*
  * 	Each type of disk transport supported MUST have a template defined
  *	within its .h file.
  */
@@ -352,11 +344,6 @@ struct se_subsystem_api {
 	 */
 	struct module *sub_owner;
 	/*
-	 * Set of function pointers use for per CDB context emulation
-	 * by virtual IBLOCK, FILEIO, and RAMDISK subsystem plugins.
-	 */
-	struct se_subsystem_api_cdb *sub_cdb;
-	/*
 	 * Counter for struct se_hba reference
 	 */
 	atomic_t sub_api_hba_cnt;
@@ -486,6 +473,11 @@ struct se_subsystem_api {
 	 */
 	int (*do_discard)(struct se_task *, enum blk_discard_type);
 	/*
+	 * Used  by virtual subsystem plugins IBLOCK and FILEIO to emulate
+	 * SYNCHRONIZE_CACHE_* <-> Linux/Block blkdev_issue_flush()
+	 */
+	void (*do_sync_cache)(struct se_task *);
+	/*
 	 * free_task():
 	 */
 	void (*free_task)(struct se_task *);
-- 
1.5.6.5
