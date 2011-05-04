From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 1/3] mpt2sas: removetheuseofwriteq@lsi.com, since writeq is
 not atomic
Date: Wed, 4 May 2011 16:33:51 +0530
Message-ID: <20110504110317.GA17855@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43709 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243Ab1EDKlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 06:41:50 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


The following code seems to be there in /usr/src/linux/arch/x86/include/asm/io.h.
This is not going to work.

static inline void writeq(__u64 val, volatile void __iomem *addr)
{
        writel(val, addr);
        writel(val >> 32, addr+4);
}

So with this code turned on in the kernel, there is going to be race condition 
where multiple cpus can be writing to the request descriptor at the same time.

Meaning this could happen:
(A) CPU A doest 32bit write
(B) CPU B does 32 bit write
(C) CPU A does 32 bit write
(D) CPU B does 32 bit write

We need the 64 bit completed in one access pci memory write, else spin lock is required.
Since it's going to be difficult to know which writeq was implemented in the kernel, 
the driver is going to have to always acquire a spin lock each time we do 64bit write.

Cc: stable@kernle.org
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index efa0255..5778334 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1558,7 +1558,6 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
  * care of 32 bit environment where its not quarenteed to send the entire word
  * in one transfer.
  */
-#ifndef writeq
 static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
     spinlock_t *writeq_lock)
 {
@@ -1570,13 +1569,6 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
 	writel((u32)(data_out >> 32), (addr + 4));
 	spin_unlock_irqrestore(writeq_lock, flags);
 }
-#else
-static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
-    spinlock_t *writeq_lock)
-{
-	writeq(cpu_to_le64(b), addr);
-}
-#endif
 
 /**
  * mpt2sas_base_put_smid_scsi_io - send SCSI_IO request to firmware
