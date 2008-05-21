From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [PATCH 0/4] revert the commit 22a9189f (cdrom: use kmalloced buffers instead of buffers on stack)
Date: Thu, 22 May 2008 00:11:13 +0200
Message-ID: <20080521221113.GA12695@alpha.franken.de>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net
List-Id: linux-scsi@vger.kernel.org

On Tue, May 20, 2008 at 01:58:30PM +0900, FUJITA Tomonori wrote:
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

If I read the bio code correctly with your patch non coherent system will
be punished a lot more. bio_copy_kern will allocate a whole page for this
8 bytes. Please correct me, if I'm wrong otherwise I tend to NAK that 
approach.

> If some architectures can't do DMA on stack, we also need to a new
> queue_flag like QUEUE_FLAG_NO_DMA_ON_STACK in addtion of this
> patchset.

DMA-mapping.txt tells that DMA on stack is forbidden. IMHO we either need
to revoke that first or deal with it. 

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
