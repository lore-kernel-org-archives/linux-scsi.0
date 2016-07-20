From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH 2/5] sd: Implement new RESET_WP provisioning mode
Date: Wed, 20 Jul 2016 09:49:31 +0900
Message-ID: <6c0e2de2-fbed-1fc1-3d2c-4063d034cb58@hgst.com>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
 <1468934710-93876-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:21532 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbcGTAwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 20:52:51 -0400
In-Reply-To: <1468934710-93876-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi Hannes,

On 7/19/16 22:25, Hannes Reinecke wrote:
> We can map the RESET WRITE POINTER command onto a 'discard'
> request.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/sd.c | 65 ++++++++++++++++++++++++++++++++++++++++++++-----------
>  drivers/scsi/sd.h |  1 +
>  2 files changed, 53 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 249ea81..52dda83 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -369,6 +369,7 @@ static const char *lbp_mode[] = {
>  	[SD_LBP_WS16]		= "writesame_16",
>  	[SD_LBP_WS10]		= "writesame_10",
>  	[SD_LBP_ZERO]		= "writesame_zero",
> +	[SD_ZBC_RESET_WP]	= "reset_wp",
>  	[SD_LBP_DISABLE]	= "disabled",
>  };
>
> @@ -391,6 +392,13 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
>
> +	if (sdkp->zoned == 1) {
> +		if (!strncmp(buf, lbp_mode[SD_ZBC_RESET_WP], 20)) {
> +			sd_config_discard(sdkp, SD_ZBC_RESET_WP);
> +			return count;
> +		}
> +		return -EINVAL;
> +	}
>  	if (sdp->type != TYPE_DISK)
>  		return -EINVAL;
>
> @@ -683,6 +691,11 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
>  		q->limits.discard_zeroes_data = sdkp->lbprz;
>  		break;
>
> +	case SD_ZBC_RESET_WP:
> +		max_blocks = sdkp->unmap_granularity;
> +		q->limits.discard_zeroes_data = 1;
> +		break;
> +
>  	case SD_LBP_ZERO:
>  		max_blocks = min_not_zero(sdkp->max_ws_blocks,
>  					  (u32)SD_MAX_WS10_BLOCKS);

I am still wondering if setting discard_zeroes_data to 1 is the right 
choice here since nothing will happen for conventional zones (no 
zeroing, no reset, nothing). discard_zeroes_data=0 may be a safer 
choice, even though I have not hit any issue with it set to 1.

Reviewed-by: Damien Le Moal <damien.lemoal@hgst.com>
Tested-by: Damien Le Moal <damien.lemoal@hgst.com>

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

