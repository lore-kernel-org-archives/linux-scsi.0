From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 20:20:17 +0200
Message-ID: <20090605182015.GA10342@8bytes.org>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906050852g2be64c7elb2872a6129d13f56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756125AbZFESUg@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <64bb37e0906050852g2be64c7elb2872a6129d13f56@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 05, 2009 at 05:52:27PM +0200, Torsten Kaiser wrote:
> 
> This doesn't look right to me.
> The comment above says "returns the entry from the hash which fits
> best", but this will always return NULL, if there are are multiple
> entrys, but no perfect match.

This is intentional. If there is no perfect-fit there is no way to tell
which entry was meant. So we potentially report wrong errors with a
wrong mapping backtrace which confuses even more than the wrong
"DMA-API: device driver tries to free DMA memory it has not allocated".

> Should there be a warning if more then one possible match were found?

True. That would be better. But I tried to keep the code change as small
as possible without disabling the feature completly.

> * driver maps address 'a' with size 1
> * driver maps same address 'a' with size 2
> * driver wrongly unmaps the second allocation with size 1
>   -> no warning, because the first allocation is returned

Hmm, I am not sure if we can handle this situation correctly in the
dma-debug code. There is no unique key to identify a mapping request
which allows to assign an unmap request to it. Currently dma-debug uses
device and dma-address. But that seems not to be sufficient. The
best-fit algorithm is also a but fuzzy of course.

> * driver wants to correctly unmap the first allocation
>   -> wrong warning about this unmap because size mismatch

Ok, at least we get a warning about a bug. Not very useful because it
reports the wrong bug. Is this the situation which triggered the
original bug report?

> Also what about sg_call_ents and sg_mapped_ents?
> Could it be possible to get the same address/size with different sg-counts.

It looks not forbidden in the API. So I guess this can happen too.

Regards,

	Joerg
