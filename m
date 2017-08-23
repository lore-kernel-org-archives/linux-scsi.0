From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 10/31] qla2xxx: Remove extra register read
Date: Wed, 23 Aug 2017 15:05:04 -0700
Message-ID: <20170823220525.3115-11-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0048.outbound.protection.outlook.com ([104.47.34.48]:27040
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751093AbdHWWFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:44 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Remove extra register read for each interrupt
for performance improvement.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c    | 9 ---------
 drivers/scsi/qla2xxx/qla_target.c | 1 -
 2 files changed, 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c6c066186d97..df8a7f378e72 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3157,7 +3157,6 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	struct device_reg_24xx __iomem *reg;
 	struct scsi_qla_host *vha;
 	unsigned long flags;
-	uint32_t stat = 0;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -3171,19 +3170,11 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	vha = pci_get_drvdata(ha->pdev);
-	/*
-	 * Use host_status register to check to PCI disconnection before we
-	 * we process the response queue.
-	 */
-	stat = RD_REG_DWORD(&reg->host_status);
-	if (qla2x00_check_reg32_for_disconnect(vha, stat))
-		goto out;
 	qla24xx_process_response_queue(vha, rsp);
 	if (!ha->flags.disable_msix_handshake) {
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
 	}
-out:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return IRQ_HANDLED;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4e2a64773060..3bcfbee2ae26 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6530,7 +6530,6 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 
 	/* Adjust ring index */
 	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), ha->tgt.atio_ring_index);
-	RD_REG_DWORD_RELAXED(ISP_ATIO_Q_OUT(vha));
 }
 
 void
-- 
2.12.0
