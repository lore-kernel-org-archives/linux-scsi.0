From: "Rodrigo R. Galvao" <rosattig@linux.vnet.ibm.com>
Subject: [PATCH] scsi: qla2xxx: Fix crash on qla2x00_mailbox_command
Date: Mon, 28 May 2018 14:58:44 -0300
Message-ID: <1527530324-32359-1-git-send-email-rosattig@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: rosattig@linux.vnet.ibm.com, maurosr@linux.vnet.ibm.com, kernel@gpiccoli.net, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch fixes a crash on qla2x00_mailbox_command caused when the
driver is on UNLOADING state and tries to call qla2x00_poll, which
triggers a NULL pointer dereference.

Signed-off-by: Rodrigo R. Galvao <rosattig@linux.vnet.ibm.com>
Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d8a36c1..7e875f5 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -292,6 +292,14 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			if (time_after(jiffies, wait_time))
 				break;
 
+			/*
+			 * Check if it's UNLOADING, cause we cannot poll in
+			 * this case, or else a NULL pointer dereference
+			 * is triggered.
+			 */
+			if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags)))
+				return QLA_FUNCTION_TIMEOUT;
+
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha->rsp_q_map[0]);
 
-- 
2.7.4
