From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 03/22] qla2xxx: Disable INTx interrupt for ISP82XX
Date: Wed, 30 Oct 2013 03:38:10 -0400
Message-ID: <1383118709-5569-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [67.231.148.157] ([67.231.148.157]:58528 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753164Ab3J3ILu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:11:50 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ff9c86b..6e649d7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2937,7 +2937,7 @@ msix_out:
 int
 qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
-	int ret;
+	int ret = QLA_FUNCTION_FAILED;
 	device_reg_t __iomem *reg = ha->iobase;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
@@ -2971,10 +2971,12 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		    ha->chip_revision, ha->fw_attributes);
 		goto clear_risc_ints;
 	}
-	ql_log(ql_log_info, vha, 0x0037,
-	    "MSI-X Falling back-to MSI mode -%d.\n", ret);
+
 skip_msix:
 
+	ql_log(ql_log_info, vha, 0x0037,
+	    "Falling back-to MSI mode -%d.\n", ret);
+
 	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
 	    !IS_QLA8001(ha) && !IS_P3P_TYPE(ha) && !IS_QLAFX00(ha))
 		goto skip_msi;
@@ -2986,14 +2988,13 @@ skip_msix:
 		ha->flags.msi_enabled = 1;
 	} else
 		ql_log(ql_log_warn, vha, 0x0039,
-		    "MSI-X; Falling back-to INTa mode -- %d.\n", ret);
+		    "Falling back-to INTa mode -- %d.\n", ret);
+skip_msi:
 
 	/* Skip INTx on ISP82xx. */
 	if (!ha->flags.msi_enabled && IS_QLA82XX(ha))
 		return QLA_FUNCTION_FAILED;
 
-skip_msi:
-
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
 	    ha->flags.msi_enabled ? 0 : IRQF_SHARED,
 	    QLA2XXX_DRIVER_NAME, rsp);
-- 
1.7.7

