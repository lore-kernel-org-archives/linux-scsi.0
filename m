From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 13:38:40 -0400
Message-ID: <yq1k530qkm7.fsf@sermon.lab.mkp.net>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	(NeilBrown's message of "Thu, 25 Jun 2009 21:07:37 +1000 (EST)")
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

[rotational flag]

Neil> So I asked git why it as added, and it pointed to
Neil>   commit 1308835ffffe6d61ad1f48c5c381c9cc47f683ec

Neil> which suggests that it was added so that user space could tell the
Neil> kernel whether the device was rotational, rather than the other
Neil> way around.

There's an option to do it via udev for broken devices that don't report
it.  But both SCSI and ATA have a setting that gets queried and the
queue flag set accordingly.


Neil> Also, I think you seem to be treating the read-modify-write
Neil> behaviour of a 4K-sector hard drive as different-in-kind to the
Neil> read-modify-write behaviour of raid5.  I cannot see that.  In both
Neil> cases an error can cause unexpected corruption and in both cases
Neil> getting the alignment right helps throughput a lot.

If you get a write error on a RAID5 component you are able to
reconstruct and remap the stripe given the cache and the remaining
drives.

If you get a write error on a 4KB phys/512 byte logical drive the result
is undefined.  In a single machine setting you can treat the 4KB block
as suspect.  In a clustered setting, however, the other machines will
unknowingly be reading garbage.

I realize this is moot in the context of MD given that it doesn't
support shared storage.  But MD is not the only virtual block device
driver that I need to support with the topology bits.


Neil> So the only difference between these two values is the size.  If
Neil> one is 4K and one is 40Meg and you have 512bytes of data that you
Neil> want to write as safely as possibly, you might pad it to 4K, but
Neil> you wont pad it to 40Meg.  If you have 32Meg of data that you want
Neil> to write as safely as you can, you may well pad it to 40Meg,
Neil> rather than say "it is a multiple of 4K, that is enough for me".
Neil> So: the difference is only in the size.

Yep.  I call the lower boundary minimum_io_size and the upper boundary
optimal_io_size.

People have been putting filesystems and databases on top of RAID
devices for ages.  And generally the best practice has been to align and
write in multiples of the chunk size and try to write full stripe
widths.

Given the requirement for read-modify-write on RAID[456] I can
understand your predisposition to set minimum_io_size to the stripe
width.  However, I'm not really sure that's what the user wants.  Given
the stripe cache I'm also not convinced the performance impact of the MD
RAID[456] RMW cycle is as bad as that of the disk drive.  So I set
minimum_io_size to the chunk size in my patch.

If you can come up with better names for minimum and optimal then that's
ok with me.  SCSI uses the term granularity.  I used that for a while in
my patches but most people thought that was really weird.  Minimum and
optimal seemed easier to grasp.  Maximum also exists in the storage
device context but is literally the largest I/O the device can receive.

And just to make it clear: I completely agree with your argument that
which knob to choose is I/O size dependent.  My beef with your proposal
is that I believe the length of the list should be 2.

How we do report this stuff is really something I'd like the FS guys to
comment on, though.  The knobs we have now correspond to what's
currently used by XFS (libdisk) and indirectly by ext2+.

-- 
Martin K. Petersen	Oracle Linux Engineering
