From: Rob Evers <revers@redhat.com>
Subject: [PATCH 2/2] Change dif type 2 commands to use embedded 32 byte cdb
Date: Wed, 21 Nov 2012 15:07:48 -0500
Message-ID: <1353528468-5664-3-git-send-email-revers@redhat.com>
References: <1353528468-5664-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab2KUUIX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 15:08:23 -0500
In-Reply-To: <1353528468-5664-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: chad.dupuis@qlogic.com, giridhar.malavali@qlogic.com, scameron@beardog.cce.hp.com, mike.miller@hp.com, dan.j.williams@intel.com, fushun@marvell.com

The original implementation of type 2 dif in sd.c used
a mempool to allocate scsi cdbs that were 32 bytes in
length.

With the previous change in this set, 32 byte cdbs are
available in the request structure, removing the need
for the mempool.

Also fixed up a comment regarding MAX_COMMAND_SIZE

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/sd.c        | 45 +--------------------------------------------
 drivers/scsi/sd.h        |  5 -----
 include/scsi/scsi_cmnd.h | 11 +----------
 3 files changed, 2 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..f72ae4a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -122,9 +122,6 @@ static DEFINE_IDA(sd_index_ida);
  * object after last put) */
 static DEFINE_MUTEX(sd_ref_mutex);
 
-static struct kmem_cache *sd_cdb_cache;
-static mempool_t *sd_cdb_pool;
-
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
@@ -852,14 +849,8 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		protect = 0;
 
 	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
-		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
-
-		if (unlikely(SCpnt->cmnd == NULL)) {
-			ret = BLKPREP_DEFER;
-			goto out;
-		}
 
-		SCpnt->cmd_len = SD_EXT_CDB_SIZE;
+		SCpnt->cmd_len = MAX_COMMAND_SIZE;
 		memset(SCpnt->cmnd, 0, SCpnt->cmd_len);
 		SCpnt->cmnd[0] = VARIABLE_LENGTH_CMD;
 		SCpnt->cmnd[7] = 0x18;
@@ -1547,21 +1538,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
-	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
-
-		/* We have to print a failed command here as the
-		 * extended CDB gets freed before scsi_io_completion()
-		 * is called.
-		 */
-		if (result)
-			scsi_print_command(SCpnt);
-
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
-
 	return good_bytes;
 }
 
@@ -2964,24 +2940,8 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out_class;
 
-	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
-					 0, 0, NULL);
-	if (!sd_cdb_cache) {
-		printk(KERN_ERR "sd: can't init extended cdb cache\n");
-		goto err_out_class;
-	}
-
-	sd_cdb_pool = mempool_create_slab_pool(SD_MEMPOOL_SIZE, sd_cdb_cache);
-	if (!sd_cdb_pool) {
-		printk(KERN_ERR "sd: can't init extended cdb pool\n");
-		goto err_out_cache;
-	}
-
 	return 0;
 
-err_out_cache:
-	kmem_cache_destroy(sd_cdb_cache);
-
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -3001,9 +2961,6 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
-	mempool_destroy(sd_cdb_pool);
-	kmem_cache_destroy(sd_cdb_cache);
-
 	scsi_unregister_driver(&sd_template.gendrv);
 	class_unregister(&sd_disk_class);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 47c52a6..eec4154 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -34,11 +34,6 @@
 #define SD_LAST_BUGGY_SECTORS	8
 
 enum {
-	SD_EXT_CDB_SIZE = 32,	/* Extended CDB size */
-	SD_MEMPOOL_SIZE = 2,	/* CDB pool size */
-};
-
-enum {
 	SD_LBP_FULL = 0,	/* Full logical block provisioning */
 	SD_LBP_UNMAP,		/* Use UNMAP command */
 	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 9890d29..8f55189 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -13,16 +13,7 @@ struct scsi_device;
 struct scsi_driver;
 
 /*
- * MAX_COMMAND_SIZE is:
- * The longest fixed-length SCSI CDB as per the SCSI standard.
- * fixed-length means: commands that their size can be determined
- * by their opcode and the CDB does not carry a length specifier, (unlike
- * the VARIABLE_LENGTH_CMD(0x7f) command). This is actually not exactly
- * true and the SCSI standard also defines extended commands and
- * vendor specific commands that can be bigger than 16 bytes. The kernel
- * will support these using the same infrastructure used for VARLEN CDB's.
- * So in effect MAX_COMMAND_SIZE means the maximum size command scsi-ml
- * supports without specifying a cmd_len by ULD's
+ * MAX_COMMAND_SIZE is the max size in bytes, a cdb can be.
  */
 #define MAX_COMMAND_SIZE 32
 #if (MAX_COMMAND_SIZE > BLK_MAX_CDB)
-- 
1.7.11.7

