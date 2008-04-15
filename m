From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 4/4] block: add large command support
Date: Wed, 16 Apr 2008 00:50:54 +0200
Message-ID: <200804160050.54842.bzolnier@gmail.com>
References: <20080414010112W.tomof@acm.org> <1208170266-1676-5-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080414112919.GF12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080414112919.GF12774@kernel.dk>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, bharrosh@panasas.com, linux-ide@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org


Hi,

On Monday 14 April 2008, Jens Axboe wrote:
> On Mon, Apr 14 2008, FUJITA Tomonori wrote:
> > This patch changes rq->cmd from the static array to a pointer to
> > support large commands.
> > 
> > We rarely handle large commands. So for optimization, a struct request
> > still has a static array for a command. rq_init sets rq->cmd pointer
> > to the static array.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  block/blk-core.c       |    1 +
> >  drivers/ide/ide-io.c   |    1 +
> >  include/linux/blkdev.h |   12 ++++++++++--
> >  3 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 6669238..6f0968f 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -132,6 +132,7 @@ void rq_init(struct request_queue *q, struct request *rq)
> >  	rq->errors = 0;
> >  	rq->ref_count = 1;
> >  	rq->cmd_len = 0;
> > +	rq->cmd = rq->__cmd;
> >  	memset(rq->cmd, 0, BLK_MAX_CDB);
> >  	rq->data_len = 0;
> >  	rq->extra_len = 0;
> > diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> > index 7153796..bac5ea1 100644
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> > @@ -1595,6 +1595,7 @@ void ide_init_drive_cmd (struct request *rq)
> >  {
> >  	memset(rq, 0, sizeof(*rq));
> >  	rq->ref_count = 1;
> > +	rq->cmd = rq->__cmd;
> >  }

Tomo, some more changes are needed:

Please think about all _static_/dynamic allocations of 'struct request'
used together with REQ_TYPE_SPECIAL etc., i.e.

static void idetape_init_rq(struct request *rq, u8 cmd)

[ rq can be from privately allocated driver's "stack" so no rq_init() ]

{
	memset(rq, 0, sizeof(*rq));
	rq->cmd_type = REQ_TYPE_SPECIAL;
	rq->cmd[0] = cmd;
}

in ide-tape.c or REQ_TYPE_SENSE in ide-cd.c:

static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
                                      struct request *failed_command)
{
        struct cdrom_info *info         = drive->driver_data;
        struct request *rq              = &info->request_sense_request;

        if (sense == NULL)
                sense = &info->sense_data;

        /* stuff the sense request in front of our current request */
        ide_cd_init_rq(drive, rq);

        rq->data = sense;
        rq->cmd[0] = GPCMD_REQUEST_SENSE;
        rq->cmd[4] = rq->data_len = 18;

        rq->cmd_type = REQ_TYPE_SENSE;

        /* NOTE! Save the failed command in "rq->buffer" */
        rq->buffer = (void *) failed_command;

        (void) ide_do_drive_cmd(drive, rq, ide_preempt);
}

> >  EXPORT_SYMBOL(ide_init_drive_cmd);
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index b3a58ad..5710ae4 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -215,8 +215,9 @@ struct request {
> >  	/*
> >  	 * when request is used as a packet command carrier
> >  	 */
> > -	unsigned int cmd_len;
> > -	unsigned char cmd[BLK_MAX_CDB];
> > +	unsigned short cmd_len;
> > +	unsigned char __cmd[BLK_MAX_CDB];
> > +	unsigned char *cmd;

The source issue lies here:

rq->cmd _silently_ becomes something else and unconverted code will happily
compile without even a _single_ warning (+ memory corruption / oops later).

This is _guaranteed_ to cause problems:

- overlooked code (like the IDE code above, with the current approach
  you have to _manually_ audit all code and still _can't_ be sure about
  the result)

- unmerged code from other trees (i.e., I _have_ WIP patches mapping
  REQ_TYPE_TASKFILE requests onto rq->cmd)

- out of tree code (in theory we don't care but in this specific
  case there is no reason to break things silently)

Please just add new field instead (cost should be negligable and if
we're concerned about it I see no problem with using unnamed union like
it was done by Boaz). 

[ Probably it is also worth to add new length field instead of re-using
  ->cmd_len, just to stay on the safe side (+ for better consistency). ]

> >  	unsigned int data_len;
> >  	unsigned int extra_len;	/* length of alignment and padding */
> > @@ -812,6 +813,13 @@ static inline void put_dev_sector(Sector p)
> >  	page_cache_release(p.v);
> >  }
> >  
> > +static inline void rq_set_cmd(struct request *rq, unsigned char *cmd,
> > +			      unsigned short cmd_len)
> > +{
> > +	rq->cmd = cmd;
> > +	rq->cmd_len = cmd_len;
> > +}
> > +
> 
> This is 100% identical to what I suggested be done instead, so of course
> I agree with this.

Jens, I see that you've applied this patch to block tree
- please revert it for now, it needs to be re-designed.

Thanks,
Bart
