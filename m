From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/10] qla2xxx: Correct locking within MSI-X interrupt handlers.
Date: Mon, 12 May 2008 22:21:09 -0700
Message-ID: <1210656076-54720-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbYEMFVS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:18 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Both MSI-X vector handlers attempt to acquire the HA's
hardware_lock.  This though requires that interrupts be
disabled/enabled during acquisition and release of the spinlock.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5d9a64a..0793aa9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1639,12 +1639,12 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	ha = dev_id;
 	reg = &ha->iobase->isp24;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irq(&ha->hardware_lock);
 
 	qla24xx_process_response_queue(ha);
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irq(&ha->hardware_lock);
 
 	return IRQ_HANDLED;
 }
@@ -1663,7 +1663,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock(&ha->hardware_lock);
+	spin_lock_irq(&ha->hardware_lock);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
 		if (stat & HSRX_RISC_PAUSED) {
@@ -1716,7 +1716,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
-	spin_unlock(&ha->hardware_lock);
+	spin_unlock_irq(&ha->hardware_lock);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-- 
1.5.5.1.211.g65ea3

