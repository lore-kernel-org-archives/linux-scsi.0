From: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
Subject: [PATCH] Staging: rts5208: Replace timeval with timespec64
Date: Thu, 30 Apr 2015 19:00:23 +0200
Message-ID: <1430413223-8021-1-git-send-email-ksenija.stanojevic@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38176 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbbD3RAl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 13:00:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, y2038@lists.linaro.org, Ksenija Stanojevic <ksenija.stanojevic@gmail.com>

struct timeval tv is used to get current time.
32-bit systems using 'struct timeval' will break in the year 2038, so
we have to replace that code with more appropriate types.

Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rts5208/rtsx.h | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.h b/drivers/staging/rts5208/rtsx.h
index 9e6ecb7..f768fc0 100644
--- a/drivers/staging/rts5208/rtsx.h
+++ b/drivers/staging/rts5208/rtsx.h
@@ -37,7 +37,7 @@
 #include <linux/cdrom.h>
 #include <linux/workqueue.h>
 #include <linux/timer.h>
-#include <linux/time.h>
+#include <linux/time64.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -151,21 +151,24 @@ static inline struct rtsx_dev *host_to_rtsx(struct Scsi_Host *host)
 
 static inline void get_current_time(u8 *timeval_buf, int buf_len)
 {
-	struct timeval tv;
+	struct timespec64 ts64;
+	u32 tv_usec;
 
 	if (!timeval_buf || (buf_len < 8))
 		return;
 
-	do_gettimeofday(&tv);
+	getnstimeofday64(&ts64);
 
-	timeval_buf[0] = (u8)(tv.tv_sec >> 24);
-	timeval_buf[1] = (u8)(tv.tv_sec >> 16);
-	timeval_buf[2] = (u8)(tv.tv_sec >> 8);
-	timeval_buf[3] = (u8)(tv.tv_sec);
-	timeval_buf[4] = (u8)(tv.tv_usec >> 24);
-	timeval_buf[5] = (u8)(tv.tv_usec >> 16);
-	timeval_buf[6] = (u8)(tv.tv_usec >> 8);
-	timeval_buf[7] = (u8)(tv.tv_usec);
+	tv_usec = ts64.tv_nsec/NSEC_PER_USEC;
+
+	timeval_buf[0] = (u8)(ts64.tv_sec >> 24);
+	timeval_buf[1] = (u8)(ts64.tv_sec >> 16);
+	timeval_buf[2] = (u8)(ts64.tv_sec >> 8);
+	timeval_buf[3] = (u8)(ts64.tv_sec);
+	timeval_buf[4] = (u8)(tv_usec >> 24);
+	timeval_buf[5] = (u8)(tv_usec >> 16);
+	timeval_buf[6] = (u8)(tv_usec >> 8);
+	timeval_buf[7] = (u8)(tv_usec);
 }
 
 /* The scsi_lock() and scsi_unlock() macros protect the sm_state and the
-- 
1.9.1

