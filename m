From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Fri, 9 Jul 2010 14:06:11 -0400
Message-ID: <20100709180611.GA19808@redhat.com>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
 <20100706213136.GA21246@redhat.com>
 <4C33BEDF.7050602@interlog.com>
 <20100707004748.GA3068@redhat.com>
 <yq1ocek6pf4.fsf@sermon.lab.mkp.net>
 <4C33F619.4010302@interlog.com>
 <20100708191146.GA1538@redhat.com>
 <yq1eifc1uzo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab0GISGa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2010 14:06:30 -0400
Content-Disposition: inline
In-Reply-To: <yq1eifc1uzo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On Fri, Jul 09 2010 at 12:27pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Turns out that this LUN has a 4K granularity requirement (will
> Mike> fail the WRITE SAME if the granularity requirements are not met).
> 
> That's lame.  The devices I've been working with just ignore the
> portions of the block range that are not aligned / do not constitute
> entire blocks.

What is really lame is this LUN also doesn't have the correct
discard_granularity!

# cat /sys/block/sda/queue/discard_granularity 
512
 
> I've had the following patch kicking around in my tree for a while.  It
> does not yet handle offset discard alignment, though.

OK, won't help us for this LUN but thanks.

I'm left wondering whether the higher level that is discarding a
particular large region (say blkdev_issue_discard's loop) should also be
trained about discard alignment too.  That way the discard requests are
submitted properly aligned and they aren't reduced (leaving holes, like
your patch could do) -- except for the last discard in a sequence, which
could be reduced if its granularity is wrong.

No idea if the above will make sense to others ;)

Mike
