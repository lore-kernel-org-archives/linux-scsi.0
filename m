From: <berthiaume_wayne@emc.com>
Subject: RE: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 08:17:41 -0400
Message-ID: <8F08A56613D77044BD153E2AC5DA0F84022BE9D1@CORPUSMX40A.corp.emc.com>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: neilb@suse.de
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, snitzer@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Just my 2 cents for what its worth, but I'd have to agree with Neil that
the location of these attributes should be somwhere logical where they
can be easily found and the naming convention of the attributes such
that they make sense to the common man. Afterall, not all of us are
kernel developers. =3D;^) =20

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of NeilBrown
Sent: Thursday, June 25, 2009 7:08 AM
To: Martin K. Petersen
Cc: Mike Snitzer; Martin K. Petersen; Linus Torvalds; Alasdair G Kergon;
jens.axboe@oracle.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org;
linux-ide@vger.kernel.org; linux-fsdevel@vger.kernel.org; device-mapper
development
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved
out of the 'queue' sysfs directory.

On Thu, June 25, 2009 6:00 pm, Martin K. Petersen wrote:
>>>>>> "Neil" =3D=3D Neil Brown <neilb@suse.de> writes:
>
> Neil,
>
> Neil>  Of these:
>
> Neil>    max_hw_sectors_kb, nr_requests, rq_affinity, iosched/,
> Neil>    max_sectors_kb scheduler nomerges rotational
>
> Neil>  are really only relevant to the elevator code and those devices
> Neil>  that used that code (ide, scsi, etc).
>
> I'm not sure I completely agree with putting rotational in that
bucket.
> It affects the choice of allocation policy in btrfs, for instance.
>

I confess to have some uncertainty about this.  There is, as far as
I can tell, no documentation for it.

So I asked git why it as added, and it pointed to
  commit 1308835ffffe6d61ad1f48c5c381c9cc47f683ec

which suggests that it was added so that user space could tell the
kernel whether the device was rotational, rather than the other way
around.

But yes, maybe 'rotational' doesn't belong with the others.

>
> Neil>  Adding a number of extra fields such as minimum_io_size,
> Neil>  optimal_io_size etc to '/queue' seems to increase the number of
> Neil>  aberrations and enforces md and dm device to have a /queue
which
> Neil>  is largely irrelevant.
>
> You seem to be hung up on the fact that you don't queue things.  I
think
> that's beside the point.  You *do* have a request_queue thanks to
> calling blk_queue_make_request() in md.c.  And there is more to
> request_queue than the values you brought up.  Like the callback
> functions.  I'm not saying that all the values in request_queue apply
to
> MD, but I really don't understand what all the fuss is about.  Other
> than the presence of the string "queue" in the choice of naming.
>

Well names are very important.  And as I said later we could possibly
keep
them in 'queue' and make 'queue' a more generic directory.  I don't like
that but it is probably better than the current situation.

As you say, I do currently have a request_queue, but that is an internal
detail, not part of the externally visible interface, and it is
something
that is very much in my sights as something I want to change.  I'm
still working out the details so I'm a fair way from a concrete proposal
and a long way from some code.  That change certainly doesn't have
to happen in any rush.  But we should get the externally visible
names "right" if we can.

> Anyway.  If you look at the request_queue in the current tree you'll
see
> that the very limits we are discussing are contained in a separate
> struct.  We can easily move that somewhere else at a later date if
that
> is deemed the right thing to do.

Agreed.  But not relevant at the moment.  The view from user-space is
what
is important.

>
>
> Neil>    I have suggested to Martin that 2 are enough.
>
> I think I have covered this in a separate mail.  You are mixing up
> hardware limitations and I/O hints on the grounds that they went in as
> part of the same patch set and live in the same place.

I think I'm actually mixing them up because they look very much the
same.  Both say "try to make write requests at least this big" and
I cannot see the difference being very big to the filesystem.

I tend to mix them up a bit with read_ahead_kb as they are in some
ways just the 'write' version of that.  But it didn't arrive in the
same patch set :-)

Also, I think you seem to be treating the read-modify-write behaviour
of a 4K-sector hard drive as different-in-kind to the read-modify-write
behaviour of raid5.  I cannot see that.  In both cases an error can
cause
unexpected corruption and in both cases getting the alignment right
helps
throughput a lot.  So the only difference between these two values
is the size.
If one is 4K and one is 40Meg and you have 512bytes of data that you
want to write as safely as possibly, you might pad it to 4K, but you
wont pad it to 40Meg.
If you have 32Meg of data that you want to write as safely as you can,
you may well pad it to 40Meg, rather than say  "it is a multiple of
4K, that is enough for me".
So: the difference is only in the size.


>
> fdisk/mdadm/dmsetup need to use physical_block_size and
alignment_offset
> to prevent us from misaligning when setting up partitions and virtual
> block devices.  Also, when stacking devices I need to know these
values
> to ensure that the I/O hints set by MD/DM don't conflict with the
> underlying hardware limitations.  There are also special cases like
> shared disk setups and filesystem journal padding that may need to
know
> details of the hardware atomicity.

"... of the *device* atomicity." It hardly matters whether the device is
hardware or software, it can still have atomicity issues.

>
> mkfs.* can leverage minimum_io_size and optimal_io_size hints to
choose
> block sizes and to lay out data structures on stripe boundaries.  Just
> like we're doing today except using a common interface for all block
> devices instead of poking at MD and LVM internals.

As we are using generic terms like "minimum" and "optimal", let's keep
with those terms when describing filesystem behaviour and not mention
stripes.
"mkfs.* can leverage these values to choose the most appropriate sizes
and alignments for various data strutures".
What is the most appropriate size?  It depends on how much data we have
to store, and how much wastage we can afford.  So if there are a range
of reasonably optimal sizes, the fs can choose the best fit, without
needing to pretend to understand why one is more optimal than another.

And the "Just like we're doing today ..." is actually a bit sad.
If you look at mkfs.ext3, it requires 3 values:
  - block size
  - stride-size
  - stripe-width

block size needs to be smallish and a power of 2 and at most
PAGE_SIZE (I think).  It would be ideal if this could be stripe-size on
a raid5, but the stripe is usually too large so the next best is
physical_block_size (so, a size based decision).

stripe-width is only really needed on raid4/5/6 as it is aimed at
avoiding read-modify-write, so it would be the stripe size, which would
be minimum_io_size.  Though on a SCSI device it should probably
be "OPTIMAL TRANSFER LENGTH GRANULARITY" which I thought would be
optimal_io_size..  so maybe we use that and make minimum_io_size and
optimal_io_size the same on raid5 ??  Or just provide a list of useful
sizes and let the fs choose whatever is in the right ball-park.

stride-size is used for raid0 or raid4, or the "Asymmetric" raid5
layouts.
It allows ext3 to stagger which drive certain 'hot' data structures are
on.  The current metrics don't allow for that at all.
I'm not saying they should, and I'm not sure how they could.  But it
is sad.

>
> logical_block_size, physical_block_size and alignment_offset are
> hardware limits that need to be honored when creating a (virtual)
block
> device or partition.

logical_block_size is a firmware limit.  The others are just hints.
Strong hints I agree.  Hints we should follow if at all possible.
But still hints.

>
> The minimum/optimal write sizes are hints to the *user* of the block
> device about how to lay out things.  If you look at my MD patch you'll
> see that I only set the I/O hints.  The hardware settings are off
limits
> for MD.
>
>
> I don't particularly care whether we store the values in queue/,
> topology/, metrics/, limits/ or in the device root.  Nor whether we
call
> it minimum_write_size instead of minimum_io_size.  I'll be happy to
roll
> up a renaming patch...

Good, thanks..  I do strongly care that they don't go in queue/, and
that they have a name that is as close as possible to what they mean.
Let's see if anyone else has an opinion.

Thanks,
NeilBrown


