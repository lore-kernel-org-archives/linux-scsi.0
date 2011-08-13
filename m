From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix task count > 1 handling breakage and use max_sector page alignment
Date: Sat, 13 Aug 2011 09:18:27 +0000
Message-ID: <1313227107-11175-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56303 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1HMJnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2011 05:43:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Kiran Patil <kiran.patil@intel.com>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses recent breakage with multiple se_task (task_count > 1)
operation following backend dev->se_sub_dev->se_dev_attrib.max_sectors in new
transport_allocate_data_tasks() code.  The initial bug here was a bogus
task->task_sg_nents assignment in transport_allocate_data_tasks() based on
the passed parameter, which now uses DIV_ROUND_UP(task_size, PAGE_SIZE) to
determine the proper number of per task SGL entries for the (task_count > 1)
case.

This also means we now need to enforce a PAGE_SIZE aligned max_sector count
value for this to work as expected without bringing back the pre v3.1
transport_map_mem_to_sg() logic to handle SGL offsets across multiple tasks.
So this patch adds se_dev_align_max_sectors() to round down max_sectors as
necessary to ensure this alignment via se_dev_set_default_attribs() and
se_dev_align_max_sectors() and keeps it simple for (task_count > 1)
operation.

So far this bugfix has been tested with (task_count > 1) operation
using iscsi-target and iblock backends.

Reported-by: Chris Boot <bootc@bootc.net>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |   28 ++++++++++++++++++++++++++++
 drivers/target/target_core_transport.c |    7 +++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 87537c6..75c77de 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -841,6 +841,24 @@ int se_dev_check_shutdown(struct se_device *dev)
 	return ret;
 }
 
+u32 se_dev_align_max_sectors(u32 max_sectors, u32 block_size)
+{
+	u32 tmp, aligned_max_sectors;
+	/*
+	 * Limit max_sectors to a PAGE_SIZE aligned value for modern
+	 * transport_allocate_data_tasks() operation.
+	 */
+	tmp = rounddown((max_sectors * block_size), PAGE_SIZE);	
+	aligned_max_sectors = (tmp / block_size);
+	if (max_sectors != aligned_max_sectors) {
+		printk(KERN_INFO "Rounding down aligned max_sectors from %u"
+				" to %u\n", max_sectors, aligned_max_sectors);
+		return aligned_max_sectors;
+	}
+
+	return max_sectors;
+}
+
 void se_dev_set_default_attribs(
 	struct se_device *dev,
 	struct se_dev_limits *dev_limits)
@@ -880,6 +898,11 @@ void se_dev_set_default_attribs(
 	 * max_sectors is based on subsystem plugin dependent requirements.
 	 */
 	dev->se_sub_dev->se_dev_attrib.hw_max_sectors = limits->max_hw_sectors;
+	/*
+	 * Align max_sectors down to PAGE_SIZE to follow transport_allocate_data_tasks()
+	 */
+	limits->max_sectors = se_dev_align_max_sectors(limits->max_sectors,
+						limits->logical_block_size);
 	dev->se_sub_dev->se_dev_attrib.max_sectors = limits->max_sectors;
 	/*
 	 * Set optimal_sectors from max_sectors, which can be lowered via
@@ -1244,6 +1267,11 @@ int se_dev_set_max_sectors(struct se_device *dev, u32 max_sectors)
 			return -EINVAL;
 		}
 	}
+	/*
+	 * Align max_sectors down to PAGE_SIZE to follow transport_allocate_data_tasks()
+	 */
+	max_sectors = se_dev_align_max_sectors(max_sectors,
+				dev->se_sub_dev->se_dev_attrib.block_size);
 
 	dev->se_sub_dev->se_dev_attrib.max_sectors = max_sectors;
 	pr_debug("dev[%p]: SE Device max_sectors changed to %u\n",
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b12b541..7eae6d0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4128,7 +4128,11 @@ static int transport_allocate_data_tasks(
 
 		/* Update new cdb with updated lba/sectors */
 		cmd->transport_split_cdb(task->task_lba, task->task_sectors, cdb);
-
+		/*
+		 * This now assumes that passed sg_ents are in PAGE_SIZE chunks
+		 * in order to calculate the number per task SGL entries
+		 */
+		task->task_sg_nents = DIV_ROUND_UP(task->task_size, PAGE_SIZE);
 		/*
 		 * Check if the fabric module driver is requesting that all
 		 * struct se_task->task_sg[] be chained together..  If so,
@@ -4138,7 +4142,6 @@ static int transport_allocate_data_tasks(
 		 * It's so much easier and only a waste when task_count > 1.
 		 * That is extremely rare.
 		 */
-		task->task_sg_nents = sgl_nents;
 		if (cmd->se_tfo->task_sg_chaining) {
 			task->task_sg_nents++;
 			task->task_padded_sg = 1;
-- 
1.7.2.5

