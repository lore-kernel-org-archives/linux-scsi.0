From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Tue, 15 Jun 2004 15:15:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615221558.GA181797@sgi.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:10629 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S266000AbUFOWSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 18:18:55 -0400
Content-Disposition: inline
In-Reply-To: <20040615213458.GC182050@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Douglas Gilbert <dougg@torque.net>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Tue, Jun 15, 2004 at 02:34:58PM -0700, Jeremy Higdon wrote:
> 
> Okay.  How about this then.  At least it will fail in a noisy way,
> so that host adapter driver maintainers will not be pressured to "fix"
> their drivers (which is how the direction override code ended up in
> qlogic and mpt in the first place).

Sorry -- I sent that one out too quickly -- it uses cmnd[0] before it is
set.  This patch is smaller and more correct.

Does anyone have objections to this?  I don't think we need to ratelimit
these printks, because whatever is causing them is likely experiencing
I/O errors and will probably give up.

===== drivers/scsi/sg.c 1.90 vs edited =====
--- 1.90/drivers/scsi/sg.c	Sat May 29 10:57:23 2004
+++ edited/drivers/scsi/sg.c	Tue Jun 15 15:05:47 2004
@@ -566,6 +566,17 @@
 	hp->usr_ptr = NULL;
 	if (__copy_from_user(cmnd, buf, cmd_size))
 		return -EFAULT;
+	/*
+	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
+	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
+	 * is a non-zero input_size, so emit a warning.
+	 */
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
+		printk("sg_write: cannot infer direction from count %ld "
+		       "and reply_len %d.  Command 0x%x will probably fail. "
+		       "Please fix the application to use proper counts or "
+		       "the sg version 3 interface\n",
+		       count, old_hdr.reply_len, (unsigned int) cmnd[0]);
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
