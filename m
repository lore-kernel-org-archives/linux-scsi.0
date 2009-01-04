From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Sun, 04 Jan 2009 17:20:42 +0200
Message-ID: <4960D3CA.2000202@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	 <20081229121423.efde9d06.akpm@linux-foundation.org>	 <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230739053.3408.74.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
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

Certainly not a problem of the OSD paradigm, just maybe a problem
of the current code boundaries laid out by years of block-devices.

> In theory, a filesystem on OSD is a thin layer of metadata mapping
> objects to files.  Get this right and the storage will manage things,
- objects to files.  Get this right and the storage will manage things,
+ files to objects.  Get this right and the storage will manage things,
[objects to files is what some of the osd-targets do.]
> like security and access and attributes (there's even a natural mapping
> to the VFS concept of extended attributes).  Plus, the storage has
> enough information to manage persistence, backups and replication.
> 

Sounds perfect to me.

> The real problem is that no-one has actually managed to come up with a
> useful VFS<->OSD mapping layer (even by extending or altering the VFS).
> Every filesystem that currently uses OSD has a separate direct OSD
> speaking interface (i.e. it slices out the block layer to do this and
> talks directly to the storage).

I'm not sure what you mean.
Lets take VFS<->BLOCKS mapping for example. Each FS has it's own
interpretation of what that means, brtfs is less perfect then xfs
or vice versa?
I guess you did not mean "mapping" but meant "Interface" or API.
(or more likely I misunderstand the meaning of "mapping" ;)

Well that is exactly what I was attempting to submit. A general-purpose
low-level but easy-to-use, objects API for kernel clients. be it a
dead-simple exofs, or a complex multi-head beast like a pNFS-Objects
file system. The same library/API/Interface will be used for NFS-Clients
NFSD-Servers, reconstruction, security what ever.

The block-layer is not sliced out, Only the elevator function is, since
BIO merging, if any, are not device global but per-object/file, and the
elevator does not currently support that. (Profiling shows that it will
be needed)

BTW. The block-based filesystems are just a big minority in Kernel. The
majority does not use block-layer either.

> 
> I suppose this could be taken to show that such a layer is impossibly
> complex, as you assert, but its lack is reflected in strange looking
> design decisions like in-kernel mkfs.  It would also mean that there
> would be very little layered code sharing between ODS based filesystems.
- would be very little layered code sharing between ODS based filesystems.
+ would be very little layered code sharing between OSD based filesystems.

I disagree.
All the OSD-Based file systems (In Linux) should absolutely only use the
open-osd library submitted. I myself will work on a couple. If anything is
missing that could not be added later, I would like to know about it.

User-mode Interface is another matter. There are some ideas and some already
implemented.
[Hosted on open-osd.org
 see: http://git.open-osd.org/gitweb.cgi?p=osc-osd/.git;a=summary
 look inside the osd-initiator directory]
And I have a toy interface that adds no new entries into the Kernel in
the form of an OSDVFS module, that will let you access the raw OSD device
through the VFS name-space.

The lack of any user-mode API is just the lack of any current need/priority,
or that I'm the only one working on OSD. But nothing that could not be solved
in two weeks of pragmatic work. Surly it's not a paradigm problem.

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
> 

Time will tell, but I believe the exact opposite. I believe and strive
for this OSD body of work to be useful for anybody that needs to talk
T10-OSD in Linux, be it for any-purpose. Any thing missing should be
easily added.

> James
> 
> 

To summarize the way I see it:
- James is right in that we can not currently see the full OSD picture since
  we do not have a user-mode API, so the usefulness of it all is unclear.
  [I will send an RFD soon, and hope all interested will chime in on the
   discussion]
- That said, all the submitted code is still relevant and useful,
  though at few places it takes the route of pragmatic-easy vs
  long-term-correctness. [Which can be fixed]
- exofs/OSD is not the first FS that depends on a none-block-dev/its-own
  stack. The lower level (OSD) is represented to kernel as a char-dev +
  Additional API, common to other FS/stack models. Though the lower OSD
  level has the potential to be a generic layer that can be used by lots
  of users and use cases, not only FS type.

Thank you James for your consideration
Boaz
