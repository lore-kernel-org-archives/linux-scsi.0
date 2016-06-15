From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] scsi: wd7000: print sector number as 64-bit
Date: Wed, 15 Jun 2016 22:54:49 +0200
Message-ID: <4878482.cSGU6mK9NX@wuerfel>
References: <20160615204231.3784044-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:61193 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbcFOUxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2016 16:53:18 -0400
In-Reply-To: <20160615204231.3784044-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org

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
Not Cc'ing Miroslav Zagorac <zaga@fly.cc.fer.hr>, that address bounces
with "Requested action not taken: mailbox unavailable invalid DNS MX or A/AAAA resource record"

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 0c0f17b9a3eb..39a3b5333bd6 100644
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
+	dprintk("wd7000_biosparam: dev=%s, size=%lld, ",
+		bdevname(bdev, b), (s64)capacity);
 	(void)b;	/* unused var warning? */
 
 	/*

