From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCHv3 5/5] scsi_devinfo: fixup string compare
Date: Fri, 11 Aug 2017 11:08:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1708111107140.1732-100000@iolanthe.rowland.org>
References: <1502461401-94630-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58400 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1753209AbdHKPIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2017 11:08:37 -0400
In-Reply-To: <1502461401-94630-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, 11 Aug 2017, Hannes Reinecke wrote:

> When checking the model and vendor string we need to use the
> minimum value of either string, otherwise we'll miss out on
> wildcard matches.

You really should fix this sentence.

> And we should take card when matching with zero size strings;
> results might be unpredictable.
> With this patch the rules for matching devinfo strings are
> as follows:
> - Vendor strings must match exactly
> - Empty Model strings will only match if the devinfo model
>   is also empty
> - Model strings shorter than the devinfo model string will
>   not match
> 
> Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Aside from the patch description,

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>

>  drivers/scsi/scsi_devinfo.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 776c701..d39b27c 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -399,8 +399,8 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
>  
>  /**
>   * scsi_dev_info_list_find - find a matching dev_info list entry.
> - * @vendor:	vendor string
> - * @model:	model (product) string
> + * @vendor:	full vendor string
> + * @model:	full model (product) string
>   * @key:	specify list to use
>   *
>   * Description:
> @@ -415,7 +415,7 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
>  	struct scsi_dev_info_list *devinfo;
>  	struct scsi_dev_info_list_table *devinfo_table =
>  		scsi_devinfo_lookup_by_key(key);
> -	size_t vmax, mmax;
> +	size_t vmax, mmax, mlen;
>  	const char *vskip, *mskip;
>  
>  	if (IS_ERR(devinfo_table))
> @@ -454,22 +454,25 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
>  			    dev_info_list) {
>  		if (devinfo->compatible) {
>  			/*
> -			 * Behave like the older version of get_device_flags.
> +			 * vendor strings must be an exact match
>  			 */
> -			if (memcmp(devinfo->vendor, vskip, vmax) ||
> -					(vmax < sizeof(devinfo->vendor) &&
> -						devinfo->vendor[vmax]))
> +			if (vmax != strlen(devinfo->vendor) ||
> +			    memcmp(devinfo->vendor, vskip, vmax))
>  				continue;
> -			if (memcmp(devinfo->model, mskip, mmax) ||
> -					(mmax < sizeof(devinfo->model) &&
> -						devinfo->model[mmax]))
> +
> +			/*
> +			 * @model specifies the full string, and
> +			 * must be larger or equal to devinfo->model
> +			 */
> +			mlen = strlen(devinfo->model);
> +			if (mmax < mlen || memcmp(devinfo->model, mskip, mlen))
>  				continue;
>  			return devinfo;
>  		} else {
>  			if (!memcmp(devinfo->vendor, vendor,
> -				     sizeof(devinfo->vendor)) &&
> -			     !memcmp(devinfo->model, model,
> -				      sizeof(devinfo->model)))
> +				    sizeof(devinfo->vendor)) &&
> +			    !memcmp(devinfo->model, model,
> +				    sizeof(devinfo->model)))
>  				return devinfo;
>  		}
>  	}
> 
