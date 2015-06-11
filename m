From: <rajinikanth.pandurangan@pmcs.com>
Subject: [Patch V2 4/9] [SCSI] aacraid: Enable 64-bit write to controller  register
Date: Wed, 10 Jun 2015 18:42:26 -0700
Message-ID: <1433986951-9033-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:34424 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbbFKBnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 21:43:23 -0400
In-Reply-To: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
        If writeq() not supported, then do atomic two 32bit write

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |  9 +++++++++
 drivers/scsi/aacraid/comminit.c |  1 +
 drivers/scsi/aacraid/src.c      | 12 ++++++++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 62b0999..e54f597 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -844,6 +844,10 @@ struct src_registers {
 						&((AEP)->regs.src.bar0->CSR))
 #define src_writel(AEP, CSR, value)	writel(value, \
 						&((AEP)->regs.src.bar0->CSR))
+#if defined(writeq)
+#define	src_writeq(AEP, CSR, value)	writeq(value, \
+						&((AEP)->regs.src.bar0->CSR))
+#endif
 
 #define SRC_ODR_SHIFT		12
 #define SRC_IDR_SHIFT		9
@@ -1163,6 +1167,11 @@ struct aac_dev
 	struct fsa_dev_info	*fsa_dev;
 	struct task_struct	*thread;
 	int			cardtype;
+	/*
+	 *This lock will protect the two 32-bit
+	 *writes to the Inbound Queue
+	 */
+	spinlock_t		iq_lock;
 
 	/*
 	 *	The following is the device specific extension.
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index e0a76d5..e4ff47e 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -424,6 +424,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	dev->management_fib_count = 0;
 	spin_lock_init(&dev->manage_lock);
 	spin_lock_init(&dev->sync_lock);
+	spin_lock_init(&dev->iq_lock);
 	dev->max_fib_size = sizeof(struct hw_fib);
 	dev->sg_tablesize = host->sg_tablesize = (dev->max_fib_size
 		- sizeof(struct aac_fibhdr)
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index eb07b3d..1409a0b 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -447,6 +447,10 @@ static int aac_src_deliver_message(struct fib *fib)
 	u32 fibsize;
 	dma_addr_t address;
 	struct aac_fib_xporthdr *pFibX;
+#if !defined(writeq)
+	unsigned long flags;
+#endif
+
 	u16 hdr_size = le16_to_cpu(fib->hw_fib_va->header.Size);
 
 	atomic_inc(&q->numpending);
@@ -511,10 +515,14 @@ static int aac_src_deliver_message(struct fib *fib)
 			return -EINVAL;
 		address |= fibsize;
 	}
-
+#if defined(writeq)
+	src_writeq(dev, MUnit.IQ_L, (u64)address);
+#else
+	spin_lock_irqsave(&fib->dev->iq_lock, flags);
 	src_writel(dev, MUnit.IQ_H, upper_32_bits(address) & 0xffffffff);
 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
-
+	spin_unlock_irqrestore(&fib->dev->iq_lock, flags);
+#endif
 	return 0;
 }
 
-- 
1.9.3

