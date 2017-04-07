From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] scsi: smartpqi: remove writeq/readq function definitions
Date: Fri,  7 Apr 2017 15:33:22 +0200
Message-ID: <20170407133322.30440-1-clabbe.montjoie@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36494 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756232AbdDGNf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2017 09:35:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>

Instead of rewriting write/readq, use linux/io-64-nonatomic-lo-hi.h which
already have them.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/scsi/smartpqi/smartpqi.h | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index b673825..2850ece 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -19,6 +19,8 @@
 #if !defined(_SMARTPQI_H)
 #define _SMARTPQI_H
 
+#include <linux/io-64-nonatomic-lo-hi.h>
+
 #pragma pack(1)
 
 #define PQI_DEVICE_SIGNATURE	"PQI DREG"
@@ -1102,33 +1104,4 @@ struct pqi_scsi_dev *pqi_find_device_by_sas_rphy(
 
 extern struct sas_function_template pqi_sas_transport_functions;
 
-#if !defined(readq)
-#define readq readq
-static inline u64 readq(const volatile void __iomem *addr)
-{
-	u32 lower32;
-	u32 upper32;
-
-	lower32 = readl(addr);
-	upper32 = readl(addr + 4);
-
-	return ((u64)upper32 << 32) | lower32;
-}
-#endif
-
-#if !defined(writeq)
-#define writeq writeq
-static inline void writeq(u64 value, volatile void __iomem *addr)
-{
-	u32 lower32;
-	u32 upper32;
-
-	lower32 = lower_32_bits(value);
-	upper32 = upper_32_bits(value);
-
-	writel(lower32, addr);
-	writel(upper32, addr + 4);
-}
-#endif
-
 #endif /* _SMARTPQI_H */
-- 
2.10.2
