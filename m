From: vikas.chaudhary@qlogic.com
Subject: [PATCH 01/10] qla4xxx: Add spurious interrupt messages under debug level 2
Date: Sun, 20 Jan 2013 23:50:56 -0500
Message-ID: <1358743865-435-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:30907 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750723Ab3AUFLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:39 -0500
In-Reply-To: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

The spurious interrupt messages are seen when interrupt lines are
shared between different adapters or modules. Example, interrupt
lines are shared between qlcnic and qla4xxx and USB modules, then the
console is flooded with flurry of spurious interrupt messages
which are expected in such scenario.

Hence put these messages under debug level 2 for INTx interrupt mode.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_isr.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index acbc2fe..39669b5 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -1124,17 +1124,18 @@ irqreturn_t qla4_83xx_intr_handler(int irq, void *dev_id)
 
 	/* Legacy interrupt is valid if bit31 of leg_int_ptr is set */
 	if (!(leg_int_ptr & LEG_INT_PTR_B31)) {
-		ql4_printk(KERN_ERR, ha,
-			   "%s: Legacy Interrupt Bit 31 not set, spurious interrupt!\n",
-			   __func__);
+		DEBUG2(ql4_printk(KERN_ERR, ha,
+				  "%s: Legacy Interrupt Bit 31 not set, spurious interrupt!\n",
+				  __func__));
 		return IRQ_NONE;
 	}
 
 	/* Validate the PCIE function ID set in leg_int_ptr bits [19..16] */
 	if ((leg_int_ptr & PF_BITS_MASK) != ha->pf_bit) {
-		ql4_printk(KERN_ERR, ha,
-			   "%s: Incorrect function ID 0x%x in legacy interrupt register, ha->pf_bit = 0x%x\n",
-			   __func__, (leg_int_ptr & PF_BITS_MASK), ha->pf_bit);
+		DEBUG2(ql4_printk(KERN_ERR, ha,
+				  "%s: Incorrect function ID 0x%x in legacy interrupt register, ha->pf_bit = 0x%x\n",
+				  __func__, (leg_int_ptr & PF_BITS_MASK),
+				  ha->pf_bit));
 		return IRQ_NONE;
 	}
 
-- 
1.7.8.GIT

