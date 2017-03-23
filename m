From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RFC: always use REQ_OP_WRITE_ZEROES for zeroing
	offload
Date: Thu, 23 Mar 2017 13:02:22 -0400
Message-ID: <20170323170221.GA20854@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
	<20170323155410.GD1138@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170323155410.GD1138@soda.linbit>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, philipp.reisner@linbit.com, linux-block@vger.kernel.org, dm-devel@redhat.com, shli@kernel.org, Christoph Hellwig <hch@lst.de>, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23 2017 at 11:54am -0400,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Thu, Mar 23, 2017 at 10:33:18AM -0400, Christoph Hellwig wrote:
> > This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
> > supported by the block layer, and switches existing implementations
> > of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
> > removes incorrect discard_zeroes_data, and also switches WRITE SAME
> > based zeroing in SCSI to this new method.
> > 
> > I've done testing with ATA, SCSI and NVMe setups, but there are
> > a few things that will need more attention:
> > 
> 
> >  - The DRBD code in this area was very odd,
> 
> DRBD wants all replicas to give back identical data.
> If what comes back after a discard is "undefined",
> we cannot really use that.
> 
> We used to "stack" discard only if our local backend claimed
> "discard_zeroes_data". We replicate that IO request to the peer
> as discard, and if the peer cannot do discards itself, or has
> discard_zeroes_data == 0, the peer will use zeroout instead.
> 
> One use-case for this is the device mapper "thin provisioning".
> At the time I wrote those "odd" hacks, dm thin targets
> would set discard_zeroes_data=0, NOT change discard granularity,
> but only actually discard (drop from the tree) whole "chunks",
> leaving partial start/end chunks in the mapping tree unchanged.
> 
> The logic of "only stack discard, if backend discard_zeroes_data"
> would mean that we would not be able to accept and pass down discards
> to dm-thin targets. But with data on dm-thin, you would really like
> to do the occasional fstrim.

Are you sure you aren't thinking of MD raid?  E.g. raid5's
"devices_handle_discard_safely":
parm:           devices_handle_discard_safely:Set to Y if all devices in each array reliably return zeroes on reads from discarded regions (bool)

I don't recall DM thinp's discard support ever having a requirement for
discard_zeroes_data.

In fact, see header from commit b60ab990ccdf3 ("dm thin: do not expose
non-zero discard limits if discards disabled"):

    Also, always set discard_zeroes_data_unsupported in targets because they
    should never advertise the 'discard_zeroes_data' capability (even if the
    pool's data device supports it).

To this day, dm-thin.c has: ti->discard_zeroes_data_unsupported = true
