From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH] qla2xxx: do not abort all commands in the adapter during EEH recovery
Date: Mon, 14 Nov 2016 19:26:22 -0200
Message-ID: <1479158782-4544-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu.Madhani@cavium.com, qla2xxx-upstream@qlogic.com
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The previous commit ("qla2xxx: fix invalid DMA access after command
aborts in PCI device remove") introduced a regression during an EEH
recovery, since the change to the qla2x00_abort_all_cmds() function
calls qla2xxx_eh_abort(), which verifies the EEH recovery condition
but handles it heavy-handed. (commit a465537ad1a4 "qla2xxx: Disable
the adapter and skip error recovery in case of register disconnect.")

This problem warrants a more general/optimistic solution right into
qla2xxx_eh_abort()  (eg in case a real command abort arrives during
EEH recovery, or if it takes long enough to trigger command aborts);
but it's still worth to add a check to ensure the code added by the
previous commit is correct and contained within its owner function.

This commit just adds a 'if (!ha->flags.eeh_busy)' check around it.
(ahem; a trivial fix for this -rc series; sorry for this oversight.)

With it applied, both PCI device remove and EEH recovery works fine.

Fixes: 1535aa75a3d8 ("scsi: qla2xxx: fix invalid DMA access after
command aborts in PCI device remove")
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 567fa080e261..56d6142852a5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1456,15 +1456,20 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
-				/* Get a reference to the sp and drop the lock.
-				 * The reference ensures this sp->done() call
-				 * - and not the call in qla2xxx_eh_abort() -
-				 * ends the SCSI command (with result 'res').
+				/* Don't abort commands in adapter during EEH
+				 * recovery as it's not accessible/responding.
 				 */
-				sp_get(sp);
-				spin_unlock_irqrestore(&ha->hardware_lock, flags);
-				qla2xxx_eh_abort(GET_CMD_SP(sp));
-				spin_lock_irqsave(&ha->hardware_lock, flags);
+				if (!ha->flags.eeh_busy) {
+					/* Get a reference to the sp and drop the lock.
+					 * The reference ensures this sp->done() call
+					 * - and not the call in qla2xxx_eh_abort() -
+					 * ends the SCSI command (with result 'res').
+					 */
+					sp_get(sp);
+					spin_unlock_irqrestore(&ha->hardware_lock, flags);
+					qla2xxx_eh_abort(GET_CMD_SP(sp));
+					spin_lock_irqsave(&ha->hardware_lock, flags);
+				}
 				req->outstanding_cmds[cnt] = NULL;
 				sp->done(vha, sp, res);
 			}
-- 
1.8.3.1
