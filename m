From: "Ed Lin" <ed.lin@promise.com>
Subject: [repost][PATCH 7/8] stex: change wait loop code
Date: Mon, 4 Dec 2006 17:49:42 -0800
Message-ID: <NONAMEBZhNfv57kVwyr00001574@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:19092 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968017AbWLEBt3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2006 20:49:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


The original wait loop may be much longer than intended time.
Use more accurate timer_after for it. Also adjust wait value to
avoid unnecessary long waiting.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index bfd7983..7edbcc9 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -76,9 +76,10 @@ enum {
 	MU_STATE_STARTED			= 4,
 	MU_STATE_RESETTING			= 5,
 
-	MU_MAX_DELAY_TIME			= 240000,
+	MU_MAX_DELAY				= 120,
 	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
 	MU_HANDSHAKE_SIGNATURE_HALF		= 0x5a5a0000,
+	MU_HARD_RESET_WAIT			= 30000,
 	HMU_PARTNER_TYPE			= 2,
 
 	/* firmware returned values */
@@ -910,23 +911,22 @@ static int stex_handshake(struct st_hba 
 	struct handshake_frame *h;
 	dma_addr_t status_phys;
 	u32 data;
-	int i;
+	unsigned long before;
 
 	if (readl(base + OMR0) != MU_HANDSHAKE_SIGNATURE) {
 		writel(MU_INBOUND_DOORBELL_HANDSHAKE, base + IDBL);
 		readl(base + IDBL);
-		for (i = 0; readl(base + OMR0) != MU_HANDSHAKE_SIGNATURE
-			&& i < MU_MAX_DELAY_TIME; i++) {
+		before = jiffies;
+		while (readl(base + OMR0) != MU_HANDSHAKE_SIGNATURE) {
+			if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+				printk(KERN_ERR DRV_NAME
+					"(%s): no handshake signature\n",
+					pci_name(hba->pdev));
+				return -1;
+			}
 			rmb();
 			msleep(1);
 		}
-
-		if (i == MU_MAX_DELAY_TIME) {
-			printk(KERN_ERR DRV_NAME
-				"(%s): no handshake signature\n",
-				pci_name(hba->pdev));
-			return -1;
-		}
 	}
 
 	udelay(10);
@@ -965,19 +965,18 @@ static int stex_handshake(struct st_hba 
 	readl(base + IDBL); /* flush */
 
 	udelay(10);
-	for (i = 0; readl(base + OMR0) != MU_HANDSHAKE_SIGNATURE
-		&& i < MU_MAX_DELAY_TIME; i++) {
+	before = jiffies;
+	while (readl(base + OMR0) != MU_HANDSHAKE_SIGNATURE) {
+		if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+			printk(KERN_ERR DRV_NAME
+				"(%s): no signature after handshake frame\n",
+				pci_name(hba->pdev));
+			return -1;
+		}
 		rmb();
 		msleep(1);
 	}
 
-	if (i == MU_MAX_DELAY_TIME) {
-		printk(KERN_ERR DRV_NAME
-			"(%s): no signature after handshake frame\n",
-			pci_name(hba->pdev));
-		return -1;
-	}
-
 	writel(0, base + IMR0);
 	readl(base + IMR0);
 	writel(0, base + OMR0);
@@ -1059,7 +1058,7 @@ static void stex_hard_reset(struct st_hb
 	pci_bctl &= ~PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_byte(bus->self, PCI_BRIDGE_CONTROL, pci_bctl);
 
-	for (i = 0; i < MU_MAX_DELAY_TIME; i++) {
+	for (i = 0; i < MU_HARD_RESET_WAIT; i++) {
 		pci_read_config_word(hba->pdev, PCI_COMMAND, &pci_cmd);
 		if (pci_cmd != 0xffff && (pci_cmd & PCI_COMMAND_MASTER))
 			break;


