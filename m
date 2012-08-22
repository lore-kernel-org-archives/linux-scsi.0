From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 13/42] qla2xxx: Don't register to legacy interrupt for ISP82xx.
Date: Wed, 22 Aug 2012 14:21:07 -0400
Message-ID: <1345659696-3670-14-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:19040 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964982Ab2HVSiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:15 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 074b680..f6415fe 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2913,6 +2913,11 @@ skip_msix:
 	} else
 		ql_log(ql_log_warn, vha, 0x0039,
 		    "MSI-X; Falling back-to INTa mode -- %d.\n", ret);
+
+	/* Skip INTx on ISP82xx. */
+	if (!ha->flags.msi_enabled && IS_QLA82XX(ha))
+		return QLA_FUNCTION_FAILED;
+
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-- 
1.7.7

