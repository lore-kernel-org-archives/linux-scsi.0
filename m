From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cdrom: support devices that have check_events but not
 media_changed
Date: Mon, 31 Jan 2011 11:12:44 +0100
Message-ID: <20110131101244.GA7459@htj.dyndns.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
 <1291838262-21274-8-git-send-email-tj@kernel.org>
 <4D44BE3E.5080107@simon.arlott.org.uk>
 <4D44BF64.4060205@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D44BF64.4060205@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Cc: axboe@kernel.dk, jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On Sun, Jan 30, 2011 at 01:31:16AM +0000, Simon Arlott wrote:
> 93aae17af1172c40c6f74b7294e93a90c3cfaa5d replaced the media_changed op
> with the check_events op in drivers/scsi/sr.c
> 
> All users that check for the CDC_MEDIA_CHANGED capability try both
> the check_events op and the media_changed op, but register_cdrom()
> was requiring media_changed.
> 
> This patch fixes the capability checking and removes a redundant
> check that media_changed != NULL.
> 
> The cdrom_select_disc ioctl is also using the two operations, so
> they should be required for CDC_SELECT_DISC too.

First of all, thanks a lot for fixing this.  Just minor nits below.

> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index 14033a3..4716d76 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -409,7 +409,9 @@ int register_cdrom(struct cdrom_device_info *cdi)
>  	}
>  
>  	ENSURE(drive_status, CDC_DRIVE_STATUS );
> -	ENSURE(media_changed, CDC_MEDIA_CHANGED);
> +	if (cdo->check_events == NULL && cdo->media_changed == NULL) {
> +		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
> +	}

Can we lose the unnecessary {}?

>  	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
>  	ENSURE(lock_door, CDC_LOCK);
>  	ENSURE(select_speed, CDC_SELECT_SPEED);
> @@ -1471,7 +1473,7 @@ int cdrom_media_changed(struct cdrom_device_info *cdi)
>  	/* This talks to the VFS, which doesn't like errors - just 1 or 0.  
>  	 * Returning "0" is always safe (media hasn't been changed). Do that 
>  	 * if the low-level cdrom driver dosn't support media changed. */ 
> -	if (cdi == NULL || cdi->ops->media_changed == NULL)
> +	if (cdi == NULL)

This change is probably not necessary as cdrom_media_changed() is only
called from drivers which implement media_changed.  I don't think it's
gonna break anything but the whole media_changed stuff is scheduled
for removal anyway, so I think it would be better to keep the changes
minimal.

Thank you.

-- 
tejun
