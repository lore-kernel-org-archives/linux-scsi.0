From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 3/9] qla4xxx: fix call trace on rmmod with ql4xdontresethba=1
Date: Tue, 6 Dec 2011 02:34:10 -0800
Message-ID: <1323167650-21334-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:26423
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753502Ab1LFKsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2011 05:48:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, Sarang Radke <sarang.radke@qlogic.com>

From: Sarang Radke <sarang.radke@qlogic.com>

abort all active commands from eh_host_reset in-case
of ql4xdontresethba=1

Fix following call trace:-
Nov 21 14:50:47 172.17.140.111 qla4xxx 0000:13:00.4: qla4_8xxx_disable_msix: qla4xxx (rsp_q)
Nov 21 14:50:47 172.17.140.111 qla4xxx 0000:13:00.4: PCI INT A disabled
Nov 21 14:50:47 172.17.140.111 slab error in kmem_cache_destroy(): cache `qla4xxx_srbs': Can't free all objects
Nov 21 14:50:47 172.17.140.111 Pid: 9154, comm: rmmod Tainted: G           O 3.2.0-rc2+ #2
Nov 21 14:50:47 172.17.140.111 Call Trace:
Nov 21 14:50:47 172.17.140.111  [<c051231a>] ? kmem_cache_destroy+0x9a/0xb0
Nov 21 14:50:47 172.17.140.111  [<c0489c4a>] ? sys_delete_module+0x14a/0x210
Nov 21 14:50:47 172.17.140.111  [<c04fd552>] ? do_munmap+0x202/0x280
Nov 21 14:50:47 172.17.140.111  [<c04a6d4e>] ? audit_syscall_entry+0x1ae/0x1d0
Nov 21 14:50:47 172.17.140.111  [<c083019f>] ? sysenter_do_call+0x12/0x28
Nov 21 14:51:50 172.17.140.111 SLAB: cache with size 64 has lost its name
Nov 21 14:51:50 172.17.140.111 iscsi: registered transport (qla4xxx)
Nov 21 14:51:50 172.17.140.111 qla4xxx 0000:13:00.4: PCI INT A -> GSI 28 (level, low) -> IRQ 28

JIRA Key: UPSISCSI-197

Signed-off-by: Sarang Radke <sarang.radke@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4169c8b..dde539c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2806,6 +2806,7 @@ dpc_post_reset_ha:
  **/
 static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 {
+	qla4xxx_abort_active_cmds(ha, DID_NO_CONNECT << 16);
 
 	if (test_bit(AF_INTERRUPTS_ON, &ha->flags)) {
 		/* Turn-off interrupts on the card. */
@@ -4816,6 +4817,20 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 }
 
 /**
+ * qla4xxx_is_eh_active - check if error handler is running
+ * @shost: Pointer to SCSI Host struct
+ *
+ * This routine finds that if reset host is called in EH
+ * scenario or from some application like sg_reset
+ **/
+static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
+{
+	if (shost->shost_state == SHOST_RECOVERY)
+		return 1;
+	return 0;
+}
+
+/**
  * qla4xxx_eh_host_reset - kernel callback
  * @cmd: Pointer to Linux's SCSI command structure
  *
@@ -4832,6 +4847,11 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	if (ql4xdontresethba) {
 		DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n",
 		     ha->host_no, __func__));
+
+		/* Clear outstanding srb in queues */
+		if (qla4xxx_is_eh_active(cmd->device->host))
+			qla4xxx_abort_active_cmds(ha, DID_ABORT << 16);
+
 		return FAILED;
 	}
 
-- 
1.7.8.rc2.3.g0911


