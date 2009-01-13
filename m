From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] [LIO-Target]: Remove legacy special cases for
	REPORT_LUNS support
Date: Tue, 13 Jan 2009 13:16:06 -0800
Message-ID: <1231881366.1274.45.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:33281 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753516AbZAMVQc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 16:16:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Thanks,

--nab

>From 1971743706e8ec835c135863119de47c97c81439 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 13 Jan 2009 13:08:04 -0800
Subject: [PATCH 2/2] [LIO-Target]: Remove legacy special cases for REPORT_LUNS support

Now that target_core_mod/ConfigFS v3.0 supports generic REPORT_LUNS functionality,
this patch removes the handful of special cases in LIO-Target that checked cdb[0]
for REPORT_LUNS and did special handing and are no longer required.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c        |    8 ------
 drivers/lio-core/iscsi_target_device.c |    8 +-----
 drivers/lio-core/iscsi_target_erl1.c   |   39 ++++++++-----------------------
 3 files changed, 11 insertions(+), 44 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 8f572af..fc9b6c9 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -102,8 +102,6 @@ struct kmem_cache *lio_dr_cache = NULL;
 struct kmem_cache *lio_ooo_cache = NULL;
 struct kmem_cache *lio_r2t_cache = NULL;
 
-extern int se_allocate_rl_cmd (se_cmd_t *, unsigned char *, u64);
-extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
 static void iscsi_rx_thread_wait_for_TCP (iscsi_conn_t *);
 
 static int iscsi_target_detect (void);
@@ -1665,12 +1663,6 @@ done:
 		goto attach_cmd;
 	}
 	/*
-	 * REPORT_LUNS never actually goes to the transport layer
-	 */
-	if (ret == 1)
-		goto build_list;
-
-	/*
 	 * The Initiator Node has access to the LUN (the addressing method
 	 * is handled inside of iscsi_get_lun_for_cmd()).  Now it's time to
 	 * allocate 1->N transport tasks (depending on sector count and
diff --git a/drivers/lio-core/iscsi_target_device.c b/drivers/lio-core/iscsi_target_device.c
index f646fd7..1b4b256 100644
--- a/drivers/lio-core/iscsi_target_device.c
+++ b/drivers/lio-core/iscsi_target_device.c
@@ -110,7 +110,6 @@ extern se_lun_t *iscsi_get_lun (
 /*	iscsi_get_lun_for_cmd():
  *	
  *	Returns (0) on success
- * 	Returns (1) on REPORT_LUN cdb
  * 	Returns (< 0) on failure
  */
 extern int iscsi_get_lun_for_cmd (
@@ -131,12 +130,7 @@ extern int iscsi_get_lun_for_cmd (
 		return(-1);
 	}
 
-	if ((ret = transport_get_lun_for_cmd(SE_CMD(cmd), cdb, unpacked_lun)) < 0)
-		return(ret);
-	if (ret > 0) /* For cdb[0] == REPORT_LUNS */
-		return(ret);
-
-	return(0);
+	return(transport_get_lun_for_cmd(SE_CMD(cmd), cdb, unpacked_lun));
 }
 
 /*	iscsi_determine_maxcmdsn():
diff --git a/drivers/lio-core/iscsi_target_erl1.c b/drivers/lio-core/iscsi_target_erl1.c
index 6a30e64..9cb0f31 100644
--- a/drivers/lio-core/iscsi_target_erl1.c
+++ b/drivers/lio-core/iscsi_target_erl1.c
@@ -64,7 +64,6 @@ extern struct kmem_cache *lio_ooo_cache;
 
 extern int iscsi_add_reject_from_cmd (u8, int, int, unsigned char *, iscsi_cmd_t *);
 extern int iscsi_build_r2ts_for_cmd (iscsi_cmd_t *, iscsi_conn_t *, int);
-extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
 extern int iscsi_logout_closesession (iscsi_cmd_t *, iscsi_conn_t *);
 extern int iscsi_logout_closeconnection (iscsi_cmd_t *, iscsi_conn_t *);
 extern int iscsi_logout_removeconnforrecovery (iscsi_cmd_t *, iscsi_conn_t *);
@@ -1044,38 +1043,20 @@ extern int iscsi_execute_cmd (iscsi_cmd_t *cmd, int ooo)
 			}
 			return(0);
 		}
-
 		/*
-		 * Special case for REPORT_LUNs.
+		 * The default handler.
 		 */
-#warning FIXME: ICF_REPORT_LUNS in iscsi_execute_cmd() is broken!!!
-#if 0
-		if (cmd->cmd_flags & ICF_REPORT_LUNS) {
-			spin_unlock_bh(&cmd->istate_lock);
-			if (iscsi_build_report_luns_response(cmd) < 0)
-				return(-1);
-	
-			return(0);
-		} else {
-#endif
-		{
-			/*
-			 * The default handler.
-			 */
-			spin_unlock_bh(&cmd->istate_lock);
+		spin_unlock_bh(&cmd->istate_lock);
 
-			if ((cmd->data_direction == ISCSI_WRITE) &&
-			    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-				iscsi_set_dataout_sequence_values(cmd);
-				spin_lock_bh(&cmd->dataout_timeout_lock);
-				iscsi_start_dataout_timer(cmd, CONN(cmd));
-				spin_unlock_bh(&cmd->dataout_timeout_lock);
-			}
-			
-			transport_generic_handle_cdb(cmd->se_cmd);
-			return(0);
+		if ((cmd->data_direction == ISCSI_WRITE) &&
+		    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
+			iscsi_set_dataout_sequence_values(cmd);
+			spin_lock_bh(&cmd->dataout_timeout_lock);
+			iscsi_start_dataout_timer(cmd, CONN(cmd));
+			spin_unlock_bh(&cmd->dataout_timeout_lock);
 		}
-		break;
+		return(transport_generic_handle_cdb(cmd->se_cmd));
+
 	case ISCSI_INIT_NOP_OUT:
 	case ISCSI_INIT_TEXT_CMND:
 		spin_unlock_bh(&cmd->istate_lock);
-- 
1.5.4.1



