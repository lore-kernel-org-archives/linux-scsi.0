From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] scsi: hpsa: Use vsnprintf extension %phN
Date: Tue, 19 Dec 2017 19:09:59 +0200
Message-ID: <20171219170959.40768-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15968 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751171AbdLSRKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Dec 2017 12:10:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Using this extension reduces the object size.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/hpsa.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b0aa5dc1d54c..4c018b653f18 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4619,21 +4619,13 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 	return 0;
 }
 
-#define BUFLEN 128
 static inline void warn_zero_length_transfer(struct ctlr_info *h,
 						u8 *cdb, int cdb_len,
 						const char *func)
 {
-	char buf[BUFLEN];
-	int outlen;
-	int i;
-
-	outlen = scnprintf(buf, BUFLEN,
-				"%s: Blocking zero-length request: CDB:", func);
-	for (i = 0; i < cdb_len; i++)
-		outlen += scnprintf(buf+outlen, BUFLEN - outlen,
-					"%02hhx", cdb[i]);
-	dev_warn(&h->pdev->dev, "%s\n", buf);
+	dev_warn(&h->pdev->dev,
+		 "%s: Blocking zero-length request: CDB:%*phN\n",
+		 func, cdb_len, cdb);
 }
 
 #define IO_ACCEL_INELIGIBLE 1
-- 
2.15.1
