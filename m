From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] libsas: remove private hex2bin() implementation
Date: Tue, 19 Dec 2017 19:37:27 +0200
Message-ID: <20171219173727.41841-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17146 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750799AbdLSRha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Dec 2017 12:37:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Christoph Hellwig <hch@lst.de>

The function sas_parse_addr() could be easily substituted by hex2bin() which is
in kernel library code.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 58476b728c57..626727207889 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -27,6 +27,7 @@
 #include <linux/firmware.h>
 #include <linux/export.h>
 #include <linux/ctype.h>
+#include <linux/kernel.h>
 
 #include "sas_internal.h"
 
@@ -946,21 +947,6 @@ void sas_target_destroy(struct scsi_target *starget)
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
@@ -977,7 +963,9 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
 		goto out;
 	}
 
-	sas_parse_addr(addr, fw->data);
+	res = hex2bin(addr, fw->data, strnlen(fw->data, SAS_ADDR_SIZE * 2) / 2);
+	if (res)
+		goto out;
 
 out:
 	release_firmware(fw);
-- 
2.15.1
