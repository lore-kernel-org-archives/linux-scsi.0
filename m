From: Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: always use REQ_OP_WRITE_ZEROES for zeroing
	offload
Date: Thu, 23 Mar 2017 23:53:09 +0100
Message-ID: <20170323225256.GK1138@soda.linbit>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323155410.GD1138@soda.linbit>
	<20170323170221.GA20854@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323170221.GA20854-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2017 at 01:02:22PM -0400, Mike Snitzer wrote:
> On Thu, Mar 23 2017 at 11:54am -0400,
> Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Thu, Mar 23, 2017 at 10:33:18AM -0400, Christoph Hellwig wrote:
> > > This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
> > > supported by the block layer, and switches existing implementations
> > > of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
> > > removes incorrect discard_zeroes_data, and also switches WRITE SAME
> > > based zeroing in SCSI to this new method.
> > > 
> > > I've done testing with ATA, SCSI and NVMe setups, but there are
> > > a few things that will need more attention:
> > > 
> > 
> > >  - The DRBD code in this area was very odd,
> > 
> > DRBD wants all replicas to give back identical data.
> > If what comes back after a discard is "undefined",
> > we cannot really use that.
> > 
> > We used to "stack" discard only if our local backend claimed
> > "discard_zeroes_data". We replicate that IO request to the peer
> > as discard, and if the peer cannot do discards itself, or has
> > discard_zeroes_data == 0, the peer will use zeroout instead.
> > 
> > One use-case for this is the device mapper "thin provisioning".
> > At the time I wrote those "odd" hacks, dm thin targets
> > would set discard_zeroes_data=0, NOT change discard granularity,
> > but only actually discard (drop from the tree) whole "chunks",
> > leaving partial start/end chunks in the mapping tree unchanged.
> > 
> > The logic of "only stack discard, if backend discard_zeroes_data"

That is DRBDs logic I just explained above.
And the "backend" (to DRBD) in that sentence would be thin, and not
the "real" hardware below thin, which may not even support discard.

> > would mean that we would not be able to accept and pass down discards
> > to dm-thin targets. But with data on dm-thin, you would really like
> > to do the occasional fstrim.
> 
> Are you sure you aren't thinking of MD raid?

Yes.

> To this day, dm-thin.c has: ti->discard_zeroes_data_unsupported = true

That is exactly what I was saying.

Thin does not claim to zero data on discard.  which is ok, and correct,
because it only punches holes on full chunks (or whatever you call
them), and leaves the rest in the mapping tree as is.

And that behaviour would prevent DRBD from exposing discards if
configured on top of thin. (see above)

But thin *could* easily guarantee zeroing, by simply punching holes
where it can, and zeroing out the not fully-aligned partial start and
end of the range.

Which is what I added as an option between DRBD and whatever is below,
with the use-case of dm-thin in mind.

And that made it possible for DRBD to
 a) expose "discard" to upper layers, even if we would usually only do
    if the DRBD Primary sits on top of a device that guarantees discard
    zeros data,
 b) still use discards on a secondary, without falling back to zero-out,
    which would unexpectedly fully allocate, instead of trim, a thinly
    provisioned device-mapper target.


Thanks,

    Lars
