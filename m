From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] scsi: mpt3sas: Use lo_hi_writeq() helper
Date: Wed, 14 Feb 2018 20:10:34 +0200
Message-ID: <20180214181034.36529-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58285 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161606AbeBNSKj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 13:10:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Since we have a writeq() for 32-bit architectures as provided by IO
non-atomic helpers, there is no need to open code it.

Moreover sparse complains about this:

drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: expected unsigned long long val
drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: got restricted __le64 <noident>

Fixing this by replacing custom writeq() with one provided by
io-64-nonatomic-lo-hi.h header.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 59a87ca328d3..a92ab4a801d7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -56,6 +56,7 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/time.h>
 #include <linux/ktime.h>
 #include <linux/kthread.h>
@@ -2968,16 +2969,9 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
  * @writeq_lock: spin lock
  *
  * Glue for handling an atomic 64 bit word to MMIO. This special handling takes
- * care of 32 bit environment where its not quarenteed to send the entire word
+ * care of 32 bit environment where its not guaranteed to send the entire word
  * in one transfer.
  */
-#if defined(writeq) && defined(CONFIG_64BIT)
-static inline void
-_base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
-{
-	writeq(cpu_to_le64(b), addr);
-}
-#else
 static inline void
 _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
 {
@@ -2985,11 +2979,9 @@ _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
 	__u64 data_out = cpu_to_le64(b);
 
 	spin_lock_irqsave(writeq_lock, flags);
-	writel((u32)(data_out), addr);
-	writel((u32)(data_out >> 32), (addr + 4));
+	writeq(data_out, addr);
 	spin_unlock_irqrestore(writeq_lock, flags);
 }
-#endif
 
 /**
  * _base_put_smid_scsi_io - send SCSI_IO request to firmware
-- 
2.15.1
