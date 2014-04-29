From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] scsi: remove private hex2bin() implementation
Date: Tue, 29 Apr 2014 17:42:06 +0300
Message-ID: <1398782526-12592-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46786 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757710AbaD2OmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2014 10:42:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>

The function sas_parse_addr() could be easily substituted by hex2bin() which is
in kernel library code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/libsas/sas_scsi_host.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 25d0f12..03344ad 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -27,6 +27,7 @@
 #include <linux/firmware.h>
 #include <linux/export.h>
 #include <linux/ctype.h>
+#include <linux/kernel.h>
 
 #include "sas_internal.h"
 
@@ -1167,21 +1168,6 @@ void sas_target_destroy(struct scsi_target *starget)
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
@@ -1198,7 +1184,12 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
 		goto out;
 	}
 
-	sas_parse_addr(addr, fw->data);
+	res = hex2bin(addr, fw->data,
+		      min_t(size_t, SAS_ADDR_SIZE, strlen(fw->data)) / 2);
+	if (res) {
+		res = -EINVAL;
+		goto out;
+	}
 
 out:
 	release_firmware(fw);
-- 
1.9.2

