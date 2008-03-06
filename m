From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte   count
Date: Thu, 6 Mar 2008 14:41:39 +0100
Message-ID: <20080306134138.GF17940@kernel.dk>
References: <47CEA40F.6050903@gmail.com> <20080305135121.GK6704@kernel.dk> <1204730484.3047.10.camel@localhost.localdomain> <20080306134146A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080306134146A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, htejun@gmail.com, bharrosh@panasas.com, efault@gmx.de, tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 06 2008, FUJITA Tomonori wrote:
> On Wed, 05 Mar 2008 09:21:24 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Wed, 2008-03-05 at 14:51 +0100, Jens Axboe wrote:
> > > On Wed, Mar 05 2008, Tejun Heo wrote:
> > > > This is getting insanely subtle.  Let's say there's PIO driver which
> > > > transfer certain sized chunks at a time and completes request partially
> > > > after completing each chunk and the driver uses draining to eat up
> > > > whatever excess data, which seems like a legit use case to me.  But it
> > > > won't work because __end_that_request_first() will terminate when it
> > > > reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,
> > > > 
> > > > Nacked-by: Tejun Heo <htejun@gmail.com>
> > > 
> > > Yeah, I think I may have gone a bit overboard in applying this so
> > > quickly. It's just not a good interface, silently adding the extra
> > > length if asked to complete more. It may even happen right now, for a
> > > driver that does no padding (it probably wont do any harm here either,
> > > but still).
> > > 
> > > I'll try and see if I can come up with something cleaner.
> > > 
> > > My basic design paradigm for this is that the _driver_ (or mid layer, if
> > > SCSI wants to handle it) should care about the padding. So make it easy
> > > for them to pad, but have it 'unrolled' by completion time. We should
> > > NOT need any extra_len checks or additions in the block/ directory,
> > > period.
> > 
> > Right, that's why my original proposal was to do nothing for padding
> > (other than ensure the driver could adjust the length if it wanted to)
> > and to add an extra element always for draining, which the driver could
> > ignore.  It basically pushed the use paradigm onto the driver.
> > 
> > If we want the use paradigm shared between block and driver, then I
> > think the best approach is to keep all the bios the same (so not adjust
> > for padding), but do adjust in the blk_rq_map_sg().  That way we have
> > the padding and draining unwind information by comparing with the bio.
> 
> Adjusting only sg in blk_rq_map_sg (like drain) looks much
> better. This works with libata for me.

Looks like a much better solution to me. Anyone have any valid
objections against moving the padding to the sg map time?

-- 
Jens Axboe

