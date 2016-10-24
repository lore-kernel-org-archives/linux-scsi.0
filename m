From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: fix uninitialized variable access in error handling
Date: Mon, 24 Oct 2016 16:37:07 +0200
Message-ID: <0f5ac05c-404f-b0d8-a66e-80a55260664c@suse.de>
References: <20161021153246.3456962-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54397 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935051AbcJXOhP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:37:15 -0400
In-Reply-To: <20161021153246.3456962-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaun Tancheff <shaun.tancheff@seagate.com>, Jens Axboe <axboe@fb.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 10/21/2016 05:32 PM, Arnd Bergmann wrote:
> If sd_zbc_report_zones fails, the check for 'zone_blocks == 0'
> later in the function accesses uninitialized data:
>
> drivers/scsi/sd_zbc.c: In function ‘sd_zbc_read_zones’:
> drivers/scsi/sd_zbc.c:520:7: error: ‘zone_blocks’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>
> This sets it to zero, which has the desired effect of leaving
> the sd_zbc_read_zones successfully with sdkp->zone_blocks = 0.
>
> Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/sd_zbc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 16d3fa62d8ac..d5b3bd915d9e 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -455,8 +455,10 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
>
>  	/* Do a report zone to get the same field */
>  	ret = sd_zbc_report_zones(sdkp, buf, SD_ZBC_BUF_SIZE, 0);
> -	if (ret)
> +	if (ret) {
> +		zone_blocks = 0;
>  		goto out;
> +	}
>
>  	same = buf[4] & 0x0f;
>  	if (same > 0) {
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
