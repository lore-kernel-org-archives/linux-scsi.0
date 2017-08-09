From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2] scsi_dh_alua: suppress errors from unsupported
        devices
Date: Wed, 9 Aug 2017 18:08:03 +0200
Message-ID: <20170809160803.GB3365@lst.de>
References: <1502182413-23560-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54268 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752725AbdHIQIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 12:08:04 -0400
Content-Disposition: inline
In-Reply-To: <1502182413-23560-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> index 0962fd5..c3aea06 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1100,6 +1100,8 @@ static int alua_bus_attach(struct scsi_device *sdev)
>  	err = alua_initialize(sdev, h);
>  	if (err == SCSI_DH_NOMEM)
>  		ret = -ENOMEM;
> +	if (err == SCSI_DH_DEV_UNSUPP)
> +		ret = -ENODEV;
>  	if (err != SCSI_DH_OK && err != SCSI_DH_DEV_OFFLINED)
>  		goto failed;

This screams for a switch statement..

> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -133,8 +133,9 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
>  
>  	error = scsi_dh->attach(sdev);
>  	if (error) {
> -		sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%d)\n",
> -			    scsi_dh->name, error);
> +		if (error != -ENODEV)
> +			sdev_printk(KERN_ERR, sdev, "%s: Attach failed (%d)\n",
> +				    scsi_dh->name, error);
>  		module_put(scsi_dh->module);

OTOH why don't we just return the SCSI_DH_ values from ->attach?
