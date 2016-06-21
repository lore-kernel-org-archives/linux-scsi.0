From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] scsi: wd7000: print sector number as 64-bit
Date: Tue, 21 Jun 2016 11:02:39 +0200
Message-ID: <20160621090249.774301-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:52000 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbcFUJC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2016 05:02:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Enabling format checking in dprintk() shows that wd7000_biosparam
uses an incorrect format string for sector_t:

drivers/scsi/wd7000.c: In function 'wd7000_biosparam':
drivers/scsi/wd7000.c:1594:21: error: format '%d' expects argument of type 'int', but argument 3 has type 'sector_t {aka long long unsigned int}' [-Werror=format=]

As sector_t can be 32-bit wide, this adds a cast to 'u64' and prints
that with the correct format. The change to use no_printk()
generally helps with finding this kind of hidden format string bug,
and I found that when building with "-Wextra", which warned about
an empty else clause in

       } else
              dprintk("ok!\n");

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: use %llu instead of %lld and use 'u64' instead of 's64' because
sector_t is unsigned.

 drivers/scsi/wd7000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 0c0f17b9a3eb..409f959845c4 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -192,7 +192,7 @@
 #ifdef WD7000_DEBUG
 #define dprintk printk
 #else
-#define dprintk(format,args...)
+#define dprintk	no_printk
 #endif
 
 /*
@@ -1591,8 +1591,8 @@ static int wd7000_biosparam(struct scsi_device *sdev,
 {
 	char b[BDEVNAME_SIZE];
 
-	dprintk("wd7000_biosparam: dev=%s, size=%d, ",
-		bdevname(bdev, b), capacity);
+	dprintk("wd7000_biosparam: dev=%s, size=%llu, ",
+		bdevname(bdev, b), (u64)capacity);
 	(void)b;	/* unused var warning? */
 
 	/*
-- 
2.9.0

