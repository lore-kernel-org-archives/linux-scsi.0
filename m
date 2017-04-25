From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 36/37] smartpqi: remove writeq/readq function definitions
Date: Tue, 25 Apr 2017 14:49:32 -0500
Message-ID: <149314977225.13903.856016860870045906.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0062.outbound.protection.outlook.com ([104.47.32.62]:22976
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1947680AbdDYTtw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:49:52 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>

Instead of rewriting write/readq, use existing functions

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi.h |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e9f113a..446e17b 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1175,33 +1175,4 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd);
 
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
