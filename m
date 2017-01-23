From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/2] qla2xxx: Avoid that issuing a LIP triggers a kernel crash
Date: Mon, 23 Jan 2017 08:34:46 -0800
Message-ID: <20170123163446.9227-3-bart.vanassche@sandisk.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170123163446.9227-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Naresh Bannoth <nbannoth@in.ibm.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, stable@vger.kernel.org
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

Fixes: 1535aa75a3d8 ("qla2xxx: fix invalid DMA access after command aborts in PCI device remove")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Naresh Bannoth <nbannoth@in.ibm.com>
Cc: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0a000ecf0881..ae9c5a7b239a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1600,6 +1600,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
+	struct scsi_cmnd *scmd;
 
 	qlt_host_reset_handler(ha);
 
@@ -1613,6 +1614,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 			sp = req->outstanding_cmds[cnt];
 			if (sp) {
+				scmd = GET_CMD_SP(sp);
+
 				/* Don't abort commands in adapter during EEH
 				 * recovery as it's not accessible/responding.
 				 */
@@ -1624,7 +1627,8 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 					 */
 					sp_get(sp);
 					spin_unlock_irqrestore(&ha->hardware_lock, flags);
-					qla2xxx_eh_abort(GET_CMD_SP(sp));
+					if (scmd)
+						qla2xxx_eh_abort(scmd);
 					spin_lock_irqsave(&ha->hardware_lock, flags);
 				}
 				req->outstanding_cmds[cnt] = NULL;
-- 
2.11.0
