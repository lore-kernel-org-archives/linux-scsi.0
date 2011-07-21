From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 064/103] target: Make transport_generic_new_cmd() available for iscsi-target
Date: Thu, 21 Jul 2011 00:11:47 -0700
Message-ID: <1311232346-6674-65-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:21802 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752030Ab1GUHGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:52 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch makes transport_generic_new_cmd() defined as EXPORT_SYMBOL()
for use with iscsi-target direct task allocation.  It then changes
iscsi-target to use this direct method instead of the legacy
transport_generic_handle_cdb() queue usage.

Signed-off-by: Andy Grover <agrover@redhat.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    4 ++--
 include/target/target_core_transport.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9bb3ac9..fbc5687 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1842,7 +1842,6 @@ int transport_generic_handle_cdb(
 		printk(KERN_ERR "cmd->se_lun is NULL\n");
 		return -EINVAL;
 	}
-
 	transport_add_cmd_to_queue(cmd, TRANSPORT_NEW_CMD);
 	return 0;
 }
@@ -4747,7 +4746,7 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 	/*
 	 * Generate struct se_task(s) and/or their payloads for this CDB.
 	 */
-static int transport_generic_new_cmd(struct se_cmd *cmd)
+int transport_generic_new_cmd(struct se_cmd *cmd)
 {
 	struct se_portal_group *se_tpg;
 	struct se_task *task;
@@ -4817,6 +4816,7 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 	transport_execute_tasks(cmd);
 	return 0;
 }
+EXPORT_SYMBOL(transport_generic_new_cmd);
 
 /*	transport_generic_process_write():
  *
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 4bbd88b..c9846d5 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -188,6 +188,7 @@ extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
 					struct se_mem **, u32 *, u32 *);
 extern void transport_do_task_sg_chain(struct se_cmd *);
 extern void transport_generic_process_write(struct se_cmd *);
+extern int transport_generic_new_cmd(struct se_cmd *);
 extern int transport_generic_do_tmr(struct se_cmd *);
 /* From target_core_alua.c */
 extern int core_alua_check_nonop_delay(struct se_cmd *);
-- 
1.7.6

