From: Neil Brown <neilb@suse.de>
Subject: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 13:58:31 +1000
Message-ID: <19010.62951.886231.96622@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi,
 I have (belatedly, I admit) been looking at the new 'topology'
 metrics that were introduced for 2.6.31.
 I have a few questions about them which I have been discussing with
 Martin, but there is one issue that I feel fairly strongly about and
 would like to see changed before it gets into a -final release.
 Hence this email to try to garner understanding and consensus.

 The various topology metrics are exposed to user-space through sysfs
 attributes in the 'queue' subdirectory of the block device
 (e.g. .../sda/queue).
 I think this is a poor choice and would like to find a better
 choice.

 To explain why, it probably helps to review the current situation.
 Before 2.6.30, 'queue' contains:
   hw_sector_size	max_hw_sectors_kb  nr_requests	  rq_affinity
   iosched/		max_sectors_kb	   read_ahead_kb  scheduler
   iostats		nomerges	   rotational

 Of these:

   max_hw_sectors_kb, nr_requests, rq_affinity, iosched/,
   max_sectors_kb scheduler nomerges rotational

 are really only relevant to the elevator code and those devices that
 used that code (ide, scsi, etc).
 They are not relevant for dm or md (md has it's own separate 'md'
 directory, and before 2.6.30, the '/queue' subdirectory did not even
 appear in dm or md devices).

 Of the others:
   hw_sector_size   - is applicable to all block devices, and could
                      reasonably be placed one level up in the device
                      directory (along side 'size').
   read_ahead_kb    - a duplicate of bdi/read_ahead_kb
   iostats          - is a switch to enable or disable accounting of
                      statistics that are reported in the 'stat'
                      file (one level up)

 So most of '/queue' is specific to one class of devices (admittedly a
 very large class).  The others could be argued to be aberrations.

 Adding a number of extra fields such as minimum_io_size,
 optimal_io_size etc to '/queue' seems to increase the number of
 aberrations and enforces md and dm device to have a /queue which is
 largely irrelevant.

 One approach that we could take would be to hide all those fields
 in 'queue' that are not relevant to the current device, and let
 'queue' be a 'dumping ground' for each block device to place whatever
 sysfs attributes they want (thus md would move all of md/* to
 queue/*, and leave 'md' as a symlink to 'queue').

 I don't like this approach because it does not make best use of the
 name space.  If 'md' and 'queue' have different directories, they are
 each free to create new attributes without risk of collision between
 different drivers - not that the collision would be a technical
 problem but it could be confusing to users.

 So, where to put these new fields?

   They could go in the device directory, along side 'size' and 'ro'.
   Like those fields, the new ones give guidance to filesystems on how
   to use the device.  Whether or not this is a good thing depends a
   bit on how many fields we are talking about.  One or two might be
   OK.  4 or more might look messy.
   There are currently 4 fields: logical_block_size,
   physical_block_size, minimum_io_size, optimal_io_size.
   I have suggested to Martin that 2 are enough.  While I don't
   particularly want to debate that in this thread, it could be
   relevant so I'll outline my idea below.

   They could go in 'bdi' along with read_ahead_kb.  read_ahead_kb
   gives guidance on optimal read sizes.  The topology fields give
   guidance on optimal write sizes.  There is a synergy there.  And
   these fields are undeniably info about a backing device.
   NFS has it's own per-filesystem bdi so we would not want to impose
   fields on NFS that weren't at all relevant.  NFS has 'rsize' and
   'wsize' which are somewhat related.  So I feel somewhat positive
   about this possibility.  My only concern is that 'read_ahead_kb' is
   more about reading *files*, where as the *_block_size and *_io_size
   are about writing to the *device*.  I'm not sure how important a
   difference this is.

   They could go in a new subdirectory of the block device, just like
   the integrity fields. e.g 'topology/'. or 'metrics/'.  This would
   be my preferred approach if there do turn out to be the full 4
   fields.

Thanks for your attention.  Comments most welcome.

NeilBrown

----------------------
Alternate implementation with only two fields.
According to Documentation/ABI/testing/sysfs-block, both
physical_block_size and minimum_io_size are the smallest unit of IO
that doesn't require read-modify-write.  The first is thought to
relate to drives with 4K blocks.  The second to RAID5 arrays.
But that doesn't make sense as it stands: you cannot have two things
that are both the smallest.

Also, minimum_io_size and optimal_io_size are both described as a
"preferred" for IO - presumably writes, not reads.  Again, we cannot
have two values that are both preferred.  There is again some
suggestion that one is for disks and the other is for RAID, but I
cannot see how a mkfs would choose between them.

My conclusion is that there are two issues of importance.
1/ avoiding read-modify-write as that can affect correctness (When a
  write error happens, you can lose unrelated data).
2/ throughput.

For each of these issues, there are a number of sizes that are
relevant.
e.g as you increase the request size, the performance can increase,
but there a key points where a small increase in size can give a big
increase in performance.  These sizes might include block size, chunk
size, stripe size, and cache size.

So I suggested two fields, each of which can store multiple values:

safe_write_size:  512 4096 327680
preferred_write_size: 4096 65536 327680 10485760

The guidance for using these is simple:
 When choosing a size where atomicity of writes is important, choose
 the largest size from safe_write_size which is practical (or a
 multiple there-of).

 When choosing a size which doesn't require atomicity, but where
 throughput is important, choose a multiple of the largest size from
 preferred_write_size which is practical.

The smallest safe_write_size would be taken as the logical_block_size.

If we just have these two fields, I would put them in the top level
directory for the block device.
