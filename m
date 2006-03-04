From: Ralf Baechle <ralf@linux-mips.org>
Subject: [SCSI] Avoid ld errors messages by marking sd_major noinline.
Date: Sat, 4 Mar 2006 17:16:09 +0000
Message-ID: <20060304171609.GA23288@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:57494 "EHLO
	ftp.linux-mips.org") by vger.kernel.org with ESMTP id S932218AbWCDRQN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 12:16:13 -0500
Received: from localhost.localdomain ([127.0.0.1]:20103 "EHLO bacchus.dhis.org")
	by ftp.linux-mips.org with ESMTP id S8133495AbWCDRH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2006 17:07:59 +0000
Received: from denk.linux-mips.net (denk.linux-mips.net [127.0.0.1])
	by bacchus.dhis.org (8.13.4/8.13.4) with ESMTP id k24HG9Zs023297
	for <linux-scsi@vger.kernel.org>; Sat, 4 Mar 2006 17:16:09 GMT
Received: (from ralf@localhost)
	by denk.linux-mips.net (8.13.4/8.13.4/Submit) id k24HG9Gm023296
	for linux-scsi@vger.kernel.org; Sat, 4 Mar 2006 17:16:09 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Gcc may compile sd_major() using a jump table which it will put into
.rodata.  If also inline sd_major's function body into exit_sd() and
CONFIG_BLK_DEV_SD has been set to y ld is going to discard exit_sd's
code later at link time.  It won't discard the jump table if was put
into another section than .exit.data and so the remaining refernces
to sd_major's function body will result in about 100 lines of non-fatal
linker error messages.  This is avoided by marking sd_major noinline.

Observed on MIPS with GCC 4.0.2 and 4.1.0 but not 3.4.5 and seems
possible on other architectures such as i386.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9d98723..f1af700 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -158,8 +158,16 @@ static struct scsi_driver sd_template = 
  * for major1, ... 
  * As we stay compatible with our numbering scheme, we can reuse 
  * the well-know SCSI majors 8, 65--71, 136--143.
+ *
+ * Gcc may compile sd_major() using a jump table which it will put into
+ * .rodata.  If also inline sd_major's function body into exit_sd() and
+ * CONFIG_BLK_DEV_SD has been set to y ld is going to discard exit_sd's
+ * code later at link time.  It won't discard the jump table if was put
+ * into another section than .exit.data and so the remaining refernces to
+ * sd_major's function body will result in about 100 lines of non-fatal
+ * linker error messages.  This is avoided by marking sd_major noinline.
  */
-static int sd_major(int major_idx)
+static noinline int sd_major(int major_idx)
 {
 	switch (major_idx) {
 	case 0:
