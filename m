From: vikas.chaudhary@qlogic.com
Subject: [PATCH 04/13] qla4xxx: Fix double IDC locking in qla4_8xxx_error_recovery
Date: Thu, 20 Sep 2012 07:35:04 -0400
Message-ID: <1348140913-11828-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:15912 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754157Ab2ITLxE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:04 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Poornima Vonti <poornima.vonti@qlogic.com>

From: Poornima Vonti <poornima.vonti@qlogic.com>

Issue:
In qla4_8xxx_error_recovery() IDC lock recovery is initiated as
IDC lock is held while enabling the interrupts

Fix:
Correctly handle IDC locking mechanism in qla4_8xxx_error_recovery().

Signed-off-by: Poornima Vonti <poornima.vonti@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c1093eb..afaba52 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6140,22 +6140,25 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 		ha->isp_ops->idc_unlock(ha);
 		clear_bit(AF_FW_RECOVERY, &ha->flags);
 		rval = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
-		ha->isp_ops->idc_lock(ha);
 
 		if (rval != QLA_SUCCESS) {
 			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: HW State: "
 			    "FAILED\n", ha->host_no, __func__);
+			ha->isp_ops->idc_lock(ha);
 			qla4_8xxx_clear_drv_active(ha);
 			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
 					    QLA8XXX_DEV_FAILED);
+			ha->isp_ops->idc_unlock(ha);
 		} else {
 			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: HW State: "
 			    "READY\n", ha->host_no, __func__);
+			ha->isp_ops->idc_lock(ha);
 			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
 					    QLA8XXX_DEV_READY);
 			/* Clear driver state register */
 			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DRV_STATE, 0);
 			qla4_8xxx_set_drv_active(ha);
+			ha->isp_ops->idc_unlock(ha);
 			ret = qla4xxx_request_irqs(ha);
 			if (ret) {
 				ql4_printk(KERN_WARNING, ha, "Failed to "
@@ -6167,7 +6170,6 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 				rval = QLA_SUCCESS;
 			}
 		}
-		ha->isp_ops->idc_unlock(ha);
 	} else {
 		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: devfn 0x%x is not "
 		    "the reset owner\n", ha->host_no, __func__,
-- 
1.7.1

