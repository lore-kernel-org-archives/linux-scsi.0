From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 01/10] qla2xxx: Report both rsp_info and rsp_info_len
Date: Thu, 9 Jul 2015 07:22:38 -0700
Message-ID: <559E83AE.8040404@sandisk.com>
References: <559E8382.6030803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0086.outbound.protection.outlook.com ([65.55.169.86]:43436
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbbGIOWp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 10:22:45 -0400
In-Reply-To: <559E8382.6030803@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Let the debug statement in qlafx00_tm_iocb_entry() report both rsp_info
and rsp_info_len instead of reporting rsp_info_len twice.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6d190b4..878fd3d 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2528,12 +2528,12 @@ check_scsi_status:
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3058,
 		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu "
 		    "tgt_id: 0x%x lscsi_status: 0x%x cdb=%10phN len=0x%x "
-		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x sense_len=0x%x, "
+		    "rsp_info=%p resid=0x%x fw_resid=0x%x sense_len=0x%x, "
 		    "par_sense_len=0x%x, rsp_info_len=0x%x\n",
 		    comp_status, scsi_status, res, vha->host_no,
 		    cp->device->id, cp->device->lun, fcport->tgt_id,
 		    lscsi_status, cp->cmnd, scsi_bufflen(cp),
-		    rsp_info_len, resid_len, fw_resid_len, sense_len,
+		    rsp_info, resid_len, fw_resid_len, sense_len,
 		    par_sense_len, rsp_info_len);
 
 	if (rsp->status_srb == NULL)
-- 
2.1.4

