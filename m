From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Tue, 15 Jun 2004 14:34:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615213458.GC182050@sgi.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:1535 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S265955AbUFOVkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 17:40:19 -0400
Content-Disposition: inline
In-Reply-To: <40CF10AA.3050509@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Douglas Gilbert <dougg@torque.net>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Tue, Jun 15, 2004 at 11:07:22AM -0400, Jeff Garzik wrote:
> Jeremy Higdon wrote:
> >On Tue, Jun 15, 2004 at 04:47:11PM +1000, Douglas Gilbert wrote:
> >
> >>So I guess this patch only applies to sg_header usage since the
> >>users of sg_io_hdr (including SG_IO ioctl users) must explicitly
> >>give the data direction.
> >
> >
> >Correct.  Several apps declare a response length greater than the
> >absolute minimum, not realizing that this confuses sg, causing
> >direction to get set incorrectly, and requiring the host drivers
> >to have their own tables.
> 
> 
> We're still at "hacking the kernel to fix broken apps"  :(:(
> 
> 	Jeff

Okay.  How about this then.  At least it will fail in a noisy way,
so that host adapter driver maintainers will not be pressured to "fix"
their drivers (which is how the direction override code ended up in
qlogic and mpt in the first place).

===== drivers/scsi/sg.c 1.90 vs edited =====
--- 1.90/drivers/scsi/sg.c	Sat May 29 10:57:23 2004
+++ edited/drivers/scsi/sg.c	Tue Jun 15 14:04:39 2004
@@ -552,9 +552,19 @@
 	hp->cmd_len = (unsigned char) cmd_size;
 	hp->iovec_count = 0;
 	hp->mx_sb_len = 0;
-	if (input_size > 0)
-		hp->dxfer_direction = (old_hdr.reply_len > SZ_SG_HEADER) ?
-		    SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
+	if (input_size > 0) {	/* data is being sent to device */
+		if (old_hdr.reply_len <= SZ_SG_HEADER)
+			hp->dxfer_direction = SG_DXFER_TO_DEV;
+		else {
+			printk("sg_write: cannot infer direction from count %ld "
+			       "and reply_len %d.  Command 0x%x will probably fail. "
+			       "Please fix the application to use proper counts or "
+			       "the sg version 3 interface\n",
+			       count, old_hdr.reply_len, (unsigned int) cmnd[0]);
+			/* SG_DXFER_TO_FROM_DEV is equivalent to SG_DXFER_FROM_DEV */
+			hp->dxfer_direction = SG_DXFER_TO_FROM_DEV;
+		}
+	}
 	else
 		hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
 	hp->dxfer_len = mxsize;
