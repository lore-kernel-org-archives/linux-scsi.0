From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: Off-by-one bug in user page calculations for Direct I/O
Date: Sun, 16 Nov 2003 12:04:18 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311161151400.1071-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:50439 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S263015AbTKPRET
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2003 12:04:19 -0500
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi, Douglas Gilbert <dougg@torque.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

The page count calculations in drivers/scsi/st.c (and copied in sg.c) are
wrong.  The code says:

	nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >> 
		PAGE_SHIFT;

That will compute an incorrect value if the user's buffer happens to end 
on the first byte of a new page.  Example:  Suppose uaddr starts right on 
a page boundary and count is PAGE_SIZE + 1.  Then

	(uaddr & ~PAGE_MASK)	->  0
	count - 1		->  PAGE_SIZE
	~PAGE_MASK		->  PAGE_SIZE - 1

	nr_pages		-> (2 * PAGE_SIZE - 1) >> PAGE_SHIFT = 1

when in fact nr_pages should be 2.  Either the "- 1" shouldn't be there or 
the second "~PAGE_MASK" should be replaced by "PAGE_SIZE".

Alan Stern


--- a/drivers/scsi/st.c	Fri Sep  5 13:58:01 2003
+++ b/drivers/scsi/st.c	Sun Nov 16 11:44:47 2003
@@ -4036,7 +4036,7 @@
 	unsigned int nr_pages;
 	struct page **pages;
 
-	nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >> PAGE_SHIFT;
+	nr_pages = ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
 
 	/* User attempted Overflow! */
 	if ((uaddr + count) < uaddr)
--- a/drivers/scsi/sg.c	Mon Oct 20 10:19:01 2003
+++ b/drivers/scsi/sg.c	Sun Nov 16 11:45:10 2003
@@ -1625,7 +1625,7 @@
 	unsigned int nr_pages;
 	struct page **pages;
 
-	nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >> PAGE_SHIFT;
+	nr_pages = ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
 
 	/* User attempted Overflow! */
 	if ((uaddr + count) < uaddr)

