From: Ben Collins <bcollins@ubuntu.com>
Subject: [PATCH 4/4] SCSI: AACRAID: Fix endian issues in core and SRC
 portions of driver
Date: Mon, 11 Jun 2012 16:14:36 -0400
Message-ID: <8e9c7ebb2faef509e1dca8264540c5d66f60b12f.1339453250.git.bcollins@ubuntu.com>
References: <cover.1339453250.git.bcollins@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55087 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2FKWkt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2012 18:40:49 -0400
Received: by pbbrp8 with SMTP id rp8so6195222pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 15:40:49 -0700 (PDT)
In-Reply-To: <cover.1339453250.git.bcollins@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>

This may not fix all endian issues in this driver, but it does get the
driver working on PowerPC for a PMC SRC card. So it should at least fix
all the problems in the core and in the SRC support.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/comminit.c |    4 ++--
 drivers/scsi/aacraid/src.c      |   46 ++++++++++++++++++++++++---------------
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index a35f54e..8e4b525 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -132,8 +132,8 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 	init->MaxFibSize = cpu_to_le32(dev->max_fib_size);
 
 	init->MaxNumAif = cpu_to_le32(dev->max_num_aif);
-	init->HostRRQ_AddrHigh = (u32)((u64)dev->host_rrq_pa >> 32);
-	init->HostRRQ_AddrLow = (u32)(dev->host_rrq_pa & 0xffffffff);
+	init->HostRRQ_AddrHigh = cpu_to_le32((u32)((u64)dev->host_rrq_pa >> 32));
+	init->HostRRQ_AddrLow = cpu_to_le32((u32)(dev->host_rrq_pa & 0xffffffff));
 
 
 	/*
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 27a3e77..0fb1f55 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -74,7 +74,7 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 		for (;;) {
 			isFastResponse = 0;
 			/* remove toggle bit (31) */
-			handle = (dev->host_rrq[index] & 0x7fffffff);
+			handle = le32_to_cpu(dev->host_rrq[index]) & 0x7fffffff;
 			/* check fast response bit (30) */
 			if (handle & 0x40000000)
 				isFastResponse = 1;
@@ -389,30 +389,42 @@ static int aac_src_deliver_message(struct fib *fib)
 	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
 	unsigned long qflags;
 	u32 fibsize;
-	u64 address;
+	dma_addr_t address;
 	struct aac_fib_xporthdr *pFibX;
+	u16 hdr_size = le16_to_cpu(fib->hw_fib_va->header.Size);
 
 	spin_lock_irqsave(q->lock, qflags);
 	q->numpending++;
 	spin_unlock_irqrestore(q->lock, qflags);
 
 	/* Calculate the amount to the fibsize bits */
-	fibsize = (sizeof(struct aac_fib_xporthdr) +
-		fib->hw_fib_va->header.Size + 127) / 128 - 1;
+	fibsize = (sizeof(struct aac_fib_xporthdr) + hdr_size + 127) / 128 - 1;
 	if (fibsize > (ALIGN32 - 1))
-		fibsize = ALIGN32 - 1;
-
-    /* Fill XPORT header */
-	pFibX = (struct aac_fib_xporthdr *)
-		((unsigned char *)fib->hw_fib_va -
-		sizeof(struct aac_fib_xporthdr));
-	pFibX->Handle = fib->hw_fib_va->header.SenderData + 1;
-	pFibX->HostAddress = fib->hw_fib_pa;
-	pFibX->Size = fib->hw_fib_va->header.Size;
-	address = fib->hw_fib_pa - (u64)sizeof(struct aac_fib_xporthdr);
-
-	src_writel(dev, MUnit.IQ_H, (u32)(address >> 32));
-	src_writel(dev, MUnit.IQ_L, (u32)(address & 0xffffffff) + fibsize);
+		return -EMSGSIZE;
+
+	/* Fill XPORT header */
+	pFibX = (void *)fib->hw_fib_va - sizeof(struct aac_fib_xporthdr);
+	/*
+	 * This was stored by aac_fib_send() and it is the index into
+	 * dev->fibs. Not sure why we add 1 to it, but I suspect that it's
+	 * because it can't be zero when we pass it to the hardware. Note that
+	 * it was stored in native endian, hence the lack of swapping. -- BenC
+	 */
+	pFibX->Handle = cpu_to_le32(fib->hw_fib_va->header.SenderData + 1);
+	pFibX->HostAddress = cpu_to_le64(fib->hw_fib_pa);
+	pFibX->Size = cpu_to_le32(hdr_size);
+
+	/*
+	 * The xport header has been 32-byte aligned for us so that fibsize
+	 * can be masked out of this address by hardware. -- BenC
+	 */
+	address = fib->hw_fib_pa - sizeof(struct aac_fib_xporthdr);
+	if (address & (ALIGN32 - 1))
+		return -EINVAL;
+	address |= fibsize;
+	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
+
 	return 0;
 }
 
-- 
1.7.9.5

