From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v9 01/10] md: Rename md_notifier into md_reboot_notifier
Date: Tue, 17 Oct 2017 08:23:09 +0200
Message-ID: <60b26c61-555a-d715-6d93-b3be620e3fca@suse.de>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
 <20171016232905.5047-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 10/17/2017 01:28 AM, Bart Van Assche wrote:
> This avoids confusion with the pm notifier that will be added
> through a later patch.
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
>  drivers/md/md.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5d61049e7417..8933cafc212d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8966,7 +8966,7 @@ static int md_notify_reboot(struct notifier_block *this,
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block md_notifier = {
> +static struct notifier_block md_reboot_notifier = {
>  	.notifier_call	= md_notify_reboot,
>  	.next		= NULL,
>  	.priority	= INT_MAX, /* before any real devices */
> @@ -9003,7 +9003,7 @@ static int __init md_init(void)
>  	blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS, THIS_MODULE,
>  			    md_probe, NULL, NULL);
>  
> -	register_reboot_notifier(&md_notifier);
> +	register_reboot_notifier(&md_reboot_notifier);
>  	raid_table_header = register_sysctl_table(raid_root_table);
>  
>  	md_geninit();
> @@ -9243,7 +9243,7 @@ static __exit void md_exit(void)
>  
>  	unregister_blkdev(MD_MAJOR,"md");
>  	unregister_blkdev(mdp_major, "mdp");
> -	unregister_reboot_notifier(&md_notifier);
> +	unregister_reboot_notifier(&md_reboot_notifier);
>  	unregister_sysctl_table(raid_table_header);
>  
>  	/* We cannot unload the modules while some process is
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
