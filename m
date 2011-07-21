From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 041/103] target: Remove unneeded checks in transport_free_pages()
Date: Thu, 21 Jul 2011 00:07:53 -0700
Message-ID: <1311232135-6653-42-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm11.access.bullet.mail.sp2.yahoo.com ([98.139.44.138]:35993
	"HELO nm11.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751408Ab1GUHDt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:03:49 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

If t_mem_bidi_list is empty, iterating over it without checking
if it's empty, or that t_tasks_se_bidi_num is nonzero, will still
be correct. Also applies to needing to check t_tasks_se_num before
looping.

Zero out t_tasks_se_bidi_num to match handling of t_tasks_se_num.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f2849ad..d0cd601 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3826,9 +3826,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH_NOALLOC)
 		return;
 
-	if (!(cmd->t_task.t_tasks_se_num))
-		return;
-
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
 			&cmd->t_task.t_mem_list, se_list) {
 		/*
@@ -3841,23 +3838,21 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		list_del(&se_mem->se_list);
 		kmem_cache_free(se_mem_cache, se_mem);
 	}
+	cmd->t_task.t_tasks_se_num = 0;
 
-	if (!list_empty(&cmd->t_task.t_mem_bidi_list) && cmd->t_task.t_tasks_se_bidi_num) {
-		list_for_each_entry_safe(se_mem, se_mem_tmp,
-				&cmd->t_task.t_mem_bidi_list, se_list) {
-			/*
-			 * We only release call __free_page(struct se_mem->se_page) when
-			 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
-			 */
-			if (free_page)
-				__free_page(se_mem->se_page);
+	list_for_each_entry_safe(se_mem, se_mem_tmp,
+				 &cmd->t_task.t_mem_bidi_list, se_list) {
+		/*
+		 * We only release call __free_page(struct se_mem->se_page) when
+		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
+		 */
+		if (free_page)
+			__free_page(se_mem->se_page);
 
-			list_del(&se_mem->se_list);
-			kmem_cache_free(se_mem_cache, se_mem);
-		}
+		list_del(&se_mem->se_list);
+		kmem_cache_free(se_mem_cache, se_mem);
 	}
-
-	cmd->t_task.t_tasks_se_num = 0;
+	cmd->t_task.t_tasks_se_bidi_num = 0;
 }
 
 static inline void transport_release_tasks(struct se_cmd *cmd)
-- 
1.7.6

