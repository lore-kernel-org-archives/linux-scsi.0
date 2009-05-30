From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH block#for-2.6.31] block: fix an oops on BLKPREP_KILL
Date: Sat, 30 May 2009 14:23:04 +0000
Message-ID: <1243693384.5223.7.camel@mulgrave.int.hansenpartnership.com>
References: <1243635503.2919.67.camel@localhost.localdomain>
	 <20090530044137.GM11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090530044137.GM11363@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2009-05-30 at 06:41 +0200, Jens Axboe wrote:
> On Fri, May 29 2009, James Bottomley wrote:
> > Doing a bit of torture testing, I ran across a BUG in the block
> > subsystem (at blk-core.c:2048): the test for if the request is queued.
> > 
> > It turns out the trigger was a BLKPREP_KILL coming out of the SCSI prep
> > function.  Currently for BLKPREP_KILL requests, we send them straight
> > into __blk_end_request_all() with an error, but they've never been
> > dequeued, so they trip the bug.  Fix this by starting requests before
> > killing them.
> > 
> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > ---
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 8b3b74e..9a0568c 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1789,6 +1789,7 @@ struct request *blk_peek_request(struct request_queue *q)
> >  			break;
> >  		} else if (ret == BLKPREP_KILL) {
> >  			rq->cmd_flags |= REQ_QUIET;
> > +			blk_start_request(rq);
> >  			__blk_end_request_all(rq, -EIO);
> >  		} else {
> >  			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
> 
> Given how illogical that now looks, I think it could do with a comment.
> I'll add that while applying.

Um, if it looks illogical, then so is the new everything has to be
dequeued before completion requirement ...  I agree a comment reminding
people why it has to work this way doesn't hurt, but if it looks
illogical then there might be something wrong with the rules requiring
this to happen ...

James


