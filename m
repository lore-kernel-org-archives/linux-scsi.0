From: Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>
Subject: Re: [linux-usb-devel] Re: Unaligned scatter-gather buffers and usb-storage
Date: Thu, 20 Nov 2003 21:18:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120191859.GA3569@kai.makisara.local>
References: <Pine.LNX.4.44L0.0311201015030.878-100000@ida.rowland.org> <Pine.LNX.4.58.0311201911070.2302@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:32481 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262901AbTKTTTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 14:19:04 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0311201911070.2302@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Patrick Mansfield <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

Thus spake Kai Makisara (Kai.Makisara@kolumbus.fi):

> On Thu, 20 Nov 2003, Alan Stern wrote:
> 
...
> > The answer seems very simple.  There should be a host template entry for
> > dma buffer alignment (there's already a dma_boundary member).  It would be
> > copied into the device's request queue stucture if it is nonzero,
> > overriding the default value of 512.  sg and st should check the user
> > buffer against the request queue's dma_alignment mask and avoid doing
> > direct I/O if the alignment is wrong -- just fall back to normal I/O.
> >
> > Any objections to this scheme?
> >
> My only objection is the default. It should be zero. If I read the
> usb-storage sources correctly, the scsi_host_template is defined in one
> file (scsiglue.c). If the mask is there set to 511, all USB storage
> devices get 512-byte alignment and other get no constraints. All get
> optimal result with minimal work. (Adding the check to st and sg is
> trivial.)
> 
To make this a little more than talk, here is a patch for 2.6.0-test9 plus
csets up to today (compiled and tested but does not include the check for sg):
---8<---
diff -ur linux-2.6-cset/drivers/scsi/st.c linux-2.6-cset-k/drivers/scsi/st.c
--- linux-2.6-cset/drivers/scsi/st.c	2003-09-09 18:19:45.000000000 +0300
+++ linux-2.6-cset-k/drivers/scsi/st.c	2003-11-20 20:49:25.000000000 +0200
@@ -1267,7 +1267,8 @@
 		i = STp->try_dio && try_rdio;
 	else
 		i = STp->try_dio && try_wdio;
-	if (i) {
+
+	if (i && ((unsigned int)buf & STp->device->host->hostt->dma_align_mask) == 0) {
 		i = st_map_user_pages(&(STbp->sg[0]), STbp->use_sg,
 				      (unsigned long)buf, count, (is_read ? READ : WRITE),
 				      STp->max_pfn);
diff -ur linux-2.6-cset/drivers/usb/storage/scsiglue.c linux-2.6-cset-k/drivers/usb/storage/scsiglue.c
--- linux-2.6-cset/drivers/usb/storage/scsiglue.c	2003-10-25 22:35:58.000000000 +0300
+++ linux-2.6-cset-k/drivers/usb/storage/scsiglue.c	2003-11-20 19:34:56.000000000 +0200
@@ -312,6 +312,9 @@
 	/* lots of sg segments can be handled */
 	.sg_tablesize =			SG_ALL,
 
+	/* alignment to 512-byte required */
+	.dma_align_mask =		0x1ff,
+
 	/* merge commands... this seems to help performance, but
 	 * periodically someone should test to see which setting is more
 	 * optimal.
Only in linux-2.6-cset/include/asm: page.h~
Only in linux-2.6-cset/include/asm-i386: page.h~
diff -ur linux-2.6-cset/include/scsi/scsi_host.h linux-2.6-cset-k/include/scsi/scsi_host.h
--- linux-2.6-cset/include/scsi/scsi_host.h	2003-10-25 22:35:58.000000000 +0300
+++ linux-2.6-cset-k/include/scsi/scsi_host.h	2003-11-20 19:33:32.000000000 +0200
@@ -268,6 +268,12 @@
 	unsigned long dma_boundary;
 
 	/*
+	 * Alignment mask for scatter/gather segments. The offset and'ed
+	 * with the mask must be zero for segments.
+	 */
+	unsigned int dma_align_mask;
+
+	/*
 	 * This specifies "machine infinity" for host templates which don't
 	 * limit the transfer size.  Note this limit represents an absolute
 	 * maximum, and may be over the transfer limits allowed for
---8<---

-- 
Kai
