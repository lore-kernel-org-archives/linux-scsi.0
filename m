From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] eata: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 11:01:37 +0100
Message-ID: <1386583297-5069-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381039399-12122-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1381039399-12122-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mike@i-Connect.Net, ballabio_dario@emc.com, JBottomley@parallels.com
Cc: linux-eata@i-connect.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/eata.c     | 2 +-
 drivers/scsi/eata_pio.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 94de88955a99..ebf57364df91 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1221,7 +1221,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 
 	/* Board detected, allocate its IRQ */
 	if (request_irq(irq, do_interrupt_handler,
-			IRQF_DISABLED | ((subversion == ESA) ? IRQF_SHARED : 0),
+			(subversion == ESA) ? IRQF_SHARED : 0,
 			driver_name, (void *)&sha[j])) {
 		printk("%s: unable to allocate IRQ %u, detaching.\n", name,
 		       irq);
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 1663173cdb91..8319d2b417b8 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -687,7 +687,7 @@ static int register_pio_HBA(long base, struct get_conf *gc, struct pci_dev *pdev
 		return 0;
 
 	if (!reg_IRQ[gc->IRQ]) {	/* Interrupt already registered ? */
-		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, IRQF_DISABLED, "EATA-PIO", sh)) {
+		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, 0, "EATA-PIO", sh)) {
 			reg_IRQ[gc->IRQ]++;
 			if (!gc->IRQ_TR)
 				reg_IRQL[gc->IRQ] = 1;	/* IRQ is edge triggered */
@@ -921,7 +921,7 @@ static int eata_pio_detect(struct scsi_host_template *tpnt)
 
 	for (i = 0; i < MAXIRQ; i++)
 		if (reg_IRQ[i])
-			request_irq(i, do_eata_pio_int_handler, IRQF_DISABLED, "EATA-PIO", NULL);
+			request_irq(i, do_eata_pio_int_handler, 0, "EATA-PIO", NULL);
 
 	HBA_ptr = first_HBA;
 
-- 
1.8.3.2
