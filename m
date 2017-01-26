From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v2] qla2xxx: Avoid that issuing a LIP triggers a kernel crash
Date: Wed, 25 Jan 2017 22:07:06 -0200
Message-ID: <1485389226-18009-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: martin.petersen@oracle.com, bart.vanassche@sandisk.com
Cc: himanshu.madhani@cavium.com, stable@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Avoid that issuing a LIP as follows:

  find /sys -name 'issue_lip'|while read f; do echo 1 > $f; done

triggers the following:

BUG: unable to handle kernel NULL pointer dereference at (null)
Call Trace:
 qla2x00_abort_all_cmds+0xed/0x140 [qla2xxx]
 qla2x00_abort_isp_cleanup+0x1e3/0x280 [qla2xxx]
 qla2x00_abort_isp+0xef/0x690 [qla2xxx]
 qla2x00_do_dpc+0x36c/0x880 [qla2xxx]
 kthread+0x10c/0x140

Note: this patch is a slight change of the original patch
      sent by Bart, submitted by request of mkp.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
Fixes: 1535aa75a3d8 ("qla2xxx: fix invalid DMA access after command aborts in PCI device remove")
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0a000ecf0881..a17cb63b3fd5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1600,6 +1600,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
+	struct scsi_cmnd *scmd;
 
 	qlt_host_reset_handler(ha);
 
@@ -1613,10 +1614,12 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
+				scmd = GET_CMD_SP(sp);
+
 				/* Don't abort commands in adapter during EEH
 				 * recovery as it's not accessible/responding.
 				 */
-				if (!ha->flags.eeh_busy) {
+				if (scmd && !ha->flags.eeh_busy) {
 					/* Get a reference to the sp and drop the lock.
 					 * The reference ensures this sp->done() call
 					 * - and not the call in qla2xxx_eh_abort() -
@@ -1624,7 +1627,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 					 */
 					sp_get(sp);
 					spin_unlock_irqrestore(&ha->hardware_lock, flags);
-					qla2xxx_eh_abort(GET_CMD_SP(sp));
+					qla2xxx_eh_abort(scmd);
 					spin_lock_irqsave(&ha->hardware_lock, flags);
 				}
 				req->outstanding_cmds[cnt] = NULL;
-- 
1.8.3.1
