From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/5]  qla2xxx: Use midlayer's int_to_scsilun() function.
Date: Thu, 27 Oct 2005 11:09:58 -0700 (PDT)
Message-ID: <20051027180958.11768.26428.sendpatchset@plap.qlogic.com>
References: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:26985 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751422AbVJ0SJ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2005 14:09:59 -0400
In-Reply-To: <20051027180928.11768.90833.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

While populating command type 6 and 7 IOCBs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_fw.h   |    4 ++--
 drivers/scsi/qla2xxx/qla_iocb.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

a6b14e7f53b17482369d3e1c030b1f3df57983d0
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index fd9df16..63f6119 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -394,7 +394,7 @@ struct cmd_type_6 {
 
 	uint16_t fcp_rsp_dsd_len;	/* FCP_RSP DSD length. */
 
-	uint8_t lun[8];			/* FCP LUN (BE). */
+	struct scsi_lun lun;		/* FCP LUN (BE). */
 
 	uint16_t control_flags;		/* Control flags. */
 #define CF_DATA_SEG_DESCR_ENABLE	BIT_2
@@ -432,7 +432,7 @@ struct cmd_type_7 {
 	uint16_t dseg_count;		/* Data segment count. */
 	uint16_t reserved_1;
 
-	uint8_t lun[8];			/* FCP LUN (BE). */
+	struct scsi_lun lun;		/* FCP LUN (BE). */
 
 	uint16_t task_mgmt_flags;	/* Task management flags. */
 #define TMF_CLEAR_ACA		BIT_14
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d735562..b58ee79 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -839,8 +839,7 @@ qla24xx_start_scsi(srb_t *sp)
 	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
 	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
 
-	cmd_pkt->lun[1] = LSB(sp->cmd->device->lun);
-	cmd_pkt->lun[2] = MSB(sp->cmd->device->lun);
+	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
 
 	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
 	if (scsi_populate_tag_msg(cmd, tag)) {

-- 
Andrew Vasquez
