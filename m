From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: bio-based DM multipath is back from the dead [was: Re: Notes
 from the four separate IO track sessions at LSF/MM]
Date: Fri, 27 May 2016 10:44:08 -0400
Message-ID: <20160527144407.GA31394@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
 <20160428121108.GA9903@redhat.com>
 <1461858038.2307.16.camel@HansenPartnership.com>
 <20160526023855.GA20659@redhat.com>
 <574807D6.4030208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbcE0OoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2016 10:44:11 -0400
Content-Disposition: inline
In-Reply-To: <574807D6.4030208@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-block@vger.kernel.org, lsf@lists.linux-foundation.org, device-mapper development <dm-devel@redhat.com>, hch@lst.de, linux-scsi <linux-scsi@vger.kernel.org>, axboe@kernel.dk, Ming Lei <ming.lei@canonical.com>

On Fri, May 27 2016 at  4:39am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 05/26/2016 04:38 AM, Mike Snitzer wrote:
> >On Thu, Apr 28 2016 at 11:40am -0400,
> >James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> >>On Thu, 2016-04-28 at 08:11 -0400, Mike Snitzer wrote:
> >>>Full disclosure: I'll be looking at reinstating bio-based DM multipath to
> >>>regain efficiencies that now really matter when issuing IO to extremely
> >>>fast devices (e.g. NVMe).  bio cloning is now very cheap (due to
> >>>immutable biovecs), coupled with the emerging multipage biovec work that
> >>>will help construct larger bios, so I think it is worth pursuing to at
> >>>least keep our options open.
> >
> >Please see the 4 topmost commits I've published here:
> >https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.8
> >
> >All request-based DM multipath support/advances have been completly
> >preserved.  I've just made it so that we can now have bio-based DM
> >multipath too.
> >
> >All of the various modes have been tested using mptest:
> >https://github.com/snitm/mptest
> >
> >>OK, but remember the reason we moved from bio to request was partly to
> >>be nearer to the device but also because at that time requests were
> >>accumulations of bios which had to be broken out, go back up the stack
> >>individually and be re-elevated, which adds to the inefficiency.  In
> >>theory the bio splitting work will mean that we only have one or two
> >>split bios per request (because they were constructed from a split up
> >>huge bio), but when we send them back to the top to be reconstructed as
> >>requests there's no guarantee that the split will be correct a second
> >>time around and we might end up resplitting the already split bios.  If
> >>you do reassembly into the huge bio again before resend down the next
> >>queue, that's starting to look like quite a lot of work as well.
> >
> >I've not even delved into the level you're laser-focused on here.
> >But I'm struggling to grasp why multipath is any different than any
> >other bio-based device...
> >
> Actually, _failover_ is not the primary concern. This is on a
> (relative) slow path so any performance degradation during failover
> is acceptable.
> 
> No, the real issue is load-balancing.
> If you have several paths you have to schedule I/O across all paths,
> _and_ you should be feeding these paths efficiently.

<snip well known limitation of bio-based mpath load balancing, also
detailed in the multipath paper I refernced>

Right, as my patch header details, this is the only limitation that
remains with the reinstated bio-based DM multipath.

> I was sort-of hoping that with the large bio work from Shaohua we

I think you mean Ming Lei and his multipage biovec work?

> could build bio which would not require any merging, ie building
> bios which would be assembled into a single request per bio.
> Then the above problem wouldn't exist anymore and we _could_ do
> scheduling on bio level.
> But from what I've gathered this is not always possible (eg for
> btrfs with delayed allocation).

I doubt many people are running btrfs over multipath in production
but...

Taking a step back: reinstating bio-based DM multipath is _not_ at the
expense of request-based DM multipath.  As you can see I've made it so
that all modes (bio-based, request_fn rq-based, and blk-mq rq-based) are
supported by a single DM multipath target.  When the trnasition to
request-based happened it would've been wise to preserve bio-based but I
digress...

So, the point is: there isn't any one-size-fits-all DM multipath queue
mode here.  If a storage config benefits from the request_fn IO
schedulers (but isn't hurt by .request_fn's queue lock, so slower
rotational storage?) then use queue_mode=2.  If the storage is connected
to a large NUMA system and there is some reason to want to use blk-mq
request_queue at the DM level: use queue_mode=3.  If the storage is
_really_ fast and doesn't care about extra IO grooming (e.g. sorting and
merging) then select bio-based using queue_mode=1.

I collected some quick performance numbers against a null_blk device, on
a single NUMA node system, with various DM layers ontop -- the multipath
runs are only with a single path... fio workload is just 10 sec randread:

FIO_QUEUE_DEPTH=32
FIO_RUNTIME=10
FIO_NUMJOBS=12
{FIO} --numa_cpu_nodes=${NID} --numa_mem_policy=bind:${NID} --cpus_allowed_policy=split --group_reporting --rw=randread --bs=4k --numjobs=${FIO_NUMJOBS} \
              --iodepth=${FIO_QUEUE_DEPTH} --runtime=${FIO_RUNTIME} --time_based --loops=1 --ioengine=libaio \
              --direct=1 --invalidate=1 --randrepeat=1 --norandommap --exitall --name task_${TASK_NAME} --filename=${DEVICE}"

I need real hardware (NVMe over Fabrics please!) to really test this
stuff properly; but I think the following results at least approximate
the relative performance of each multipath mode.

On null_blk blk-mq
------------------

baseline:
null_blk blk-mq       iops=1936.3K
dm-linear             iops=1616.1K

multipath using round-robin path-selector:
bio-based             iops=1579.8K
blk-mq rq-based       iops=1411.6K
request_fn rq-based   iops=326491

multipath using queue-length path-selector:
bio-based             iops=1526.2K
blk-mq rq-based       iops=1351.9K
request_fn rq-based   iops=326399

On null_blk bio-based
---------------------

baseline:
null_blk blk-mq       iops=2776.8K
dm-linear             iops=2183.5K

multipath using round-robin path-selector:
bio-based             iops=2101.5K

multipath using queue-length path-selector:
bio-based             iops=2019.4K

I haven't even looked at optimizing bio-based DM yet.. not liking that
dm-linear is taking a ~15% - ~20% hit from baseline null_blk.  But nice
to see bio-based multipath is very comparable to dm-linear.  So any
future bio-based DM performance advances should translate to better
multipath perf.

> Have you found another way of addressing this problem?

No, bio sorting/merging really isn't a problem for DM multipath to
solve.

Though Jens did say (in the context of one of these dm-crypt bulk mode
threads) that the block core _could_ grow some additional _minimalist_
capability for bio merging:
https://www.redhat.com/archives/dm-devel/2015-November/msg00130.html

I'd like to understand a bit more about what Jens is thinking in that
area because it could benefit DM thinp as well (though that is using bio
sorting rather than merging, introduced via commit 67324ea188).

I'm not opposed to any line of future development -- but development
needs to be driven by observed limitations while testing on _real_
hardware.

Mike
