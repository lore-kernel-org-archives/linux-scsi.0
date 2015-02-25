From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH v2] scsi: stex: Remove use of struct timeval
Date: Wed, 25 Feb 2015 07:41:36 +0530
Message-ID: <20150225021136.GA2728@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38678 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbbBYCLr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2015 21:11:47 -0500
Received: by padbj1 with SMTP id bj1so1329662pad.5
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2015 18:11:47 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

Function stex_gettime uses 'struct timeval' whose tv_sec value
will overflow on 32-bit systems in year 2038 and beyond. This patch
replaces the use of struct timeval and do_gettimeofday with
ktime_get_real_seconds, which returns a 64-bit seconds value.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
--
Changes in v2:
- Change subject line to indicate that the patch is restricted to stex driver.
---
 drivers/scsi/stex.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 98a62bc..40b6290 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -25,6 +25,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/ktime.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -364,10 +365,7 @@ MODULE_VERSION(ST_DRIVER_VERSION);
 
 static void stex_gettime(__le64 *time)
 {
-	struct timeval tv;
-
-	do_gettimeofday(&tv);
-	*time = cpu_to_le64(tv.tv_sec);
+	*time = cpu_to_le64(ktime_get_real_seconds());
 }
 
 static struct status_msg *stex_get_status(struct st_hba *hba)
-- 
2.2.0.rc0.207.ga3a616c

