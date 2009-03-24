From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 19/26] qla2xxx: Drop use of IRQF_DISABLE.
Date: Tue, 24 Mar 2009 09:08:13 -0700
Message-ID: <1237910900-30817-20-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762351AbZCXQIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:43 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

When IRQs are shared by multiple controllers and if the first one
to register does not disable the IRQ, then IRQ will be enabled
for all other controllers by default, irrespective of their
setting. With IRQF_DISABLED registration, the driver interrupt
routine was called with interrupt enabled always. Disbaling the
registration with IRQF_DISABLED, since driver code is re-entrant
safe and all critical sections are guarded with interrupt safe
locks.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0f03812..d049818 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2018,7 +2018,7 @@ skip_msix:
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
+	    IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
-- 
1.6.2.rc0.55.g30aa4f

