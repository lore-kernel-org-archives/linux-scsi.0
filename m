From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 11/17] qla2xxx: Host reset handling in ABTS path.
Date: Thu, 25 Sep 2014 06:14:53 -0400
Message-ID: <1411640099-7856-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:15877 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbaIYKtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:49:04 -0400
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Arun Easi <arun.easi@qlogic.com>

ABTS path takes path similar to regular task management, but
reset_count was not initialized when allocating mcmd causing
the response to get dropped in qlt_xmit_tm_rsp. Fix this by
initializing reset_count correctly.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 38f3f1f..ccd0ca2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1185,6 +1185,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
+	mcmd->reset_count = vha->hw->chip_reset;
 
 	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, TMR_ABORT_TASK,
 	    abts->exchange_addr_to_abort);
@@ -3523,6 +3524,7 @@ static int __qlt_abort_task(struct scsi_qla_host *vha,
 
 	lun = a->u.isp24.fcp_cmnd.lun;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
+	mcmd->reset_count = vha->hw->chip_reset;
 
 	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, unpacked_lun, TMR_ABORT_TASK,
 	    le16_to_cpu(iocb->u.isp2x.seq_id));
-- 
1.7.7

