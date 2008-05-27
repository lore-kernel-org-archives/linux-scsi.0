From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 0/4] revert the commit 22a9189f (cdrom: use kmalloced buffers instead of buffers on stack)
Date: Tue, 27 May 2008 20:58:55 +0200
Message-ID: <200805272058.56130.bzolnier@gmail.com>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net, Borislav Petkov <petkovbb@gmail.com>
List-Id: linux-scsi@vger.kernel.org


On Tuesday 20 May 2008, FUJITA Tomonori wrote:
> The goal of this patchset is reverting the commit
> 22a9189fd073db3d03a4cf8b8c098aa207602de1 (cdrom: use kmalloced buffers
> instead of buffers on stack).
> 
> http://lkml.org/lkml/2008/4/21/634
> 
> The commit is using kmalloced buffers for cdrom packet commands to
> avoid stack corruption on non coherent platforms. But allocating a
> small buffer like this is not nice (unnecessary complicity):
> 
> +	buffer = kmalloc(8, GFP_KERNEL);
> 
> I tried to remove generic_packet() and convert cdrom users to use the
> block queue like pkt_generic_packet (as Jens suggested in the thread
> if I correctly understand), but it turned out that it needs tricky
> surgery (like handling ssleep and retries for packet commands in ide).
> 
> Then I found that we can easily handle packet commands on non coherent
> platforms. The diffstat is pretty small except for the revert. All
> this patchset does is just setting the dma_pad_mask to
> ARCH_KMALLOC_MINALIGN.
> 
> Only scsi and ide-cd do DMA generic_packet. In the case of scsi,
> sr_packet uses blk_rq_map_kern (the commit
> 68154e90c9d1492d570671ae181d9a8f8530da55) post 2.6.25. So if we set
> the dma padding on non coherent platforms, sr_packet uses allocated
> pages properly.
> 
> In the case of IDE, ide-cd has a mechanism to handle alignment and
> padding for SG_IO. So we can easily exploit it for packet commands.
> 
> If some architectures can't do DMA on stack, we also need to a new
> queue_flag like QUEUE_FLAG_NO_DMA_ON_STACK in addtion of this
> patchset.
> 
> The diffstat is:
> 
>  block/blk-settings.c      |   30 +++++-
>  drivers/ata/libata-scsi.c |    3 +-
>  drivers/cdrom/cdrom.c     |  274 +++++++++++++++------------------------------
>  drivers/ide/ide-cd.c      |   17 ++-
>  include/linux/blkdev.h    |    1 +
>  5 files changed, 134 insertions(+), 191 deletions(-)

The patchset looks good to me after a quick look but Borislav is a more
appropriate person to contact on ide-cd specific patches.

Thanks,
Bart
