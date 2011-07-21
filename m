From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 055/103] target: Change name & semantics of transport_get_sectors()
Date: Thu, 21 Jul 2011 00:08:07 -0700
Message-ID: <1311232135-6653-56-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22.access.bullet.mail.sp2.yahoo.com ([98.139.44.149]:24870
	"HELO nm22.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751925Ab1GUHFB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:01 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

It used to set cmd->t_tasks_sectors, remove the need for this member by
making transport_get_sectors into transport_cmd_get_valid_sectors, a
side-effect-free function that returns the number of sectors, or 0 if
invalid. cmd creation will still error out properly with this change.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   32 ++++++++++++--------------------
 include/target/target_core_base.h      |    1 -
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 343dfb0..537d8f5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -213,7 +213,7 @@ static u32 transport_generic_get_cdb_count(struct se_cmd *cmd,
 static int transport_generic_get_mem(struct se_cmd *cmd, u32 length);
 static int transport_generic_remove(struct se_cmd *cmd,
 		int release_to_pool, int session_reinstatement);
-static int transport_get_sectors(struct se_cmd *cmd);
+static int transport_cmd_get_valid_sectors(struct se_cmd *cmd);
 static int transport_map_sg_to_mem(struct se_cmd *cmd,
 		struct list_head *se_mem_list, struct scatterlist *sgl,
 		u32 *se_mem_cnt);
@@ -3398,7 +3398,7 @@ static int transport_generic_cmd_sequencer(
 		 * Check to ensure that LBA + Range does not exceed past end of
 		 * device.
 		 */
-		if (transport_get_sectors(cmd) < 0)
+		if (!transport_cmd_get_valid_sectors(cmd))
 			goto out_invalid_cdb_field;
 		break;
 	case UNMAP:
@@ -3979,30 +3979,26 @@ static inline long long transport_dev_end_lba(struct se_device *dev)
 	return dev->transport->get_blocks(dev) + 1;
 }
 
-static int transport_get_sectors(struct se_cmd *cmd)
+static int transport_cmd_get_valid_sectors(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-
-	cmd->t_tasks_sectors =
-		(cmd->data_length / dev->se_sub_dev->se_dev_attrib.block_size);
-	if (!(cmd->t_tasks_sectors))
-		cmd->t_tasks_sectors = 1;
+	u32 sectors;
 
 	if (dev->transport->get_device_type(dev) != TYPE_DISK)
 		return 0;
 
-	if ((cmd->t_task_lba + cmd->t_tasks_sectors) >
+	sectors = (cmd->data_length / dev->se_sub_dev->se_dev_attrib.block_size);
+
+	if ((cmd->t_task_lba + sectors) >
 	     transport_dev_end_lba(dev)) {
 		printk(KERN_ERR "LBA: %llu Sectors: %u exceeds"
 			" transport_dev_end_lba(): %llu\n",
-			cmd->t_task_lba, cmd->t_tasks_sectors,
+			cmd->t_task_lba, sectors,
 			transport_dev_end_lba(dev));
-		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-		cmd->scsi_sense_reason = TCM_SECTOR_COUNT_TOO_MANY;
-		return PYX_TRANSPORT_REQ_TOO_MANY_SECTORS;
+		return 0;
 	}
 
-	return 0;
+	return sectors;
 }
 
 static int transport_new_cmd_obj(struct se_cmd *cmd)
@@ -4026,7 +4022,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 		    (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
 			rc = transport_generic_get_cdb_count(cmd,
 				cmd->t_task_lba,
-				cmd->t_tasks_sectors,
+				transport_cmd_get_valid_sectors(cmd),
 				DMA_FROM_DEVICE, &cmd->t_mem_bidi_list,
 				set_counts);
 			if (!(rc)) {
@@ -4043,7 +4039,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 		 */
 		task_cdbs = transport_generic_get_cdb_count(cmd,
 				cmd->t_task_lba,
-				cmd->t_tasks_sectors,
+				transport_cmd_get_valid_sectors(cmd),
 				cmd->data_direction, &cmd->t_mem_list,
 				set_counts);
 		if (!(task_cdbs)) {
@@ -4777,10 +4773,6 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 			return ret;
 	}
 
-	ret = transport_get_sectors(cmd);
-	if (ret < 0)
-		return ret;
-
 	ret = transport_new_cmd_obj(cmd);
 	if (ret < 0)
 		return ret;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 58e5c17..3bac5e0 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -493,7 +493,6 @@ struct se_cmd {
 	u32			t_task_cdbs;
 	u32			t_tasks_check;
 	u32			t_tasks_no;
-	u32			t_tasks_sectors;
 	u32			t_tasks_se_num;
 	u32			t_tasks_se_bidi_num;
 	u32			t_tasks_sg_chained_no;
-- 
1.7.6

