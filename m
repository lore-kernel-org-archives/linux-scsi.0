From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 04/24] hpsa: remove redundant board_id parameter from
	hpsa_interrupt_mode
Date: Thu, 27 May 2010 15:13:02 -0500
Message-ID: <20100527201302.3116.24940.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:6625 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab0E0UIX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:23 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: remove redundant board_id parameter from hpsa_interrupt_mode
and delete duplicated comment

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index eb4fb56..bea2d41 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3217,7 +3217,7 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
  * controllers that are capable. If not, we use IO-APIC mode.
  */
 
-static void __devinit hpsa_interrupt_mode(struct ctlr_info *h, u32 board_id)
+static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
 {
 #ifdef CONFIG_PCI_MSI
 	int err;
@@ -3226,9 +3226,8 @@ static void __devinit hpsa_interrupt_mode(struct ctlr_info *h, u32 board_id)
 	};
 
 	/* Some boards advertise MSI but don't really support it */
-	if ((board_id == 0x40700E11) ||
-	    (board_id == 0x40800E11) ||
-	    (board_id == 0x40820E11) || (board_id == 0x40830E11))
+	if ((h->board_id == 0x40700E11) || (h->board_id == 0x40800E11) ||
+	    (h->board_id == 0x40820E11) || (h->board_id == 0x40830E11))
 		goto default_int_mode;
 	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSIX)) {
 		dev_info(&h->pdev->dev, "MSIX\n");
@@ -3325,11 +3324,7 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 			"cannot obtain PCI resources, aborting\n");
 		return err;
 	}
-
-	/* If the kernel supports MSI/MSI-X we will try to enable that,
-	 * else we use the IO-APIC interrupt assigned to us by system ROM.
-	 */
-	hpsa_interrupt_mode(h, h->board_id);
+	hpsa_interrupt_mode(h);
 
 	/* find the memory BAR */
 	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {

