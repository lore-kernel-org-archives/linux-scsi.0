From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/1] qla2xxx: Obtain proper host structure during response-queue processing.
Date: Tue,  2 Feb 2010 19:48:33 -0800
Message-ID: <1265168913-353-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1265168913-353-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:58457 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753515Ab0BCDsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2010 22:48:35 -0500
In-Reply-To: <1265168913-353-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, stable@kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original code incorrectly assumed only status-type-0
IOCBs would be queued to the response-queue, and thus all
entries would safely reference a VHA from the IOCB
'handle.'
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 09ba26b..154ce9e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2033,7 +2033,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 
 	spin_lock_irq(&ha->hardware_lock);
 
-	vha = qla25xx_get_host(rsp);
+	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, rsp);
 	if (!ha->flags.disable_msix_handshake) {
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-- 
1.6.2.rc1.30.gd43c

