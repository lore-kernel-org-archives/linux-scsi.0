From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/9] block: Add 'zoned' sysfs queue attribute
Date: Fri, 15 Apr 2016 10:45:43 -0700
Message-ID: <571128C7.1060107@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:58654
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916AbcDORp5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 13:45:57 -0400
In-Reply-To: <1459764020-126038-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
> Add a sysfs queue attribute 'zoned' to display the zone layout
> for zoned devices.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   block/blk-sysfs.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index ff97091..748bb27 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -244,6 +244,43 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
>   	return queue_var_show(max_hw_sectors_kb, (page));
>   }
>
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static ssize_t queue_zoned_show(struct request_queue *q, char *page)
> +{
> +	struct rb_node *node;
> +	struct blk_zone *zone;
> +	ssize_t offset = 0, end = 0;
> +	size_t size = 0, num = 0;
> +	enum blk_zone_type type = BLK_ZONE_TYPE_UNKNOWN;
> +
> +	for (node = rb_first(&q->zones); node; node = rb_next(node)) {
> +		zone = rb_entry(node, struct blk_zone, node);
> +		if (zone->type != type ||
> +		    zone->len != size ||
> +		    end != zone->start) {
> +			if (size != 0)
> +				offset += sprintf(page + offset, "%zu\n", num);
> +			/* We can only store one page ... */
> +			if (offset + 42 > PAGE_SIZE) {
> +				offset += sprintf(page + offset, "...\n");
> +				return offset;
> +			}
> +			size = zone->len;
> +			type = zone->type;
> +			offset += sprintf(page + offset, "%zu %zu %d ",
> +					  zone->start, size, type);
> +			num = 0;
> +			end = zone->start + size;
> +		} else
> +			end += zone->len;
> +		num++;
> +	}
> +	if (num > 0)
> +		offset += sprintf(page + offset, "%zu\n", num);
> +	return offset > 0 ? offset : -EINVAL;
> +}
> +#endif
> +
>   #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
>   static ssize_t								\
>   queue_show_##name(struct request_queue *q, char *page)			\
> @@ -468,6 +505,13 @@ static struct queue_sysfs_entry queue_write_same_max_entry = {
>   	.show = queue_write_same_max_show,
>   };
>
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static struct queue_sysfs_entry queue_zoned_entry = {
> +	.attr = {.name = "zoned", .mode = S_IRUGO },
> +	.show = queue_zoned_show,
> +};
> +#endif
> +

Hello Hannes,

Have you considered to move the above definitions into a new file? That 
would allow to avoid two #ifdefs and to move the code that decides 
whether or not the above code gets built into block/Makefile.

Additionally, have you considered to create one sysfs directory per zone 
instead of one sysfs attribute with all zone information? From 
Documentation/filesystems/sysfs.txt: "Attributes should be ASCII text 
files, preferably with only one value per file."

Thanks,

Bart.
