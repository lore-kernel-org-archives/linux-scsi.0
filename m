From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/9] qla4xxx: fix call trace on rmmod with ql4xdontresethba=1
Date: Thu, 1 Dec 2011 22:42:08 -0800
Message-ID: <1322808134-21665-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:7787 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1LBGzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 01:55:52 -0500
In-Reply-To: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
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
 drivers/scsi/qla4xxx/ql4_os.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4169c8b..d9a6aa5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4816,6 +4816,20 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 }
 
 /**
+ * qla4xxx_is_eh_active:
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
@@ -4832,6 +4846,11 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
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


