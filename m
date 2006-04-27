From: akpm@osdl.org
Subject: [patch 18/20] advansys-warning-workaround
Date: Thu, 27 Apr 2006 02:33:10 -0700
Message-ID: <200604270934.k3R9YcM9025488@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14032 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965039AbWD0Jex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:34:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org


From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/advansys.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/advansys.c~advansys-warning-workaround drivers/scsi/advansys.c
--- devel/drivers/scsi/advansys.c~advansys-warning-workaround	2006-04-20 00:46:42.000000000 -0700
+++ devel-akpm/drivers/scsi/advansys.c	2006-04-20 00:46:42.000000000 -0700
@@ -2056,11 +2056,12 @@ STATIC ASC_DCNT  AscGetMaxDmaCount(ushor
 /*
  * Define Adv Library required memory access macros.
  */
-#define ADV_MEM_READB(addr) readb(addr)
-#define ADV_MEM_READW(addr) readw(addr)
-#define ADV_MEM_WRITEB(addr, byte) writeb(byte, addr)
-#define ADV_MEM_WRITEW(addr, word) writew(word, addr)
-#define ADV_MEM_WRITEDW(addr, dword) writel(dword, addr)
+#warning these typecasts need to go away
+#define ADV_MEM_READB(addr) readb((void __iomem *)addr)
+#define ADV_MEM_READW(addr) readw((void __iomem *)addr)
+#define ADV_MEM_WRITEB(addr, byte) writeb(byte, (void __iomem *)addr)
+#define ADV_MEM_WRITEW(addr, word) writew(word, (void __iomem *)addr)
+#define ADV_MEM_WRITEDW(addr, dword) writel(dword, (void __iomem *)addr)
 
 #define ADV_CARRIER_COUNT (ASC_DEF_MAX_HOST_QNG + 15)
 
_
