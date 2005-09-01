From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg direct io/mmap oops, st sync
Date: Thu, 01 Sep 2005 21:50:02 +1000
Message-ID: <4316EAEA.5050800@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010006070009080204080201"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:63703 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S965088AbVIALtv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2005 07:49:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kai.Makisara@kolumbus.fi, James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------010006070009080204080201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch has the same effect of stopping the oops
as that described in:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112540053711489&w=2
titled: "[PATCH] sg direct io/mmap oops".

This patch adopts the same solution as proposed by Kai M. in
a post titled: "[PATCH] SCSI tape signed/unsigned fix".
The fix is in a function that the sg driver borrowed from
the st driver so its maintenance is a little easier if
the functions remain the same after the fix.

James, please apply this patch rather than the earlier one
(referenced above) that I posted for the sg driver.

Changelog:
   - change nr_pages type from unsigned to signed so errors
     from get_user_pages() call are properly handled

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------010006070009080204080201
Content-Type: text/x-patch;
 name="sg_2613kai.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2613kai.diff"

--- linux/drivers/scsi/sg.c	2005-08-29 18:28:23.000000000 +1000
+++ linux/drivers/scsi/sg.c2613kai	2005-09-01 21:30:39.000000000 +1000
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20050328";
+static char *sg_version_date = "20050901";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -1795,12 +1795,12 @@
 	          unsigned long uaddr, size_t count, int rw,
 	          unsigned long max_pfn)
 {
+	unsigned long end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	unsigned long start = uaddr >> PAGE_SHIFT;
+	const int nr_pages = end - start;
 	int res, i, j;
-	unsigned int nr_pages;
 	struct page **pages;
 
-	nr_pages = ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
-
 	/* User attempted Overflow! */
 	if ((uaddr + count) < uaddr)
 		return -EINVAL;

--------------010006070009080204080201--
