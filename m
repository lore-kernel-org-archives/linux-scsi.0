From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] hpsa: add support for legacy boards
Date: Tue,  8 Aug 2017 10:35:11 +0200
Message-ID: <1502181315-102499-3-git-send-email-hare@suse.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750818AbdHHIfS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 04:35:18 -0400
In-Reply-To: <1502181315-102499-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add support for legacy boards, ensuring to enable the driver for
those boards only when 'hpsa_allow_any' is set.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/hpsa.h | 45 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8914eab..7ca6078 100644
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
@@ -278,7 +300,8 @@ static int hpsa_find_cfg_addrs(struct pci_dev *pdev, void __iomem *vaddr,
 			       u64 *cfg_offset);
 static int hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 				    unsigned long *memory_bar);
-static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id);
+static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id,
+				bool *supported);
 static int wait_for_device_to_become_ready(struct ctlr_info *h,
 					   unsigned char lunaddr[],
 					   int reply_queue);
@@ -7232,7 +7255,8 @@ static int hpsa_interrupt_mode(struct ctlr_info *h)
 	return 0;
 }
 
-static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
+static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id,
+				bool *supported)
 {
 	int i;
 	u32 subsystem_vendor_id, subsystem_device_id;
@@ -7242,9 +7266,22 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
 		    subsystem_vendor_id;
 
+	if (supported)
+		*supported = true;
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
+				if (supported)
+					*supported = false;
+				return i;
+			}
+		}
 
 	if ((subsystem_vendor_id != PCI_VENDOR_ID_HP &&
 		subsystem_vendor_id != PCI_VENDOR_ID_COMPAQ) ||
@@ -7253,6 +7290,8 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 			"0x%08x, ignoring.\n", *board_id);
 			return -ENODEV;
 	}
+	if (supported)
+		*supported = false;
 	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
 }
 
@@ -7555,13 +7594,14 @@ static void hpsa_free_pci_init(struct ctlr_info *h)
 static int hpsa_pci_init(struct ctlr_info *h)
 {
 	int prod_index, err;
+	bool supported;
 
-	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id);
+	prod_index = hpsa_lookup_board_id(h->pdev, &h->board_id, &supported);
 	if (prod_index < 0)
 		return prod_index;
 	h->product_name = products[prod_index].product_name;
 	h->access = *(products[prod_index].access);
-
+	h->supported = supported;
 	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
 			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
 
@@ -8241,7 +8281,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (number_of_controllers == 0)
 		printk(KERN_INFO DRIVER_NAME "\n");
 
-	rc = hpsa_lookup_board_id(pdev, &board_id);
+	rc = hpsa_lookup_board_id(pdev, &board_id, NULL);
 	if (rc < 0) {
 		dev_warn(&pdev->dev, "Board ID not found\n");
 		return rc;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index bd16f38..ccec1e6 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -294,6 +294,7 @@ struct ctlr_info {
 	unsigned int reset_in_progress:1;
 	unsigned int needs_abort_tags_swizzled:1;
 	unsigned int remove_in_progress:1;
+	unsigned int supported:1;
 	int	raid_offload_debug;
 	struct  ReportLUNdata *lastlogicals;
 	struct workqueue_struct *resubmit_wq;
@@ -447,6 +448,25 @@ static void SA5_intr_mask(struct ctlr_info *h, unsigned long val)
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
@@ -549,6 +569,16 @@ static bool SA5_ioaccel_mode1_intr_pending(struct ctlr_info *h)
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
@@ -587,6 +617,21 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
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
