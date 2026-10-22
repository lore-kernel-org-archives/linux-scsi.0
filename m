Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792674797;
	b=Lphw/CajLqF9bZ84hI2fpRoLUT4+S22EqKH2L72MM861WoHJ7zd/lc07GvoGs3ypEd+U
	 Y65cFe7slgQt819Rf74puce1I2sdKKpduAE0blD3ZQ+9MFygiza9ck2kjT3LJbqUOjWpR
	 W5HTwG+bWdeq0p0P61IgUIo742Nko9sRGRA/1p1jN3dbotM+qLbEYzAlunvPOX9iZkicd
	 DPLoc8mkbTizi2DEfiw/UcZ9dv2pfXuTNZ5I22ZRLJMMjZkBSobZCH0EbPrw1vDvrup9v
	 YL0KNEn4jgfLNDT2UDz0sFuRSbGkiHhPZ10n6mIJhKr6Zr6DHXtLZ5QmaVbT70IOEhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792674797;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xlaV1V+yQ3J8w/w8Ck84D01xkjHZK2MyUGosH96xsm4=;
	b=SODFDxOuYnUTM9ndsFzdfgdAmqq1h4NmlQRouTgh73DrzdyOgdudus372ScXGeTTg7Wm
	 Ts9/65uhfu2zLOAvSJ5Z1fJDGZabkUZImO8TyInEAtKqmlC2oQCxzryjPKhP3Nm/cTixz
	 rV3vD3AnLrjZ1Ol3b7t2z5H5r0Y8t705ZxPNkt5901SgDWRIhWD4OhQ7b3ztvFrKskvHy
	 oo51XTC+spkQxJpOaItPYOtCCxmw3FQCoP75Gnho8ZBF0B2JB9id+5Rn1+oAF09jUdnX0
	 IUC5rr639Ajj4+yIxhL8RvwLQc1Go48LNp2a3t8aIXR94+KSgfZOwtotrgv9cRh+nfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNZcQL0z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FD2606A319;
	Thu, 22 Oct 2026 13:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNZcQL0z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5240B1F000C1;
	Thu, 22 Oct 2026 13:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792674796;
	bh=xlaV1V+yQ3J8w/w8Ck84D01xkjHZK2MyUGosH96xsm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DNZcQL0z3lmwG2/ll8BW3r8AVu0q/Zb7r4HFXCKMxwool0fDvQs9tz2YhS4gW1UTo
	 0/0I0JfWjZ3MrG0/Wx5ib8lt53kQ+2rbnJxNmSH76EadYFtvxInLxfTYyP4UjxtHUM
	 haFiKTF1W4YYKMIFBVj5sIOFdLQ02Dp/PDdDDqDk=
Date: Thu, 22 Oct 2026 15:05:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Michal Pecio <michal.pecio@gmail.com>, linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: uas: wait for pending commands before unbinding
Message-ID: <2026102214-citrus-reselect-b26d@gregkh>
References: <20261022123401.319479-1-lijiayi@kylinos.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022123401.319479-1-lijiayi@kylinos.cn>

On Thu, Oct 22, 2026 at 08:34:01PM +0800, Jiayi Li wrote:
> USB core normally disables interface endpoints before calling
> uas_disconnect(). This cancels pending URBs while the device may still
> be processing the associated commands. Some storage bridges then stop
> responding after a driver rebind and need a disconnect and reconnect
> to recover.
> 
> Enable soft unbinding and block new SCSI requests before waiting for
> pending commands to finish. This keeps the endpoints available until
> the wait completes. Stop waiting when USB core marks the device as
> not attached, and continue with the existing cleanup on timeout.
> 
> Keep requests blocked when leaving the preparation step, including on
> timeout. Set resetting before unblocking the host so that queued
> requests cannot submit new URBs during teardown.
> 
> ---
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 2651629..58a67d7 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/blkdev.h>
> +#include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/module.h>
> @@ -1211,16 +1212,55 @@ static int uas_reset_resume(struct usb_interface *intf)
>  	return 0;
>  }
>  
> +static void uas_pre_disconnect(struct usb_interface *intf)
> +{
> +	struct Scsi_Host *shost = usb_get_intfdata(intf);
> +	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
> +	unsigned long flags, start_time;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	scsi_block_requests(shost);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	start_time = jiffies;
> +	for (;;) {
> +		if (READ_ONCE(devinfo->udev->state) == USB_STATE_NOTATTACHED)
> +			return;
> +
> +		flush_work(&devinfo->work);
> +
> +		if (!usb_wait_anchor_empty_timeout(&devinfo->sense_urbs, 5000))
> +			break;
> +
> +		if (!usb_wait_anchor_empty_timeout(&devinfo->data_urbs, 500))
> +			break;
> +
> +		if (time_after(jiffies, start_time + 5 * HZ))
> +			break;
> +		if (uas_cmnd_list_empty(devinfo))
> +			return;
> +
> +		msleep(20);
> +	}
> +
> +	shost_printk(KERN_ERR, shost, "%s: timed out\n", __func__);
> +}
> +
>  static void uas_disconnect(struct usb_interface *intf)
>  {
>  	struct Scsi_Host *shost = usb_get_intfdata(intf);
>  	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
>  	unsigned long flags;
>  
> +	uas_pre_disconnect(intf);
> +
>  	spin_lock_irqsave(&devinfo->lock, flags);
>  	devinfo->resetting = 1;
>  	spin_unlock_irqrestore(&devinfo->lock, flags);
>  
> +	if (shost->host_self_blocked)
> +		scsi_unblock_requests(shost);
> +
>  	cancel_work_sync(&devinfo->work);
>  	usb_kill_anchored_urbs(&devinfo->cmd_urbs);
>  	usb_kill_anchored_urbs(&devinfo->sense_urbs);
> @@ -1260,6 +1300,7 @@ static void uas_shutdown(struct usb_interface *intf)
>  
>  static struct usb_driver uas_driver = {
>  	.name = "uas",
> +	.soft_unbind = 1,
>  	.probe = uas_probe,
>  	.disconnect = uas_disconnect,
>  	.pre_reset = uas_pre_reset,

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch does not have a Signed-off-by: line.  Please read the
  kernel file, Documentation/process/submitting-patches.rst and resend
  it after adding that line.  Note, the line needs to be in the body of
  the email, before the patch, not at the bottom of the patch or in the
  email signature.


If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
