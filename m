From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] block: provide helpers for reading block count
Date: Mon, 27 Jun 2016 09:30:12 -0700
Message-ID: <20160627163012.GA11116@linux-80c1.suse>
References: <20160623133016.3781907-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160623133016.3781907-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, "Nicholas A . Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 23 Jun 2016, Arnd Bergmann wrote:

>Several drivers use an expensive do_div() to compute the number
>of logical or physical blocks in a blockdev, which can be done
>more efficiently using a shift, since the blocksize is always
>a power of two number.
>
>Let's introduce bdev_logical_block_count() and bdev_physical_block_count()
>helper functions mirroring the bdev_logical_block_size() and
>bdev_physical_block_size() interfaces for the block size.

>@@ -1226,6 +1226,13 @@ static inline unsigned short bdev_logical_block_size(struct block_device *bdev)
> 	return queue_logical_block_size(bdev_get_queue(bdev));
> }
>
>+static inline sector_t bdev_logical_block_count(struct block_device *bdev)

Curious, why not just return u64 instead for all these instead of sector_t (ie
dealing with lba, it reads weird)?

Thanks,
Davidlohr
