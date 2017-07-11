From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: add support for legacy boards
Date: Tue, 11 Jul 2017 08:49:04 +0200
Message-ID: <1499755744-79217-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60097 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753397AbdGKGtM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 02:49:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add support for legacy boards, ensuring to enable the driver for
those boards only when 'hpsa_allow_any' is set.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 35 +++++++++++++++++++++++++++++++++--
 drivers/scsi/hpsa.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8914eab..2cf6ccc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -148,6 +148,8 @@
 	{PCI_VENDOR_ID_HP, 0x333f, 0x103c, 0x333f},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
+	{PCI_VENDOR_ID_COMPAQ,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
 
@@ -158,6 +160,26 @@
  *  access = Address of the struct of function pointers
  */
 static struct board_type products[] = {
+	{0x40700E11, "Smart Array 5300", &SA5A_access},
+	{0x40800E11, "Smart Array 5i", &SA5B_access},
+	{0x40820E11, "Smart Array 532", &SA5B_access},
+	{0x40830E11, "Smart Array 5312", &SA5B_access},
+	{0x409A0E11, "Smart Array 641", &SA5A_access},
+	{0x409B0E11, "Smart Array 642", &SA5A_access},
+	{0x409C0E11, "Smart Array 6400", &SA5A_access},
+	{0x409D0E11, "Smart Array 6400 EM", &SA5A_access},
+	{0x40910E11, "Smart Array 6i", &SA5A_access},
+	{0x3225103C, "Smart Array P600", &SA5A_access},
+	{0x3223103C, "Smart Array P800", &SA5A_access},
+	{0x3234103C, "Smart Array P400", &SA5A_access},
+	{0x3235103C, "Smart Array P400i", &SA5A_access},
+	{0x3211103C, "Smart Array E200i", &SA5A_access},
+	{0x3212103C, "Smart Array E200", &SA5A_access},
+	{0x3213103C, "Smart Array E200i", &SA5A_access},
+	{0x3214103C, "Smart Array E200i", &SA5A_access},
+	{0x3215103C, "Smart Array E200i", &SA5A_access},
+	{0x3237103C, "Smart Array E500", &SA5A_access},
+	{0x323D103C, "Smart Array P700m", &SA5A_access},
 	{0x3241103C, "Smart Array P212", &SA5_access},
 	{0x3243103C, "Smart Array P410", &SA5_access},
 	{0x3245103C, "Smart Array P410i", &SA5_access},
@@ -7243,8 +7265,17 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 		    subsystem_vendor_id;
 
 	for (i = 0; i < ARRAY_SIZE(products); i++)
-		if (*board_id == products[i].board_id)
-			return i;
+		if (*board_id == products[i].board_id) {
+			if (products[i].access != &SA5A_access &&
+			    products[i].access != &SA5B_access)
+				return i;
+			if (hpsa_allow_any) {
+				dev_warn(&pdev->dev,
+					 "unsupported board ID: 0x%08x\n",
+					 *board_id);
+				return i;
+			}
+		}
 
 	if ((subsystem_vendor_id != PCI_VENDOR_ID_HP &&
 		subsystem_vendor_id != PCI_VENDOR_ID_COMPAQ) ||
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 1c49741..e700d2b 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -447,6 +447,25 @@ static void SA5_intr_mask(struct ctlr_info *h, unsigned long val)
 	}
 }
 
+/*
+ *  This card is the opposite of the other cards.
+ *   0 turns interrupts on...
+ *   0x04 turns them off...
+ */
+static void SA5B_intr_mask(struct ctlr_info *h, unsigned long val)
+{
+	if (val) { /* Turn interrupts on */
+		h->interrupts_enabled = 1;
+		writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+	} else { /* Turn them off */
+		h->interrupts_enabled = 0;
+		writel(SA5B_INTR_OFF,
+		       h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+	}
+}
+
 static void SA5_performant_intr_mask(struct ctlr_info *h, unsigned long val)
 {
 	if (val) { /* turn on interrupts */
@@ -549,6 +568,16 @@ static bool SA5_ioaccel_mode1_intr_pending(struct ctlr_info *h)
 		true : false;
 }
 
+/*
+ *      Returns true if an interrupt is pending..
+ */
+static bool SA5B_intr_pending(struct ctlr_info *h)
+{
+	unsigned long register_value  =
+		readl(h->vaddr + SA5_INTR_STATUS);
+	return (register_value & SA5B_INTR_PENDING);
+}
+
 #define IOACCEL_MODE1_REPLY_QUEUE_INDEX  0x1A0
 #define IOACCEL_MODE1_PRODUCER_INDEX     0x1B8
 #define IOACCEL_MODE1_CONSUMER_INDEX     0x1BC
@@ -587,6 +616,21 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 	.command_completed = SA5_completed,
 };
 
+/* Duplicate entry of the above to mark unsupported boards */
+static struct access_method SA5A_access = {
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5_intr_mask,
+	.intr_pending = SA5_intr_pending,
+	.command_completed = SA5_completed,
+};
+
+static struct access_method SA5B_access = {
+	.submit_command = SA5_submit_command,
+	.set_intr_mask = SA5B_intr_mask,
+	.intr_pending = SA5B_intr_pending,
+	.command_completed = SA5_completed,
+};
+
 static struct access_method SA5_ioaccel_mode1_access = {
 	.submit_command = SA5_submit_command,
 	.set_intr_mask = SA5_performant_intr_mask,
-- 
1.8.5.6
