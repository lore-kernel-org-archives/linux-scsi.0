From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt sees I/O
 capped at 1MB and no merging
Date: Thu, 22 Dec 2016 12:59:59 -0500 (EST)
Message-ID: <1357936316.8619285.1482429599286.JavaMail.zimbra@redhat.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com> <1668746735.8200653.1482266682585.JavaMail.zimbra@redhat.com> <120559766.8215321.1482291094018.JavaMail.zimbra@redhat.com> <1928955380.8220327.1482302041315.JavaMail.zimbra@redhat.com> <1337539588.8422488.1482372617094.JavaMail.zimbra@redhat.com> <20161222062321.GA30326@infradead.org> <1661819060.8462293.1482412678092.JavaMail.zimbra@redhat.com> <20161222154049.GA4638@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222154049.GA4638-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


----- Original Message -----
> From: "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>,
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Thursday, December 22, 2016 10:40:49 AM
> Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt sees I/O capped at 1MB and no merging
> 
> Hi Laurance,
> 
> please try the patch below:
> 
> ---
> From 69febe1cfb55844862f768447432249781001f9c Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Date: Thu, 22 Dec 2016 16:38:29 +0100
> Subject: block: add back plugging in __blkdev_direct_IO
> 
> This allows sending larger than 1 MB requess to devices that support
> large I/O sizes.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Reported-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/block_dev.c | 3 +++
>  fs/iomap.c     | 1 -
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 7c45072..206a92a 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -328,6 +328,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter
> *iter, int nr_pages)
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = bdev_file_inode(file);
>  	struct block_device *bdev = I_BDEV(inode);
> +	struct blk_plug plug;
>  	struct blkdev_dio *dio;
>  	struct bio *bio;
>  	bool is_read = (iov_iter_rw(iter) == READ);
> @@ -353,6 +354,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter
> *iter, int nr_pages)
>  	dio->multi_bio = false;
>  	dio->should_dirty = is_read && (iter->type == ITER_IOVEC);
>  
> +	blk_start_plug(&plug);
>  	for (;;) {
>  		bio->bi_bdev = bdev;
>  		bio->bi_iter.bi_sector = pos >> 9;
> @@ -394,6 +396,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter
> *iter, int nr_pages)
>  		submit_bio(bio);
>  		bio = bio_alloc(GFP_KERNEL, nr_pages);
>  	}
> +	blk_finish_plug(&plug);
>  
>  	if (!dio->is_sync)
>  		return -EIOCBQUEUED;
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 354a123..3adf1e1 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -844,7 +844,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> struct iomap_ops *ops,
>  	size_t count = iov_iter_count(iter);
>  	loff_t pos = iocb->ki_pos, end = iocb->ki_pos + count - 1, ret = 0;
>  	unsigned int flags = IOMAP_DIRECT;
> -	struct blk_plug plug;
>  	struct iomap_dio *dio;
>  
>  	lockdep_assert_held(&inode->i_rwsem);
> --
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Christoph

The patch works and I now see 4MB I/O

# DISK STATISTICS (/sec)
#                   <---------reads---------><---------writes---------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  KBytes Merged  IOs Size  RWSize  QLen  Wait SvcTim Util
11:53:58 sdah        143360    105   35 4096       0      0    0    0    4096     1    28     28   99
11:53:59 sdah        139264    102   34 4096       0      0    0    0    4096     1    29     29   99
11:54:00 sdah        143360    105   35 4096       0      0    0    0    4096     1    28     28   99

I think you forgot to remove calls to blk_start_plug and blk_finish_plug in fs/iomap.c in your patch.
I took them out and built the test kernel that way.

Let me know if you will just remove those in the final or want a patch.


Thanks fo rthe super quick response

Regards
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
