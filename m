From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: Off-by-one bug in user page calculations for Direct I/O
Date: Mon, 17 Nov 2003 10:01:33 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311170959250.820-100000@ida.rowland.org>
References: <Pine.LNX.4.58.0311162341040.17544@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1028 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263262AbTKQPBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 10:01:36 -0500
In-Reply-To: <Pine.LNX.4.58.0311162341040.17544@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

Please apply the patch below to the scsi-bugfixes-2.6 tree.

Alan Stern


On Sun, 16 Nov 2003, Kai Makisara wrote:

> On Sun, 16 Nov 2003, Alan Stern wrote:
> 
> > The page count calculations in drivers/scsi/st.c (and copied in sg.c) are
> > wrong.  The code says:
> >
> > 	nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >>
> > 		PAGE_SHIFT;
> >
> > That will compute an incorrect value if the user's buffer happens to end
> > on the first byte of a new page.  Example:  Suppose uaddr starts right on
> 
> Your analysis is correct and this is a bug. Could you send the fix to
> James Bottomley for inclusion into the scsi-bugfixes-2.6 bk tree (at least
> the st part).
> 
> Thanks for noticing the bug.
> 
> 	Kai
> 
> P.S. I usually write these ((base ~ mask) + count + PAGE_SIZE - 1) >>
> PAGE_SHIFT. I don't know why I did it like this here. One should never try
> to be clever and do something in a new way or copy something that does not
> match one's own standard ways of doing things ;-)

On Mon, 17 Nov 2003, Douglas Gilbert wrote:

> Alan,
> ... and the sg part as well ..
> 
> > Thanks for noticing the bug.
> 
> dito
> 
> Doug Gilbert


===== sg.c 1.48 vs edited =====
--- 1.48/drivers/scsi/sg.c	Fri Oct 24 14:53:37 2003
+++ edited/drivers/scsi/sg.c	Mon Nov 17 09:57:36 2003
@@ -1627,7 +1627,7 @@
 	unsigned int nr_pages;
 	struct page **pages;
 
-	nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >> PAGE_SHIFT;
+	nr_pages = ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
 
 	/* User attempted Overflow! */
 	if ((uaddr + count) < uaddr)
===== st.c 1.45 vs edited =====
--- 1.45/drivers/scsi/st.c	Fri Sep  5 12:16:40 2003
+++ edited/drivers/scsi/st.c	Mon Nov 17 09:57:09 2003
@@ -4036,7 +4036,7 @@
 	unsigned int nr_pages;
 	struct page **pages;
 
-	nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >> PAGE_SHIFT;
+	nr_pages = ((uaddr & ~PAGE_MASK) + count + ~PAGE_MASK) >> PAGE_SHIFT;
 
 	/* User attempted Overflow! */
 	if ((uaddr + count) < uaddr)

