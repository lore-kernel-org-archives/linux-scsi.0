From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/4] libsas: remove private hex2bin() implementation
Date: Fri,  6 May 2016 19:23:56 +0300
Message-ID: <1462551839-44380-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbcEFQYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 12:24:10 -0400
In-Reply-To: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Christoph Hellwig <hch@lst.de>

The function sas_parse_addr() could be easily substituted by hex2bin() which is
in kernel library code.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 519dac4..30a5970 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -27,6 +27,7 @@
 #include <linux/firmware.h>
 #include <linux/export.h>
 #include <linux/ctype.h>
+#include <linux/kernel.h>
 
 #include "sas_internal.h"
 
@@ -961,21 +962,6 @@ void sas_target_destroy(struct scsi_target *starget)
 	sas_put_device(found_dev);
 }
 
-static void sas_parse_addr(u8 *sas_addr, const char *p)
-{
-	int i;
-	for (i = 0; i < SAS_ADDR_SIZE; i++) {
-		u8 h, l;
-		if (!*p)
-			break;
-		h = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
-		p++;
-		l = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
-		p++;
-		sas_addr[i] = (h<<4) | l;
-	}
-}
-
 #define SAS_STRING_ADDR_SIZE	16
 
 int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
@@ -992,7 +978,11 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
 		goto out;
 	}
 
-	sas_parse_addr(addr, fw->data);
+	res = hex2bin(addr, fw->data, strnlen(fw->data, SAS_ADDR_SIZE * 2) / 2);
+	if (res) {
+		res = -EINVAL;
+		goto out;
+	}
 
 out:
 	release_firmware(fw);
-- 
2.8.1

