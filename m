From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard
 request payload
Date: Tue, 29 Jun 2010 19:51:04 -0400
Message-ID: <20100629235104.GA23641@redhat.com>
References: <20100622180029.GA15950@redhat.com>
	<1277582211-10725-1-git-send-email-snitzer@redhat.com>
	<1277652576.4366.19.camel@mulgrave.site>
	<Pine.LNX.4.64.1006291811300.27462@hs20-bc2-1.build.redhat.com>
	<1277852600.4379.211.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1277852600.4379.211.camel@mulgrave.site>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@suse.de>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 29 2010 at  7:03pm -0400,
James Bottomley <James.Bottomley@suse.de> wrote:

> On Tue, 2010-06-29 at 18:28 -0400, Mikulas Patocka wrote:
> > 
> > On Sun, 27 Jun 2010, James Bottomley wrote:
> > 
> > > linux-scsi cc added, since it's a SCSI patch.
> > > 
> > > On Sat, 2010-06-26 at 15:56 -0400, Mike Snitzer wrote:
> > > > Fix leaks introduced via "block: don't allocate a payload for discard
> > > > request" commit a1d949f5f44.
> > > > 
> > > > sd_done() is not called for REQ_TYPE_BLOCK_PC commands so cleanup
> > > > discard request's payload directly in scsi_finish_command().
> > > > 
> > > > Also cleanup page allocated for discard payload in
> > > > scsi_setup_discard_cmnd's scsi_setup_blk_pc_cmnd error path.
> > > > 
> > > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > > ---
> > > >  block/blk-core.c       |   23 +++++++++++++++++++++++
> > > >  drivers/scsi/scsi.c    |    8 ++++++++
> > > >  drivers/scsi/sd.c      |   18 ++++++++----------
> > > >  include/linux/blkdev.h |    1 +
> > > >  4 files changed, 40 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > index 98b4cee..07925aa 100644
> > > > --- a/block/blk-core.c
> > > > +++ b/block/blk-core.c
> > > > @@ -1167,6 +1167,29 @@ void blk_add_request_payload(struct request *rq, struct page *page,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(blk_add_request_payload);
> > > >  
> > > > +/**
> > > > + * blk_clear_request_payload - clear a request's payload
> > > > + * @rq: request to update
> > > > + *
> > > > + * The driver needs to take care of freeing the payload itself.
> > > > + */
> > > > +void blk_clear_request_payload(struct request *rq)
> > > > +{
> > > > +	struct bio *bio = rq->bio;
> > > > +
> > > > +	rq->__data_len = rq->resid_len = 0;
> > > > +	rq->nr_phys_segments = 0;
> > > > +	rq->buffer = NULL;
> > > > +
> > > > +	bio->bi_size = 0;
> > > > +	bio->bi_vcnt = 0;
> > > > +	bio->bi_phys_segments = 0;
> > > > +
> > > > +	bio->bi_io_vec->bv_page = NULL;
> > > > +	bio->bi_io_vec->bv_len = 0;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(blk_clear_request_payload);
> > > > +
> > > >  void init_request_from_bio(struct request *req, struct bio *bio)
> > > >  {
> > > >  	req->cpu = bio->bi_comp_cpu;
> > > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > > index ad0ed21..69c7ea4 100644
> > > > --- a/drivers/scsi/scsi.c
> > > > +++ b/drivers/scsi/scsi.c
> > > > @@ -851,6 +851,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
> > > >  		 */
> > > >  		if (good_bytes == old_good_bytes)
> > > >  			good_bytes -= scsi_get_resid(cmd);
> > > > +	} else if (cmd->request->cmd_flags & REQ_DISCARD) {
> > > > +		/*
> > > > +		 * If this is a discard request that originated from the kernel
> > > > +		 * we need to free our payload here.  Note that we need to check
> > > > +		 * the request flag as the normal payload rules apply for
> > > > +		 * pass-through UNMAP / WRITE SAME requests.
> > > > +		 */
> > > > +		__free_page(bio_page(cmd->request->bio));
> > > 
> > > This is another layering violation:  the page is allocated in the Upper
> > > layer and freed in the mid-layer.
> > > 
> > > I really hate these growing contortions for discard.  They're a clear
> > > signal that we haven't implemented it right.
> > > 
> > > So let's first work out how it should be done.  I really like Tomo's
> > > idea of doing discard through the normal REQ_TYPE_FS route, which means
> > > we can control the setup in prep and the tear down in done, all confined
> > > to the ULD.
> > > 
> > > Where I think I'm at is partially what Christoph says:  The command
> > > transformation belongs in the ULD so that's where the allocation and
> > > deallocation should be, and partly what Tomo says in that we should
> > > eliminate the special case paths.
> > > 
> > > The payload vs actual request size should be a red herring if we've got
> > > everything correct:  only the ULD cares about the request parameters.
> > > Once we've got everything set up, the mid layer and LLD should only care
> > > about the parameters in the command, so we can confine the size changing
> > > part to the ULD doing the discard.
> > > 
> > > Could someone take a stab at this and see if it works without layering
> > > violations or any other problematic signals?
> > > 
> > > Thanks,
> > > 
> > > James
> > 
> > Well, I think that you overestimate the importance of scsi code too much.
> 
> Not, I think, a deadly sin for a SCSI maintainer.

Indeed ;)

> > There is a layering violation in the code. So what --- you either fix the 
> > layering violation or let it be there and grind your teeth on it. But in 
> > either case, that layering violation won't affect anyone except scsi 
> > developers.
> 
> A layering violation is a signal of bad design wherever it occurs, so
> that wasn't a SCSI centric argument.
> 
> > On the other hand, if you say "because we want to avoid layering violation 
> > in SCSI, every issuer of discard request must supply an empty page", you 
> > create havoc all over the Linux codebase. md, dm, drbd, xvd, virtio --- 
> > whatever you think of, will be allocating a dummy page when constructing 
> > a discard request.
> 
> Since I didn't actually say any of that, I suggest you re-read text you
> quoted above.  The phrase "The command transformation belongs in the ULD
> so that's where the allocation and deallocation should be" might be a
> relevant one to concentrate on.

Right, freeing the page, that was allocated in SCSI's ULD, from the SCSI
midlayer is a SCSI layering violation.  I think Mikulas was reacting to
the desire to maintain the existing, arguably more problematic, layering
violation that spans the block and SCSI layers.

> > If the layering violation spans only scsi code, it can be eventually 
> > fixed, but this, much worse "layering violation" that will be spanning all 
> > block device midlayers, won't ever be fixed.
> > 
> > Imagine for example --- a discard request arrivers at a dm-snapshot 
> > device. The driver splits it into chunks, remaps each chunk to the 
> > physical chunk, submits the requests, the elevator merges adjacent 
> > requests and submits fewer bigger requests to the device. Now, if you had 
> > to allocate a zeroed page each time you are splitting the request, that 
> > would exhaust memory and burn cpu needlessly. You delete a 100MB file? --- 
> > fine, allocate a 100MB of zeroed pages.
> 
> This is a straw man:  You've tried to portray a position I've never
> taken as mine then attack it ... with what is effectively another bogus
> argument.
> 
> It's not an either/or choice.  I've asked the relevant parties to
> combine the approaches and see if a REQ_TYPE_FS path that does the
> allocations in the appropriate place, likely the ULD, produces a good
> design.

If in the end we can fix up SCSI properly then everyone is happy.  So
lets just keep working toward that.  The various attempts to convert
discard over to REQ_TYPE_FS have fallen short.  Hopefully we'll have a
break through shortly.

Thanks for your guidance James,
Mike
