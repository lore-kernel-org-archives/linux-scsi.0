From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 04:00:51 -0400
Message-ID: <yq11vp8spxo.fsf@sermon.lab.mkp.net>
References: <19010.62951.886231.96622@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19010.62951.886231.96622@notabene.brown> (Neil Brown's message
	of "Thu, 25 Jun 2009 13:58:31 +1000")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil,

Neil>  Of these:

Neil>    max_hw_sectors_kb, nr_requests, rq_affinity, iosched/,
Neil>    max_sectors_kb scheduler nomerges rotational

Neil>  are really only relevant to the elevator code and those devices
Neil>  that used that code (ide, scsi, etc).

I'm not sure I completely agree with putting rotational in that bucket.
It affects the choice of allocation policy in btrfs, for instance.



Neil>  Of the others:
Neil>    hw_sector_size - is applicable to all block devices, and could
Neil>                       reasonably be placed one level up in the
Neil>                       device directory (along side 'size').

hw_sector_size is deprecated.  It's now split into logical and
physical_block_size.


Neil>  Adding a number of extra fields such as minimum_io_size,
Neil>  optimal_io_size etc to '/queue' seems to increase the number of
Neil>  aberrations and enforces md and dm device to have a /queue which
Neil>  is largely irrelevant.

You seem to be hung up on the fact that you don't queue things.  I think
that's beside the point.  You *do* have a request_queue thanks to
calling blk_queue_make_request() in md.c.  And there is more to
request_queue than the values you brought up.  Like the callback
functions.  I'm not saying that all the values in request_queue apply to
MD, but I really don't understand what all the fuss is about.  Other
than the presence of the string "queue" in the choice of naming.

Anyway.  If you look at the request_queue in the current tree you'll see
that the very limits we are discussing are contained in a separate
struct.  We can easily move that somewhere else at a later date if that
is deemed the right thing to do.


Neil>    I have suggested to Martin that 2 are enough.  

I think I have covered this in a separate mail.  You are mixing up
hardware limitations and I/O hints on the grounds that they went in as
part of the same patch set and live in the same place.

fdisk/mdadm/dmsetup need to use physical_block_size and alignment_offset
to prevent us from misaligning when setting up partitions and virtual
block devices.  Also, when stacking devices I need to know these values
to ensure that the I/O hints set by MD/DM don't conflict with the
underlying hardware limitations.  There are also special cases like
shared disk setups and filesystem journal padding that may need to know
details of the hardware atomicity.

mkfs.* can leverage minimum_io_size and optimal_io_size hints to choose
block sizes and to lay out data structures on stripe boundaries.  Just
like we're doing today except using a common interface for all block
devices instead of poking at MD and LVM internals.


logical_block_size, physical_block_size and alignment_offset are
hardware limits that need to be honored when creating a (virtual) block
device or partition.

The minimum/optimal write sizes are hints to the *user* of the block
device about how to lay out things.  If you look at my MD patch you'll
see that I only set the I/O hints.  The hardware settings are off limits
for MD.


I don't particularly care whether we store the values in queue/,
topology/, metrics/, limits/ or in the device root.  Nor whether we call
it minimum_write_size instead of minimum_io_size.  I'll be happy to roll
up a renaming patch...

-- 
Martin K. Petersen	Oracle Linux Engineering
