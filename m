From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Mon, 03 Mar 2008 18:21:13 +0900
Message-ID: <47CBC309.7090106@gmail.com>
References: <47CB6508.3040206@gmail.com>	<20080303125940T.fujita.tomonori@lab.ntt.co.jp>	<47CB79E9.8000505@gmail.com> <20080303172623O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080303172623O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tomof@acm.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, efault@gmx.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
>>> I can't see what changing the meaning of rq->data_len (and
>>> investigating all the block drivers) gives us.
>> No matter which way you go, you change the meaning of rq->data_len and
>> you MUST inspect rq->data_len usage whichever way you go.
> 
> The patch doens't change that rq->data_len means the true data
> length. But yeah, it breaks rq->data_len == sum(sg). So it might break
> some drivers.

Yeah, that's what I was saying.  You end up breaking one of the two
assumptions.  As sglist is getting modified for any driver if it has DMA
alignment set, whether rq->data_len is adjusted together or not, sglist
and data_len usages have to be audited.

>> Apply your patch and try to do sg IO on IDE cdrom w/ various
>> transfer lengths.
> 
> I've just tried the patch with both ata and libata and it seems to
> work.

Right, I missed you added extra_len in libata and IDE isn't using block
layer stuff yet.

> For anyone hitting this problem, please try the following patch:
> 
> http://lkml.org/lkml/2008/3/2/218

Whether rq->data_len stays with requested data buffer size or sum(sg), I
think we need to separate out padding from address alignment; otherwise,
we'll have to audit every block driver to make sure they can deal with
extended sglist no matter which value rq->data_len ends up indicating.

If padding is applied iff explicitly requested, rq->data_len indicates
matters only to the drivers which want to see the data length adjusted,
so most of the problems go away.

-- 
tejun
