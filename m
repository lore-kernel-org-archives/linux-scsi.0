From: akpm@linux-foundation.org
Subject: [patch 4/6] drivers/scsi/sg.c: convert to kstrtoul_from_user()
Date: Tue, 10 Jan 2012 15:42:34 -0800
Message-ID: <20120110234235.774BF200133@hpza10.eem.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64968 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab2AJXmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 18:42:38 -0500
Received: by mail-ey0-f202.google.com with SMTP id k10so4933eaa.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2012 15:42:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, sboyd@codeaurora.org, dgilbert@interlog.com, dougg@torque.net

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: drivers/scsi/sg.c: convert to kstrtoul_from_user()

Instead of open coding this function use kstrtoul_from_user() directly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/sg.c~drivers-scsi-sgc-convert-to-kstrtoul_from_user drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~drivers-scsi-sgc-convert-to-kstrtoul_from_user
+++ a/drivers/scsi/sg.c
@@ -2368,16 +2368,15 @@ static ssize_t 
 sg_proc_write_adio(struct file *filp, const char __user *buffer,
 		   size_t count, loff_t *off)
 {
-	int num;
-	char buff[11];
+	int err;
+	unsigned long num;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	sg_allow_dio = simple_strtoul(buff, NULL, 10) ? 1 : 0;
+	err = kstrtoul_from_user(buffer, count, 0, &num);
+	if (err)
+		return err;
+	sg_allow_dio = num ? 1 : 0;
 	return count;
 }
 
@@ -2390,17 +2389,15 @@ static ssize_t 
 sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 		     size_t count, loff_t *off)
 {
-	int num;
+	int err;
 	unsigned long k = ULONG_MAX;
-	char buff[11];
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
-	num = (count < 10) ? count : 10;
-	if (copy_from_user(buff, buffer, num))
-		return -EFAULT;
-	buff[num] = '\0';
-	k = simple_strtoul(buff, NULL, 10);
+
+	err = kstrtoul_from_user(buffer, count, 0, &k);
+	if (err)
+		return err;
 	if (k <= 1048576) {	/* limit "big buff" to 1 MB */
 		sg_big_buff = k;
 		return count;
_
