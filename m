From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/4] revert the commit 22a9189f (cdrom: use kmalloced
	buffers instead of buffers on stack)
Date: Mon, 26 May 2008 18:17:34 +0900
Message-ID: <20080526181723X.tomof@acm.org>
References: <20080522095506E.tomof@acm.org>
	<20080521.181847.157652663.davem@davemloft.net>
	<1211445792.3956.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37654 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYEZJSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2008 05:18:09 -0400
In-Reply-To: <1211445792.3956.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, tsbogend@alpha.franken.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, jeff@garzik.org, akpm@linux-foundation.org

On Thu, 22 May 2008 09:43:12 +0100
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-05-21 at 18:18 -0700, David Miller wrote:
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Thu, 22 May 2008 10:13:31 +0900
> > 
> > > DMA on stack is forbidden because of non coherent architecutes and
> > > architectures can't uses stack addresses for DMA? What architectures
> > > can't uses stack addresses for DMA? Would it be better to just forbid
> > > using stack addresses for DMA on all the architectures at all times?
> > 
> > Rather, the real problem is that some architectures map the kernel
> > stack virtually, and as a result virt_to_page() and things like that
> > will not work.
> > 
> > It really is fully not working to put DMA buffers on the stack
> > in these cases.
> 
> Actually, for SCSI only, that problem is fixed.  Our decision to
> re-route all I/O, including kernel internal I/O through the block
> mapping algorithms (really so we don't have to worry about GFP_DMA any
> more since we can now use the block bounce buffers) means that all SCSI
> submission routines will accept vmalloc'd and even stack buffers
> perfectly correctly.

Yeah, post 2.6.24, blk_rq_map_kern was fixed to use the bounce
buffers. But the block layer doesn't take care of stack buffers or non
coherent architectures wrt the bounce buffers. If we fix that, all
SCSI submission routines are fine. That's the issue that this patchset
tries to fix.


> However (before anyone gets any ideas), the stack is incredibly
> dangerous to do DMA on because it's packed with current data.  If you
> don't get the alignment requirements right on a non-coherent platform,
> you'll end up corrupting data because of cache line interference issues.
> For this reason, DMA to stack is still technically illegal.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
