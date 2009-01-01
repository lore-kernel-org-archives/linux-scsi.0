From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [osd-dev] [PATCH 7/9] exofs: mkexofs
Date: Thu, 01 Jan 2009 16:23:00 +0200
Message-ID: <495CD1C4.1030605@panasas.com>
References: <4947BFAA.4030208@panasas.com>	<4947CA5C.50104@panasas.com>	<20081229121423.efde9d06.akpm@linux-foundation.org>	<495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <495C8B65.4010202@panasas.com> <495C92C8.5040702@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:15743 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756047AbZAAOXG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jan 2009 09:23:06 -0500
In-Reply-To: <495C92C8.5040702@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, open-osd development <osd-dev@open-osd.org>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, avishay@gmail.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Jan. 01, 2009, 11:54 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Benny Halevy wrote:
>> On Dec. 31, 2008, 17:57 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>>> On Wed, 2008-12-31 at 17:19 +0200, Boaz Harrosh wrote:
>>>> Andrew Morton wrote:
>>>>> On Tue, 16 Dec 2008 17:33:48 +0200
>>>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>>>
>>>>>> We need a mechanism to prepare the file system (mkfs).
>>>>>> I chose to implement that by means of a couple of
>>>>>> mount-options. Because there is no user-mode API for committing
>>>>>> OSD commands. And also, all this stuff is highly internal to
>>>>>> the file system itself.
>>>>>>
>>>>>> - Added two mount options mkfs=0/1,format=capacity_in_meg, so mkfs/format
>>>>>>   can be executed by kernel code just before mount. An mkexofs utility
>>>>>>   can now be implemented by means of a script that mounts and unmount the
>>>>>>   file system with proper options.
>>>>> Doing mkfs in-kernel is unusual.  I don't think the above description
>>>>> sufficiently helps the uninitiated understand why mkfs cannot be done
>>>>> in userspace as usual.  Please flesh it out a bit.
>>>> There are a few main reasons.
>>>> - There is no user-mode API for initiating OSD commands. Such a subsystem
>>>>   would be hundredfold bigger then the mkfs code submitted. I think it would be
>>>>   hard and stupid to maintain a complex user-mode API just for creating
>>>>   a couple of objects and writing a couple of on disk structures.
>>> This is really a reflection of the whole problem with the OSD paradigm.
>>>
>>> In theory, a filesystem on OSD is a thin layer of metadata mapping
>>> objects to files.  Get this right and the storage will manage things,
>>> like security and access and attributes (there's even a natural mapping
>>> to the VFS concept of extended attributes).  Plus, the storage has
>>> enough information to manage persistence, backups and replication.
>>>
>>> The real problem is that no-one has actually managed to come up with a
>>> useful VFS<->OSD mapping layer (even by extending or altering the VFS).
>>> Every filesystem that currently uses OSD has a separate direct OSD
>>> speaking interface (i.e. it slices out the block layer to do this and
>>> talks directly to the storage).
>>>
>>> I suppose this could be taken to show that such a layer is impossibly
>>> complex, as you assert, but its lack is reflected in strange looking
>>> design decisions like in-kernel mkfs.  It would also mean that there
>>> would be very little layered code sharing between ODS based filesystems.
>> I think that we may need to gain some more experience to extract the
>> commonalities of such file systems.  Currently we came up with the
>> lowest possible denominator the osd initiator library that deals
>> with command formatting and execution, including attrs, sense status,
>> and security.
> 
> Not putting words in James' mouth, but I definitely agree that the 
> in-kernel mkfs raises a red flag or two.  mkfs.ext3 for block-based 
> filesystems has direct and intimate knowledge of ext3 filesystem 
> structure, and it writes that information from userland directly to the 
> block(s) necessary.

Personally, I'm not sure if maintaining that intimate knowledge in a
user space program is an ideal model with respect to keeping both
in sync, avoiding code duplication, and dealing with upgrade issues
(e.g. upgrading the kernel and not the user space utils)

The main advantage I can see in doing that is keeping the kernel
code small without bloating it with rarely-used logic.  However,
the mkfs logic for exofs has such a small footprint that it
doesn't add much to the module footprint so justifying the user space
util using that parameter is questionable IMO.

> 
> Similarly, mkfs for an object-based filesystem should be issuing SCSI 
> commands to the OSD device from userland, AFAICS.

That's possible...

Benny

> 
> 
>> To provide a higher level abstraction that would help with "administrative"
>> tasks like mkfs and the like we already tossed an idea in the past -
>> a file system that will represent the contents of an OSD in a namespace,
>> for example: partition_id / object_id / {data, attrs / ..., ctl / ...}.
>> Such a file system could provide a generic mapping which one could
>> use to easily develop management applications for the OSD.  That said,
>> it's out of the scope of exofs which focuses mostly on the filesystem
>> data and metadata paths.
> 
> That's far too complex for what is necessary.  Just issue SCSI commands 
> from userland.  We don't need an abstract interface specifically for 
> low-level details.  The VFS is that abstract interface; anything else 
> should be low-level and purpose-built.
> 
> 	Jeff
> 
> 
> 
> 
> 
> 
