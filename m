From: Meelis Roos <mroos@linux.ee>
Subject: [PATCH] Remove slash in QlogicPTI irq name
Date: Mon, 8 Mar 2010 20:23:20 +0200 (EET)
Message-ID: <alpine.SOC.1.00.1003081809380.26387@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:42859 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab0CHSus (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Mar 2010 13:50:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

qlogicpti driver registers its irq with a name containing slash.
This results in 

[   71.049735] WARNING: at fs/proc/generic.c:316 __xlate_proc_name+0xa8/0xb8()
[   71.132815] name 'Qlogic/PTI'

because proc_mkdir with the name of the irq fails. Fix it by just 
removing the slash from irq name. Discovered and tested on real hardware 
(Sun Ultra 1).

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index fa34b92..1b82170 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -738,7 +738,7 @@ static int __devinit qpti_register_irq(struct qlogicpti *qpti)
 	 * sanely maintain.
 	 */
 	if (request_irq(qpti->irq, qpti_intr,
-			IRQF_SHARED, "Qlogic/PTI", qpti))
+			IRQF_SHARED, "QlogicPTI", qpti))
 		goto fail;
 
 	printk("qlogicpti%d: IRQ %d ", qpti->qpti_id, qpti->irq);

-- 
Meelis Roos (mroos@linux.ee)
