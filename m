From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 07/14] block: Add prefix to block integrity profile flags
Date: Thu, 03 Jul 2014 12:42:16 +0300
Message-ID: <53B52578.7010605@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com> <1401334128-15499-8-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57663 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965200AbaGCJm0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 05:42:26 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so11058535wiw.4
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 02:42:24 -0700 (PDT)
In-Reply-To: <1401334128-15499-8-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 5/29/2014 6:28 AM, Martin K. Petersen wrote:
> Add a BLK_ prefix to the integrity profile flags. Also rename the flags
> to be more consistent with the generate/verify terminology in the rest
> of the integrity code.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   block/bio-integrity.c  |  4 ++--
>   block/blk-integrity.c  | 43 ++++++++++++++++++++++---------------------
>   include/linux/blkdev.h |  6 ++++--
>   3 files changed, 28 insertions(+), 25 deletions(-)
>
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index e711b9c71767..c91181e3d18d 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -179,11 +179,11 @@ bool bio_integrity_enabled(struct bio *bio)
>   		return false;
>   
>   	if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
> -	    (bi->flags & INTEGRITY_FLAG_READ))
> +	    (bi->flags & BLK_INTEGRITY_VERIFY))
>   		return true;
>   
>   	if (bio_data_dir(bio) == WRITE && bi->generate_fn != NULL &&
> -	    (bi->flags & INTEGRITY_FLAG_WRITE))
> +	    (bi->flags & BLK_INTEGRITY_GENERATE))
>   		return true;
>   
>   	return false;
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index 3760d0aeed92..95f451a3c581 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -269,42 +269,42 @@ static ssize_t integrity_tag_size_show(struct blk_integrity *bi, char *page)
>   		return sprintf(page, "0\n");
>   }
>   
> -static ssize_t integrity_read_store(struct blk_integrity *bi,
> -				    const char *page, size_t count)
> +static ssize_t integrity_verify_store(struct blk_integrity *bi,
> +				      const char *page, size_t count)
>   {
>   	char *p = (char *) page;
>   	unsigned long val = simple_strtoul(p, &p, 10);
>   
>   	if (val)
> -		bi->flags |= INTEGRITY_FLAG_READ;
> +		bi->flags |= BLK_INTEGRITY_VERIFY;
>   	else
> -		bi->flags &= ~INTEGRITY_FLAG_READ;
> +		bi->flags &= ~BLK_INTEGRITY_VERIFY;
>   
>   	return count;
>   }
>   
> -static ssize_t integrity_read_show(struct blk_integrity *bi, char *page)
> +static ssize_t integrity_verify_show(struct blk_integrity *bi, char *page)
>   {
> -	return sprintf(page, "%d\n", (bi->flags & INTEGRITY_FLAG_READ) != 0);
> +	return sprintf(page, "%d\n", (bi->flags & BLK_INTEGRITY_VERIFY) != 0);
>   }
>   
> -static ssize_t integrity_write_store(struct blk_integrity *bi,
> -				     const char *page, size_t count)
> +static ssize_t integrity_generate_store(struct blk_integrity *bi,
> +					const char *page, size_t count)
>   {
>   	char *p = (char *) page;
>   	unsigned long val = simple_strtoul(p, &p, 10);
>   
>   	if (val)
> -		bi->flags |= INTEGRITY_FLAG_WRITE;
> +		bi->flags |= BLK_INTEGRITY_GENERATE;
>   	else
> -		bi->flags &= ~INTEGRITY_FLAG_WRITE;
> +		bi->flags &= ~BLK_INTEGRITY_GENERATE;
>   
>   	return count;
>   }
>   
> -static ssize_t integrity_write_show(struct blk_integrity *bi, char *page)
> +static ssize_t integrity_generate_show(struct blk_integrity *bi, char *page)
>   {
> -	return sprintf(page, "%d\n", (bi->flags & INTEGRITY_FLAG_WRITE) != 0);
> +	return sprintf(page, "%d\n", (bi->flags & BLK_INTEGRITY_GENERATE) != 0);
>   }
>   
>   static struct integrity_sysfs_entry integrity_format_entry = {
> @@ -317,23 +317,23 @@ static struct integrity_sysfs_entry integrity_tag_size_entry = {
>   	.show = integrity_tag_size_show,
>   };
>   
> -static struct integrity_sysfs_entry integrity_read_entry = {
> +static struct integrity_sysfs_entry integrity_verify_entry = {
>   	.attr = { .name = "read_verify", .mode = S_IRUGO | S_IWUSR },
> -	.show = integrity_read_show,
> -	.store = integrity_read_store,
> +	.show = integrity_verify_show,
> +	.store = integrity_verify_store,
>   };
>   
> -static struct integrity_sysfs_entry integrity_write_entry = {
> +static struct integrity_sysfs_entry integrity_generate_entry = {
>   	.attr = { .name = "write_generate", .mode = S_IRUGO | S_IWUSR },
> -	.show = integrity_write_show,
> -	.store = integrity_write_store,
> +	.show = integrity_generate_show,
> +	.store = integrity_generate_store,
>   };
>   
>   static struct attribute *integrity_attrs[] = {
>   	&integrity_format_entry.attr,
>   	&integrity_tag_size_entry.attr,
> -	&integrity_read_entry.attr,
> -	&integrity_write_entry.attr,
> +	&integrity_verify_entry.attr,
> +	&integrity_generate_entry.attr,
>   	NULL,
>   };
>   
> @@ -406,7 +406,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
>   
>   		kobject_uevent(&bi->kobj, KOBJ_ADD);
>   
> -		bi->flags |= INTEGRITY_FLAG_READ | INTEGRITY_FLAG_WRITE;
> +		bi->flags |= BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE;
>   		bi->interval = queue_logical_block_size(disk->queue);
>   		disk->integrity = bi;
>   	} else
> @@ -419,6 +419,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
>   		bi->verify_fn = template->verify_fn;
>   		bi->tuple_size = template->tuple_size;
>   		bi->tag_size = template->tag_size;
> +		bi->flags |= template->flags;
>   	} else
>   		bi->name = bi_unsupported_name;
>   
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e4adbc687d0b..bb44630d27f8 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1428,8 +1428,10 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
>   
>   #if defined(CONFIG_BLK_DEV_INTEGRITY)
>   
> -#define INTEGRITY_FLAG_READ	2	/* verify data integrity on read */
> -#define INTEGRITY_FLAG_WRITE	4	/* generate data integrity on write */
> +enum blk_integrity_flags {
> +	BLK_INTEGRITY_VERIFY		= 1 << 0,
> +	BLK_INTEGRITY_GENERATE		= 1 << 1,
> +};
>   
>   struct blk_integrity_iter {
>   	void			*prot_buf;

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

