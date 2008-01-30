From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/qlogicpti.c section fixes
Date: Wed, 30 Jan 2008 22:03:36 +0200
Message-ID: <20080130200336.GN29368@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51842 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762908AbYA3UDE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 15:03:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davem@davemloft.net, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes the following section mismatches:

<--  snip  -->

...
WARNING: drivers/scsi/qlogicpti.o(.devexit.text+0x8): Section mismatch in reference from the function qpti_sbus_remove() to the function .init.text:qpti_chain_del()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x56c): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_regs()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x580): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_register_irq()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x594): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_get_scsi_id()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x5b8): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_map_queues()
WARNING: drivers/scsi/qlogicpti.o(.devinit.text+0x780): Section mismatch in reference from the function qpti_sbus_probe() to the function .init.text:qpti_chain_add()
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/qlogicpti.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

3d89831963c0b6f62b24fc4b9dfe1c10d7f90d1b 
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 65455ab..4a1cf63 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -651,7 +651,7 @@ static int qlogicpti_verify_tmon(struct qlogicpti *qpti)
 
 static irqreturn_t qpti_intr(int irq, void *dev_id);
 
-static void __init qpti_chain_add(struct qlogicpti *qpti)
+static void __devinit qpti_chain_add(struct qlogicpti *qpti)
 {
 	spin_lock_irq(&qptichain_lock);
 	if (qptichain != NULL) {
@@ -667,7 +667,7 @@ static void __init qpti_chain_add(struct qlogicpti *qpti)
 	spin_unlock_irq(&qptichain_lock);
 }
 
-static void __init qpti_chain_del(struct qlogicpti *qpti)
+static void __devexit qpti_chain_del(struct qlogicpti *qpti)
 {
 	spin_lock_irq(&qptichain_lock);
 	if (qptichain == qpti) {
@@ -682,7 +682,7 @@ static void __init qpti_chain_del(struct qlogicpti *qpti)
 	spin_unlock_irq(&qptichain_lock);
 }
 
-static int __init qpti_map_regs(struct qlogicpti *qpti)
+static int __devinit qpti_map_regs(struct qlogicpti *qpti)
 {
 	struct sbus_dev *sdev = qpti->sdev;
 
@@ -705,7 +705,7 @@ static int __init qpti_map_regs(struct qlogicpti *qpti)
 	return 0;
 }
 
-static int __init qpti_register_irq(struct qlogicpti *qpti)
+static int __devinit qpti_register_irq(struct qlogicpti *qpti)
 {
 	struct sbus_dev *sdev = qpti->sdev;
 
@@ -730,7 +730,7 @@ fail:
 	return -1;
 }
 
-static void __init qpti_get_scsi_id(struct qlogicpti *qpti)
+static void __devinit qpti_get_scsi_id(struct qlogicpti *qpti)
 {
 	qpti->scsi_id = prom_getintdefault(qpti->prom_node,
 					   "initiator-id",
@@ -783,7 +783,7 @@ static void qpti_get_clock(struct qlogicpti *qpti)
 /* The request and response queues must each be aligned
  * on a page boundary.
  */
-static int __init qpti_map_queues(struct qlogicpti *qpti)
+static int __devinit qpti_map_queues(struct qlogicpti *qpti)
 {
 	struct sbus_dev *sdev = qpti->sdev;
 

