From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 048/103] target: get_cdb should never return NULL
Date: Thu, 21 Jul 2011 00:08:00 -0700
Message-ID: <1311232135-6653-49-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm25.access.bullet.mail.sp2.yahoo.com ([98.139.44.152]:43343
	"HELO nm25.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750973Ab1GUHE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:29 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

dev->transport->get_cdb(task) should just be returning a pointer to
the cdb space that's already allocated in the task, so it should never
be NULL.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d5df995..c01a81b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4648,12 +4648,15 @@ static u32 transport_generic_get_cdb_count(
 				   dev->se_sub_dev->se_dev_attrib.block_size);
 
 		cdb = dev->transport->get_cdb(task);
-		if ((cdb)) {
-			memcpy(cdb, cmd->t_task.t_task_cdb,
-				scsi_command_size(cmd->t_task.t_task_cdb));
-			cmd->transport_split_cdb(task->task_lba,
-					&task->task_sectors, cdb);
-		}
+		/* Should be part of task, can't fail */
+		BUG_ON(!cdb);
+
+		memcpy(cdb, cmd->t_task.t_task_cdb,
+		       scsi_command_size(cmd->t_task.t_task_cdb));
+
+		/* Update new cdb with updated lba/sectors */
+		cmd->transport_split_cdb(task->task_lba,
+					 &task->task_sectors, cdb);
 
 		/*
 		 * Perform the SE OBJ plugin and/or Transport plugin specific
@@ -4719,9 +4722,9 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
 
 	cdb = dev->transport->get_cdb(task);
-	if (cdb)
-		memcpy(cdb, cmd->t_task.t_task_cdb,
-			scsi_command_size(cmd->t_task.t_task_cdb));
+	BUG_ON(!cdb);
+	memcpy(cdb, cmd->t_task.t_task_cdb,
+	       scsi_command_size(cmd->t_task.t_task_cdb));
 
 	task->task_size = cmd->data_length;
 	task->task_sg_num =
-- 
1.7.6

