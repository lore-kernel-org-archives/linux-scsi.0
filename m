From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: switch int off when in kdump kernel starts
Date: Fri,  7 Nov 2014 13:48:33 +0100
Message-ID: <1415364513-25531-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaKGMsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 07:48:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, Elliott@hp.com, brace77070@gmail.com

Sometimes when the card is restarted it may cause -
"irq 16: nobody cared (try booting with the "irqpoll" option)"
that is likely caused so, that the card, after the hard reset
finishes, pulls on the irq. Disabling the ints before or after
the hpsa_kdump_hard_reset_controller fixes it.

At this point we can't know in which state the card is,
so using SA5_INTR_OFF + SA5_REPLY_INTR_MASK_OFFSET defines directly,
instead of the function the drivers provides, seems to be apropriate.
I hope someone who knows the hw details will review it.

Tomas

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 59ea37d175..d7f96e373c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6532,6 +6532,7 @@ static void hpsa_hba_inquiry(struct ctlr_info *h)
 static int hpsa_init_reset_devices(struct pci_dev *pdev)
 {
 	int rc, i;
+	void __iomem *vaddr;
 
 	if (!reset_devices)
 		return 0;
@@ -6553,6 +6554,15 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 		return -ENODEV;
 	}
 	pci_set_master(pdev);
+
+	vaddr = pci_ioremap_bar(pdev, 0);
+	if (vaddr == NULL) {
+		rc = -ENOMEM;
+		goto out_disable;
+	}
+	writel(SA5_INTR_OFF, vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+	iounmap(vaddr);
+
 	/* Reset the controller with a PCI power-cycle or via doorbell */
 	rc = hpsa_kdump_hard_reset_controller(pdev);
 
-- 
1.9.3

