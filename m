From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Thu, 26 May 2005 22:54:00 -0400
Message-ID: <42968BC8.1040108@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org>	 <1116880875.5021.34.camel@mulgrave>  <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:32988 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261449AbVE0CyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 22:54:04 -0400
In-Reply-To: <1116886206.5021.42.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, Jens Axboe <axboe@suse.de>

James Bottomley wrote:
> +/* Just quietly quiesce the device and SYNCHRONIZE CACHE for suspend too */
> +static int sd_suspend(struct device *dev, pm_message_t state, u32 level)
> +{
> +	struct scsi_device *sdp = to_scsi_device(dev);
> +	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +
> +	if (!sdkp)
> +		return 0;         /* this can happen */
> +
> +	if (!sdkp->WCE)
> +		return 0;
> +
> +	/* don't try to sync an offline device ... it will only error */
> +	if (!scsi_device_online(sdp))
> +		return 0;
> +
> +	if (sd_sync_cache(sdp))
> +		return -EIO;


Add

	if (I_can_PM_this_disk && sd_start_stop_unit(sdp))
		return -EIO;

and libata is happy.

	Jeff


