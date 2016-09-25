From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH 2/3] megaraid_sas: clean function declarations in megaraid_sas_fusion.c up
Date: Sun, 25 Sep 2016 13:53:13 +0800
Message-ID: <1474782793-12031-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35655 "EHLO
        mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbcIYFxa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2016 01:53:30 -0400
Received: by mail-pa0-f53.google.com with SMTP id oz2so52393296pac.2
        for <linux-scsi@vger.kernel.org>; Sat, 24 Sep 2016 22:53:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn

We get 10 warnings when building kernel with W=1:
drivers/scsi/megaraid/megaraid_sas_base.c:226:21: warning: no previous prototype for 'megasas_get_cmd' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:252:1: warning: no previous declaration for 'megasas_return_cmd' [-Wmissing-declarations]
drivers/scsi/megaraid/megaraid_sas_base.c:998:1: warning: no previous prototype for 'megasas_issue_polled' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:1936:6: warning: no previous prototype for 'megaraid_sas_kill_hba' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:1965:1: warning: no previous prototype for 'megasas_check_and_restore_queue_depth' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:2043:6: warning: no previous prototype for 'megasas_start_timer' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:2366:5: warning: no previous prototype for 'megasas_sriov_start_heartbeat' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:2436:6: warning: no previous prototype for 'megasas_sriov_heartbeat_handler' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:3878:6: warning: no previous prototype for 'megasas_free_cmds' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:3915:5: warning: no previous prototype for 'megasas_alloc_cmds' [-Wmissing-prototypes]

In fact, these functions are declared in
drivers/scsi/megaraid/megaraid_sas_fusion.c, but should be
declared in a header file. thus can be recognized in other file.

So this patch moves the declarations into
drivers/scsi/megaraid/megaraid_sas.h.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        | 19 +++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 15 ---------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ca86c88..d1a6ea5 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2380,4 +2380,23 @@ void megasas_update_sdev_properties(struct scsi_device *sdev);
 int megasas_reset_fusion(struct Scsi_Host *shost, int reason);
 int megasas_task_abort_fusion(struct scsi_cmnd *scmd);
 int megasas_reset_target_fusion(struct scsi_cmnd *scmd);
+struct megasas_cmd *megasas_get_cmd(struct megasas_instance *instance);
+void
+megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
+int
+megasas_issue_polled(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+void
+megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
+void megasas_start_timer(struct megasas_instance *instance,
+			 struct timer_list *timer,
+			 void *fn, unsigned long interval);
+int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
+				  int initial);
+void megasas_sriov_heartbeat_handler(unsigned long instance_addr);
+
+void megasas_free_cmds(struct megasas_instance *instance);
+int megasas_alloc_cmds(struct megasas_instance *instance);
+
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e7b77e1..6210922 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -59,9 +59,6 @@
 #include "megaraid_sas.h"
 
 
-extern void megasas_free_cmds(struct megasas_instance *instance);
-extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-					   *instance);
 extern void
 megasas_complete_cmd(struct megasas_instance *instance,
 		     struct megasas_cmd *cmd, u8 alt_status);
@@ -69,24 +66,12 @@ int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	      int seconds);
 
-void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
-int megasas_alloc_cmds(struct megasas_instance *instance);
 int
 megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
-int
-megasas_issue_polled(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd);
-void
-megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
 
 int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
-void megaraid_sas_kill_hba(struct megasas_instance *instance);
 
 extern u32 megasas_dbg_lvl;
-void megasas_sriov_heartbeat_handler(unsigned long instance_addr);
-int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
-				  int initial);
 void megasas_start_timer(struct megasas_instance *instance,
 			struct timer_list *timer,
 			 void *fn, unsigned long interval);
-- 
2.7.4

