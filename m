From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] block: Return error in rescan_partitions if
 revalidating disk failed
Date: Tue, 21 Apr 2015 19:58:26 -0700
Message-ID: <1429671506.18798.4.camel@HansenPartnership.com>
References: <1427192175-23802-1-git-send-email-famz@redhat.com>
	 <1427192175-23802-2-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427192175-23802-2-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-03-24 at 18:16 +0800, Fam Zheng wrote:
> If the disk can't read capacity, we should return an error.

I'm not sure I buy this: you need to justify why.

For instance removable media return an error in revalidate that causes
the medium not present flag to be set ... do we really want to propagate
the error in that case?

> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  block/partition-generic.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/partition-generic.c b/block/partition-generic.c
> index 0d9e5f9..1e60d7d 100644
> --- a/block/partition-generic.c
> +++ b/block/partition-generic.c
> @@ -427,11 +427,11 @@ rescan:
>  		return res;
>  
>  	if (disk->fops->revalidate_disk)
> -		disk->fops->revalidate_disk(disk);
> +		res = disk->fops->revalidate_disk(disk);

You're assuming here that a negative error code is being returned, but
some (cciss) seem to be returning 1 on error.

You'll need to assure us that you've checked all the consumers before
making this change.

James

>  	check_disk_size_change(disk, bdev);
>  	bdev->bd_invalidated = 0;
> -	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
> -		return 0;
> +	if (res || !get_capacity(disk) || !(state = check_partition(disk, bdev)))
> +		return res;
>  	if (IS_ERR(state)) {
>  		/*
>  		 * I/O error reading the partition table.  If any
