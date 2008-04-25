From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC 0/5] block large commands support continue
Date: Fri, 25 Apr 2008 18:27:00 +0900
Message-ID: <20080425182700H.fujita.tomonori@lab.ntt.co.jp>
References: <20080424104930.GU12774@kernel.dk>
	<20080425001725K.tomof@acm.org>
	<20080425092204.GJ12774@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080425092204.GJ12774@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, bharrosh@panasas.com, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, pw@osc.edu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 25 Apr 2008 11:22:04 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Apr 25 2008, FUJITA Tomonori wrote:
> > On Thu, 24 Apr 2008 12:49:30 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Thu, Apr 24 2008, FUJITA Tomonori wrote:
> > > > On Thu, 24 Apr 2008 13:31:21 +0900
> > > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > > 
> > > > > On Wed, 23 Apr 2008 17:50:42 +0300
> > > > > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > > > > 
> > > > > > 
> > > > > > The support for large commands was dropped from the for-2.6.26 branch
> > > > > > and will probably not get accepted into next kernel.
> > > > > > 
> > > > > > I have tried to take all comments from Jens and Bart. and incorporate
> > > > > > it into a new patchset. This is basically Tomo's patchset but with
> > > > > > proposed changes.
> > > > > 
> > > > > Have you seen the patchset to remove request on the stack?
> > > > > 
> > > > > http://marc.info/?l=linux-ide&m=120882410712466&w=2
> > > > > 
> > > > > 
> > > > > > They are based on current linux-block/master. They will probably conflict with
> > > > > > latest patch sent by Tomo for the blk_get_request(). Once those patches
> > > > > > get accepted at some git tree, (Where will that be?), I will rebase these
> > > > > > on top of them. Please CC me of any progress.
> > > > > > 
> > > > > > [PATCH 1/5] block: no need to initialize rq->cmd
> > > > > >   This is 2 of Tomo's patches squashed together as they are
> > > > > >   small and do the same. Tomo is this OK?
> > > > > > 
> > > > > > [PATCH 2/5] block: replace sizeof(rq->cmd) with BLK_MAX_CDB
> > > > > >   Tomos patch rebased to here
> > > > > > 
> > > > > > [PATCH 3/5] block: Export rq_init, rename to blk_init_rq
> > > > > > [PATCH 4/5] block: Use new blk_init_rq
> > > > > >   These patches are basically what Jens and Bart has suggested, that with
> > > > > >   a small code change to blk-core.c we can memset at rq_init() and only set
> > > > > >   none zero members. We can also export that initializer and use it all over
> > > > > >   the ide tree where ever requests don't come from a request queue. (OK also
> > > > > >   at scsi_error.c)
> > > > > 
> > > > > +void blk_init_rq(struct request_queue *q, struct request *rq, int cmd_flags)
> > > > > 
> > > > > Hmm, would it be better to modify the block layer to let rq_init just
> > > > > memset() the request structure?
> > > > 
> > > > I think, if we move rq_init to blk_alloc_request from get_request,
> > > > rq_init can just memset() the structure.
> > > > 
> > > > Then we can export rq_init and rq_init works for everyone.
> > > 
> > > Wont work, see the io scheduler set_request() functions.
> > 
> > Sorry, can you be more specific?
> > 
> > Only cfq uses set_request for now. cfq_set_request uses rq->cmd_flags
> > and stores information at rq->elevator_private and
> > rq->elevator_private2.
> > 
> > The patch does memset() the request structure and sets up
> > rq->cmd_flags, and then elv_set_request. Doesn't it work?
> 
> Sorry, with the moved rq_init() it should work, didn't look closely
> enough.

No problem.

So are you ok with the patch? If so, I'll re-send it with a proper
description and the signed-off.
