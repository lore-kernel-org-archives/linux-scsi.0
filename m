From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 057/103] target: Rename se_cmd.t_task_cdbs to t_task_list_num
Date: Thu, 21 Jul 2011 00:08:09 -0700
Message-ID: <1311232135-6653-58-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm2.access.bullet.mail.sp2.yahoo.com ([98.139.44.129]:34697
	"HELO nm2.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751925Ab1GUHFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:15 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Since it tracks the number of entries in the t_task_list, give it
a more related name.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       |    2 +-
 drivers/target/target_core_transport.c |    6 +++---
 include/target/target_core_base.h      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 4235e72..6667e39 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -260,7 +260,7 @@ int core_tmr_lun_reset(
 			" t_task_cdbs_sent: %d -- t_transport_active: %d"
 			" t_transport_stop: %d t_transport_sent: %d\n",
 			cmd->se_tfo->get_task_tag(cmd), cmd->pr_res_key,
-			cmd->t_task_cdbs,
+			cmd->t_task_list_num,
 			atomic_read(&cmd->t_task_cdbs_left),
 			atomic_read(&cmd->t_task_cdbs_sent),
 			atomic_read(&cmd->t_transport_active),
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index afb453c..39e4b29 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2515,7 +2515,7 @@ check_depth:
 	atomic_inc(&cmd->t_task_cdbs_sent);
 
 	if (atomic_read(&cmd->t_task_cdbs_sent) ==
-	    cmd->t_task_cdbs)
+	    cmd->t_task_list_num)
 		atomic_set(&cmd->transport_sent, 1);
 
 	transport_start_task_timer(task);
@@ -4008,7 +4008,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 
 	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)) {
 		task_cdbs = 1;
-		cmd->t_task_cdbs = 1;
+		cmd->t_task_list_num = 1;
 	} else {
 		int set_counts = 1;
 
@@ -4047,7 +4047,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 					TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			return PYX_TRANSPORT_LU_COMM_FAILURE;
 		}
-		cmd->t_task_cdbs = task_cdbs;
+		cmd->t_task_list_num = task_cdbs;
 
 #if 0
 		printk(KERN_INFO "data_length: %u, LBA: %llu t_tasks_sectors:"
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d2b1067..71c96ce 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -490,7 +490,6 @@ struct se_cmd {
 	int			t_tasks_failed;
 	int			t_tasks_fua;
 	bool			t_tasks_bidi;
-	u32			t_task_cdbs;
 	u32			t_tasks_se_num;
 	u32			t_tasks_se_bidi_num;
 	u32			t_tasks_sg_chained_no;
@@ -529,6 +528,7 @@ struct se_cmd {
 	/* Used for BIDI READ */
 	struct list_head	t_mem_bidi_list;
 	struct list_head	t_task_list;
+	u32			t_task_list_num;
 
 } ____cacheline_aligned;
 
-- 
1.7.6

