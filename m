From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH 3/3] megaraid_sas: clean function declarations in megaraid_sas_base.c up
Date: Sun, 25 Sep 2016 13:54:35 +0800
Message-ID: <1474782875-15708-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get 8 warnings when building kernel with W=1:
drivers/scsi/megaraid/megaraid_sas_fusion.c:281:1: warning: no previous prototype for 'megasas_free_cmds_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:714:1: warning: no previous prototype for 'megasas_ioc_init_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:1038:1: warning: no previous prototype for 'megasas_get_map_info' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:1061:1: warning: no previous prototype for 'megasas_sync_map_info' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:2599:1: warning: no previous prototype for 'megasas_release_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:2833:7: warning: no previous prototype for 'megasas_reset_reply_desc' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:3354:5: warning: no previous prototype for 'megasas_check_mpio_paths' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:3664:6: warning: no previous prototype for 'megasas_fusion_ocr_wq' [-Wmissing-prototypes]

In fact, these functions are declared in
drivers/scsi/megaraid/megaraid_sas_base.c, but should be
declared in a header file. thus can be recognized in other file.

So this patch moves the declarations into
drivers/scsi/megaraid/megaraid_sas.h.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 15 ++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas_base.c | 14 --------------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index d1a6ea5..aad81c6 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2398,5 +2398,18 @@ void megasas_sriov_heartbeat_handler(unsigned long instance_addr);
 
 void megasas_free_cmds(struct megasas_instance *instance);
 int megasas_alloc_cmds(struct megasas_instance *instance);
-
+void
+megasas_free_cmds_fusion(struct megasas_instance *instance);
+int
+megasas_ioc_init_fusion(struct megasas_instance *instance);
+u8
+megasas_get_map_info(struct megasas_instance *instance);
+int
+megasas_sync_map_info(struct megasas_instance *instance);
+void
+megasas_release_fusion(struct megasas_instance *instance);
+void megasas_reset_reply_desc(struct megasas_instance *instance);
+int megasas_check_mpio_paths(struct megasas_instance *instance,
+			     struct scsi_cmnd *scmd);
+void megasas_fusion_ocr_wq(struct work_struct *work);
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1b033da..73f4e27 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -189,25 +189,11 @@ u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
 static void megasas_complete_cmd_dpc(unsigned long instance_addr);
-void
-megasas_release_fusion(struct megasas_instance *instance);
-int
-megasas_ioc_init_fusion(struct megasas_instance *instance);
-void
-megasas_free_cmds_fusion(struct megasas_instance *instance);
-u8
-megasas_get_map_info(struct megasas_instance *instance);
-int
-megasas_sync_map_info(struct megasas_instance *instance);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	int seconds);
-void megasas_reset_reply_desc(struct megasas_instance *instance);
-void megasas_fusion_ocr_wq(struct work_struct *work);
 static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 					 int initial);
-int megasas_check_mpio_paths(struct megasas_instance *instance,
-			     struct scsi_cmnd *scmd);
 
 static int
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
-- 
2.7.4
