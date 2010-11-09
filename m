From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Drop ->max_cdb_len from struct se_dev_limits
Date: Mon,  8 Nov 2010 20:34:14 -0800
Message-ID: <1289277254-17097-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm2.bullet.mail.ne1.yahoo.com ([98.138.90.65]:29926 "HELO
	nm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753136Ab0KIEeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 23:34:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops the backend subsystem plugin provided ->max_cdb_len value
in favor of a single check in transport_generic_allocate_tasks() against
the Linux/SCSI defined SCSI_MAX_VARLEN_CDB_SIZE of (252 + 8) bytes for all
received CDBs.

It also follows the recommendation by Boaz to drop the SCF_ECDB_ALLOCATION
flag and use (T_TASK(se_cmd)->t_task_cdb != T_TASK(se_cmd)->__t_task_cdb)
conditionals to signal that a T_TASK(cmd)->t_task_cdb allocation exists.

Many thanks to Boaz for his comments!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    4 ----
 drivers/target/target_core_device.c    |    4 ----
 drivers/target/target_core_file.c      |    1 -
 drivers/target/target_core_iblock.c    |    1 -
 drivers/target/target_core_pscsi.c     |   16 +++-------------
 drivers/target/target_core_pscsi.h     |    3 ---
 drivers/target/target_core_rd.c        |    1 -
 drivers/target/target_core_transport.c |   32 ++++++++++++++------------------
 include/target/target_core_base.h      |    6 +-----
 9 files changed, 18 insertions(+), 50 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b9b756d..bd2d4af 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -751,9 +751,6 @@ SE_DEV_ATTR(emulate_tpws, S_IRUGO | S_IWUSR);
 DEF_DEV_ATTRIB(enforce_pr_isids);
 SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
 
-DEF_DEV_ATTRIB_RO(max_cdb_len);
-SE_DEV_ATTR_RO(max_cdb_len);
-
 DEF_DEV_ATTRIB_RO(hw_block_size);
 SE_DEV_ATTR_RO(hw_block_size);
 
@@ -802,7 +799,6 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
 	&target_core_dev_attrib_emulate_tpu.attr,
 	&target_core_dev_attrib_emulate_tpws.attr,
 	&target_core_dev_attrib_enforce_pr_isids.attr,
-	&target_core_dev_attrib_max_cdb_len.attr,
 	&target_core_dev_attrib_hw_block_size.attr,
 	&target_core_dev_attrib_block_size.attr,
 	&target_core_dev_attrib_hw_max_sectors.attr,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7b7fd42..de8a8cb 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -924,10 +924,6 @@ void se_dev_set_default_attribs(
 	DEV_ATTRIB(dev)->unmap_granularity_alignment =
 				DA_UNMAP_GRANULARITY_ALIGNMENT_DEFAULT;
 	/*
-	 * max_cdb_len is based on subsystem plugin dependent requirements.
-	 */
-	DEV_ATTRIB(dev)->max_cdb_len = dev_limits->max_cdb_len;
-	/*
 	 * block_size is based on subsystem plugin dependent requirements.
 	 */
 	DEV_ATTRIB(dev)->hw_block_size = limits->logical_block_size;
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 4b20a8d..34ab402 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -231,7 +231,6 @@ static struct se_device *fd_create_virtdevice(
 		fd_dev->fd_block_size = FD_BLOCKSIZE;
 	}
 
-	dev_limits.max_cdb_len = TCM_MAX_COMMAND_SIZE;
 	dev_limits.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 	dev_limits.queue_depth = FD_DEVICE_QUEUE_DEPTH;
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index de67a5b..890db59 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -179,7 +179,6 @@ static struct se_device *iblock_create_virtdevice(
 	limits->logical_block_size = bdev_logical_block_size(bd);	
 	limits->max_hw_sectors = queue_max_hw_sectors(q);
 	limits->max_sectors = queue_max_sectors(q);
-	dev_limits.max_cdb_len = TCM_MAX_COMMAND_SIZE;
 	dev_limits.hw_queue_depth = IBLOCK_MAX_DEVICE_QUEUE_DEPTH;
 	dev_limits.queue_depth = IBLOCK_DEVICE_QUEUE_DEPTH;
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index de412ea..6296a0f 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -251,7 +251,6 @@ static struct se_device *pscsi_add_device_to_list(
 				  queue_max_hw_sectors(q) : sd->host->max_sectors; 
 	limits->max_sectors = (sd->host->max_sectors > queue_max_sectors(q)) ?
 				  queue_max_sectors(q) : sd->host->max_sectors;
-	dev_limits.max_cdb_len = PSCSI_MAX_CDB_SIZE;
 	dev_limits.hw_queue_depth = sd->queue_depth;
 	dev_limits.queue_depth = sd->queue_depth;
 	/*
@@ -711,17 +710,7 @@ static void *pscsi_allocate_request(
 	 * allocate the extended CDB buffer for per struct se_task context
 	 * pt->pscsi_cdb now.
 	 */
-	if (cmd->se_cmd_flags & SCF_ECDB_ALLOCATION) {
-		/*
-		 * PSCSI_MAX_CDB_SIZE is currently set to 240 bytes which
-		 * allows the largest OSD CDB sizes again.
-		 */
-		if (scsi_command_size(cdb) > PSCSI_MAX_CDB_SIZE) {
-			printk(KERN_ERR "pSCSI: Received CDB of size: %u larger"
-				" than PSCSI_MAX_CDB_SIZE: %u\n",
-				scsi_command_size(cdb), PSCSI_MAX_CDB_SIZE);
-			return NULL;
-		}
+	if (T_TASK(cmd)->t_task_cdb != T_TASK(cmd)->__t_task_cdb) {
 
 		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
 		if (!(pt->pscsi_cdb)) {
@@ -827,11 +816,12 @@ static int pscsi_do_task(struct se_task *task)
 static void pscsi_free_task(struct se_task *task)
 {
 	struct pscsi_plugin_task *pt = task->transport_req;
+	struct se_cmd *cmd = task->task_se_cmd;
 	/*
 	 * Release the extended CDB allocation from pscsi_allocate_request()
 	 * if one exists.
 	 */
-	if (task->task_se_cmd->se_cmd_flags & SCF_ECDB_ALLOCATION)
+	if (T_TASK(cmd)->t_task_cdb != T_TASK(cmd)->__t_task_cdb)
 		kfree(pt->pscsi_cdb);
 	/*
 	 * We do not release the bio(s) here associated with this task, as
diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
index 4055967..f40d119 100644
--- a/drivers/target/target_core_pscsi.h
+++ b/drivers/target/target_core_pscsi.h
@@ -9,9 +9,6 @@
 #define INQUIRY_DATA_SIZE	0x24
 #endif
 
-/* Maximum extended CDB size for handling OSD passthrough */
-#define PSCSI_MAX_CDB_SIZE	240
-
 /* used in pscsi_add_device_to_list() */
 #define PSCSI_DEFAULT_QUEUEDEPTH	1
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 7121647..226c8ca 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -286,7 +286,6 @@ static struct se_device *rd_create_virtdevice(
 	dev_limits.limits.logical_block_size = RD_BLOCKSIZE;
 	dev_limits.limits.max_hw_sectors = RD_MAX_SECTORS;
 	dev_limits.limits.max_sectors = RD_MAX_SECTORS;
-	dev_limits.max_cdb_len = TCM_MAX_COMMAND_SIZE;
 	dev_limits.hw_queue_depth = RD_MAX_DEVICE_QUEUE_DEPTH;
 	dev_limits.queue_depth = RD_DEVICE_QUEUE_DEPTH;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 63dbb3e..150c0f8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2777,7 +2777,7 @@ void transport_free_se_cmd(
 	/*
 	 * Check and free any extended CDB buffer that was allocated
 	 */
-	if (se_cmd->se_cmd_flags & SCF_ECDB_ALLOCATION)
+	if (T_TASK(se_cmd)->t_task_cdb != T_TASK(se_cmd)->__t_task_cdb)
 		kfree(T_TASK(se_cmd)->t_task_cdb);
 	/*
 	 * Release any optional TCM fabric dependent iovecs allocated by
@@ -2823,20 +2823,29 @@ int transport_generic_allocate_tasks(
 	if (non_data_cdb < 0)
 		return -1;
 	/*
+	 * Ensure that the received CDB is less than the max (252 + 8) bytes
+	 * for VARIABLE_LENGTH_CMD
+	 */
+	if (scsi_command_size(cdb) > SCSI_MAX_VARLEN_CDB_SIZE) {
+		printk(KERN_ERR "Received SCSI CDB with command_size: %d that"
+			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
+			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
+		return -1;
+	}
+	/*
 	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
 	 * allocate the additional extended CDB buffer now..  Otherwise
 	 * setup the pointer from __t_task_cdb to t_task_cdb.
 	 */
-	if (scsi_command_size(cdb) > TCM_MAX_COMMAND_SIZE) {
+	if (scsi_command_size(cdb) > sizeof(T_TASK(cmd)->__t_task_cdb)) {
 		T_TASK(cmd)->t_task_cdb = kzalloc(scsi_command_size(cdb),
 						GFP_KERNEL);
 		if (!(T_TASK(cmd)->t_task_cdb)) {
 			printk(KERN_ERR "Unable to allocate T_TASK(cmd)->t_task_cdb"
-				" %u > TCM_MAX_COMMAND_SIZE ops\n",
-				scsi_command_size(cdb));
+				" %u > sizeof(T_TASK(cmd)->__t_task_cdb): %u ops\n",
+				scsi_command_size(cdb), sizeof(T_TASK(cmd)->__t_task_cdb));
 			return -1;
 		}
-		cmd->se_cmd_flags |= SCF_ECDB_ALLOCATION;
 	} else
 		T_TASK(cmd)->t_task_cdb = &T_TASK(cmd)->__t_task_cdb[0];
 	/*
@@ -4753,19 +4762,6 @@ static int transport_generic_cmd_sequencer(
 	case VARIABLE_LENGTH_CMD:
 		service_action = get_unaligned_be16(&cdb[8]);
 		/*
-		 * Check the additional CDB length (+ 8 bytes for header) does
-		 * not exceed our backsores ->max_cdb_len
-		 */
-		if (scsi_varlen_cdb_length(&cdb[0]) >
-				DEV_ATTRIB(dev)->max_cdb_len) {
-			printk(KERN_INFO "Only %u-byte extended CDBs currently"
-				" supported for VARIABLE_LENGTH_CMD backstore %s,"
-				" received: %d for service action: 0x%04x\n",
-				DEV_ATTRIB(dev)->max_cdb_len, TRANSPORT(dev)->name,
-				scsi_varlen_cdb_length(&cdb[0]), service_action);
-			return TGCS_INVALID_CDB_FIELD;
-		}
-		/*
 		 * Determine if this is TCM/PSCSI device and we should disable
 		 * internal emulation for this CDB.
 		 */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ead2caf..49af478 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -137,8 +137,7 @@ enum se_cmd_flags_table {
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00800000,
 	SCF_EMULATE_SYNC_CACHE		= 0x01000000,
 	SCF_EMULATE_CDB_ASYNC		= 0x02000000,
-	SCF_EMULATE_SYNC_UNMAP		= 0x04000000,
-	SCF_ECDB_ALLOCATION		= 0x08000000
+	SCF_EMULATE_SYNC_UNMAP		= 0x04000000
 };
 	
 /* struct se_device->type for known subsystem plugins */
@@ -739,8 +738,6 @@ struct se_dev_entry {
 }  ____cacheline_aligned;
 
 struct se_dev_limits {
-	/* Max supported SCSI CDB length */
-	int		max_cdb_len;
 	/* Max supported HW queue depth */
 	u32		hw_queue_depth;
 	/* Max supported virtual queue depth */
@@ -761,7 +758,6 @@ struct se_dev_attrib {
 	int		emulate_reservations;
 	int		emulate_alua;
 	int		enforce_pr_isids;
-	int		max_cdb_len;
 	u32		hw_block_size;
 	u32		block_size;
 	u32		hw_max_sectors;
-- 
1.5.6.5

