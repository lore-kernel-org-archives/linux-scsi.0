From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] cciss: add 30 second initial timeout wait on
 controller reset
Date: Mon, 15 Mar 2010 08:25:58 -0500
Message-ID: <1268659558.2853.9.camel@mulgrave.site>
References: <4B9E3284.3070003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964904Ab0CON0E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Mar 2010 09:26:04 -0400
In-Reply-To: <4B9E3284.3070003@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, Mike.Miller@hp.com, scameron@beardog.cce.hp.com

On Mon, 2010-03-15 at 14:13 +0100, Tomas Henzl wrote:
> It looks like the patch - cciss: remove 30 second initial timeout on controller reset
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5e18cfd04feca78cc08a6b8b71a60a610de81eaa
> has caused a regression. 
> During kdump a box with an 5i controller freezes.
> The HP Smart Array 5i Controller probably needs some more time 
> of inactivity after reset.
> To get rid of it we can revert the above mentioned patch or use
> the patch below which adds an additional timeout only for this 
> one controller (HP Smart Array 5i). I haven't seen this with other
> cciss controllers.
> 
> cciss: add 30 second initial timeout wait on controller reset
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 9e3af30..34ec2c7 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -4172,9 +4172,13 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  		if (cciss_hard_reset_controller(pdev) || cciss_reset_msi(pdev))
>  			return -ENODEV;
>  
> -		/* Now try to get the controller to respond to a no-op. Some
> -		   devices (notably the HP Smart Array 5i Controller) need
> -		   up to 30 seconds to respond. */
> +		/* The HP Smart Array 5i Controller needs
> +		 * at least 20 seconds before first status checking
> +		 * set it to 30 seconds for this controller to be sure */
> +		if (0x4080 == pdev->subsystem_device)
> +			schedule_timeout_uninterruptible(30*HZ);

The HZ thing is deprecated, plus if you really want an interruptible
sleep, you need to check for signals going in.

It's far better to use msleep_interruptible, which does all of this for
you (of course, it might be even better if we had ssleep_interruptible).

James


> +
> +		/* Now try to get the controller to respond to a no-op. */
>  		for (i=0; i<30; i++) {
>  			if (cciss_noop(pdev) == 0)
>  				break;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


