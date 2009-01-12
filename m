From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Mon, 12 Jan 2009 14:23:11 -0500
Message-ID: <496B989F.7050907@garzik.org>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	 <20081229121423.efde9d06.akpm@linux-foundation.org>	 <495B8D90.1090004@panasas.com>	 <1230739053.3408.74.camel@localhost.localdomain>	 <4960D3CA.2000202@panasas.com> <1231783926.3256.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33059 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZALTYI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 14:24:08 -0500
In-Reply-To: <1231783926.3256.29.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

James Bottomley wrote:
> On Sun, 2009-01-04 at 17:20 +0200, Boaz Harrosh wrote:
>> James Bottomley wrote:
>>> On Wed, 2008-12-31 at 17:19 +0200, Boaz Harrosh wrote:
>>>> Andrew Morton wrote:
>>>>> On Tue, 16 Dec 2008 17:33:48 +0200
>>>>> Boaz Harrosh <bharrosh@panasas.com> wrote:

>>>>> Doing mkfs in-kernel is unusual.  I don't think the above description
>>>>> sufficiently helps the uninitiated understand why mkfs cannot be done
>>>>> in userspace as usual.  Please flesh it out a bit.

>>>> There are a few main reasons.
>>>> - There is no user-mode API for initiating OSD commands. Such a subsystem
>>>>   would be hundredfold bigger then the mkfs code submitted. I think it would be
>>>>   hard and stupid to maintain a complex user-mode API just for creating
>>>>   a couple of objects and writing a couple of on disk structures.
>>> This is really a reflection of the whole problem with the OSD paradigm.

>> Certainly not a problem of the OSD paradigm, just maybe a problem
>> of the current code boundaries laid out by years of block-devices.
> 
> Not having a suggestion for redrawing the boundaries is a problem of the
> paradigm.  Right at the moment using OSD is an all or nothing, there's
> no migration path for block based filesystems, or even a good idea how
> they'd take advantage of OSD.  Most OSD based filesystems are for
> special purpose things (mainly cluster FS).

I think you both are talking past each other a bit.

There is no inherent "problem with the paradigm" with regards to 
creating a userspace mkfs and userspace filesystem access library.

Yes, it's annoying to maintain two parallel codebases, but from 
experience we have found that that is what is best.  A userspace library 
is used by a wide variety of users:  specialized filesystem tools, 
filesystem repair tools, filesystem creation and optimization tools, 
FUSE implementations, the list goes on.

It has nothing to do with "block-based code boundaries".

History and experience have shown that we want a minimal, purpose-built 
filesystem in the kernel, with all the other filesystem tools external 
to the kernel.  That has proven the most robust over time, IMO (although 
noises about in-kernel fsck are beginning to appear)



>>> In theory, a filesystem on OSD is a thin layer of metadata mapping
>>> objects to files.  Get this right and the storage will manage things,
>> - objects to files.  Get this right and the storage will manage things,
>> + files to objects.  Get this right and the storage will manage things,
>> [objects to files is what some of the osd-targets do.]
>>> like security and access and attributes (there's even a natural mapping
>>> to the VFS concept of extended attributes).  Plus, the storage has
>>> enough information to manage persistence, backups and replication.

I'm a bit lost in the quoting, but to respond...

One should not make assumptions that an in-kernel OSD filesystem will 
simply turn all the "inode-ish" (object manipulation) duties wholesale 
to the OSD storage device(s).  That is an implementation detail.

To conjure an example, an OSD filesystem designer may wish to store 
collections of VFS extended attributes as a single OSD object, for 
performance or caching reasons.

Or, as discussed at the filesystem/storage summit I attended, a separate 
layer handles replication and OSD device aggregation (read: RAID) just 
like MD manages RAID[0156] now.


>>> The real problem is that no-one has actually managed to come up with a
>>> useful VFS<->OSD mapping layer (even by extending or altering the VFS).
>>> Every filesystem that currently uses OSD has a separate direct OSD
>>> speaking interface (i.e. it slices out the block layer to do this and
>>> talks directly to the storage).
>> I'm not sure what you mean.
>> Lets take VFS<->BLOCKS mapping for example. Each FS has it's own
>> interpretation of what that means, brtfs is less perfect then xfs
>> or vice versa?
>> I guess you did not mean "mapping" but meant "Interface" or API.
>> (or more likely I misunderstand the meaning of "mapping" ;)
> 
> No ... by mapping I mean mapping of VFS functions.
> 
> For example, an OSD filesystem should be user mountable: if the user has

I think that's setting the bar too high.  It would be nice if an OSD 
filesystem were user-mountable, but that obviously is less compatible 
with existing tools, admin knowledge, and site policies.


> the security key (could possibly do this in userspace).  Additionally,
> an OSD with attributes should be pluggable into the VFS layer
> sufficiently to allow attribute search, even if the VFS has no idea of
> the metadata layout, we can still get objects back.  We'd also better be
> able to do backup and restore of object based devices.

Sure.  tar/cpio/pax at the userspace level, or exofs-specific 
dump+restore tools running in userspace.  Just like with other 
filesystems :)


> The basic problem for OSD, at least as I see it is that unless it can
> provide some compelling relevance to current filesystem problems (like
> attribute search is 10x faster over OSD vs block or X filesystem gets a
> 2x performance improvement using OSD vs block ...) it's doomed forever
> to be a niche player: nice idea but no relevance to the real world.

Let's get exofs into the kernel, and prove you wrong (or right).

I know you have wonderful anecdotes about how OSD has been around 
forever and you consider it a failed paradigm; but new work is occuring, 
and people are talking about how this might be the successor to 
sector-based devices.

Let's not be closed-minded and close doors before they can be opened.

At this point, OSD is a fun and interesting research experiment that 
might have promise for the future.

That's Linux's bread-n-butter:  be on the cutting edge, experimenting 
with new technologies.  Some pan out, others don't.

But I don't see any compelling reason for an overall pushback _against_ 
OSD devices and filesystems.


>> Well that is exactly what I was attempting to submit. A general-purpose
>> low-level but easy-to-use, objects API for kernel clients. be it a
>> dead-simple exofs, or a complex multi-head beast like a pNFS-Objects
>> file system. The same library/API/Interface will be used for NFS-Clients
>> NFSD-Servers, reconstruction, security what ever.
> 
> OK ... perhaps I missed the description of how a general purpose
> filesystem might use this then?
> 
>> The block-layer is not sliced out, Only the elevator function is, since
>> BIO merging, if any, are not device global but per-object/file, and the
>> elevator does not currently support that. (Profiling shows that it will
>> be needed)
> 
> Um, your submission path is character.  You pick up block again because
> SCSI uses it for queues, but it's not really part of your paradigm.
> 
>> BTW. The block-based filesystems are just a big minority in Kernel. The
>> majority does not use block-layer either.
>>
>>> I suppose this could be taken to show that such a layer is impossibly
>>> complex, as you assert, but its lack is reflected in strange looking
>>> design decisions like in-kernel mkfs.  It would also mean that there
>>> would be very little layered code sharing between ODS based filesystems.
>> - would be very little layered code sharing between ODS based filesystems.
>> + would be very little layered code sharing between OSD based filesystems.
>>
>> I disagree.
>> All the OSD-Based file systems (In Linux) should absolutely only use the
>> open-osd library submitted. I myself will work on a couple. If anything is
>> missing that could not be added later, I would like to know about it.
> 
> But that's precisely the problem:  "OSD based filesystems" implying that
> if you want to use OSD you write a new filesystem.

Are you somehow assuming that existing block-based filesystems will take 
advantage of OSD?  I hope not; that would be silly.

_Of course_ using OSD implies a new filesystem.  You are using a wholly 
different method of interacting with storage.

Just like NFS implies a new filesystem, because networked RPC is wholly 
different from sector-based storage as well.


> It's an indicator of one.  If you buy my premise that OSD cannot be
> relevant without compelling user cases, then the lack of a user API can
> be viewed as a symptom of this.

If having a compelling user case was a prereq for kernel inclusion, well 
over half the code would be gone.


> I think your choice of using a character device will turn out to be a
> design mistake because the migration path of existing filesystems is
> bound to be a block device with extra features (which they may or may
> not make use of) but only if there's a way to make ODS relevant to
> users.

It is fantasy to think we will be migrating ext4 to OSD.  That fantasy 
is not a compelling reason to block OSD development.

To sum,

* exofs needs a userspace library, around which the standard filesystem 
tools will be built, most notably mkfs, dump, restore, fsck

* talk of migrating existing filesystems is wildly premature (and a bit 
of a silly argument, since you are also arguing that OSD lacks 
compelling use cases)

* an in-kernel OSD-based filesystem needs some sort of generic in-kernel 
libosd API, so that multiple OSD filesystems do not reinvent the wheel 
each time.

* OSD was bound to be annoying, because it forces the kernel filesystem 
to either (a) talk SCSI or (b) use messages that can be converted to 
SCSI OSD commands, like existing drivers convert the block layer's READ 
and WRITE to device-specific commands.

* Trying to force OSD to export a block device is pushing a square peg 
through a round hole.  Thus, the best (and only) alternative is 
character device.  What you really want is a Third Way(tm):  a mmap'able 
message device, since you really want to export an API to userspace.

	Jeff



