From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Thu, 26 Aug 2004 00:09:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040826070935.GA126538@sgi.com>
References: <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com> <20040615221558.GA181797@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:7592 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267703AbUHZHKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 03:10:19 -0400
Content-Disposition: inline
In-Reply-To: <20040615221558.GA181797@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dougg@torque.net>, james.bottomley@steeleye.com

I still think that this change should go into the sg1/sg2 command
issue path, so that a warning is issued when sg has to guess on
command direction.  This will encourage developers to fix up apps
that don't set buffer sizes properly.

Doug, can you comment on this?  If you don't like it, I'll drop
it  :-)

This patch is against 2.6.9-rc1.

thanks,

jeremy

===== drivers/scsi/sg.c 1.95 vs edited =====
--- 1.95/drivers/scsi/sg.c	2004-08-07 19:11:33 -07:00
+++ edited/drivers/scsi/sg.c	2004-08-26 00:04:25 -07:00
@@ -564,6 +564,17 @@
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
