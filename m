From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] sd: Fix wrong DPOFUA disable in sd_read_cache_type
Date: Thu, 12 Jan 2017 07:52:40 +0100
Message-ID: <1c6a02ce-f3b3-3432-01ba-8aa696afec30@suse.de>
References: <20170112062511.20261-1-damien.lemoal@wdc.com>
 <20170112062511.20261-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58925 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750722AbdALGwp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 01:52:45 -0500
In-Reply-To: <20170112062511.20261-2-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>

On 01/12/2017 07:25 AM, Damien Le Moal wrote:
> Zoned block devices force the use of READ/WRITE(16) commands by setting
> sdkp->use_16_for_rw and clearing sdkp->use_10_for_rw. This result in
> DPOFUA always being disabled for these drives as the assumed use of
> the deprecated READ/WRITE(6) commands only looks at sdkp->use_10_for_rw.
> Strenghten the test by also checking that sdkp->use_16_for_rw is false.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/sd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b193304..d7aaacf 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2600,7 +2600,8 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>  		if (sdp->broken_fua) {
>  			sd_first_printk(KERN_NOTICE, sdkp, "Disabling FUA\n");
>  			sdkp->DPOFUA = 0;
> -		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
> +		} else if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw &&
> +			   !sdkp->device->use_16_for_rw) {
>  			sd_first_printk(KERN_NOTICE, sdkp,
>  				  "Uses READ/WRITE(6), disabling FUA\n");
>  			sdkp->DPOFUA = 0;
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
