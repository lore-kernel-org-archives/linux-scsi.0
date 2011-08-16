From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 6/9] qla2xxx: Save and restore irq in the response queue interrupt handler.
Date: Tue, 16 Aug 2011 11:29:27 -0700
Message-ID: <1313519370-22963-7-git-send-email-chad.dupuis@qlogic.com>
References: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:57459 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1HPSje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:39:34 -0400
In-Reply-To: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 5cbf33a..02704fe 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2208,6 +2208,7 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_82xx __iomem *reg;
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -2218,11 +2219,11 @@ qla82xx_msix_rsp_q(int irq, void *dev_id)
 
 	ha = rsp->hw;
 	reg = &ha->iobase->isp82;
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
 	WRT_REG_DWORD(&reg->host_int, 0);
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return IRQ_HANDLED;
 }
 
-- 
1.6.0.2


