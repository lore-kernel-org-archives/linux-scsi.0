From: akpm@google.com
Subject: [patch 6/8] drivers/scsi/sg.c: convert to kstrtoul_from_user()
Date: Tue, 20 Sep 2011 14:20:21 -0700
Message-ID: <201109202120.p8KLKL3I025337@wpaz24.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:2832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1ITVU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 17:20:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@google.com, sboyd@codeaurora.org, dgilbert@interlog.com, dougg@torque.net

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: drivers/scsi/sg.c: convert to kstrtoul_from_user()

Instead of open coding this function use kstrtoul_from_user() directly.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/scsi/sg.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/sg.c~drivers-scsi-sgc-convert-to-kstrtoul_from_user drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~drivers-scsi-sgc-convert-to-kstrtoul_from_user
+++ a/drivers/scsi/sg.c
@@ -2369,16 +2369,15 @@ static ssize_t 
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
 
@@ -2391,17 +2390,15 @@ static ssize_t 
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
