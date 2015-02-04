From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH] scsi: Remove use of struct timeval
Date: Wed, 4 Feb 2015 08:34:48 +0530
Message-ID: <20150204030448.GA3666@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64087 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbBDDEx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 22:04:53 -0500
Received: by mail-pa0-f44.google.com with SMTP id rd3so104282926pab.3
        for <linux-scsi@vger.kernel.org>; Tue, 03 Feb 2015 19:04:53 -0800 (PST)
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

