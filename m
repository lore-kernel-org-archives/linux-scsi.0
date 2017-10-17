From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 02/10] md: Introduce md_stop_all_writes()
Date: Tue, 17 Oct 2017 08:23:35 +0200
Message-ID: <e1cf7087-68d2-6bd6-a1c0-5447c9e081f7@suse.de>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-3-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 10/17/2017 01:28 AM, Bart Van Assche wrote:
> Introduce md_stop_all_writes() because the next patch will add
> a second caller for this function. This patch does not change
> any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Shaohua Li <shli@kernel.org>
> Tested-by: Martin Steigerwald <martin@lichtvoll.de>
> Cc: linux-raid@vger.kernel.org
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/md.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8933cafc212d..b99584e5d6b1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8937,8 +8937,7 @@ int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>  }
>  EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>  
> -static int md_notify_reboot(struct notifier_block *this,
> -			    unsigned long code, void *x)
> +static void md_stop_all_writes(void)
>  {
>  	struct list_head *tmp;
>  	struct mddev *mddev;
> @@ -8962,6 +8961,12 @@ static int md_notify_reboot(struct notifier_block *this,
>  	 */
>  	if (need_delay)
>  		mdelay(1000*1);
> +}
> +
> +static int md_notify_reboot(struct notifier_block *this,
> +			    unsigned long code, void *x)
> +{
> +	md_stop_all_writes();
>  
>  	return NOTIFY_DONE;
>  }
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
