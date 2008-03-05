From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte   count
Date: Wed, 5 Mar 2008 14:51:21 +0100
Message-ID: <20080305135121.GK6704@kernel.dk>
References: <47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org> <47CDDC31.4070806@gmail.com> <20080305092619Y.fujita.tomonori@lab.ntt.co.jp> <47CE72EF.7050302@panasas.com> <20080305123317.GI6704@kernel.dk> <47CE9634.6040501@panasas.com> <20080305124857.GJ6704@kernel.dk> <47CEA40F.6050903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2995 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYCENvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2008 08:51:25 -0500
Content-Disposition: inline
In-Reply-To: <47CEA40F.6050903@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Galbraith <efault@gmx.de>, James.Bottomley@HansenPartnership.com, tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Wed, Mar 05 2008, Tejun Heo wrote:
> Hello, Jens, Boaz.
> 
> Jens Axboe wrote:
> >>>> From: Boaz Harrosh <bharrosh@panasas.com>
> >>>> Date: Wed, 5 Mar 2008 12:07:12 +0200
> >>>> Subject: [PATCH] blk: missing add of padded bytes to io completion byte count
> >>>>
> >>>> the commit e97a294ef6938512b655b1abf17656cf2b26f709 was very wrong. This is
> >>>> because scsi-ml supports the ability to split a request into smaller chunks,
> >>>> in which case scsi_bufflen() is smaller then request length. Then at completion
> >>>> time the remainder can be issued as a new scsi command. In that case the above
> >>>> commit is a data corruption.
> 
> Thanks for catching the stupidity.  Did it actually happen?  PC commands
> are not completed in pieces and padding / draining should only happen
> for those.  qc->extra_len should be zero where commands can be splitted
> for all current cases.
> 
> >>> We needed something for -rc4, so it had to be rushed a bit...
> >>>
> >>>> Also in this fix all users of block layer are taken care of, and not only
> >>>> scsi devices.
> >>>>
> >>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> >>>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> >>>> ---
> >>>>  block/blk-core.c    |    4 ++++
> >>>>  drivers/scsi/scsi.c |    2 +-
> >>>>  2 files changed, 5 insertions(+), 1 deletions(-)
> >>>>
> >>>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>>> index 2a438a9..37fcccc 100644
> >>>> --- a/block/blk-core.c
> >>>> +++ b/block/blk-core.c
> >>>> @@ -1549,6 +1549,9 @@ static int __end_that_request_first(struct request *req, int error,
> >>>>  			     nr_bytes >> 9, req->sector);
> >>>>  	}
> >>>>  
> >>>> +	if (nr_bytes >= blk_rq_bytes(req))
> >>>> +		nr_bytes += req->extra_len;
> >>>> +
> 
> This is getting insanely subtle.  Let's say there's PIO driver which
> transfer certain sized chunks at a time and completes request partially
> after completing each chunk and the driver uses draining to eat up
> whatever excess data, which seems like a legit use case to me.  But it
> won't work because __end_that_request_first() will terminate when it
> reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,
> 
> Nacked-by: Tejun Heo <htejun@gmail.com>

Yeah, I think I may have gone a bit overboard in applying this so
quickly. It's just not a good interface, silently adding the extra
length if asked to complete more. It may even happen right now, for a
driver that does no padding (it probably wont do any harm here either,
but still).

I'll try and see if I can come up with something cleaner.

My basic design paradigm for this is that the _driver_ (or mid layer, if
SCSI wants to handle it) should care about the padding. So make it easy
for them to pad, but have it 'unrolled' by completion time. We should
NOT need any extra_len checks or additions in the block/ directory,
period.

-- 
Jens Axboe

