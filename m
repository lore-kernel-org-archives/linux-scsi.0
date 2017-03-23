From: Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: always use REQ_OP_WRITE_ZEROES for zeroing
	offload
Date: Thu, 23 Mar 2017 16:54:10 +0100
Message-ID: <20170323155410.GD1138@soda.linbit>
References: <20170323143341.31549-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323143341.31549-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23, 2017 at 10:33:18AM -0400, Christoph Hellwig wrote:
> This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
> supported by the block layer, and switches existing implementations
> of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
> removes incorrect discard_zeroes_data, and also switches WRITE SAME
> based zeroing in SCSI to this new method.
> 
> I've done testing with ATA, SCSI and NVMe setups, but there are
> a few things that will need more attention:
> 

>  - The DRBD code in this area was very odd,

DRBD wants all replicas to give back identical data.
If what comes back after a discard is "undefined",
we cannot really use that.

We used to "stack" discard only if our local backend claimed
"discard_zeroes_data". We replicate that IO request to the peer
as discard, and if the peer cannot do discards itself, or has
discard_zeroes_data == 0, the peer will use zeroout instead.

One use-case for this is the device mapper "thin provisioning".
At the time I wrote those "odd" hacks, dm thin targets
would set discard_zeroes_data=0, NOT change discard granularity,
but only actually discard (drop from the tree) whole "chunks",
leaving partial start/end chunks in the mapping tree unchanged.

The logic of "only stack discard, if backend discard_zeroes_data"
would mean that we would not be able to accept and pass down discards
to dm-thin targets. But with data on dm-thin, you would really like
to do the occasional fstrim.

Also, IO backends on the peers do not have to have the same
characteristics.  You could have the DRBD Primary on some SSD,
and the Secondary on some thin-pool LV,
scheduling thin snapthots in intervals or on demand.

With the logic of "use zero-out instead", fstrim would cause it to
fully allocate what was supposed to be thinly provisioned :-(

So what I did there was optionally tell DRBD that
"discard_zeroes_data == 0" on that peer would actually mean
"discard_zeroes_data == 1,
 IF you zero-out the partial chunks of this granularity yourself".

And implemented this "discard aligned chunks of that granularity,
and zero-out partial start/end chunks, if any".

And then claim to upper layers that, yes, discard_zeroes_data=1,
in that case, if so configured, even if our backend (dm-thin)
would say discard_zeroes_data=0.

Does that make sense?  Can we still do that?  Has something like that
been done in block core or device mapper meanwhile?


> and will need an audit from the maintainers.

Will need to make some time for review and testing.

Thanks,

    Lars
