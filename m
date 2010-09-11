From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH] drivers: scsi: remove private hex_to_bin() implementation
Date: Sat, 11 Sep 2010 16:38:00 +0300
Message-ID: <1284212280-25944-1-git-send-email-andy.shevchenko@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/libsas/sas_scsi_host.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0cfba9..527dcf7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1078,14 +1078,10 @@ void sas_target_destroy(struct scsi_target *starget)
 static void sas_parse_addr(u8 *sas_addr, const char *p)
 {
 	int i;
-	for (i = 0; i < SAS_ADDR_SIZE; i++) {
+	for (i = 0; i < SAS_ADDR_SIZE && *p; i++) {
 		u8 h, l;
-		if (!*p)
-			break;
-		h = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
-		p++;
-		l = isdigit(*p) ? *p-'0' : toupper(*p)-'A'+10;
-		p++;
+		h = hex_to_bin(*p++);
+		l = hex_to_bin(*p++);
 		sas_addr[i] = (h<<4) | l;
 	}
 }
-- 
1.7.2.2
