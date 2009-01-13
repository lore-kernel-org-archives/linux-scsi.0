From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Date: Tue, 13 Jan 2009 15:03:05 +0200
Message-ID: <496C9109.5040803@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com>	<1230739053.3408.74.camel@localhost.localdomain>	<4960D3CA.2000202@panasas.com>	<1231783926.3256.29.camel@localhost.localdomain>	<496B989F.7050907@garzik.org>	<1231790190.15161.29.camel@localhost.localdomain>	<496BA671.3070900@garzik.org> <1231802758.27151.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:16692 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZAMNDN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 08:03:13 -0500
In-Reply-To: <1231802758.27151.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: open-osd development <osd-dev@open-osd.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, linux-kernel <linux-kernel@vger.kernel.org>, Avishay Traeger <avishay@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Jan. 13, 2009, 1:25 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2009-01-12 at 15:22 -0500, Jeff Garzik wrote: 
>> James Bottomley wrote:
>>> On Mon, 2009-01-12 at 14:23 -0500, Jeff Garzik wrote:
>>>>> It's an indicator of one.  If you buy my premise that OSD cannot be
>>>>> relevant without compelling user cases, then the lack of a user API can
>>>>> be viewed as a symptom of this.
>>>> If having a compelling user case was a prereq for kernel inclusion, well 
>>>> over half the code would be gone.
>>> I'm not holding this against inclusion ... I'm saying it's a symptom of
>>> the generic relevance to user issues problem that OSD has.
>>>
>>>>> I think your choice of using a character device will turn out to be a
>>>>> design mistake because the migration path of existing filesystems is
>>>>> bound to be a block device with extra features (which they may or may
>>>>> not make use of) but only if there's a way to make ODS relevant to
>>>>> users.
>>>> It is fantasy to think we will be migrating ext4 to OSD.  That fantasy 
>>>> is not a compelling reason to block OSD development.
>>> OK, so your quote managed to miss this bit:
>>>
>>> "Right, so I'm reasonably happy to accept libosd for what it is:  an
>>> enabler for a few specialised applications. "
>>>
>>> I can't see how that can be construed as "blocking OSD development".
>>> The word "accept" is conventionally used in Linux parlance to mean "will
>>> send upstream".
>> Yet you continue to expend energy complaining about migrating 
>> block-based filesystems to OSD, a complex, overhead-laden undertaking 
>> _no one_ has proposed or entertained.
> 
> You're the one who keeps suggesting migration, not me.  I keep
> suggesting ways to make OSD more relevant to current user problems.
> 
> A maintainer doesn't have to like everything they merge.
> 
>>>> To sum,
>>>>
>>>> * exofs needs a userspace library, around which the standard filesystem 
>>>> tools will be built, most notably mkfs, dump, restore, fsck
>>>>
>>>> * talk of migrating existing filesystems is wildly premature (and a bit 
>>>> of a silly argument, since you are also arguing that OSD lacks 
>>>> compelling use cases)
>>> So criticising lacking compelling use cases while at the same time
>>> suggesting how to find them is wrong?
>>>
>>> Actually, If the only use case OSD can bring to the table is requiring
>>> new filesystems, then there's nothing of general user relevance for it
>>> on the horizon ... anywhere.  There's never going to be a compelling
>>> reason to move the consumer OSDs in the various development labs to
>>> production because nothing would be able to use them on a mass scale.
>>> If we could derive a benefit from OSD in existing filesystems, then they
>>> do have user relevance, and Seagate and the others might just consider
>>> releasing the devices.
>> If Seagate were to release a production OSD device, do you really think 
>> they would prefer a block-based filesystem hacked to work with OSDs?  I 
>> don't think so.
> 
> Um, speaking with my business hat on, I'd really beg to differ ... you
> don't release a product into an empty market.  you pick an existing one,
> or fill a fundamental need that a market nucleates around.  If that
> means block based filesystems hacked to work with OSDs, I think they'd
> take it, yes.
> 
>> Existing block filesystems are very much purpose built for sector-based 
>> storage as implemented on modern storage devices.  No kernel API can 
>> hand-wave that away.
>>
>> The whole point of OSDs is to move some of the overhead to the storage 
>> device, not _add_ to the overhead.
> 
> Well, that was the idea, with OSD version 1.  The problem is that the
> benchmarks didn't confirm that letting the disk take care of object
> placement was a win over block based filesystems.   If you want to
> migrate objects across disks (i.e. cfs paradigm), then it is a win, but
> not really for performance.  That's why OSDv2 has been beefing up
> attributes and security.

IMO the main advantage of moving block allocation down to the OSD target
is more apparent with distributed file systems a-la pNFS over objects
where paralleling that task is a key for scalable performance.

The thing is that the target needs to implement its own mapping from
object logical offsets into disk blocks and this is usually done
using some kind of a (possibly trimmed down) local file system.
Therefore the I/O performance of a single OSD is likely to be similar
to a single file server's.  I'm not sure what will be case comparing
an OSD with a local file system mounted over a block device over
a storage network, e.g. FC or iSCSI - that could be an interesting
research topic.  I guess that the main issue there is to cache enough
metadata on the host to minimize transfer latencies (assuming
latency of a directly attached device is always better than
a fabric-attached one).

Anyhow, capacity management via partitions and object allocation,
plus quotas, and the fine grain OSD security model is a big one
that's worth investigating, to say the least.

> 
> The interesting question is what does it take to allow arbitrary
> filesystems to benefit from this.

One direction is to mount the file system over an object or a set
of object exported via exofs using mount -o loop.
And the user doesn't have to be necessarily a filesystem. It could
be a database either...  or anything that's typically working
over a block device.

Benny

> 
>>> Note that "providing benefit to" does not equate to "rewriting the
>>> filesystem for" ... and it shouldn't; the benefit really should be
>>> incremental.  And that's the crux of my criticism.  While OSD are
>>> separate things that we have to rewrite whole filesystems for, they're
>>> never going to set the world on fire.  If they could be used with only
>>> incremental effort, they might.  The bridge for the incremental effort
>>> will come from a properly designed kernel API.
>> Well, hey, if you wanna expend energy creating a kernel API that 
>> presents a complex OSD as simple block-based storage, go for it.  AFAICS 
>> it's just extra overhead and complexity when a new filesystem could do 
>> the job much better.
> 
> Because writing a new filesystem is so much easier?
> 
>> And I seriously doubt Linus or anyone else will want to hack up a 
>> block-based filesystem in this manner.  Better to create a silly "for 
>> argument's sake" OSD block device, upon which any block-based filesystem 
>> can be mounted.  (Note I said block device, _not_ filesystem)
> 
> That's a possibility ... as I said before: a block device with extra
> features that allows incremental use in the filesystem.

I can understand representing a single object as a block device (although I
think that using a file for that should be good enough and easier) but
why representing the whole OSD as a block device?  The OSD holds partitions
and objects each with attributes and OSD security related support.  Hence
representing that in a namespace using a filesystem seems straight forward.

Benny

> 
>>>> * an in-kernel OSD-based filesystem needs some sort of generic in-kernel 
>>>> libosd API, so that multiple OSD filesystems do not reinvent the wheel 
>>>> each time.
>>>>
>>>> * OSD was bound to be annoying, because it forces the kernel filesystem 
>>>> to either (a) talk SCSI or (b) use messages that can be converted to 
>>>> SCSI OSD commands, like existing drivers convert the block layer's READ 
>>>> and WRITE to device-specific commands.
>>> OK, so what you're arguing is that unlike block devices where we can
>>> produce a useful generic abstraction that is protocol agnostic, for OSD
>>> we can't?  As I've said before, I think this might be true, but fear it
>>> dooms OSD to being too difficult to use.
>> No, a generic abstraction is "(b)" in my quoted paragraph.
>>
>> But it's certainly easy to create an OSD block device client, that 
>> simulates sector-based storage, if you are motivated in that direction.
>>
>> But that only makes sense if you want the extra overhead (square peg, 
>> round hole), which no sane person will want.  Face it, only screwballs 
>> want to mount ext4 on an OSD.
> 
> So what's your proposal for lowering the barrier to adoption then?
> 
>>>> * Trying to force OSD to export a block device is pushing a square peg 
>>>> through a round hole.  Thus, the best (and only) alternative is 
>>>> character device.  What you really want is a Third Way(tm):  a mmap'able 
>>>> message device, since you really want to export an API to userspace.
>>> only allowing a character tap raises the effort bar on getting other
>>> filesystems to use it, because they're all block based ...
>> That's irrelevant, since no one is calling for block-based filesystems 
>> to be converted to use OSD.
> 
> It's relevant to lowering the barrier to adoption, unless there's some
> other means I haven't seen.
> 
>> And I can only imagine the push-back, should someone actually propose 
>> doing so.  Filesystems are very much purpose-built for their storage 
>> paradigm.
> 
> Filesystems are complex and difficult beasts to get right.  Btrfs took a
> year to get to the point of kernel inclusion and will take some little
> time longer to get enterprises to the point of trusting data to it.  So
> if we say a two year lead time, that would mean that even if someone
> started a general purpose OSD based filesystem today, it wouldn't be
> ready for the consumer market until 2011.  That's not really going to
> convince the disk vendors that OSD based devices should be marketed
> today.
> 
> James
> 
> 
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev

