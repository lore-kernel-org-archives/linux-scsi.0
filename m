From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 08/12] scsi: sd_zbc: Fix
 sd_zbc_read_zoned_characteristics()
Date: Fri, 15 Sep 2017 12:46:23 +0200
Message-ID: <b1990b7e-6b13-750e-4faa-891eeaa943ee@suse.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
 <20170915100645.17999-9-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-9-damien.lemoal@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/15/2017 12:06 PM, Damien Le Moal wrote:
> The three values starting at byte 8 of the Zoned Block Device
> Characteristics VPD page B6h are 32 bits values, not 64bits. So use
> get_unaligned_be32() to retrieve the values and not get_unaligned_be64()
> 
> Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
> Cc: <stable@vger.kernel.org>
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Bart Van Assche <Bart.VanAssche@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/sd_zbc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 37b33adbb2ef..7e30d0c22930 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -385,15 +385,15 @@ static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
>  	if (sdkp->device->type != TYPE_ZBC) {
>  		/* Host-aware */
>  		sdkp->urswrz = 1;
> -		sdkp->zones_optimal_open = get_unaligned_be64(&buf[8]);
> -		sdkp->zones_optimal_nonseq = get_unaligned_be64(&buf[12]);
> +		sdkp->zones_optimal_open = get_unaligned_be32(&buf[8]);
> +		sdkp->zones_optimal_nonseq = get_unaligned_be32(&buf[12]);
>  		sdkp->zones_max_open = 0;
>  	} else {
>  		/* Host-managed */
>  		sdkp->urswrz = buf[4] & 1;
>  		sdkp->zones_optimal_open = 0;
>  		sdkp->zones_optimal_nonseq = 0;
> -		sdkp->zones_max_open = get_unaligned_be64(&buf[16]);
> +		sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
>  	}
>  
>  	return 0;
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
