From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Tue, 30 Sep 2014 00:43:29 -0700
Message-ID: <20140930074329.GA10290@infradead.org>
References: <1411991272-129962-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38056 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaI3Hnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 03:43:31 -0400
Content-Disposition: inline
In-Reply-To: <1411991272-129962-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@avagotech.com>

On Mon, Sep 29, 2014 at 01:47:52PM +0200, Hannes Reinecke wrote:
> Megaraid_sas uses a shared pool of commands per HBA, so we
> should be enabling a shared tag map.
> This will allow the I/O scheduler to make better scheduling
> decisions and will avoid BUSY states in the driver.

What exact problem did you see?  Do you have a link to a bugzilla entry
or similar?  Was this observed on real hardware or your qemu emulation?

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 34 ++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index f6a69a3..996fa9a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1659,7 +1659,7 @@ static int megasas_slave_configure(struct scsi_device *sdev)
>  	*/
>  	blk_queue_rq_timeout(sdev->request_queue,
>  		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
> -
> +	sdev->tagged_supported = 1;

> +	/* We have a shared tag map, so TCQ is always supported */
> +	sdev->tagged_supported = 1;
> +

Why doesn't the device return the proper data in the INQUIRY response?

And more importantly why do you want to do this twice?

>  	instance = megasas_lookup_instance(sdev->host->host_no);
>  	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
>  		/*
> @@ -1677,13 +1681,20 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
>  			sdev->id;
>  		if (instance->pd_list[pd_index].driveState ==
>  					MR_PD_STATE_SYSTEM) {
> +			scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
>  			return 0;
>  		}
>  		return -ENXIO;
>  	}
> +	scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
>  	return 0;

Please refactor the code so that the first case falls through to the
second, something like:


		if (instance->pd_list[pd_index].driveState !=
					MR_PD_STATE_SYSTEM)
			return -ENXIO;
	}

	scsi_activate_tcq(sdev, MEGASAS_DEFAULT_CMD_PER_LUN);
	return 0;

