From: Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH] [SCSI] mvumi: 64bit value for seconds_since1970
Date: Wed, 25 Feb 2015 07:43:54 +0530
Message-ID: <20150225021354.GA2794@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44141 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbBYCOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2015 21:14:05 -0500
Received: by padet14 with SMTP id et14so1278044pad.11
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2015 18:14:04 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

struct mvumi_hs_page2 stores a "seconds_since1970" field which is of
type u64. It is however, written to, using 'struct timeval' which has
a 32-bit seconds field and whose value will overflow in year 2038.
This patch uses ktime_get_real_seconds() instead since it provides a
64-bit seconds value, which is 2038 safe.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 drivers/scsi/mvumi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 3e6b866..02360de 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/ktime.h>
 #include <linux/blkdev.h>
 #include <linux/io.h>
 #include <scsi/scsi.h>
@@ -858,8 +859,8 @@ static void mvumi_hs_build_page(struct mvumi_hba *mhba,
 	struct mvumi_hs_page2 *hs_page2;
 	struct mvumi_hs_page4 *hs_page4;
 	struct mvumi_hs_page3 *hs_page3;
-	struct timeval time;
-	unsigned int local_time;
+	u64 time;
+	u64 local_time;
 
 	switch (hs_header->page_code) {
 	case HS_PAGE_HOST_INFO:
@@ -877,9 +878,8 @@ static void mvumi_hs_build_page(struct mvumi_hba *mhba,
 		hs_page2->slot_number = 0;
 		hs_page2->intr_level = 0;
 		hs_page2->intr_vector = 0;
-		do_gettimeofday(&time);
-		local_time = (unsigned int) (time.tv_sec -
-						(sys_tz.tz_minuteswest * 60));
+		time = ktime_get_real_seconds();
+		local_time = (time - (sys_tz.tz_minuteswest * 60));
 		hs_page2->seconds_since1970 = local_time;
 		hs_header->checksum = mvumi_calculate_checksum(hs_header,
 						hs_header->frame_length);
-- 
2.2.0.rc0.207.ga3a616c

