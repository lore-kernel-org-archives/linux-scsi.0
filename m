From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI tape signed/unsigned fix
Date: Wed, 31 Aug 2005 23:12:05 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0508312304580.2962@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:49640 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S964927AbVHaUHO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 16:07:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>

This patch fixes in st.c the bug in the signed/unsigned int comparison
reported by Doug Gilbert and fixed by him in sg.c (see [PATCH] sg direct
io/mmap oops). Doug fixed the comparison in sg.c. This fix for st.c does not
touch the comparison but makes both arguments signed to remove the
problem. The new code is adapted from linux/fs/bio.c.

Doug's fix is correct and simple, no question about it. I just have learned to
hate these signed/unsigned comparisons where they can be avoided (having
originally created this bug is one more reason ;-)

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.13/drivers/scsi/st.c	2005-08-29 21:04:57.000000000 +0300
+++ linux-2.6.13-k1/drivers/scsi/st.c	2005-08-30 21:35:14.000000000 +0300
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050501";
+static char *verstr = "20050830";
 
 #include <linux/module.h>
 
@@ -4348,12 +4348,12 @@ static int st_map_user_pages(struct scat
 static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages, 
 			      unsigned long uaddr, size_t count, int rw)
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
