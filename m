From: madhu.iyengar@qlogic.com
Subject: [PATCH 07/12] qla2xxx: Remove scsi_cmnd->serial_number from debug traces
Date: Fri, 15 Oct 2010 11:27:44 -0700
Message-ID: <1287167269-8034-8-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36968 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756532Ab0JOSga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:30 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

This patch cleans up any printk or debug tracing of the the
serial_number field in the qla2xxx driver.

Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    4 ++--
 drivers/scsi/qla2xxx/qla_isr.c  |    9 ++++-----
 drivers/scsi/qla2xxx/qla_os.c   |   18 ++++++------------
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 579f028..5f94430 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -992,8 +992,8 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	ha = vha->hw;
 
 	DEBUG18(printk(KERN_DEBUG
-	    "%s(%ld): Executing cmd sp %p, pid=%ld, prot_op=%u.\n", __func__,
-	    vha->host_no, sp, cmd->serial_number, scsi_get_prot_op(sp->cmd)));
+	    "%s(%ld): Executing cmd sp %p, prot_op=%u.\n", __func__,
+	    vha->host_no, sp, scsi_get_prot_op(sp->cmd)));
 
 	cmd_pkt->vp_index = sp->fcport->vp_idx;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 55870a3..a47a38f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1431,9 +1431,8 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 		rsp->status_srb = sp;
 
 	DEBUG5(printk("%s(): Check condition Sense data, scsi(%ld:%d:%d:%d) "
-	    "cmd=%p pid=%ld\n", __func__, sp->fcport->vha->host_no,
-	    cp->device->channel, cp->device->id, cp->device->lun, cp,
-	    cp->serial_number));
+	    "cmd=%p\n", __func__, sp->fcport->vha->host_no,
+	    cp->device->channel, cp->device->id, cp->device->lun, cp));
 	if (sense_len)
 		DEBUG5(qla2x00_dump_buffer(cp->sense_buffer, sense_len));
 }
@@ -1799,10 +1798,10 @@ out:
 	if (logit)
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "scsi(%ld:%d:%d) FCP command status: 0x%x-0x%x (0x%x) "
-		    "oxid=0x%x ser=0x%lx cdb=%02x%02x%02x len=0x%x "
+		    "oxid=0x%x cdb=%02x%02x%02x len=0x%x "
 		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x\n", vha->host_no,
 		    cp->device->id, cp->device->lun, comp_status, scsi_status,
-		    cp->result, ox_id, cp->serial_number, cp->cmnd[0],
+		    cp->result, ox_id, cp->cmnd[0],
 		    cp->cmnd[1], cp->cmnd[2], scsi_bufflen(cp), rsp_info_len,
 		    resid_len, fw_resid_len));
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 85bd0a8..fb18f43 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -831,7 +831,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	srb_t *sp;
 	int ret, i;
 	unsigned int id, lun;
-	unsigned long serial;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
@@ -848,7 +847,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
-	serial = cmd->serial_number;
 	spt = (srb_t *) CMD_SP(cmd);
 	if (!spt)
 		return SUCCESS;
@@ -866,8 +864,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		if (sp->cmd != cmd)
 			continue;
 
-		DEBUG2(printk("%s(%ld): aborting sp %p from RISC."
-		" pid=%ld.\n", __func__, vha->host_no, sp, serial));
+		DEBUG2(printk("%s(%ld): aborting sp %p from RISC.",
+		    __func__, vha->host_no, sp));
 
 		/* Get a reference to the sp and drop the lock.*/
 		sp_get(sp);
@@ -892,8 +890,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	if (wait) {
 		if (qla2x00_eh_wait_on_command(cmd) != QLA_SUCCESS) {
 			qla_printk(KERN_ERR, ha,
-			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
-			    "%x.\n", vha->host_no, id, lun, serial, ret);
+			    "scsi(%ld:%d:%d): Abort handler timed out -- %x.\n",
+			    vha->host_no, id, lun, ret);
 			ret = FAILED;
 		}
 	}
@@ -902,8 +900,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		qla2x00_sp_compl(ha, sp);
 
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
-	    vha->host_no, id, lun, wait, serial, ret);
+	    "scsi(%ld:%d:%d): Abort command issued -- %d %x.\n",
+	    vha->host_no, id, lun, wait, ret);
 
 	return ret;
 }
@@ -1048,13 +1046,11 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
 	unsigned int id, lun;
-	unsigned long serial;
 
 	fc_block_scsi_eh(cmd);
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
-	serial = cmd->serial_number;
 
 	if (!fcport)
 		return ret;
@@ -1109,14 +1105,12 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	struct qla_hw_data *ha = vha->hw;
 	int ret = FAILED;
 	unsigned int id, lun;
-	unsigned long serial;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	fc_block_scsi_eh(cmd);
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
-	serial = cmd->serial_number;
 
 	if (!fcport)
 		return ret;
-- 
1.6.0.2

