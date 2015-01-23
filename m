From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 03/48] hpsa: turn off interrupts when kdump starts
Date: Fri, 23 Jan 2015 16:41:20 -0600
Message-ID: <20150123224120.14919.21419.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:38234 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbbAWWmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:14 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

Sometimes when the card is restarted it may cause -
"irq 16: nobody cared (try booting with the "irqpoll" option)"
that is likely caused so, that the card, after the hard reset
finishes, pulls on the irq. Disabling the ints before or after
the hpsa_kdump_hard_reset_controller fixes it.

At this point we can't know in which state the card is,
so using SA5_INTR_OFF + SA5_REPLY_INTR_MASK_OFFSET defines directly,
instead of the function the drivers provides, seems to be apropriate.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d97f455..9edacff 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6370,6 +6370,7 @@ static void hpsa_hba_inquiry(struct ctlr_info *h)
 static int hpsa_init_reset_devices(struct pci_dev *pdev)
 {
 	int rc, i;
+	void __iomem *vaddr;
 
 	if (!reset_devices)
 		return 0;
@@ -6393,6 +6394,14 @@ static int hpsa_init_reset_devices(struct pci_dev *pdev)
 
 	pci_set_master(pdev);
 
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
 

