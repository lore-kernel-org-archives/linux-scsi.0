From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Thu, 26 Aug 2004 18:12:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040827011252.GA131916@sgi.com>
References: <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com> <20040615221558.GA181797@sgi.com> <20040826070935.GA126538@sgi.com> <412DA2F8.8080607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:25274 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S269924AbUH0BNy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 21:13:54 -0400
Content-Disposition: inline
In-Reply-To: <412DA2F8.8080607@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

On Thu, Aug 26, 2004 at 06:44:40PM +1000, Douglas Gilbert wrote:
> Jeremy,
> Perhaps the first argument of printk() could be prefixed with
> KERN_WARNING to make it a bit more syslog friendly.
> Otherwise ok.
> 
> Doug Gilbert

You're right.  It's fixed in this patch.
James, if you're satisfied, please apply.

thanks,
jeremy

signed-off-by: jeremy@sgi.com

===== drivers/scsi/sg.c 1.95 vs edited =====
--- 1.95/drivers/scsi/sg.c	2004-08-07 19:11:33 -07:00
+++ edited/drivers/scsi/sg.c	2004-08-26 17:19:58 -07:00
@@ -564,6 +564,18 @@
 	hp->usr_ptr = NULL;
 	if (__copy_from_user(cmnd, buf, cmd_size))
 		return -EFAULT;
+	/*
+	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
+	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
+	 * is a non-zero input_size, so emit a warning.
+	 */
+	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
+		printk(KERN_WARNING
+		       "sg_write: cannot infer direction from count %ld "
+		       "and reply_len %d.  Command 0x%x will probably fail. "
+		       "Please fix the application to use proper counts or "
+		       "the sg version 3 interface\n",
+		       count, old_hdr.reply_len, (unsigned int) cmnd[0]);
 	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
 	return (k < 0) ? k : count;
 }
