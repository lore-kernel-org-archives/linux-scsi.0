From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 063/103] target: Rename get_cdb_count to allocate_tasks
Date: Thu, 21 Jul 2011 00:11:46 -0700
Message-ID: <1311232346-6674-64-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.74]:29899 "HELO
	nm26-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752030Ab1GUHGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:46 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

To be more in-line with what it actually does.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c5a541d..9bb3ac9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -206,7 +206,7 @@ static int __transport_execute_tasks(struct se_device *dev);
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_direct_request_timeout(struct se_cmd *cmd);
 static void transport_free_dev_tasks(struct se_cmd *cmd);
-static u32 transport_generic_get_cdb_count(struct se_cmd *cmd,
+static u32 transport_allocate_tasks(struct se_cmd *cmd,
 		unsigned long long starting_lba, u32 sectors,
 		enum dma_data_direction data_direction,
 		struct list_head *mem_list, int set_counts);
@@ -4013,7 +4013,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 		 */
 		if (!list_empty(&cmd->t_mem_bidi_list) &&
 		    (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
-			rc = transport_generic_get_cdb_count(cmd,
+			rc = transport_allocate_tasks(cmd,
 				cmd->t_task_lba,
 				transport_cmd_get_valid_sectors(cmd),
 				DMA_FROM_DEVICE, &cmd->t_mem_bidi_list,
@@ -4030,7 +4030,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 		 * Setup the tasks and memory from cmd->t_mem_list
 		 * Note for BIDI transfers this will contain the WRITE payload
 		 */
-		task_cdbs = transport_generic_get_cdb_count(cmd,
+		task_cdbs = transport_allocate_tasks(cmd,
 				cmd->t_task_lba,
 				transport_cmd_get_valid_sectors(cmd),
 				cmd->data_direction, &cmd->t_mem_list,
@@ -4562,7 +4562,7 @@ static int transport_do_se_mem_map(
 /*
  * Break up cmd into chunks transport can handle
  */
-static u32 transport_generic_get_cdb_count(
+static u32 transport_allocate_tasks(
 	struct se_cmd *cmd,
 	unsigned long long lba,
 	u32 sectors,
-- 
1.7.6

