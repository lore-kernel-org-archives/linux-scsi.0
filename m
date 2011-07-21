From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 052/103] target: Pass sg with type scatterlist in transport_map_sg_to_mem
Date: Thu, 21 Jul 2011 00:08:04 -0700
Message-ID: <1311232135-6653-53-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.160]:29842
	"HELO nm13-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752430Ab1GUHKi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:10:38 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Instead of passing as void * and then casting to sg, we can just
pass it as a struct scatterlist*.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    3 +--
 include/target/target_core_transport.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9bbc626..ccc5319 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4312,7 +4312,7 @@ static int transport_map_sg_to_mem(
 int transport_map_mem_to_sg(
 	struct se_task *task,
 	struct list_head *se_mem_list,
-	void *in_mem,
+	struct scatterlist *sg,
 	struct se_mem *in_se_mem,
 	struct se_mem **out_se_mem,
 	u32 *se_mem_cnt,
@@ -4320,7 +4320,6 @@ int transport_map_mem_to_sg(
 {
 	struct se_cmd *se_cmd = task->task_se_cmd;
 	struct se_mem *se_mem = in_se_mem;
-	struct scatterlist *sg = (struct scatterlist *)in_mem;
 	u32 task_size = task->task_size, sg_no = 0;
 
 	if (!sg) {
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index acd5914..4bbd88b 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -184,7 +184,7 @@ extern void transport_generic_free_cmd(struct se_cmd *, int, int, int);
 extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
 extern int transport_init_task_sg(struct se_task *, struct se_mem *, u32);
 extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
-					void *, struct se_mem *,
+					struct scatterlist *, struct se_mem *,
 					struct se_mem **, u32 *, u32 *);
 extern void transport_do_task_sg_chain(struct se_cmd *);
 extern void transport_generic_process_write(struct se_cmd *);
-- 
1.7.6

