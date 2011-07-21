From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 031/103] target: Rename get_lun_for_{cmd,tmr} to lookup_{cmd,tmr}_lun
Date: Thu, 21 Jul 2011 00:07:43 -0700
Message-ID: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8.access.bullet.mail.sp2.yahoo.com ([98.139.44.135]:28119
	"HELO nm8.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752132Ab1GUHJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:09:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

These functions don't get a lun, they lookup an existing lun (from fabric)
and ensure it is valid.

Also, iscsi code was checking lun was less than MAX_LUNS_PER_TPG, which
is already being checked in the transport code already.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c  |    4 ++--
 drivers/target/target_core_device.c |   12 ++++--------
 drivers/target/tcm_fc/tfc_cmd.c     |    4 ++--
 include/target/target_core_device.h |    4 ++--
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index e1d17b9..5d7a40e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -122,7 +122,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	/*
 	 * Locate the struct se_lun pointer and attach it to struct se_cmd
 	 */
-	if (transport_get_lun_for_cmd(se_cmd, tl_cmd->sc->device->lun) < 0) {
+	if (transport_lookup_cmd_lun(se_cmd, tl_cmd->sc->device->lun) < 0) {
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 		set_host_byte(sc, DID_NO_CONNECT);
 		return NULL;
@@ -391,7 +391,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	/*
 	 * Locate the underlying TCM struct se_lun from sc->device->lun
 	 */
-	if (transport_get_lun_for_tmr(se_cmd, sc->device->lun) < 0)
+	if (transport_lookup_tmr_lun(se_cmd, sc->device->lun) < 0)
 		goto release;
 	/*
 	 * Queue the TMR to TCM Core and sleep waiting for tcm_loop_queue_tm_rsp()
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fd92385..8b07ad2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -59,9 +59,7 @@ static struct se_subsystem_dev *lun0_su_dev;
 /* not static, needed by tpg.c */
 struct se_device *g_lun0_dev;
 
-int transport_get_lun_for_cmd(
-	struct se_cmd *se_cmd,
-	u32 unpacked_lun)
+int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
@@ -185,11 +183,9 @@ out:
 
 	return 0;
 }
-EXPORT_SYMBOL(transport_get_lun_for_cmd);
+EXPORT_SYMBOL(transport_lookup_cmd_lun);
 
-int transport_get_lun_for_tmr(
-	struct se_cmd *se_cmd,
-	u32 unpacked_lun)
+int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
 	struct se_device *dev = NULL;
 	struct se_dev_entry *deve;
@@ -240,7 +236,7 @@ int transport_get_lun_for_tmr(
 
 	return 0;
 }
-EXPORT_SYMBOL(transport_get_lun_for_tmr);
+EXPORT_SYMBOL(transport_lookup_tmr_lun);
 
 /*
  * This function is called from core_scsi3_emulate_pro_register_and_move()
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 19b2b99..a913e84 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -438,7 +438,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 	switch (fcp->fc_tm_flags) {
 	case FCP_TMF_LUN_RESET:
 		cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
-		if (transport_get_lun_for_tmr(&cmd->se_cmd, cmd->lun) < 0) {
+		if (transport_lookup_tmr_lun(&cmd->se_cmd, cmd->lun) < 0) {
 			/*
 			 * Make sure to clean up newly allocated TMR request
 			 * since "unable to  handle TMR request because failed
@@ -637,7 +637,7 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 
 	cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
-	ret = transport_get_lun_for_cmd(&cmd->se_cmd, cmd->lun);
+	ret = transport_lookup_cmd_lun(&cmd->se_cmd, cmd->lun);
 	if (ret < 0) {
 		ft_dump_cmd(cmd, __func__);
 		transport_send_check_condition_and_sense(&cmd->se_cmd,
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index d9745bf..96586cc 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -1,8 +1,8 @@
 #ifndef TARGET_CORE_DEVICE_H
 #define TARGET_CORE_DEVICE_H
 
-extern int transport_get_lun_for_cmd(struct se_cmd *, u32);
-extern int transport_get_lun_for_tmr(struct se_cmd *, u32);
+extern int transport_lookup_cmd_lun(struct se_cmd *, u32);
+extern int transport_lookup_tmr_lun(struct se_cmd *, u32);
 extern struct se_dev_entry *core_get_se_deve_from_rtpi(
 					struct se_node_acl *, u16);
 extern int core_free_device_list_for_node(struct se_node_acl *,
-- 
1.7.6

