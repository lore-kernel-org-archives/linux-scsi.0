From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] hpsa: add support for legacy boards
Date: Wed, 9 Aug 2017 15:45:14 +0200
Message-ID: <20170809134514.GD25852@lst.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de> <1502181315-102499-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53566 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752409AbdHINpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 09:45:15 -0400
Content-Disposition: inline
In-Reply-To: <1502181315-102499-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> -static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
> +static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id,
> +				bool *supported)
>  {
>  	int i;
>  	u32 subsystem_vendor_id, subsystem_device_id;
> @@ -7242,9 +7266,22 @@ static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
>  	*board_id = ((subsystem_device_id << 16) & 0xffff0000) |
>  		    subsystem_vendor_id;
>  
> +	if (supported)
> +		*supported = true;
>  	for (i = 0; i < ARRAY_SIZE(products); i++)
> -		if (*board_id == products[i].board_id)
> -			return i;
> +		if (*board_id == products[i].board_id) {
> +			if (products[i].access != &SA5A_access &&
> +			    products[i].access != &SA5B_access)
> +				return i;
> +			if (hpsa_allow_any) {
> +				dev_warn(&pdev->dev,
> +					 "unsupported board ID: 0x%08x\n",
> +					 *board_id);
> +				if (supported)
> +					*supported = false;
> +				return i;
> +			}
> +		}

Can you explain the point of the supported flag?

> +	unsigned long register_value  =
> +		readl(h->vaddr + SA5_INTR_STATUS);
> +	return (register_value & SA5B_INTR_PENDING);

This should be condensed into:

	return readl(h->vaddr + SA5_INTR_STATUS) & SA5B_INTR_PENDING;

>  	.command_completed = SA5_completed,
>  };
>  
> +/* Duplicate entry of the above to mark unsupported boards */
> +static struct access_method SA5A_access = {
> +	.submit_command = SA5_submit_command,
> +	.set_intr_mask = SA5_intr_mask,
> +	.intr_pending = SA5_intr_pending,
> +	.command_completed = SA5_completed,
> +};
> +
> +static struct access_method SA5B_access = {
> +	.submit_command = SA5_submit_command,
> +	.set_intr_mask = SA5B_intr_mask,
> +	.intr_pending = SA5B_intr_pending,
> +	.command_completed = SA5_completed,
> +};

Please align the fields nicely, e.g.:

static struct access_method SA5A_access = {
	.submit_command 	= SA5_submit_command,
	.set_intr_mask		= SA5_intr_mask,
	...
