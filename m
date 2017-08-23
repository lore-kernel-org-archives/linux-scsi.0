From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 30/31] qla2xxx: Do not call abort handler function during chip reset
Date: Wed, 23 Aug 2017 15:05:24 -0700
Message-ID: <20170823220525.3115-31-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0064.outbound.protection.outlook.com ([104.47.40.64]:14752
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751005AbdHWWko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:40:44 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

If there are IO's running and host reset or chip reset is triggered,
IO's can fail due to rport time out. During chip reset recovery process,
driver notifies the transport layer that remote port no longer exist,
by calling fc_remote_port_delete(). When this function is called,
it actually delays deletion by "blocking" it. It sets the remote
port state to "FC_PORTSTATE_BLOCKED" and sets FC_RPORT_DEVLOSS_PENDING.
When driver tries to abort the command by calling its abort handler
function, abort handler will wait until remote port state is blocked
state or wait for dev_loss_tmo time. Due to this bocking, rport times
out and results in an IO failure. This patch adds a check for any
active reset process before calling abort handler function.

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 715427f8e732..56bd086b79ea 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1732,6 +1732,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 						    &ha->hardware_lock, flags);
 					} else if (GET_CMD_SP(sp) &&
 					    !ha->flags.eeh_busy &&
+					    (!test_bit(ABORT_ISP_ACTIVE,
+						&vha->dpc_flags)) &&
 					    (sp->type == SRB_SCSI_CMD)) {
 						/*
 						 * Don't abort commands in
-- 
2.12.0
