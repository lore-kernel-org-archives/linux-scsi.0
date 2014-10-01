From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] block: remove artifical max_hw_sectors cap
Date: Wed, 1 Oct 2014 18:59:34 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CC7BAB@G4W3202.americas.hpqcorp.net>
References: <1410044885-14893-1-git-send-email-hch@lst.de>
 <20141001130822.GA5362@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141001130822.GA5362@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Wednesday, 01 October, 2014 8:08 AM
> To: Jens Axboe; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Wu
> Fengguang
> Subject: Re: [PATCH] block: remove artifical max_hw_sectors cap
> 
> As we still haven't made any progress on this let me explain why
> the limit does not make sense:  It only applies to _FS request,
> which basically have three use cases:
> 
>  - metadata I/O.  Generally small enough that the limit does not
>    matter at all.
>  - buffered reads/writes.  We already have a self-tuning algorithm
>    that limits writeback size, and a readahead size tunable that
>    caps read sizes.  Imposing another confusing limit that does
>    not interact with the visible tunables here is not helpful
>  - direct I/O.  Users should get something resembling their request
>    as closely as possible on the write, and this is where our
>    stupid limitation causes the most problems.

One supporting example: A low limit interferes with creation of
full stripe writes for RAID controllers.



> On Sat, Sep 06, 2014 at 04:08:05PM -0700, Christoph Hellwig wrote:
> > Set max_sectors to the value the drivers provides as hardware limit by
> > default.  Linux had proper I/O throttling for a long time and doesn't
> > rely on a artifically small maximum I/O size anymore.  By not limiting
> > the I/O size by default we remove an annoying tuning step required for
> > most Linux installation.
> >
> > Note that both the user, and if absolutely required the driver can still
> > impose a limit for FS requests below max_hw_sectors_kb.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  block/blk-settings.c       | 4 +---
> >  drivers/block/aoe/aoeblk.c | 2 +-
> >  include/linux/blkdev.h     | 1 -
> >  3 files changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index f1a1795..f52c223 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -257,9 +257,7 @@ void blk_limits_max_hw_sectors(struct queue_limits
> *limits, unsigned int max_hw_
> >  		       __func__, max_hw_sectors);
> >  	}
> >
> > -	limits->max_hw_sectors = max_hw_sectors;
> > -	limits->max_sectors = min_t(unsigned int, max_hw_sectors,
> > -				    BLK_DEF_MAX_SECTORS);
> > +	limits->max_sectors = limits->max_hw_sectors = max_hw_sectors;
> >  }
> >  EXPORT_SYMBOL(blk_limits_max_hw_sectors);

1. Documentation/block/biodoc.txt needs some updates:

        blk_queue_max_sectors(q, max_sectors)
                Sets two variables that limit the size of the request.

                - The request queue's max_sectors, which is a soft size in
                units of 512 byte sectors, and could be dynamically varied
                by the core kernel.

                - The request queue's max_hw_sectors, which is a hard limit
                and reflects the maximum size request a driver can handle
                in units of 512 byte sectors.

                The default for both max_sectors and max_hw_sectors is
                255. The upper limit of max_sectors is 1024.

There is no function with that name (it is now called
blk_queue_max_hw_sectors), the upper limit of max_sectors
is max_hw_sectors, and the default is misleading (255
is the default if the LLD doesn't provide max_hw_sectors).

2. Testing with hpsa and mpt3sas, this patch works as expected
for this setting.  I/O sizes are still limited by max_segments, 
which is expected.  Something else is still limiting I/O sizes
to 1 MiB, though; probably bio_get_nr_vecs enforcing a maximum
size per bio of BIO_MAX_PAGES 256 (which is 1 MiB with 4 KiB
pages).


Otherwise,
Reviewed-by: Robert Elliott <elliott@hp.com>
Tested-by: Robert Elliott <elliott@hp.com>

---
Rob Elliott    HP Server Storage
