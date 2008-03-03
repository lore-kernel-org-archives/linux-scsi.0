From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 3 Mar 2008 21:17:28 +0900
Message-ID: <20080303211727P.tomof@acm.org>
References: <47CB79E9.8000505@gmail.com>
	<20080303172623O.fujita.tomonori@lab.ntt.co.jp>
	<47CBC309.7090106@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CBC309.7090106@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.comfujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Mon, 03 Mar 2008 18:21:13 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> >>> I can't see what changing the meaning of rq->data_len (and
> >>> investigating all the block drivers) gives us.
> >> No matter which way you go, you change the meaning of rq->data_len and
> >> you MUST inspect rq->data_len usage whichever way you go.
> > 
> > The patch doens't change that rq->data_len means the true data
> > length. But yeah, it breaks rq->data_len == sum(sg). So it might break
> > some drivers.
> 
> Yeah, that's what I was saying.  You end up breaking one of the two
> assumptions.  As sglist is getting modified for any driver if it has DMA
> alignment set, whether rq->data_len is adjusted together or not, sglist
> and data_len usages have to be audited.

My patch (well, James' original approach) doesn't affect drivers that
don't use drain buffer. rq->data_len still means the true data length
and rq->data_len is equal to sum(sg) for them. So right now we need to
audit only libata.

But your patch changes the meaning of rq->data_len. It affects all the
drivers. So it breaks non libata stuff, like the SMP handler. We need
to audit all the drivers.
