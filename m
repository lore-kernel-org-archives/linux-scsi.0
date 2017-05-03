From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 35/36] smartpqi: remove writeq/readq function definitions
Date: Wed, 3 May 2017 18:55:49 -0500
Message-ID: <149385574974.11043.14803946009404604297.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0059.outbound.protection.outlook.com ([104.47.41.59]:11712
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751927AbdECXz7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:55:59 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
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
 drivers/scsi/smartpqi/smartpqi.h |   31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index e9f113a..07ec8a88 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -16,6 +16,8 @@
  *
  */
 
+#include <linux/io-64-nonatomic-lo-hi.h>
+
 #if !defined(_SMARTPQI_H)
 #define _SMARTPQI_H
 
@@ -1175,33 +1177,4 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd);
 
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
