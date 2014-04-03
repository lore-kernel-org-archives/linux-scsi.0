From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 7/9] target: Enable WRITE_INSERT emulation in target_execute_cmd
Date: Thu,  3 Apr 2014 09:35:51 +0000
Message-ID: <1396517753-23546-8-git-send-email-nab@daterainc.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53367 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaDCJ7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 05:59:10 -0400
Received: by mail-oa0-f45.google.com with SMTP id eb12so1701043oac.32
        for <linux-scsi@vger.kernel.org>; Thu, 03 Apr 2014 02:59:10 -0700 (PDT)
In-Reply-To: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch enables WRITE_INSERT emulation in target_execute_cmd()
in order to locally generate DIF PI before submitting the WRITE
to the underlying backend device.

This is required for fabric drivers that currently don't support
DIF over-the-wire, in order to inact with backend devices that
have hardware (IBLOCK) or software (FILEIO + RAMDISK) support
for handling T10 PI.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9c820ba..530a9e8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1767,6 +1767,15 @@ void target_execute_cmd(struct se_cmd *cmd)
 	cmd->t_state = TRANSPORT_PROCESSING;
 	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
+	/*
+	 * Perform WRITE_INSERT of PI using software emulation when backend
+	 * device has PI enabled, if the transport has not already generated
+	 * PI using hardware WRITE_INSERT offload.
+	 */
+	if (cmd->prot_op == TARGET_PROT_DOUT_INSERT) {
+		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
+			sbc_dif_write_insert(cmd);
+	}
 
 	if (target_handle_task_attr(cmd)) {
 		spin_lock_irq(&cmd->t_state_lock);
-- 
1.7.10.4

