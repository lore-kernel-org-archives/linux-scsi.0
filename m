From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 03 Mar 2008 17:26:23 +0900
Message-ID: <20080303172623O.fujita.tomonori@lab.ntt.co.jp>
References: <47CB6508.3040206@gmail.com>
	<20080303125940T.fujita.tomonori@lab.ntt.co.jp>
	<47CB79E9.8000505@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CB79E9.8000505@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 03 Mar 2008 13:09:13 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> >> - I think bugs caused by using raw_data_len instead of data_len are more
> >> subtle than the other way around.  Using data_len instead of
> >> raw_data_len usually affects the application layer while using
> >> raw_data_len instead of data_len affects the DMA engine and transport layer.
> > 
> > If we add extra_len, we can get what raw_data_len and data_len
> > provide.
> > 
> > I can't see what changing the meaning of rq->data_len (and
> > investigating all the block drivers) gives us.
> 
> No matter which way you go, you change the meaning of rq->data_len and
> you MUST inspect rq->data_len usage whichever way you go.

The patch doens't change that rq->data_len means the true data
length. But yeah, it breaks rq->data_len == sum(sg). So it might break
some drivers.


> Apply your patch and try to do sg IO on IDE cdrom w/ various
> transfer lengths.

I've just tried the patch with both ata and libata and it seems to
work.

For anyone hitting this problem, please try the following patch:

http://lkml.org/lkml/2008/3/2/218


Thanks,
