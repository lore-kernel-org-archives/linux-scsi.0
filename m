From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 1/4] block: Allow devices to indicate whether discarded
 blocks are zeroed
Date: Sat, 21 Nov 2009 07:50:28 -0500
Message-ID: <4B07E214.3020800@redhat.com>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZKUMxv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Nov 2009 07:53:51 -0500
In-Reply-To: <1258771524-26673-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 11/20/2009 09:45 PM, Martin K. Petersen wrote:
> The discard ioctl is used by mkfs utilities to clear a block device
> prior to putting metadata down.  However, not all devices return zeroed
> blocks after a discard.  Some drives return stale data, potentially
> containing old superblocks.  It is therefore important to know whether
> discarded blocks are properly zeroed.
>
> Both ATA and SCSI drives have configuration bits that indicate whether
> zeroes are returned after a discard operation.  Implement a block level
> interface that allows this information to be bubbled up the stack.
>
> Signed-off-by: Martin K. Petersen<martin.petersen@oracle.com>
> ---
>   block/blk-settings.c   |    2 ++
>   block/blk-sysfs.c      |   11 +++++++++++
>   include/linux/blkdev.h |    1 +
>   3 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 7f986ca..1027e30 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -100,6 +100,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>   	lim->discard_granularity = 0;
>   	lim->discard_alignment = 0;
>   	lim->discard_misaligned = 0;
> +	lim->discard_zeroes_data = -1;
>    


Did you mean to set this to -1 ?

ric


>   	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
>   	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY>>  PAGE_SHIFT);
>   	lim->alignment_offset = 0;
> @@ -543,6 +544,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>
>   	t->io_min = max(t->io_min, b->io_min);
>   	t->no_cluster |= b->no_cluster;
> +	t->discard_zeroes_data&= b->discard_zeroes_data;
>
>   	/* Bottom device offset aligned? */
>   	if (offset&&
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 3147145..1f1d2b6 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -136,6 +136,11 @@ static ssize_t queue_discard_max_show(struct request_queue *q, char *page)
>   	return queue_var_show(q->limits.max_discard_sectors<<  9, page);
>   }
>
> +static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->limits.discard_zeroes_data == 1 ? 1 : 0, page);
> +}
> +
>   static ssize_t
>   queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
>   {
> @@ -313,6 +318,11 @@ static struct queue_sysfs_entry queue_discard_max_entry = {
>   	.show = queue_discard_max_show,
>   };
>
> +static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
> +	.attr = {.name = "discard_zeroes_data", .mode = S_IRUGO },
> +	.show = queue_discard_zeroes_data_show,
> +};
> +
>   static struct queue_sysfs_entry queue_nonrot_entry = {
>   	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
>   	.show = queue_nonrot_show,
> @@ -350,6 +360,7 @@ static struct attribute *default_attrs[] = {
>   	&queue_io_opt_entry.attr,
>   	&queue_discard_granularity_entry.attr,
>   	&queue_discard_max_entry.attr,
> +	&queue_discard_zeroes_data_entry.attr,
>   	&queue_nonrot_entry.attr,
>   	&queue_nomerges_entry.attr,
>   	&queue_rq_affinity_entry.attr,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3b67221..e605945 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -322,6 +322,7 @@ struct queue_limits {
>   	unsigned char		misaligned;
>   	unsigned char		discard_misaligned;
>   	unsigned char		no_cluster;
> +	signed char		discard_zeroes_data;
>   };
>
>   struct request_queue
>    

