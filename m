From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Thu, 8 Jul 2010 15:11:46 -0400
Message-ID: <20100708191146.GA1538@redhat.com>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
 <20100706213136.GA21246@redhat.com>
 <4C33BEDF.7050602@interlog.com>
 <20100707004748.GA3068@redhat.com>
 <yq1ocek6pf4.fsf@sermon.lab.mkp.net>
 <4C33F619.4010302@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0GHTMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 15:12:12 -0400
Content-Disposition: inline
In-Reply-To: <4C33F619.4010302@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On Tue, Jul 06 2010 at 11:35pm -0400,
Douglas Gilbert <dgilbert@interlog.com> wrote:

> On 10-07-06 09:39 PM, Martin K. Petersen wrote:
> >>>>>>"Mike" == Mike Snitzer<snitzer@redhat.com>  writes:

> >Mike>  # cat /sys/block/sda/queue/discard_granularity
> >Mike>  512
> >Mike>  # cat /sys/block/sda/queue/discard_max_bytes
> >Mike>  4294966784
> >
> >Mike>  I'll look to understand why 'discard_max_bytes' is so large for
> >Mike>  this LUN despite the standard Block limits VPD page not reflecting
> >Mike>  this.
> >
> >discard_max_bytes is 0xFFFFFFFF for WRITE SAME(16).
> 
> FORMAT UNIT has several associated mechanisms (e.g
> IMMED bit and REQUEST SENSE polling) that let it
> run for a long time. WRITE SAME has no such mechanisms.
> There was a proposal put to t10 to place an upper limit
> on WRITE SAME's lba count but I think that has been
> dropped. IMO if we want to give large block counts to
> UNMAP or WRITE SAME in the absence of guidance from the
> block limits VPD page, then we need to cope with
> device saying "nope".
> 
> Whatever device Mike has it seems to be failing the
> WRITE SAME(16) command due to the huge lba block count.
> Does the device work with a smaller lba block count?
> For example:
>    sg_write_same --unmap --lba 0 --num 1024 /dev/sda

Yes, and even large requests that have 4K granularity work.

Turns out that this LUN has a 4K granularity requirement (will fail the
WRITE SAME if the granularity requirements are not met).

4294966784 % 4096 = 3584

So we need to see why Linux actually has discard_max_bytes = 4294966784
rather than the full 0xFFFFFFFF we initialize in read_capacity_16:

q->limits.max_discard_sectors = 0xffffffff;

By bet is on blkdev_issue_discard:
  unsigned int max_discard_sectors =
         min(q->limits.max_discard_sectors, UINT_MAX >> 9);

Mike
