From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 15/21] target: Fix task SGL chaining breakage with transport_allocate_data_tasks
Date: Wed, 17 Aug 2011 23:17:19 +0000
Message-ID: <1313623045-15916-16-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58340 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab1HQXmk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:40 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Kiran Patil <kiran.patil@intel.com>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes two bugs associated with transport_do_task_sg_chain()
operation where transport_allocate_data_tasks() was incorrectly setting
task_padded_sg for all tasks, and causing bogus task->task_sg_nents
assignments + OOPsen with fabrics depending upon this code.  The first bit
here adds a task_sg_nents_padded check in transport_allocate_data_tasks()
to include an extra SGL vector when necessary for tasks that expect to
be linked using sg_chain().

The second change involves making transport_do_task_sg_chain() properly
account for the extra SGL vector when task->task_padded_sg is set for
the non trailing ->task_sg or single ->task_sg allocations.  Note this
patch also removes the BUG_ON(!task->task_padded_sg) check within
transport_do_task_sg_chain() as we expect this to happen normally
with the updated logic in transport_allocate_data_tasks(), along with
being bogus for CONTROL_SG_IO_CDB type payloads.

So far this bugfix has been tested with tcm_qla2xxx and iblock backends
in (task_count > 1)( and (task_count == 1) operation.

Reported-by: Kiran Patil <kiran.patil@intel.com>
Cc: Kiran Patil <kiran.patil@intel.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   34 +++++++++++++++++++------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index efac6a9..9cc49d1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4044,8 +4044,6 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 		if (!task->task_sg)
 			continue;
 
-		BUG_ON(!task->task_padded_sg);
-
 		if (!sg_first) {
 			sg_first = task->task_sg;
 			chained_nents = task->task_sg_nents;
@@ -4053,9 +4051,19 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 			sg_chain(sg_prev, sg_prev_nents, task->task_sg);
 			chained_nents += task->task_sg_nents;
 		}
+		/*
+		 * For the padded tasks, use the extra SGL vector allocated
+		 * in transport_allocate_data_tasks() for the sg_prev_nents
+		 * offset into sg_chain() above..  The last task of a
+		 * multi-task list, or a single task will not have
+		 * task->task_sg_padded set..
+		 */
+		if (task->task_padded_sg)
+			sg_prev_nents = (task->task_sg_nents + 1);
+		else
+			sg_prev_nents = task->task_sg_nents;
 
 		sg_prev = task->task_sg;
-		sg_prev_nents = task->task_sg_nents;
 	}
 	/*
 	 * Setup the starting pointer and total t_tasks_sg_linked_no including
@@ -4107,7 +4115,7 @@ static int transport_allocate_data_tasks(
 	
 	cmd_sg = sgl;
 	for (i = 0; i < task_count; i++) {
-		unsigned int task_size;
+		unsigned int task_size, task_sg_nents_padded;
 		int count;
 
 		task = transport_generic_get_task(cmd, data_direction);
@@ -4135,24 +4143,24 @@ static int transport_allocate_data_tasks(
 		 * Check if the fabric module driver is requesting that all
 		 * struct se_task->task_sg[] be chained together..  If so,
 		 * then allocate an extra padding SG entry for linking and
-		 * marking the end of the chained SGL.
-		 * Possibly over-allocate task sgl size by using cmd sgl size.
-		 * It's so much easier and only a waste when task_count > 1.
-		 * That is extremely rare.
+		 * marking the end of the chained SGL for every task except
+		 * the last one for (task_count > 1) operation, or skipping
+		 * the extra padding for the (task_count == 1) case.
 		 */
-		if (cmd->se_tfo->task_sg_chaining) {
-			task->task_sg_nents++;
+		if (cmd->se_tfo->task_sg_chaining && (i < (task_count - 1))) {
+			task_sg_nents_padded = (task->task_sg_nents + 1);
 			task->task_padded_sg = 1;
-		}
+		} else
+			task_sg_nents_padded = task->task_sg_nents;
 
 		task->task_sg = kmalloc(sizeof(struct scatterlist) *
-					task->task_sg_nents, GFP_KERNEL);
+					task_sg_nents_padded, GFP_KERNEL);
 		if (!task->task_sg) {
 			cmd->se_dev->transport->free_task(task);
 			return -ENOMEM;
 		}
 
-		sg_init_table(task->task_sg, task->task_sg_nents);
+		sg_init_table(task->task_sg, task_sg_nents_padded);
 
 		task_size = task->task_size;
 
-- 
1.7.6

