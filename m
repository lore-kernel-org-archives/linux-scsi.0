From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 16:06:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312131602520.1185-100000@iolanthe.rowland.org>
References: <1386964999.2055.59.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60588 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750822Ab3LMVGX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2013 16:06:23 -0500
In-Reply-To: <1386964999.2055.59.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 13 Dec 2013, James Bottomley wrote:

> Actually, I think I have this figured out.  There's a thinko in one of
> the scsi_target_reap() cases.  The original (and still existing) problem
> with targets is that nothing creates them and nothing destroys them, so,
> while we could rely on the refcounting of the device model to preserve
> the actual target object, we had no idea when to remove it from
> visibility.  That was the job of the reap reference, to track
> visibility.  It looks like the reap on device last put is occurring too
> late.  I think we should reap immediately after doing the sdev
> device_del, so does this fix the warn on? (I'm not sure because no-one
> has actually posted a backtrace, but it sounds like this is the
> problem).
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 8ff62c2..98d4eb3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -399,8 +399,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	/* NULL queue means the device can't be used */
>  	sdev->request_queue = NULL;
>  
> -	scsi_target_reap(scsi_target(sdev));
> -
>  	kfree(sdev->inquiry);
>  	kfree(sdev);
>  
> @@ -1044,6 +1042,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	} else
>  		put_device(&sdev->sdev_dev);
>  
> +	scsi_target_reap(scsi_target(sdev));
> +
>  	/*
>  	 * Stop accepting new requests and wait until all queuecommand() and
>  	 * scsi_run_queue() invocations have finished before tearing down the

This is not right.  The problem is that you don't keep track explicitly 
of the number of references to a target; you rely implicitly on 
starget->devices being non-empty.  starget->reap_ref is only a count of 
local operations that should block removal.

Consider, for example, what would happen if there is more than one LUN.  
What if one of them is removed while the other remains?

A more invasive change is needed.

Alan Stern

