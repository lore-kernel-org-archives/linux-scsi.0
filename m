From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Fri, 8 Feb 2008 11:46:13 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802081143010.4593-100000@iolanthe.rowland.org>
References: <20080205175403.GA31714@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080205175403.GA31714-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 5 Feb 2008, Matthew Dharm wrote:

> We both agree that the code shouldn't run off the end of the s-g list.

Incidentally, if people want a simple bugfix patch for 2.6.24.stable, 
this should do it.  Mark, can you confirm that this patch alone fixes 
the problem?

Alan Stern



Index: 2.6.24/drivers/usb/storage/protocol.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/protocol.c
+++ 2.6.24/drivers/usb/storage/protocol.c
@@ -194,7 +194,7 @@ unsigned int usb_stor_access_xfer_buf(un
 		 * and the starting offset within the page, and update
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
-		while (cnt < buflen) {
+		while (cnt < buflen && sg) {
 			struct page *page = sg_page(sg) +
 					((sg->offset + *offset) >> PAGE_SHIFT);
 			unsigned int poff =
@@ -249,6 +249,7 @@ void usb_stor_set_xfer_buf(unsigned char
 	unsigned int offset = 0;
 	struct scatterlist *sg = NULL;
 
+	buflen = min(buflen, srb->request_bufflen);
 	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
 			TO_XFER_BUF);
 	if (buflen < srb->request_bufflen)
