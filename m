From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Tue, 07 Jul 2009 01:29:37 -0400
Message-ID: <yq163e55ada.fsf@sermon.lab.mkp.net>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<yq1k530qkm7.fsf@sermon.lab.mkp.net>
	<19012.47077.328965.919868@notabene.brown>
	<yq1ws6znja4.fsf@sermon.lab.mkp.net>
	<19026.43290.340555.774690@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <19026.43290.340555.774690@notabene.brown> (Neil Brown's message
	of "Tue, 7 Jul 2009 11:47:06 +1000")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

>> What: /sys/block/<disk>/queue/minimum_io_size Date: April 2009
>> Contact: Martin K. Petersen <martin.petersen@oracle.com> Description:
>> Storage devices may report a granularity or minimum I/O size which is
>> the device's preferred unit of I/O.  Requests smaller than this may
>> incur a significant performance penalty.
>> 
>> For disk drives this value corresponds to the physical block
>> size. For RAID devices it is usually the stripe chunk size.

Neil> These two paragraphs are contradictory.  There is no sense in
Neil> which a RAID chunk size is a preferred minimum I/O size.

Maybe not for MD.  This is not just about MD.

This is a hint that says "Please don't send me random I/Os smaller than
this.  And please align to a multiple of this value".

I agree that for MD devices the alignment portion of that is the
important one.  However, putting a lower boundary on the size *is* quite
important for 4KB disk drives.  There are also HW RAID devices that
choke on requests smaller than the chunk size.

I appreciate the difficulty in filling out these hints in a way that
makes sense for all the supported RAID levels in MD.  However, I really
don't consider the hints particularly interesting in the isolated
context of MD.  To me the hints are conduits for characteristics of the
physical storage.  The question you should be asking yourself is: "What
do I put in these fields to help the filesystem so that we get the most
out of the underlying, slow hardware?".

I think it is futile to keep spending time coming up with terminology
that encompasses all current and future software and hardware storage
devices with 100% accuracy.


Neil> To some degree it is actually a 'maximum' preferred size for
Neil> random IO.  If you do random IO is blocks larger than the chunk
Neil> size then you risk causing more 'head contention' (at least with
Neil> RAID0 - with RAID5 the tradeoff is more complex).

Please elaborate.


Neil> Also, you say "may" report.  If a device does not report, what
Neil> happens to this file.  Is it not present, or empty, or contain a
Neil> special "undefined" value?  I think the answer is that "512" is
Neil> reported.

The answer is physical_block_size.


Neil> In this case, if a device does not report an optimal size, the
Neil> file contains "0" - correct?  Should that be explicit?

Now documented.


Neil> I'd really like to see an example of how you expect filesystems to
Neil> use this.  I can well imagine the VM or elevator using this to
Neil> assemble IO requests in to properly aligned requests.  But I
Neil> cannot imagine how e.g mkfs would use it.  Or am I
Neil> misunderstanding and this is for programs that use O_DIRECT on the
Neil> block device so they can optimise their request stream?

The way it has been working so far (with the manual ioctl pokage) is
that mkfs will align metadata as well as data on a minimum_io_size
boundary.  And it will try to use the minimum_io_size as filesystem
block size.  On Linux that's currently limited by the fact that we can't
have blocks bigger than a page.  The filesystem can also report the
optimal I/O size in statfs.  For XFS the stripe width also affects how
the realtime/GRIO allocators work.

-- 
Martin K. Petersen	Oracle Linux Engineering
