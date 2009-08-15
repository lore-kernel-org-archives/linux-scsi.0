From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH] stex: Add reset code for st_yel
Date: Fri, 14 Aug 2009 22:03:00 -0800
Message-ID: <200908142202591084033@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:31700 "EHLO
	nanamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbZHOFSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2009 01:18:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>


Add reset related code for st_yel.
1. Set the SS_H2I_INT_RESET bit.
2. Wait for the SS_MU_OPERATIONAL flag. This is also part of
   normal handshake process so move it to handshake routine.
3. Continue handshake with the firmware.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8d2a95c..b57f92f 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -55,6 +55,7 @@ enum {
 	OIS	= 0x30,	/* MU_OUTBOUND_INTERRUPT_STATUS */
 	OIM	= 0x3c,	/* MU_OUTBOUND_INTERRUPT_MASK */
 
+	YIOA_STATUS				= 0x00,
 	YH2I_INT				= 0x20,
 	YINT_EN					= 0x34,
 	YI2H_INT				= 0x9c,
@@ -108,6 +109,10 @@ enum {
 
 	SS_HEAD_HANDSHAKE			= 0x80,
 
+	SS_H2I_INT_RESET			= 0x100,
+
+	SS_MU_OPERATIONAL			= 0x80000000,
+
 	STEX_CDB_LENGTH				= 16,
 	STATUS_VAR_LEN				= 128,
 
@@ -884,7 +889,7 @@ static void stex_ss_mu_intr(struct st_hba *hba)
 		tag = (u16)value;
 		if (unlikely(tag >= hba->host->can_queue)) {
 			printk(KERN_WARNING DRV_NAME
-					"(%s): invalid tag\n", pci_name(hba->pdev));
+				"(%s): invalid tag\n", pci_name(hba->pdev));
 			continue;
 		}
 
@@ -1040,16 +1045,28 @@ static int stex_ss_handshake(struct st_hba *hba)
 	void __iomem *base = hba->mmio_base;
 	struct st_msg_header *msg_h;
 	struct handshake_frame *h;
-	__le32 *scratch = hba->scratch;
+	__le32 *scratch;
 	u32 data;
 	unsigned long before;
 	int ret = 0;
 
-	h = (struct handshake_frame *)(hba->alloc_rq(hba));
-	msg_h = (struct st_msg_header *)h - 1;
+	before = jiffies;
+	while ((readl(base + YIOA_STATUS) & SS_MU_OPERATIONAL) == 0) {
+		if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+			printk(KERN_ERR DRV_NAME
+				"(%s): firmware not operational\n",
+				pci_name(hba->pdev));
+			return -1;
+		}
+		rmb();
+		msleep(1);
+	}
+
+	msg_h = (struct st_msg_header *)hba->dma_mem;
 	msg_h->handle = cpu_to_le64(hba->dma_handle);
 	msg_h->flag = SS_HEAD_HANDSHAKE;
 
+	h = (struct handshake_frame *)(msg_h + 1);
 	h->rb_phy = cpu_to_le64(hba->dma_handle);
 	h->req_sz = cpu_to_le16(hba->rq_size);
 	h->req_cnt = cpu_to_le16(hba->rq_count+1);
@@ -1205,6 +1222,13 @@ static void stex_hard_reset(struct st_hba *hba)
 			hba->pdev->saved_config_space[i]);
 }
 
+static void stex_ss_reset(struct st_hba *hba)
+{
+	writel(SS_H2I_INT_RESET, hba->mmio_base + YH2I_INT);
+	readl(hba->mmio_base + YH2I_INT);
+	ssleep(5);
+}
+
 static int stex_reset(struct scsi_cmnd *cmd)
 {
 	struct st_hba *hba;
@@ -1221,6 +1245,8 @@ static int stex_reset(struct scsi_cmnd *cmd)
 
 	if (hba->cardtype == st_shasta)
 		stex_hard_reset(hba);
+	else if (hba->cardtype == st_yel)
+		stex_ss_reset(hba);
 
 	if (hba->cardtype != st_yosemite) {
 		if (stex_handshake(hba)) {


