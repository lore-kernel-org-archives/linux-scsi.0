From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/4] block: add large command support
Date: Thu, 17 Apr 2008 13:02:00 +0900
Message-ID: <20080417125900E.tomof@acm.org>
References: <200804160050.54842.bzolnier@gmail.com>
	<20080416075743R.fujita.tomonori@lab.ntt.co.jp>
	<20080416083305.GY12774@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080416083305.GY12774@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, linux-scsi@vger.kernel.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 16 Apr 2008 10:33:06 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Apr 16 2008, FUJITA Tomonori wrote:
> > On Wed, 16 Apr 2008 00:50:54 +0200
> > Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> > > 
> > > Hi,
> > > 
> > > On Monday 14 April 2008, Jens Axboe wrote:
> > > > On Mon, Apr 14 2008, FUJITA Tomonori wrote:
> > > > > This patch changes rq->cmd from the static array to a pointer to
> > > > > support large commands.
> > > > > 
> > > > > We rarely handle large commands. So for optimization, a struct request
> > > > > still has a static array for a command. rq_init sets rq->cmd pointer
> > > > > to the static array.
> > > > > 
> > > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > > Cc: Jens Axboe <jens.axboe@oracle.com>
> > > > > ---
> > > > >  block/blk-core.c       |    1 +
> > > > >  drivers/ide/ide-io.c   |    1 +
> > > > >  include/linux/blkdev.h |   12 ++++++++++--
> > > > >  3 files changed, 12 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > > index 6669238..6f0968f 100644
> > > > > --- a/block/blk-core.c
> > > > > +++ b/block/blk-core.c
> > > > > @@ -132,6 +132,7 @@ void rq_init(struct request_queue *q, struct request *rq)
> > > > >  	rq->errors = 0;
> > > > >  	rq->ref_count = 1;
> > > > >  	rq->cmd_len = 0;
> > > > > +	rq->cmd = rq->__cmd;
> > > > >  	memset(rq->cmd, 0, BLK_MAX_CDB);
> > > > >  	rq->data_len = 0;
> > > > >  	rq->extra_len = 0;
> > > > > diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> > > > > index 7153796..bac5ea1 100644
> > > > > --- a/drivers/ide/ide-io.c
> > > > > +++ b/drivers/ide/ide-io.c
> > > > > @@ -1595,6 +1595,7 @@ void ide_init_drive_cmd (struct request *rq)
> > > > >  {
> > > > >  	memset(rq, 0, sizeof(*rq));
> > > > >  	rq->ref_count = 1;
> > > > > +	rq->cmd = rq->__cmd;
> > > > >  }
> > > 
> > > Tomo, some more changes are needed:
> > > 
> > > Please think about all _static_/dynamic allocations of 'struct request'
> > > used together with REQ_TYPE_SPECIAL etc., i.e.
> > 
> > I think that using struct request allocated statically is wrong from
> > the perspective of the block layer design, that is, you always need to
> > use blk_get_request. I think that except ide, everyone does.
> > 
> > I try to convert ide to use blk_get_request properly if you want.
> 
> That would be best, but the on-stack allocation has the benefit that
> it'll always work. So until we can completely get rid of that, lets just
> make it a hard rule that ANY rq allocation MUST call rq_init(). It's a
> lot saner than doing a memset() anyway.

I'm fine with that.

There is one minor issue. rq_init doesn't initialize rq->cmd_flags so
the callers need to do it for themselves (If they don't, probably they
hit BUG_ON in blk_queue_end_tag).
