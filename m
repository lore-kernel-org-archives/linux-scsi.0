From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Add support for CDBs greater than TCM_MAX_COMMAND_SIZE bytes
Date: Sat,  2 Oct 2010 14:43:52 -0700
Message-ID: <1286055832-15725-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.58]:39328 "HELO
	nm17-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751164Ab0JBVn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2010 17:43:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch allows TCM Core to process CDBs containing a received scsi_command_size()
larger than the hardcoded default of TCM_MAX_COMMAND_SIZE (32-bytes).  This patch
first converts the hardcoded per struct se_cmd -> struct se_transport_task->t_task_cdb[]
to ->__t_task_cdb[TCM_MAX_COMMAND_SIZE], and turns ->t_task_cdb into a pointer used
to reference ->__t_task_cdb or an extended CDB buffer setup in transport_generic_allocate_tasks().

It next adds a new struct se_subsystem_api->get_max_cdb_len() API caller that is
used by TCM subsystem plugins to report their individual CDB size limits.  Next
transport_generic_cmd_sequencer() has been changed to use ->get_max_cdb_len() for
VARIABLE_LENGTH_CMD to determine if the backstore can support the received
> TCM_MAX_COMMAND_SIZE sized CDB, or to fail the I/O with exception status.

The extended CDB buffer is setup in transport_generic_allocate_tasks() when necessary,
and a new SCF_ECDB_ALLOCATION flag is then set.  The release of the extended CDB buffer
happens in transport_free_se_cmd() in the normal struct se_cmd release path.

This patch also updates TCM/pSCSI to handle extended CDBs up to PSCSI_MAX_CDB_SIZE=240
(maximum current OSD CDB size) and sets up the extra struct pscsi_plugin_task->pscsi_cdb
allocation in struct se_task context in order to complete the > TCM_MAX_COMMAND_SIZE=32
request.  The IBLOCK, FILEIO, RAMDISK, and STGT subsystem plugins have been updated to
enforce the TCM_MAX_COMMAND_SIZE=32 limit via struct se_subsystem_api->get_max_cdb_len().

So far this code been tested with 'sgv4_xdwriteread -e' into a TCM_Loop -> TCM/pSCSI
-> scsi_debug backstore with a TCM_MAX_COMMAND_SIZE=16 to force the extended CDB
allocations.  This was done due to the lack of an easy method to test > 32-byte CDBs
w/o an TCM/OSD fabric module.

Many thanks to Boaz Harrosh for his help in this area!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c      |    6 +++++
 drivers/target/target_core_iblock.c    |    6 +++++
 drivers/target/target_core_pscsi.c     |   39 ++++++++++++++++++++++++++++++++
 drivers/target/target_core_pscsi.h     |    6 ++++-
 drivers/target/target_core_rd.c        |    6 +++++
 drivers/target/target_core_stgt.c      |    6 +++++
 drivers/target/target_core_transport.c |   34 +++++++++++++++++++++++----
 include/target/target_core_base.h      |    6 +++-
 include/target/target_core_transport.h |    5 ++++
 9 files changed, 106 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index d0afb50..bf9bfc2 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -1125,6 +1125,11 @@ static unsigned char *fd_get_cdb(struct se_task *task)
 	return req->fd_scsi_cdb;
 }
 
+static u32 fd_get_max_cdb_len(struct se_device *dev)
+{
+	return TCM_MAX_COMMAND_SIZE;
+}
+
 /*	fd_get_blocksize(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1224,6 +1229,7 @@ static struct se_subsystem_api fileio_template = {
 	.check_lba		= fd_check_lba,
 	.check_for_SG		= fd_check_for_SG,
 	.get_cdb		= fd_get_cdb,
+	.get_max_cdb_len	= fd_get_max_cdb_len,
 	.get_blocksize		= fd_get_blocksize,
 	.get_device_rev		= fd_get_device_rev,
 	.get_device_type	= fd_get_device_type,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 2dae7fd..3337357 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -1059,6 +1059,11 @@ static unsigned char *iblock_get_cdb(struct se_task *task)
 	return req->ib_scsi_cdb;
 }
 
+static u32 iblock_get_max_cdb_len(struct se_device *dev)
+{
+	return TCM_MAX_COMMAND_SIZE;
+}
+
 static u32 iblock_get_blocksize(struct se_device *dev)
 {
 	struct iblock_dev *ibd = dev->dev_ptr;
@@ -1167,6 +1172,7 @@ static struct se_subsystem_api iblock_template = {
 	.check_lba		= iblock_check_lba,
 	.check_for_SG		= iblock_check_for_SG,
 	.get_cdb		= iblock_get_cdb,
+	.get_max_cdb_len	= iblock_get_max_cdb_len,
 	.get_blocksize		= iblock_get_blocksize,
 	.get_device_rev		= iblock_get_device_rev,
 	.get_device_type	= iblock_get_device_type,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 8dfedb1..b550725 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -714,13 +714,40 @@ static void *pscsi_allocate_request(
 	struct se_task *task,
 	struct se_device *dev)
 {
+	struct se_cmd *cmd = task->task_se_cmd;
 	struct pscsi_plugin_task *pt;
+	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
 
 	pt = kzalloc(sizeof(struct pscsi_plugin_task), GFP_KERNEL);
 	if (!(pt)) {
 		printk(KERN_ERR "Unable to allocate struct pscsi_plugin_task\n");
 		return NULL;
 	}
+	/*
+	 * If TCM Core is signaling a > TCM_MAX_COMMAND_SIZE allocation,
+	 * allocate the extended CDB buffer for per struct se_task context
+	 * pt->pscsi_cdb now.
+	 */
+	if (cmd->se_cmd_flags & SCF_ECDB_ALLOCATION) {
+		/*
+		 * PSCSI_MAX_CDB_SIZE is currently set to 240 bytes which
+		 * allows the largest OSD CDB sizes again.
+		 */
+		if (scsi_command_size(cdb) > PSCSI_MAX_CDB_SIZE) {
+			printk(KERN_ERR "pSCSI: Received CDB of size: %u larger"
+				" than PSCSI_MAX_CDB_SIZE: %u\n",
+				scsi_command_size(cdb), PSCSI_MAX_CDB_SIZE);
+			return NULL;
+		}
+
+		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
+		if (!(pt->pscsi_cdb)) {
+			printk(KERN_ERR "pSCSI: Unable to allocate extended"
+					" pt->pscsi_cdb\n");
+			return NULL;
+		}
+	} else
+		pt->pscsi_cdb = &pt->__pscsi_cdb[0];
 
 	return pt;
 }
@@ -818,6 +845,12 @@ static void pscsi_free_task(struct se_task *task)
 {
 	struct pscsi_plugin_task *pt = task->transport_req;
 	/*
+	 * Release the extended CDB allocation from pscsi_allocate_request()
+	 * if one exists.
+	 */
+	if (task->task_se_cmd->se_cmd_flags & SCF_ECDB_ALLOCATION)
+		kfree(pt->pscsi_cdb);
+	/*
 	 * We do not release the bio(s) here associated with this task, as
 	 * this is handled by bio_put() and pscsi_bi_endio().
 	 */
@@ -1366,6 +1399,11 @@ static unsigned char *pscsi_get_cdb(struct se_task *task)
 	return pt->pscsi_cdb;
 }
 
+static u32 pscsi_get_max_cdb_len(struct se_device *dev)
+{
+	return PSCSI_MAX_CDB_SIZE;
+}
+
 /*	pscsi_get_sense_buffer():
  *
  *
@@ -1533,6 +1571,7 @@ static struct se_subsystem_api pscsi_template = {
 	.check_lba		= pscsi_check_lba,
 	.check_for_SG		= pscsi_check_for_SG,
 	.get_cdb		= pscsi_get_cdb,
+	.get_max_cdb_len	= pscsi_get_max_cdb_len,
 	.get_sense_buffer	= pscsi_get_sense_buffer,
 	.get_blocksize		= pscsi_get_blocksize,
 	.get_device_rev		= pscsi_get_device_rev,
diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
index d3c8972..e7f07e3 100644
--- a/drivers/target/target_core_pscsi.h
+++ b/drivers/target/target_core_pscsi.h
@@ -9,6 +9,9 @@
 #define INQUIRY_DATA_SIZE	0x24
 #endif
 
+/* Maximum extended CDB size for handling OSD passthrough */
+#define PSCSI_MAX_CDB_SIZE	240
+
 /* used in pscsi_add_device_to_list() */
 #define PSCSI_DEFAULT_QUEUEDEPTH	1
 
@@ -28,7 +31,8 @@ extern int linux_blockdevice_check(int, int);
 #include <linux/kobject.h>
 
 struct pscsi_plugin_task {
-	unsigned char pscsi_cdb[TCM_MAX_COMMAND_SIZE];
+	unsigned char *pscsi_cdb;
+	unsigned char __pscsi_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
 	int	pscsi_direction;
 	int	pscsi_result;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 1debdd3..0a54c57 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -1392,6 +1392,11 @@ static unsigned char *rd_get_cdb(struct se_task *task)
 	return req->rd_scsi_cdb;
 }
 
+static u32 rd_get_max_cdb_len(struct se_device *dev)
+{
+	return TCM_MAX_COMMAND_SIZE;
+}
+
 /*	rd_get_blocksize(): (Part of se_subsystem_api_t template)
  *
  *
@@ -1475,6 +1480,7 @@ static struct se_subsystem_api rd_dr_template = {
 	.check_lba		= rd_DIRECT_check_lba,
 	.check_for_SG		= rd_check_for_SG,
 	.get_cdb		= rd_get_cdb,
+	.get_max_cdb_len	= rd_get_max_cdb_len,
 	.get_blocksize		= rd_get_blocksize,
 	.get_device_rev		= rd_get_device_rev,
 	.get_device_type	= rd_get_device_type,
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index fdcd7eb..ecd4601 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -751,6 +751,11 @@ static unsigned char *stgt_get_cdb(struct se_task *task)
 	return pt->stgt_cdb;
 }
 
+static u32 stgt_get_max_cdb_len(struct se_device *dev)
+{
+	return TCM_MAX_COMMAND_SIZE;
+}
+
 /*	stgt_get_sense_buffer():
  *
  *
@@ -931,6 +936,7 @@ static struct se_subsystem_api stgt_template = {
 	.check_lba		= stgt_check_lba,
 	.check_for_SG		= stgt_check_for_SG,
 	.get_cdb		= stgt_get_cdb,
+	.get_max_cdb_len	= stgt_get_max_cdb_len,
 	.get_sense_buffer	= stgt_get_sense_buffer,
 	.get_blocksize		= stgt_get_blocksize,
 	.get_device_rev		= stgt_get_device_rev,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 830c5bb..866b0fa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2860,6 +2860,11 @@ void transport_free_se_cmd(
 	if (se_cmd->se_tmr_req)
 		core_tmr_release_req(se_cmd->se_tmr_req);
 	/*
+	 * Check and free any extended CDB buffer that was allocated
+	 */
+	if (se_cmd->se_cmd_flags & SCF_ECDB_ALLOCATION)
+		kfree(T_TASK(se_cmd)->t_task_cdb);
+	/*
 	 * Release any optional TCM fabric dependent iovecs allocated by
 	 * transport_allocate_iovecs_for_cmd()
 	 */
@@ -2903,6 +2908,23 @@ int transport_generic_allocate_tasks(
 	if (non_data_cdb < 0)
 		return -1;
 	/*
+	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
+	 * allocate the additional extended CDB buffer now..  Otherwise
+	 * setup the pointer from __t_task_cdb to t_task_cdb.
+	 */
+	if (scsi_command_size(cdb) > TCM_MAX_COMMAND_SIZE) {
+		T_TASK(cmd)->t_task_cdb = kzalloc(scsi_command_size(cdb),
+						GFP_KERNEL);
+		if (!(T_TASK(cmd)->t_task_cdb)) {
+			printk(KERN_ERR "Unable to allocate T_TASK(cmd)->t_task_cdb"
+				" %u > TCM_MAX_COMMAND_SIZE ops\n",
+				scsi_command_size(cdb));
+			return -1;
+		}
+		cmd->se_cmd_flags |= SCF_ECDB_ALLOCATION;
+	} else
+		T_TASK(cmd)->t_task_cdb = &T_TASK(cmd)->__t_task_cdb[0];
+	/*
 	 * Copy the original CDB into T_TASK(cmd).
 	 */
 	memcpy(T_TASK(cmd)->t_task_cdb, cdb, scsi_command_size(cdb));
@@ -5746,13 +5768,15 @@ static int transport_generic_cmd_sequencer(
 		service_action = get_unaligned_be16(&cdb[8]);
 		/*
 		 * Check the additional CDB length (+ 8 bytes for header) does
-		 * not exceed our TCM_MAX_COMMAND_SIZE.
+		 * not exceed our backsores ->get_max_cdb_len()
 		 */
-		if (scsi_varlen_cdb_length(&cdb[0]) > TCM_MAX_COMMAND_SIZE) {
+		if (scsi_varlen_cdb_length(&cdb[0]) >
+				TRANSPORT(dev)->get_max_cdb_len(dev)) {
 			printk(KERN_INFO "Only %u-byte extended CDBs currently"
-				" supported for VARIABLE_LENGTH_CMD, received:"
-				" %d for service action: 0x%04x\n",
-				TCM_MAX_COMMAND_SIZE,
+				" supported for VARIABLE_LENGTH_CMD backstore %s,"
+				" received: %d for service action: 0x%04x\n",
+				TRANSPORT(dev)->get_max_cdb_len(dev),
+				TRANSPORT(dev)->name,
 				scsi_varlen_cdb_length(&cdb[0]), service_action);
 			return TGCS_INVALID_CDB_FIELD;
 		}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 3905a0e..fc5300c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -137,7 +137,8 @@ enum se_cmd_flags_table {
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00800000,
 	SCF_EMULATE_SYNC_CACHE		= 0x01000000,
 	SCF_EMULATE_CDB_ASYNC		= 0x02000000,
-	SCF_EMULATE_SYNC_UNMAP		= 0x04000000
+	SCF_EMULATE_SYNC_UNMAP		= 0x04000000,
+	SCF_ECDB_ALLOCATION		= 0x08000000
 };
 	
 /* struct se_device->type for known subsystem plugins */
@@ -424,7 +425,8 @@ struct se_queue_obj {
  * drivers/target/target_core_transport.c:__transport_alloc_se_cmd()
  */
 struct se_transport_task {
-	unsigned char		t_task_cdb[MAX_COMMAND_SIZE];
+	unsigned char		*t_task_cdb;
+	unsigned char		__t_task_cdb[MAX_COMMAND_SIZE];
 	unsigned long long	t_task_lba;
 	int			t_tasks_failed;
 	int			t_tasks_fua;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index ab7336b..d45063e 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -519,6 +519,11 @@ struct se_subsystem_api {
 	 */
 	unsigned char *(*get_cdb)(struct se_task *);
 	/*
+	 * get_max_cdb_len(): Used by subsystems backstoers to signal the
+	 * maximum receivable SCSI CDB size.
+	 */
+	u32 (*get_max_cdb_len)(struct se_device *);
+	/*
 	 * get_blocksize():
 	 */
 	u32 (*get_blocksize)(struct se_device *);
-- 
1.5.6.5

