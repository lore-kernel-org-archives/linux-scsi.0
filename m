From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 10/14] target: Convert TMR REQ/RSP definitions to target namespace
Date: Fri, 25 Feb 2011 11:50:02 -0800
Message-ID: <1298663406-5118-11-git-send-email-nab@linux-iscsi.org>
References: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8.bullet.mail.sp2.yahoo.com ([98.139.91.78]:21842 "HELO
	nm8.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932644Ab1BYTum (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:50:42 -0500
In-Reply-To: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes include/target/target_core_tmr.h code to use
target specific 'TMR_*' prefixed definitions for fabric independent
SCSI Task Management Request/Request naming in include/scsi/scsi.h
definitions for mainline target code.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   19 ++++-------
 include/target/target_core_tmr.h       |   52 +++++++++++++------------------
 2 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b177a87..3ca1556 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5833,31 +5833,26 @@ int transport_generic_do_tmr(struct se_cmd *cmd)
 	int ret;
 
 	switch (tmr->function) {
-	case ABORT_TASK:
+	case TMR_ABORT_TASK:
 		ref_cmd = tmr->ref_cmd;
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
-	case ABORT_TASK_SET:
-	case CLEAR_ACA:
-	case CLEAR_TASK_SET:
+	case TMR_ABORT_TASK_SET:
+	case TMR_CLEAR_ACA:
+	case TMR_CLEAR_TASK_SET:
 		tmr->response = TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
 		break;
-	case LUN_RESET:
+	case TMR_LUN_RESET:
 		ret = core_tmr_lun_reset(dev, tmr, NULL, NULL);
 		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
 					 TMR_FUNCTION_REJECTED;
 		break;
-#if 0
-	case TARGET_WARM_RESET:
-		transport_generic_host_reset(dev->se_hba);
+	case TMR_TARGET_WARM_RESET:
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
-	case TARGET_COLD_RESET:
-		transport_generic_host_reset(dev->se_hba);
-		transport_generic_cold_reset(dev->se_hba);
+	case TMR_TARGET_COLD_RESET:
 		tmr->response = TMR_FUNCTION_REJECTED;
 		break;
-#endif
 	default:
 		printk(KERN_ERR "Uknown TMR function: 0x%02x.\n",
 				tmr->function);
diff --git a/include/target/target_core_tmr.h b/include/target/target_core_tmr.h
index 6c8248b..bd55968 100644
--- a/include/target/target_core_tmr.h
+++ b/include/target/target_core_tmr.h
@@ -1,37 +1,29 @@
 #ifndef TARGET_CORE_TMR_H
 #define TARGET_CORE_TMR_H
 
-/* task management function values */
-#ifdef ABORT_TASK
-#undef ABORT_TASK
-#endif /* ABORT_TASK */
-#define ABORT_TASK				1
-#ifdef ABORT_TASK_SET
-#undef ABORT_TASK_SET
-#endif /* ABORT_TASK_SET */
-#define ABORT_TASK_SET				2
-#ifdef CLEAR_ACA
-#undef CLEAR_ACA
-#endif /* CLEAR_ACA */
-#define CLEAR_ACA				3
-#ifdef CLEAR_TASK_SET
-#undef CLEAR_TASK_SET
-#endif /* CLEAR_TASK_SET */
-#define CLEAR_TASK_SET				4
-#define LUN_RESET				5
-#define TARGET_WARM_RESET			6
-#define TARGET_COLD_RESET			7
-#define TASK_REASSIGN				8
+/* fabric independent task management function values */
+enum tcm_tmreq_table {
+	TMR_ABORT_TASK		= 1,
+	TMR_ABORT_TASK_SET	= 2,
+	TMR_CLEAR_ACA		= 3,
+	TMR_CLEAR_TASK_SET	= 4,
+	TMR_LUN_RESET		= 5,
+	TMR_TARGET_WARM_RESET	= 6,
+	TMR_TARGET_COLD_RESET	= 7,
+	TMR_FABRIC_TMR		= 255,
+};
 
-/* task management response values */
-#define TMR_FUNCTION_COMPLETE			0
-#define TMR_TASK_DOES_NOT_EXIST			1
-#define TMR_LUN_DOES_NOT_EXIST			2
-#define TMR_TASK_STILL_ALLEGIANT		3
-#define TMR_TASK_FAILOVER_NOT_SUPPORTED		4
-#define TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED	5
-#define TMR_FUNCTION_AUTHORIZATION_FAILED	6
-#define TMR_FUNCTION_REJECTED			255
+/* fabric independent task management response values */
+enum tcm_tmrsp_table {
+	TMR_FUNCTION_COMPLETE		= 0,
+	TMR_TASK_DOES_NOT_EXIST		= 1,
+	TMR_LUN_DOES_NOT_EXIST		= 2,
+	TMR_TASK_STILL_ALLEGIANT	= 3,
+	TMR_TASK_FAILOVER_NOT_SUPPORTED	= 4,
+	TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED	= 5,
+	TMR_FUNCTION_AUTHORIZATION_FAILED = 6,
+	TMR_FUNCTION_REJECTED		= 255,
+};
 
 extern struct kmem_cache *se_tmr_req_cache;
 
-- 
1.7.4.1

