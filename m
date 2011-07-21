From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 047/103] target: Simplify sector limiting code
Date: Thu, 21 Jul 2011 00:07:59 -0700
Message-ID: <1311232135-6653-48-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm20.access.bullet.mail.sp2.yahoo.com ([98.139.44.147]:29665
	"HELO nm20.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752030Ab1GUHIT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:19 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

It was possible to simplify the code that checked/limited sectors, since
it boiled down to 1) can't go beyond lun's last lba and 2) limit to
underlying device's max_sectors attribute.

Give each local variable in transport_generic_get_cdb_count its own line.

BUG_ON(!mem_list), it should never be null now.

Replace max_sectors_set check with a test if limit_task_sectors returned 0.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   98 +++++++++----------------------
 1 files changed, 29 insertions(+), 69 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 887314f..d5df995 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4249,59 +4249,19 @@ next:
 	return task->task_sg_num;
 }
 
-static inline int transport_set_tasks_sectors_disk(
-	struct se_task *task,
+/* Reduce sectors if they are too long for the device */
+static inline sector_t transport_limit_task_sectors(
 	struct se_device *dev,
 	unsigned long long lba,
-	u32 sectors,
-	int *max_sectors_set)
+	sector_t sectors)
 {
-	if ((lba + sectors) > transport_dev_end_lba(dev)) {
-		task->task_sectors = ((transport_dev_end_lba(dev) - lba) + 1);
-
-		if (task->task_sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
-			task->task_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
-			*max_sectors_set = 1;
-		}
-	} else {
-		if (sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
-			task->task_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
-			*max_sectors_set = 1;
-		} else
-			task->task_sectors = sectors;
-	}
-
-	return 0;
-}
+	sectors = min_t(sector_t, sectors, dev->se_sub_dev->se_dev_attrib.max_sectors);
 
-static inline int transport_set_tasks_sectors_non_disk(
-	struct se_task *task,
-	struct se_device *dev,
-	unsigned long long lba,
-	u32 sectors,
-	int *max_sectors_set)
-{
-	if (sectors > dev->se_sub_dev->se_dev_attrib.max_sectors) {
-		task->task_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
-		*max_sectors_set = 1;
-	} else
-		task->task_sectors = sectors;
-
-	return 0;
-}
+	if (dev->transport->get_device_type(dev) == TYPE_DISK)
+		if ((lba + sectors) > transport_dev_end_lba(dev))
+			sectors = ((transport_dev_end_lba(dev) - lba) + 1);
 
-static inline int transport_set_tasks_sectors(
-	struct se_task *task,
-	struct se_device *dev,
-	unsigned long long lba,
-	u32 sectors,
-	int *max_sectors_set)
-{
-	return (dev->transport->get_device_type(dev) == TYPE_DISK) ?
-		transport_set_tasks_sectors_disk(task, dev, lba, sectors,
-				max_sectors_set) :
-		transport_set_tasks_sectors_non_disk(task, dev, lba, sectors,
-				max_sectors_set);
+	return sectors;
 }
 
 /*
@@ -4625,6 +4585,9 @@ static int transport_do_se_mem_map(
 				task_offset_in);
 }
 
+/*
+ * Break up cmd into chunks transport can handle
+ */
 static u32 transport_generic_get_cdb_count(
 	struct se_cmd *cmd,
 	unsigned long long lba,
@@ -4635,17 +4598,18 @@ static u32 transport_generic_get_cdb_count(
 {
 	unsigned char *cdb = NULL;
 	struct se_task *task;
-	struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
-	struct se_mem *se_mem_bidi = NULL, *se_mem_bidi_lout = NULL;
+	struct se_mem *se_mem = NULL;
+	struct se_mem *se_mem_lout = NULL;
+	struct se_mem *se_mem_bidi = NULL;
+	struct se_mem *se_mem_bidi_lout = NULL;
 	struct se_device *dev = cmd->se_dev;
-	int max_sectors_set = 0, ret;
-	u32 task_offset_in = 0, se_mem_cnt = 0, se_mem_bidi_cnt = 0, task_cdbs = 0;
+	int ret;
+	u32 task_offset_in = 0;
+	u32 se_mem_cnt = 0;
+	u32 se_mem_bidi_cnt = 0;
+	u32 task_cdbs = 0;
 
-	if (!mem_list) {
-		printk(KERN_ERR "mem_list is NULL in transport_generic_get"
-				"_cdb_count()\n");
-		return 0;
-	}
+	BUG_ON(!mem_list);
 	/*
 	 * While using RAMDISK_DR backstores is the only case where
 	 * mem_list will ever be empty at this point.
@@ -4662,18 +4626,22 @@ static u32 transport_generic_get_cdb_count(
 					struct se_mem, se_list);
 
 	while (sectors) {
+		sector_t limited_sectors;
+
 		DEBUG_VOL("ITT[0x%08x] LBA(%llu) SectorsLeft(%u) EOBJ(%llu)\n",
 			cmd->se_tfo->get_task_tag(cmd), lba, sectors,
 			transport_dev_end_lba(dev));
 
+		limited_sectors = transport_limit_task_sectors(dev, lba, sectors);
+		if (!limited_sectors)
+			break;
+
 		task = transport_generic_get_task(cmd, data_direction);
-		if (!(task))
+		if (!task)
 			goto out;
 
-		transport_set_tasks_sectors(task, dev, lba, sectors,
-				&max_sectors_set);
-
 		task->task_lba = lba;
+		task->task_sectors = limited_sectors;
 		lba += task->task_sectors;
 		sectors -= task->task_sectors;
 		task->task_size = (task->task_sectors *
@@ -4722,14 +4690,6 @@ static u32 transport_generic_get_cdb_count(
 
 		DEBUG_VOL("Incremented task_cdbs(%u) task->task_sg_num(%u)\n",
 				task_cdbs, task->task_sg_num);
-
-		if (max_sectors_set) {
-			max_sectors_set = 0;
-			continue;
-		}
-
-		if (!sectors)
-			break;
 	}
 
 	if (set_counts) {
-- 
1.7.6

