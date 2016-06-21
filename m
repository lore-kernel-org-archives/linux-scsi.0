From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] Add support for SCT Write Same
Date: Tue, 21 Jun 2016 14:41:44 +0200
Message-ID: <20160621124144.GD1689@lst.de>
References: <1466435028-13886-1-git-send-email-shaun@tancheff.com> <1466435028-13886-2-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46975 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbcFUMtR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2016 08:49:17 -0400
Content-Disposition: inline
In-Reply-To: <1466435028-13886-2-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>

On Mon, Jun 20, 2016 at 10:03:48AM -0500, Shaun Tancheff wrote:
> index bfec66f..3dcc29e 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1204,6 +1204,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
>  	if (!ata_id_has_unload(dev->id))
>  		dev->flags |= ATA_DFLAG_NO_UNLOAD;
>  
> +	if (ata_id_sct_write_same(dev->id))
> +		sdev->sct_write_same = 1;
> +

No need scsi_device flags for libata internal data.  You need to expose
your capabilities through the SCSI protocol to the SCSI midlayer.
