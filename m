From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 24/37] target: Have core_tmr_alloc_req() take an explicit GFP_xxx flag
Date: Fri, 14 Oct 2011 00:41:56 +0000
Message-ID: <1318552929-13341-25-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33467 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab1JNApG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:45:06 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

Testing in_interrupt() to know when sleeping is allowed is not really
reliable (since eg it won't be true if the caller is holding a spinlock).
Instead have the caller tell core_tmr_alloc_req() what GFP_xxx to use;
every caller except tcm_qla2xxx can use GFP_KERNEL.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |    3 ++-
 drivers/target/loopback/tcm_loop.c       |    2 +-
 drivers/target/target_core_tmr.c         |    6 +++---
 drivers/target/tcm_fc/tfc_cmd.c          |    2 +-
 include/target/target_core_tmr.h         |    2 +-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index f00137f..c4be622 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -289,7 +289,8 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 	}
 
 	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd,
-				(void *)cmd->tmr_req, tcm_function);
+				(void *)cmd->tmr_req, tcm_function,
+				GFP_KERNEL);
 	if (!se_cmd->se_tmr_req)
 		goto out;
 
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index f0e701d..5b870c3 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -366,7 +366,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	 * Allocate the LUN_RESET TMR
 	 */
 	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd, tl_tmr,
-				TMR_LUN_RESET);
+						TMR_LUN_RESET, GFP_KERNEL);
 	if (IS_ERR(se_cmd->se_tmr_req))
 		goto release;
 	/*
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index d04cc10..efc5ec7 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -43,12 +43,12 @@
 struct se_tmr_req *core_tmr_alloc_req(
 	struct se_cmd *se_cmd,
 	void *fabric_tmr_ptr,
-	u8 function)
+	u8 function,
+	gfp_t gfp_flags)
 {
 	struct se_tmr_req *tmr;
 
-	tmr = kmem_cache_zalloc(se_tmr_req_cache, (in_interrupt()) ?
-					GFP_ATOMIC : GFP_KERNEL);
+	tmr = kmem_cache_zalloc(se_tmr_req_cache, gfp_flags);
 	if (!tmr) {
 		pr_err("Unable to allocate struct se_tmr_req\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 7f2ee5a..55a278e 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -396,7 +396,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	}
 
 	pr_debug("alloc tm cmd fn %d\n", tm_func);
-	tmr = core_tmr_alloc_req(&cmd->se_cmd, cmd, tm_func);
+	tmr = core_tmr_alloc_req(&cmd->se_cmd, cmd, tm_func, GFP_KERNEL);
 	if (!tmr) {
 		pr_debug("alloc failed\n");
 		ft_send_resp_code_and_free(cmd, FCP_TMF_FAILED);
diff --git a/include/target/target_core_tmr.h b/include/target/target_core_tmr.h
index bd55968..d5876e1 100644
--- a/include/target/target_core_tmr.h
+++ b/include/target/target_core_tmr.h
@@ -27,7 +27,7 @@ enum tcm_tmrsp_table {
 
 extern struct kmem_cache *se_tmr_req_cache;
 
-extern struct se_tmr_req *core_tmr_alloc_req(struct se_cmd *, void *, u8);
+extern struct se_tmr_req *core_tmr_alloc_req(struct se_cmd *, void *, u8, gfp_t);
 extern void core_tmr_release_req(struct se_tmr_req *);
 extern int core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 				struct list_head *, struct se_cmd *);
-- 
1.5.6.5

