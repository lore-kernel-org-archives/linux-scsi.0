From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Fri, 27 Aug 2004 01:10:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040827081024.GA133749@sgi.com>
References: <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <40CE9B6F.8000301@torque.net> <20040615074137.GA179379@sgi.com> <40CF10AA.3050509@pobox.com> <20040615213458.GC182050@sgi.com> <20040615221558.GA181797@sgi.com> <20040826070935.GA126538@sgi.com> <412DA2F8.8080607@torque.net> <20040827011252.GA131916@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:1698 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S267879AbUH0ILJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 04:11:09 -0400
Content-Disposition: inline
In-Reply-To: <20040827011252.GA131916@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

On Thu, Aug 26, 2004 at 06:12:53PM -0700, Jeremy Higdon wrote:
> On Thu, Aug 26, 2004 at 06:44:40PM +1000, Douglas Gilbert wrote:
> > Jeremy,
> > Perhaps the first argument of printk() could be prefixed with
> > KERN_WARNING to make it a bit more syslog friendly.
> > Otherwise ok.
> > 
> > Doug Gilbert
> 
> You're right.  It's fixed in this patch.
> James, if you're satisfied, please apply.

This is one of those days when I seem to be working against myself.
It turns out that our RAID vendor modified their agent to trim
the "reply_len" field for write commands, but did not trim the
"count" field for read commands.  So in this case, sg actually
guesses correctly when it needs to, and the app works.  Only with
this patch, /var/log/messages gets filled with this new error
message.

Doug, what do you think is the right thing to do?

jeremy

> thanks,
> jeremy
> 
> signed-off-by: jeremy@sgi.com
> 
> ===== drivers/scsi/sg.c 1.95 vs edited =====
> --- 1.95/drivers/scsi/sg.c	2004-08-07 19:11:33 -07:00
> +++ edited/drivers/scsi/sg.c	2004-08-26 17:19:58 -07:00
> @@ -564,6 +564,18 @@
>  	hp->usr_ptr = NULL;
>  	if (__copy_from_user(cmnd, buf, cmd_size))
>  		return -EFAULT;
> +	/*
> +	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
> +	 * but is is possible that the app intended SG_DXFER_TO_DEV, because there
> +	 * is a non-zero input_size, so emit a warning.
> +	 */
> +	if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
> +		printk(KERN_WARNING
> +		       "sg_write: cannot infer direction from count %ld "
> +		       "and reply_len %d.  Command 0x%x will probably fail. "
> +		       "Please fix the application to use proper counts or "
> +		       "the sg version 3 interface\n",
> +		       count, old_hdr.reply_len, (unsigned int) cmnd[0]);
>  	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
>  	return (k < 0) ? k : count;
>  }
