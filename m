From: Neil Brown <neilb@suse.de>
Subject: Re: REQUEST for new 'topology' metrics to be moved out of
	the 'queue' sysfs directory.
Date: Thu, 9 Jul 2009 10:42:43 +1000
Message-ID: <19029.15619.61976.205727@notabene.brown>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<yq1k530qkm7.fsf@sermon.lab.mkp.net>
	<19012.47077.328965.919868@notabene.brown>
	<yq1ws6znja4.fsf@sermon.lab.mkp.net>
	<19026.43290.340555.774690@notabene.brown>
	<yq163e55ada.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Martin K. Petersen on Tuesday July 7
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tuesday July 7, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == Neil Brown <neilb@suse.de> writes:
> 
> >> What: /sys/block/<disk>/queue/minimum_io_size Date: April 2009
> >> Contact: Martin K. Petersen <martin.petersen@oracle.com> Description:
> >> Storage devices may report a granularity or minimum I/O size which is
> >> the device's preferred unit of I/O.  Requests smaller than this may
> >> incur a significant performance penalty.
> >> 
> >> For disk drives this value corresponds to the physical block
> >> size. For RAID devices it is usually the stripe chunk size.
> 
> Neil> These two paragraphs are contradictory.  There is no sense in
> Neil> which a RAID chunk size is a preferred minimum I/O size.
> 
> Maybe not for MD.  This is not just about MD.

I wasn't just thinking about MD.  I was thinking about the generic
concept of RAID.

> 
> This is a hint that says "Please don't send me random I/Os smaller than
> this.  And please align to a multiple of this value".
> 
> I agree that for MD devices the alignment portion of that is the
> important one.  However, putting a lower boundary on the size *is* quite
> important for 4KB disk drives.  There are also HW RAID devices that
> choke on requests smaller than the chunk size.

I certainly see that the lower boundary is important for 4KB disk
drives, but we have that information encoded in physical_block_size,
so duplicating here doesn't seem to be a high priority.
I'm surprised that a HW RAID device would choke on requests smaller
than the chunk size.  If that is the case, then I guess it could be
useful to have this number separate from physical_block_size....

> 
> I appreciate the difficulty in filling out these hints in a way that
> makes sense for all the supported RAID levels in MD.  However, I really
> don't consider the hints particularly interesting in the isolated
> context of MD.  To me the hints are conduits for characteristics of the
> physical storage.  The question you should be asking yourself is: "What
> do I put in these fields to help the filesystem so that we get the most
> out of the underlying, slow hardware?".

That is certainly a good approach, but to be able to answer that
question, I would need to know how the filesystem is going to use this
information.   You have included that below (thanks).  Maybe including
it in the documentation would be helpful.

> 
> I think it is futile to keep spending time coming up with terminology
> that encompasses all current and future software and hardware storage
> devices with 100% accuracy.

And I think it is futile to export a value with such a vague meaning.
Concrete usage examples would help make the meaning less vague.

> 
> 
> Neil> To some degree it is actually a 'maximum' preferred size for
> Neil> random IO.  If you do random IO is blocks larger than the chunk
> Neil> size then you risk causing more 'head contention' (at least with
> Neil> RAID0 - with RAID5 the tradeoff is more complex).
> 
> Please elaborate.

If you are performing random IO on a 4-drive RAID0 and every IO fits
within a chunk, then you can expect to get 4 times the throughput of a
single drive as you get 4-way parallelism on the seeks.
If you are performing random IO on that same array but every IO
crosses a chunk boundary, then you need 2 drives to satisfy each
request, and you only get 2-way parallelism on the seeks.  As random
IO tends to be seek-bound, this will probably be slower.

The same is true for reading from RAID5.  For writing to RAID5, the
parity updates confuse the numbers, so it is hard to make such general
statements, though for largish arrays (6 or more devices) you probably
get a similar effect.


> 
> 
> Neil> Also, you say "may" report.  If a device does not report, what
> Neil> happens to this file.  Is it not present, or empty, or contain a
> Neil> special "undefined" value?  I think the answer is that "512" is
> Neil> reported.
> 
> The answer is physical_block_size.
> 
> 
> Neil> In this case, if a device does not report an optimal size, the
> Neil> file contains "0" - correct?  Should that be explicit?
> 
> Now documented.

Thanks.

> 
> 
> Neil> I'd really like to see an example of how you expect filesystems to
> Neil> use this.  I can well imagine the VM or elevator using this to
> Neil> assemble IO requests in to properly aligned requests.  But I
> Neil> cannot imagine how e.g mkfs would use it.  Or am I
> Neil> misunderstanding and this is for programs that use O_DIRECT on the
> Neil> block device so they can optimise their request stream?
> 
> The way it has been working so far (with the manual ioctl pokage) is
> that mkfs will align metadata as well as data on a minimum_io_size
> boundary.  And it will try to use the minimum_io_size as filesystem
> block size.  On Linux that's currently limited by the fact that we can't
> have blocks bigger than a page.  The filesystem can also report the
> optimal I/O size in statfs.  For XFS the stripe width also affects how
> the realtime/GRIO allocators work.

Thanks for these details.

It seems from these that the primary issue is alignment, while size is
secondary (with the exception of physical_block_size, where it is very
important).
Yet in your documentation, alignment doesn't get mentioned until the
last paragraph, making it seem like an afterthought.

(I couldn't find an 'optimal I/O size" in statfs.  Maybe you mean
 "st_blksize" in 'stat'??  I think that one really has to be the
 filesystem block size.)


I think all these numbers are probably useful numbers to export.  But
I think that trying to give them labels like "optimal" or "minimum" or
"physical" is trying to give them a meaning which they don't really
possess.  It is treading a middle-ground which is less useful than
either extreme.
I think they should either be:
   block_size   chunk_size  stripe_size
or
   align-A   align-B   align-C
    With the uniform definition:
      IO requests of this alignment (and possibly size) give
      significantly better performance non-aligned requests.


Yes, I know.  We've been here before.  You didn't understand/believe
me before so there is no reason for me to expect to be more successful
this time.  I'll go find some bugs that I can be successful in fixing.

NeilBrown
