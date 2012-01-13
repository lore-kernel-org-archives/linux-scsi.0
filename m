From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: [PATCH] pm8001: optimization surrounding call to sas_ssp_task_response
Date: Fri, 13 Jan 2012 11:46:40 -0500
Message-ID: <46C64AF8-8DB5-4380-AB15-DF861E10F3A8@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:40593 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751499Ab2AMQqp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2012 11:46:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jack Wang <jack_wang@usish.com>, JBottomley@parallels.com, crystal_yu@usish.com, john_gong@usish.com, lindar_liu <lindar_liu@usish.com>

Optimization. Since sas_ssp_task_response sets both the ts->resp and ts->stat values, there is no need to set them before the call. Remaining changes are all cosmetic debug print messages.

Signed-off-by: mark_salyzyn@xyratex.com
Cc: jack_wang@usish.com
Cc: JBottomley@parallels.com
Cc: crystal_yu@usish.com
Cc: john_gong@usish.com
Cc: lindar_liu <lindar_liu@usish.com>

 drivers/scsi/pm8001/pm8001_hwi.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index b7b92f7..6b63a54 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1474,13 +1474,11 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	switch (status) {
 	case IO_SUCCESS:
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"
-			",param = %d\n", param));
+			", param = %d\n", param));
 		if (param == 0) {
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAM_STAT_GOOD;
 		} else {
-			ts->resp = SAS_TASK_COMPLETE;
-			ts->stat = SAS_PROTO_RESPONSE;
 			ts->residual = param;
 			iu = &psspPayload->ssp_resp_iu;
 			sas_ssp_task_response(pm8001_ha->dev, t, iu);
@@ -1497,7 +1495,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 	case IO_UNDERFLOW:
 		/* SSP Completion with error */
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_UNDERFLOW"
-			",param = %d\n", param));
+			", param = %d\n", param));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_UNDERRUN;
 		ts->residual = param;
@@ -1659,7 +1657,7 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		break;
 	}
 	PM8001_IO_DBG(pm8001_ha,
-		pm8001_printk("scsi_status = %x \n ",
+		pm8001_printk("scsi_status = %x\n",
 		psspPayload->ssp_resp_iu.status));
 	spin_lock_irqsave(&t->task_state_lock, flags);
 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
@@ -1842,7 +1840,7 @@ static void mpi_ssp_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		break;
 	case IO_XFER_CMD_FRAME_ISSUED:
 		PM8001_IO_DBG(pm8001_ha,
-			pm8001_printk("  IO_XFER_CMD_FRAME_ISSUED\n"));
+			pm8001_printk("IO_XFER_CMD_FRAME_ISSUED\n"));
 		return;
 	default:
 		PM8001_IO_DBG(pm8001_ha,
@@ -3137,7 +3135,7 @@ static int mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	device_id = le32_to_cpu(registerRespPayload->device_id);
 	if (status != 0)
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" deregister device failed ,status = %x"
+			pm8001_printk("deregister device failed, status = %x"
 			", device_id = %x\n", status, device_id));
 	return 0;
 }
@@ -3218,7 +3216,7 @@ mpi_general_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		(struct general_event_resp *)(piomb + 4);
 	status = le32_to_cpu(pPayload->status);
 	PM8001_MSG_DBG(pm8001_ha,
-		pm8001_printk(" status = 0x%x\n", status));
+		pm8001_printk("OPC_OUB_GENERAL_EVENT: status = 0x%x\n", status);
 	for (i = 0; i < GENERAL_EVENT_PAYLOAD; i++)
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("inb_IOMB_payload[0x%x] 0x%x,\n", i,
@@ -3532,7 +3530,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case OPC_OUB_DEREG_DEV:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unresgister the deviece\n"));
+			pm8001_printk("OPC_OUB_DEREG_DEV\n"));
 		mpi_dereg_resp(pm8001_ha, piomb);
 		break;
 	case OPC_OUB_GET_DEV_HANDLE:

