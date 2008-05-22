From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] revert the commit 22a9189f (cdrom: use kmalloced
	buffers instead of buffers on stack)
Date: Thu, 22 May 2008 09:43:12 +0100
Message-ID: <1211445792.3956.14.camel@localhost.localdomain>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <20080521221113.GA12695@alpha.franken.de> <20080522095506E.tomof@acm.org>
	 <20080521.181847.157652663.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080521.181847.157652663.davem@davemloft.net>
Sender: linux-ide-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, tsbogend@alpha.franken.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, jeff@garzik.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-05-21 at 18:18 -0700, David Miller wrote:
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu, 22 May 2008 10:13:31 +0900
> 
> > DMA on stack is forbidden because of non coherent architecutes and
> > architectures can't uses stack addresses for DMA? What architectures
> > can't uses stack addresses for DMA? Would it be better to just forbid
> > using stack addresses for DMA on all the architectures at all times?
> 
> Rather, the real problem is that some architectures map the kernel
> stack virtually, and as a result virt_to_page() and things like that
> will not work.
> 
> It really is fully not working to put DMA buffers on the stack
> in these cases.

Actually, for SCSI only, that problem is fixed.  Our decision to
re-route all I/O, including kernel internal I/O through the block
mapping algorithms (really so we don't have to worry about GFP_DMA any
more since we can now use the block bounce buffers) means that all SCSI
submission routines will accept vmalloc'd and even stack buffers
perfectly correctly.

However (before anyone gets any ideas), the stack is incredibly
dangerous to do DMA on because it's packed with current data.  If you
don't get the alignment requirements right on a non-coherent platform,
you'll end up corrupting data because of cache line interference issues.
For this reason, DMA to stack is still technically illegal.

James


