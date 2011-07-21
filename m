From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 004/103] target: Remove unnecessary *cdb transport_get_lun_for_cmd parameter
Date: Thu, 21 Jul 2011 00:04:40 -0700
Message-ID: <1311231979-6631-5-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6.bullet.mail.bf1.yahoo.com ([98.139.212.165]:27158 "HELO
	nm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035Ab1GUHGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:14 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now unnecessary 'unsigned char *cdb' function
parameter from transport_get_lun_for_cmd().  This also includes updating
lio-target, tcm_loop and tcm_fc usage of transport_get_lun_for_cmd().

Reported-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c  |    2 +-
 drivers/target/target_core_device.c |    1 -
 drivers/target/tcm_fc/tfc_cmd.c     |    2 +-
 include/target/target_core_device.h |    2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 70c2e7f..2d0f22a 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -122,7 +122,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	/*
 	 * Locate the struct se_lun pointer and attach it to struct se_cmd
 	 */
-	if (transport_get_lun_for_cmd(se_cmd, NULL, tl_cmd->sc->device->lun) < 0) {
+	if (transport_get_lun_for_cmd(se_cmd, tl_cmd->sc->device->lun) < 0) {
 		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 		set_host_byte(sc, DID_NO_CONNECT);
 		return NULL;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1b5d78f..b0ebe9a 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -56,7 +56,6 @@ static void se_dev_stop(struct se_device *dev);
 
 int transport_get_lun_for_cmd(
 	struct se_cmd *se_cmd,
-	unsigned char *cdb,
 	u32 unpacked_lun)
 {
 	struct se_dev_entry *deve;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index b2a1067..92a449a 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -637,7 +637,7 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 	fc_seq_exch(cmd->seq)->lp->tt.seq_set_resp(cmd->seq, ft_recv_seq, cmd);
 
 	cmd->lun = scsilun_to_int((struct scsi_lun *)fcp->fc_lun);
-	ret = transport_get_lun_for_cmd(&cmd->se_cmd, NULL, cmd->lun);
+	ret = transport_get_lun_for_cmd(&cmd->se_cmd, cmd->lun);
 	if (ret < 0) {
 		ft_dump_cmd(cmd, __func__);
 		transport_send_check_condition_and_sense(&cmd->se_cmd,
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index 52b18a5..d9745bf 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -1,7 +1,7 @@
 #ifndef TARGET_CORE_DEVICE_H
 #define TARGET_CORE_DEVICE_H
 
-extern int transport_get_lun_for_cmd(struct se_cmd *, unsigned char *, u32);
+extern int transport_get_lun_for_cmd(struct se_cmd *, u32);
 extern int transport_get_lun_for_tmr(struct se_cmd *, u32);
 extern struct se_dev_entry *core_get_se_deve_from_rtpi(
 					struct se_node_acl *, u16);
-- 
1.7.6

