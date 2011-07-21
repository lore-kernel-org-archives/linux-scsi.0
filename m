From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 050/103] target: Use assignment rather than increment for t_task_cdbs
Date: Thu, 21 Jul 2011 00:08:02 -0700
Message-ID: <1311232135-6653-51-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19.access.bullet.mail.sp2.yahoo.com ([98.139.44.146]:26119
	"HELO nm19.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751814Ab1GUHEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:36 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Increment makes it seem like t_task_cdbs could've had a nonzero value
before, that we want to preserve. This does not seem to ever be the case,
since there is no looping in transport_new_cmd_obj.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index df9a9a2..da6bd74 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4009,11 +4009,12 @@ static int transport_get_sectors(struct se_cmd *cmd)
 static int transport_new_cmd_obj(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	u32 task_cdbs = 0, rc;
+	u32 task_cdbs;
+	u32 rc;
 
 	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)) {
-		task_cdbs++;
-		cmd->t_task.t_task_cdbs++;
+		task_cdbs = 1;
+		cmd->t_task.t_task_cdbs = 1;
 	} else {
 		int set_counts = 1;
 
@@ -4052,7 +4053,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 					TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			return PYX_TRANSPORT_LU_COMM_FAILURE;
 		}
-		cmd->t_task.t_task_cdbs += task_cdbs;
+		cmd->t_task.t_task_cdbs = task_cdbs;
 
 #if 0
 		printk(KERN_INFO "data_length: %u, LBA: %llu t_tasks_sectors:"
-- 
1.7.6

