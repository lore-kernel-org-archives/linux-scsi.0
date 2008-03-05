From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
	 count
Date: Wed, 05 Mar 2008 09:21:24 -0600
Message-ID: <1204730484.3047.10.camel@localhost.localdomain>
References: <47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org>
	 <47CDDC31.4070806@gmail.com>
	 <20080305092619Y.fujita.tomonori@lab.ntt.co.jp>
	 <47CE72EF.7050302@panasas.com> <20080305123317.GI6704@kernel.dk>
	 <47CE9634.6040501@panasas.com> <20080305124857.GJ6704@kernel.dk>
	 <47CEA40F.6050903@gmail.com>  <20080305135121.GK6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080305135121.GK6704@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Galbraith <efault@gmx.de>, tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-03-05 at 14:51 +0100, Jens Axboe wrote:
> On Wed, Mar 05 2008, Tejun Heo wrote:
> > This is getting insanely subtle.  Let's say there's PIO driver which
> > transfer certain sized chunks at a time and completes request partially
> > after completing each chunk and the driver uses draining to eat up
> > whatever excess data, which seems like a legit use case to me.  But it
> > won't work because __end_that_request_first() will terminate when it
> > reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,
> > 
> > Nacked-by: Tejun Heo <htejun@gmail.com>
> 
> Yeah, I think I may have gone a bit overboard in applying this so
> quickly. It's just not a good interface, silently adding the extra
> length if asked to complete more. It may even happen right now, for a
> driver that does no padding (it probably wont do any harm here either,
> but still).
> 
> I'll try and see if I can come up with something cleaner.
> 
> My basic design paradigm for this is that the _driver_ (or mid layer, if
> SCSI wants to handle it) should care about the padding. So make it easy
> for them to pad, but have it 'unrolled' by completion time. We should
> NOT need any extra_len checks or additions in the block/ directory,
> period.

Right, that's why my original proposal was to do nothing for padding
(other than ensure the driver could adjust the length if it wanted to)
and to add an extra element always for draining, which the driver could
ignore.  It basically pushed the use paradigm onto the driver.

If we want the use paradigm shared between block and driver, then I
think the best approach is to keep all the bios the same (so not adjust
for padding), but do adjust in the blk_rq_map_sg().  That way we have
the padding and draining unwind information by comparing with the bio.

For passing on to the driver:  req->data_len still needs to be the input
(bio) lenght.  req->extra_len can record how much padding and draining
was added.  The completion length also needs to be in terms of the true
(bio) length.  Now, here's the subtlety.  Because of the way transfers
work, we expect the padded length not to contribute to overrun (because
it represents transfers that were successfully completed at the correct
length), but we *do* expect drain usage to be recorded as overrun.
However, if we keep the bios intact, we have all the information to make
this determination in the block layer at completion time, with the
expectation that the lower layers report the exact amount they
transferred.

James


