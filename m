From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/24] hpsa: factor out hpsa_wait_for_board_ready
Date: Thu, 27 May 2010 15:13:12 -0500
Message-ID: <20100527201312.3116.85331.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30588 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759350Ab0E0UId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:08:33 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: factor out hpsa_wait_for_board_ready

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 59c0101..12b1625 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3310,9 +3310,23 @@ static int __devinit hpsa_pci_find_memory_BAR(struct ctlr_info *h,
 	return -ENODEV;
 }
 
+static int __devinit hpsa_wait_for_board_ready(struct ctlr_info *h)
+{
+	int i;
+	u32 scratchpad;
+
+	for (i = 0; i < HPSA_BOARD_READY_ITERATIONS; i++) {
+		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
+		if (scratchpad == HPSA_FIRMWARE_READY)
+			return 0;
+		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
+	}
+	dev_warn(&h->pdev->dev, "board not ready, timed out.\n");
+	return -ENODEV;
+}
+
 static int __devinit hpsa_pci_init(struct ctlr_info *h)
 {
-	u32 scratchpad = 0;
 	u64 cfg_offset;
 	u32 cfg_base_addr;
 	u64 cfg_base_addr_index;
@@ -3347,18 +3361,9 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		goto err_out_free_res;
 	h->vaddr = remap_pci_mem(h->paddr, 0x250);
 
-	/* Wait for the board to become ready.  */
-	for (i = 0; i < HPSA_BOARD_READY_ITERATIONS; i++) {
-		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
-		if (scratchpad == HPSA_FIRMWARE_READY)
-			break;
-		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
-	}
-	if (scratchpad != HPSA_FIRMWARE_READY) {
-		dev_warn(&h->pdev->dev, "board not ready, timed out.\n");
-		err = -ENODEV;
+	err = hpsa_wait_for_board_ready(h);
+	if (err)
 		goto err_out_free_res;
-	}
 
 	/* get the address index number */
 	cfg_base_addr = readl(h->vaddr + SA5_CTCFG_OFFSET);

