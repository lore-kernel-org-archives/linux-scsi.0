From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Date: Thu, 01 Jan 2009 11:22:45 +0200
Message-ID: <495C8B65.4010202@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230739053.3408.74.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: open-osd development <osd-dev@open-osd.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, jeff@garzik.org, linux-kernel@vger.kernel.org, avishay@gmail.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Dec. 31, 2008, 17:57 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-12-31 at 17:19 +0200, Boaz Harrosh wrote:
>> Andrew Morton wrote:
>>> On Tue, 16 Dec 2008 17:33:48 +0200
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> We need a mechanism to prepare the file system (mkfs).
>>>> I chose to implement that by means of a couple of
>>>> mount-options. Because there is no user-mode API for committing
>>>> OSD commands. And also, all this stuff is highly internal to
>>>> the file system itself.
>>>>
>>>> - Added two mount options mkfs=0/1,format=capacity_in_meg, so mkfs/format
>>>>   can be executed by kernel code just before mount. An mkexofs utility
>>>>   can now be implemented by means of a script that mounts and unmount the
>>>>   file system with proper options.
>>> Doing mkfs in-kernel is unusual.  I don't think the above description
>>> sufficiently helps the uninitiated understand why mkfs cannot be done
>>> in userspace as usual.  Please flesh it out a bit.
>> There are a few main reasons.
>> - There is no user-mode API for initiating OSD commands. Such a subsystem
>>   would be hundredfold bigger then the mkfs code submitted. I think it would be
>>   hard and stupid to maintain a complex user-mode API just for creating
>>   a couple of objects and writing a couple of on disk structures.
> 
> This is really a reflection of the whole problem with the OSD paradigm.
> 
> In theory, a filesystem on OSD is a thin layer of metadata mapping
> objects to files.  Get this right and the storage will manage things,
> like security and access and attributes (there's even a natural mapping
> to the VFS concept of extended attributes).  Plus, the storage has
> enough information to manage persistence, backups and replication.
> 
> The real problem is that no-one has actually managed to come up with a
> useful VFS<->OSD mapping layer (even by extending or altering the VFS).
> Every filesystem that currently uses OSD has a separate direct OSD
> speaking interface (i.e. it slices out the block layer to do this and
> talks directly to the storage).
> 
> I suppose this could be taken to show that such a layer is impossibly
> complex, as you assert, but its lack is reflected in strange looking
> design decisions like in-kernel mkfs.  It would also mean that there
> would be very little layered code sharing between ODS based filesystems.

I think that we may need to gain some more experience to extract the
commonalities of such file systems.  Currently we came up with the
lowest possible denominator the osd initiator library that deals
with command formatting and execution, including attrs, sense status,
and security.

To provide a higher level abstraction that would help with "administrative"
tasks like mkfs and the like we already tossed an idea in the past -
a file system that will represent the contents of an OSD in a namespace,
for example: partition_id / object_id / {data, attrs / ..., ctl / ...}.
Such a file system could provide a generic mapping which one could
use to easily develop management applications for the OSD.  That said,
it's out of the scope of exofs which focuses mostly on the filesystem
data and metadata paths.

> 
>> - I intend to refactor the code further to make use of more super.c services,
>>   so to make this addition even smaller. Also future direction of raid over
>>   multiple objects will make even more kernel infrastructure needed which
>>   will need even more user-mode code duplication.
>> - I anticipate problems that are not yet addressed in this body of work
>>   but will be in the future, mainly that a single OSD-target (lun) can
>>   be shared by lots of FSs, and a single FS can span many OSD-targets.
>>   Some central management is much easier to do in Kernel.
>>
>>> What are the dependencies for this filesystem code?  I assume that it
>>> depends on various block- and scsi-level patches?  Which ones, and
>>> what is their status, and is this code even compileable without them?
>>>
>> This OSD-based file system is dependent on the open-osd initiator library
>> code that I've submitted for inclusion for 2.6.29. It has been sitting
>> in linux-next for a while now, and has not been receiving any comments
>> for the last two updated patchsets I've sent to scsi-misc/lkml. However
>> it has not yet been submitted into Jame's scsi-misc git tree, and James
>> is the ultimate maintainer that should submit this work. I hope it will
>> still be submitted into 2.6.29, as this code is totally self sufficient
>> and does not endangers or changes any other Kernel subsystems.
>> (All the needed ground work was already submitted to Linus since 2.6.26)
>> So why should it not?
> 
> I don't like it mainly because it's not truly a useful general framework
> for others to build on.  However, as argued above, there might not
> actually be such a useful framework, so as long as the only two
> consumers (you and Lustre) want an interface like this, I'll put it in.

Not to mention pnfs over objects which is coming up around the corner.
The pnfs-obj layout driver will use the osd initiator library as well
for distributed data I/O access (while the metadata server, to be based
on exofs accesses the OSD for metadata and security ops too)

Benny

> 
> James
> 
> 
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev

