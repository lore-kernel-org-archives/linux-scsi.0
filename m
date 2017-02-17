From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] smartpqi: fix time handling
Date: Fri, 17 Feb 2017 16:03:52 +0100
Message-ID: <20170217150417.2458237-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:59017 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934072AbdBQPEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2017 10:04:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, kevin Barnett <kevin.barnett@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, Scott Benesh <scott.benesh@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

When we have turned off RTC support, the smartpqi driver fails to build:

ERROR: "rtc_time64_to_tm" [drivers/scsi/smartpqi/smartpqi.ko] undefined!

This is easily avoided by using the generic 'struct tm' based helper rather
than the RTC specific one. While fixing this, I noticed that even though
the driver uses time64_t for storing seconds, it gets them from the
old 32-bit struct timeval. To address this, we can simplify the code
by calling ktime_get_real_seconds() directly.

Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 11c0dfb3dfa3..657ad15682a3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -534,8 +534,7 @@ static int pqi_write_current_time_to_host_wellness(
 	size_t buffer_length;
 	time64_t local_time;
 	unsigned int year;
-	struct timeval time;
-	struct rtc_time tm;
+	struct tm tm;
 
 	buffer_length = sizeof(*buffer);
 
@@ -552,9 +551,8 @@ static int pqi_write_current_time_to_host_wellness(
 	put_unaligned_le16(sizeof(buffer->time),
 		&buffer->time_length);
 
-	do_gettimeofday(&time);
-	local_time = time.tv_sec - (sys_tz.tz_minuteswest * 60);
-	rtc_time64_to_tm(local_time, &tm);
+	local_time = ktime_get_real_seconds();
+	time64_to_tm(local_time, -sys_tz.tz_minuteswest * 60, &tm);
 	year = tm.tm_year + 1900;
 
 	buffer->time[0] = bin2bcd(tm.tm_hour);
-- 
2.9.0
