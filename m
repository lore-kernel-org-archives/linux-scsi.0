From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 1/2] fix our current target reap infrastructure.
Date: Mon, 16 Dec 2013 10:57:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312161050390.1266-100000@iolanthe.rowland.org>
References: <1387206772.2200.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38738 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754500Ab3LPP53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 10:57:29 -0500
In-Reply-To: <1387206772.2200.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Mon, 16 Dec 2013, James Bottomley wrote:

> This patch eliminates the reap_ref and replaces it with a proper kref.
> On last put of this kref, the target is removed from visibility in
> sysfs.  The final call to scsi_target_reap() for the device is done from
> __scsi_remove_device() and only if the device was made visible.  This
> ensures that the target disappears as soon as the last device is gone
> rather than waiting until final release of the device (which is often
> too long).

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

Two small suggested changes:

> @@ -441,29 +466,32 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
>  	return starget;
>  
>   found:
> -	found_target->reap_ref++;
> +	if (!kref_get_unless_zero(&found_target->reap_ref))
> +		/*
> +		 * release routine already fired.  Target is dead, but
> +		 * STARGET_DEL may not yet be set (set in the release
> +		 * routine), so set here as well, just in case
> +		 */
> +		found_target->state = STARGET_DEL;
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	if (found_target->state != STARGET_DEL) {
>  		put_device(dev);
>  		return found_target;
>  	}
> -	/* Unfortunately, we found a dying target; need to
> -	 * wait until it's dead before we can get a new one */
> +	/*
> +	 * Unfortunately, we found a dying target; need to wait until it's
> +	 * dead before we can get a new one.  There is an anomaly here.  We
> +	 * *should* call scsi_target_reap() to balance the kref_get() of the
> +	 * reap_ref above.  However, since the target is in state STARGET_DEL,
> +	 * it's already invisible and the reap_ref is irrelevant.  If we call
> +	 * scsi_target_reap() we might spuriously do another device_del() on
> +	 * an already invisible target.
> +	 */
>  	put_device(&found_target->dev);
>  	flush_scheduled_work();
>  	goto retry;

Since scsi_target_reap_usercontext() is now gone, scsi_target_destroy()
doesn't rely on a work queue any more.  Therefore something like
msleep(1) would be more appropriate than flush_scheduled_work().

> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -257,7 +257,7 @@ struct scsi_target {
>  	struct list_head	siblings;
>  	struct list_head	devices;
>  	struct device		dev;
> -	unsigned int		reap_ref; /* protected by the host lock */
> +	struct kref		reap_ref; /* last put renders device invisible */

s/device/target/

Alan Stern

