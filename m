From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 13/24] aacraid: Added support to set QD of attached
 drives
Date: Mon, 30 Jan 2017 11:39:51 +0100
Message-ID: <20170130103951.GJ3603@linux-x5ow.site>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
 <20170127192853.10082-14-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48876 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751302AbdA3KkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 05:40:01 -0500
Content-Disposition: inline
In-Reply-To: <20170127192853.10082-14-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

On Fri, Jan 27, 2017 at 11:28:42AM -0800, Raghava Aditya Renukunta wrote:
> Added support to set qd of drives in slave_configure.This only works for
> HBA1000 attached drives.
> 
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
> Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
> 
> ---

[...]

> @@ -428,34 +441,41 @@ static int aac_slave_configure(struct scsi_device *sdev)
>  		 */
>  		if (sdev->request_queue->rq_timeout < (45 * HZ))
>  			blk_queue_rq_timeout(sdev->request_queue, 45*HZ);
> -		for (cid = 0; cid < aac->maximum_num_containers; ++cid)
> -			if (aac->fsa_dev[cid].valid)
> -				++num_lsu;
> -		__shost_for_each_device(dev, host) {
> -			if (dev->tagged_supported && (dev->type == TYPE_DISK) &&
> +		if (!is_native_device) {
> +			for (cid = 0; cid < aac->maximum_num_containers; ++cid)
> +				if (aac->fsa_dev[cid].valid)
> +					++num_lsu;
> +			__shost_for_each_device(dev, host) {
> +				if (dev->tagged_supported &&
> +					(dev->type == TYPE_DISK) &&
>  					(!aac->raid_scsi_mode ||
> -						(sdev_channel(sdev) != 2)) &&
> +					(sdev_channel(sdev) != 2)) &&
>  					!dev->no_uld_attach) {
> -				if ((sdev_channel(dev) != CONTAINER_CHANNEL)
> -				 || !aac->fsa_dev[sdev_id(dev)].valid)
> -					++num_lsu;
> -			} else
> -				++num_one;
> +					if ((sdev_channel(dev)
> +						!= CONTAINER_CHANNEL)
> +					 || !aac->fsa_dev[sdev_id(dev)].valid) {
> +						++num_lsu;
> +					}
> +				} else {
> +					++num_one;
> +				}
> +			}
> +			if (num_lsu == 0)
> +				++num_lsu;
> +			depth = (host->can_queue - num_one) / num_lsu;
> +			if (depth > 256)
> +				depth = 256;
> +			else if (depth < 2)
> +				depth = 2;
> +			scsi_change_queue_depth(sdev, depth);
> +		} else {
> +			scsi_change_queue_depth(sdev,
> +				aac->hba_map[chn][tid].qd_limit);

At least in diff form, the above is quite hard to read. Can you make the code
flow a bit more obvious? The extra level of indentation and thus newly
introduced linebreaks didn't make it easier.


>  		}
> -		if (num_lsu == 0)
> -			++num_lsu;
> -		depth = (host->can_queue - num_one) / num_lsu;
> -		if (depth > 256)
> -			depth = 256;
> -		else if (depth < 2)
> -			depth = 2;
> -		scsi_change_queue_depth(sdev, depth);
> -	} else {
> -		scsi_change_queue_depth(sdev, 1);
> -
> -		sdev->tagged_supported = 1;
>  	}


[...]

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
