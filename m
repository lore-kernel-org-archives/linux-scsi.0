From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH 4/4] block: add large command support
Date: Thu, 17 Apr 2008 13:55:48 +0200
Message-ID: <58cb370e0804170455i58a8165fuc4b675c034217bd5@mail.gmail.com>
References: <20080416075743R.fujita.tomonori@lab.ntt.co.jp>
	 <20080416083305.GY12774@kernel.dk> <4805C209.6040606@panasas.com>
	 <20080417123218V.tomof@acm.org> <20080417070704.GO12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080417070704.GO12774@kernel.dk>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 17, 2008 at 9:07 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Thu, Apr 17 2008, FUJITA Tomonori wrote:
>  > On Wed, 16 Apr 2008 12:08:25 +0300
>  > Boaz Harrosh <bharrosh@panasas.com> wrote:
>  >
>  > > On Wed, Apr 16 2008 at 11:33 +0300, Jens Axboe <jens.axboe@oracle.com> wrote:
>  > > > On Wed, Apr 16 2008, FUJITA Tomonori wrote:
>  > > >> On Wed, 16 Apr 2008 00:50:54 +0200
>  > > >> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>  > > >>
>  > > >>> Hi,
>  > > >>>
>  > > >>> On Monday 14 April 2008, Jens Axboe wrote:
>  > > >>>> On Mon, Apr 14 2008, FUJITA Tomonori wrote:
>  > > >>>>> This patch changes rq->cmd from the static array to a pointer to
>  > > >>>>> support large commands.
>  > > >>>>>
>  > > >>>>> We rarely handle large commands. So for optimization, a struct request
>  > > >>>>> still has a static array for a command. rq_init sets rq->cmd pointer
>  > > >>>>> to the static array.
>  > > >>>>>
>  > > >>>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>  > > >>>>> Cc: Jens Axboe <jens.axboe@oracle.com>
>  > > >>>>> ---
>  > > >>>>>  block/blk-core.c       |    1 +
>  > > >>>>>  drivers/ide/ide-io.c   |    1 +
>  > > >>>>>  include/linux/blkdev.h |   12 ++++++++++--
>  > > >>>>>  3 files changed, 12 insertions(+), 2 deletions(-)
>  > > >>>>>
>  > > >>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>  > > >>>>> index 6669238..6f0968f 100644
>  > > >>>>> --- a/block/blk-core.c
>  > > >>>>> +++ b/block/blk-core.c
>  > > >>>>> @@ -132,6 +132,7 @@ void rq_init(struct request_queue *q, struct request *rq)
>  > > >>>>>       rq->errors = 0;
>  > > >>>>>       rq->ref_count = 1;
>  > > >>>>>       rq->cmd_len = 0;
>  > > >>>>> +     rq->cmd = rq->__cmd;
>  > > >>>>>       memset(rq->cmd, 0, BLK_MAX_CDB);
>  > > >>>>>       rq->data_len = 0;
>  > > >>>>>       rq->extra_len = 0;
>  > > >>>>> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>  > > >>>>> index 7153796..bac5ea1 100644
>  > > >>>>> --- a/drivers/ide/ide-io.c
>  > > >>>>> +++ b/drivers/ide/ide-io.c
>  > > >>>>> @@ -1595,6 +1595,7 @@ void ide_init_drive_cmd (struct request *rq)
>  > > >>>>>  {
>  > > >>>>>       memset(rq, 0, sizeof(*rq));
>  > > >>>>>       rq->ref_count = 1;
>  > > >>>>> +     rq->cmd = rq->__cmd;
>  > > >>>>>  }
>  > > >>> Tomo, some more changes are needed:
>  > > >>>
>  > > >>> Please think about all _static_/dynamic allocations of 'struct request'
>  > > >>> used together with REQ_TYPE_SPECIAL etc., i.e.
>  > > >> I think that using struct request allocated statically is wrong from
>  > > >> the perspective of the block layer design, that is, you always need to
>  > > >> use blk_get_request. I think that except ide, everyone does.
>  > > >>
>  > > >> I try to convert ide to use blk_get_request properly if you want.
>  > > >
>  > > > That would be best, but the on-stack allocation has the benefit that
>  > > > it'll always work. So until we can completely get rid of that, lets just
>  > > > make it a hard rule that ANY rq allocation MUST call rq_init(). It's a
>  > > > lot saner than doing a memset() anyway.
>  > > >
>  > >
>  > > Just a patch that I had for ages since the bad old request bidi times,
>  > > perhaps is also good today. (rebased to for-2.6.26 branch)
>  > > ---
>  > > From: Boaz Harrosh <bharrosh@panasas.com>
>  > > Date: Wed, 16 Apr 2008 12:05:33 +0300
>  > > Subject: [PATCH] Initialize all members of struct request in rq_init
>  > >
>  > > Before, every member added/removed from struct request would entitle a change
>  > > to rq_init, for initialization. Now all members are default to zero and only
>  > > the none zero members are specifically initialized.
>  > >
>  > > Users that need requests on the stack or pre-allocated, must call rq_init()
>  > > before use.
>  > >
>  > > Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>  > > ---
>  > >  block/blk-core.c |   22 ++--------------------
>  > >  1 files changed, 2 insertions(+), 20 deletions(-)
>  > >
>  > > diff --git a/block/blk-core.c b/block/blk-core.c
>  > > index 6f0968f..3f4c563 100644
>  > > --- a/block/blk-core.c
>  > > +++ b/block/blk-core.c
>  > > @@ -113,36 +113,18 @@ EXPORT_SYMBOL(blk_get_backing_dev_info);
>  > >   */
>  > >  void rq_init(struct request_queue *q, struct request *rq)
>  > >  {
>  > > +   memset(rq, 0, sizeof(*rq));
>  >
>  > Hmm, rq_init comment says:
>  >
>  > /*
>  >  * We can't just memset() the structure, since the allocation path
>  >  * already stored some information in the request.
>  >  */
>  >
>  > I think that we can't initialize rq->cmd_flags here.
>
>  That is correct, the patch wont work as-is. The principle of clearing
>  every member except block internal is sound and should be applied,
>  though.

While we're at it we may fix it as well (preferably in another pre-patch):

- move setting rq->cmd_flags from blk_alloc_request() to the callers
  (this is only get_request() ATM)

- re-order setting rq->cmd_flags vs calling rq_init() in get_request(),
  queue_lfush() and  start_ordered()

Thanks,
Bart
