From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to warn about ambiguous data direction
Date: Mon, 30 Aug 2004 00:08:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040830070830.GA160316@sgi.com>
References: <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com> <20040615221558.GA181797@sgi.com> <20040826070935.GA126538@sgi.com> <412DA2F8.8080607@torque.net> <20040827011252.GA131916@sgi.com> <20040827081024.GA133749@sgi.com> <41301339.1020108@torque.net> <20040828093945.GB137773@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:39343 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S265773AbUH3HJL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 03:09:11 -0400
Content-Disposition: inline
In-Reply-To: <20040828093945.GB137773@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

On Sat, Aug 28, 2004 at 02:39:45AM -0700, Jeremy Higdon wrote:
> > Jeremy,
> > You could use a (block scope) static and only print out
> > the warning the first time it is detected.
> > 
> > Doug Gilbert
> 
> Yes, that's a good idea -- I'll add a rate limiter and also print
> out the process name like James does in his recent deprecated
> ioctl warning patch.  I'll send a new patch out later this weekend.
> Sorry for the churn.
> 
> thanks
> 
> jeremy

Okay, I'm pretty happy with this.  I get this kind of output:

sg_write: data in/out 512/512 bytes for SCSI command 0x8--guessing data in;
   program java not setting count and/or reply_len properly
printk: 11 messages suppressed.
sg_write: data in/out 512/512 bytes for SCSI command 0x8--guessing data in;
   program java not setting count and/or reply_len properly
printk: 4 messages suppressed.


signed-off-by: jeremy@sgi.com

===== drivers/scsi/sg.c 1.95 vs edited =====
--- 1.95/drivers/scsi/sg.c	2004-08-07 19:11:33 -07:00
+++ edited/drivers/scsi/sg.c	2004-08-29 23:22:21 -07:00
@@ -564,6 +564,19 @@
 	hp->usr_ptr = NULL;
 	if (__copy_from_user(cmnd, buf, cmd_size))
 		return -EFAULT;
+	/*
+	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
+	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
+	 * is a non-zero input_size, so emit a warning.
+	 */
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
+		if (printk_ratelimit())
+			printk(KERN_WARNING
+			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
+			       "guessing data in;\n" KERN_WARNING "   "
+			       "program %s not setting count and/or reply_len properly\n",
+			       old_hdr.reply_len - SZ_SG_HEADER, input_size,
+			       (unsigned int) cmnd[0], current->comm);
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
