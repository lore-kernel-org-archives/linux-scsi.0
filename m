From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] updated: suspending I/Os to a device
Date: Tue, 10 Aug 2004 21:50:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040810215000.A21884@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F154@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:14094 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267551AbUHJUuE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 16:50:04 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F154@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Tue, Aug 10, 2004 at 04:35:05PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 10, 2004 at 04:35:05PM -0400, James.Smart@Emulex.Com wrote:
> + **/
> +void scsi_add_sdev_timer(struct scsi_device *sdev, int timeout,
> +			 void (*complete)(struct scsi_device *))

the name sounds a little too generic.  scsi_device_add_recovery_timer
is more descriptive but also rather longish.

> +	/*
> +	 * If the clock was already running for this command, then
> +	 * first delete the timer.  The timer handling code gets rather
> +	 * confused if we don't do this.
> +	 */
> +	if (sdev->device_recovert) {
> +		if (sdev->device_recovert->eh_nodev_timeout.function)
> +			del_timer(&sdev->device_recovert->eh_nodev_timeout);

This needs to be a del_timer_sync.  Also the .function check is wrong, just
call del_timer_sync unconditionally.

> +
> +		sdev->device_recovert->eh_nodev_timeout.data = (unsigned long) sdev;
> +		sdev->device_recovert->eh_nodev_timeout.expires = jiffies + timeout;
> +		sdev->device_recovert->eh_nodev_timeout.function = (void (*)(unsigned long)) complete;

These lines are longer than 80 characters.  Also device_recovert is a strange
naming choice.  What about just recover or recovery?

> +int scsi_delete_sdev_timer(struct scsi_device *sdev)

Smae naming issue.

> +			printk(KERN_WARNING "scsi_device_suspend: nodev_timeout"
> +				"value invalid on host %d channel %d id %d" 
> +				"lun %d nodev_timeout=%d\n",
> +				sdev->host->host_no, sdev->channel, sdev->id, 
> +				sdev->lun, sdev->device_recovert->nodev_timeout);
> +		return -1;

wrong indentation for the return.

> +struct device_recover_template {
> +	/* Device recovery template. */
> +	unsigned int nodev_timeout;		/* Device suspend timeout value
> +						 * in seconds. */
> +	struct timer_list eh_nodev_timeout;	/* Used to timeout the suspend 
> +						 * state. */
> +};

I'm not so sue the separate allocation is worth it or whether we should just
sick it into the fc transport data.

