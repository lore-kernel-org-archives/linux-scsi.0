From: akpm@osdl.org
Subject: [patch 18/45] ioremap balanced with iounmap for drivers/scsi/seagate.c
Date: Fri, 20 Oct 2006 14:48:19 -0700
Message-ID: <200610202148.k9KLmJ2b004118@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38278 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992777AbWJTVsc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/seagate.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/seagate.c~ioremap-balanced-with-iounmap-drivers-scsi-seagatec drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c~ioremap-balanced-with-iounmap-drivers-scsi-seagatec
+++ a/drivers/scsi/seagate.c
@@ -494,12 +494,19 @@ int __init seagate_st0x_detect (struct s
 	 *	if we lose our first interrupt.
 	 */
 	instance = scsi_register (tpnt, 0);
-	if (instance == NULL)
+	if (instance == NULL) {
+		iounmap(st0x_cr_sr);
+		iounmap(st0x_dr);
+		st0x_cr_sr = st0x_dr = NULL;
 		return 0;
+	}
 
 	hostno = instance->host_no;
 	if (request_irq (irq, do_seagate_reconnect_intr, IRQF_DISABLED, (controller_type == SEAGATE) ? "seagate" : "tmc-8xx", instance)) {
 		printk(KERN_ERR "scsi%d : unable to allocate IRQ%d\n", hostno, irq);
+		iounmap(st0x_cr_sr);
+		iounmap(st0x_dr);
+		st0x_cr_sr = st0x_dr = NULL;
 		return 0;
 	}
 	instance->irq = irq;
@@ -1646,6 +1653,10 @@ static int seagate_st0x_release(struct S
 {
 	if (shost->irq)
 		free_irq(shost->irq, shost);
+	if (st0x_cr_sr)
+		iounmap(st0x_cr_sr);
+	if (st0x_dr)
+		iounmap(st0x_dr);
 	release_region(shost->io_port, shost->n_io_port);
 	return 0;
 }
_
