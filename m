From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 16:56:31 +0400
Message-ID: <4C52CBFF.6090406@vlnb.net>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56696 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0G3M4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jul 2010 08:56:39 -0400
In-Reply-To: <20100729230406.GI4506@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.>

Ted Ts'o, on 07/30/2010 03:04 AM wrote:
> On Thu, Jul 29, 2010 at 04:30:54PM -0600, Andreas Dilger wrote:
>> Like James wrote, this is basically everything FUA.  It is OK for
>> ordered mode to allow the device to aggregate the normal filesystem
>> and journal IO, but when the commit block is written it should flush
>> all of the previously written data to disk.  This still allows
>> request re-ordering and merging inside the device, but orders the
>> data vs. the commit block.  Having the proposed "flush ranges"
>> interface to the disk would be ideal, since there would be no wasted
>> time flushing data that does not need it (i.e. other partitions).
>
> My understanding is that "everything FUA" can be a performance
> disaster.  That's because it bypasses the track buffer, and things get
> written directly to disk.  So there is no possibility to reorder
> buffers so that they get written in one disk rotation.  Depending on
> the disk, it might even be that if you send N sequential sectors all
> tagged with FUA, it could be slower than sending the N sectors
> followed by a cache flush or SYNCHRONIZE_CACHE command.

It should be, because it gives the drive opportunity to better load 
internal resources and provide data transfer pipelining. Although, of 
course, it's possible to imagine a stupid drive with nearly broken 
caching which would work in write through mode faster.

I used word "drive", not "disk" above, because I think this discussions 
is not only about disks. Storage might be not only disks, but also 
external arrays and even clusters of arrays. They all look to the system 
as single "disks", but are much more advanced and sophisticated in all 
internal capabilities than dumb (S)ATA disks. Now such arrays and 
clusters are getting more and more commonly used. Anybody can make such 
array using just a Linux box with any OSS SCSI target software and use 
them with a variety of interfaces: iSCSI, Fibre Channel, SAS, InfiniBand 
and even familiar parallel SCSI (Funny, 2 Linux boxes connected by Wide 
SCSI :) ).

So, why to only limit discussion to the low end disks? I believe it 
would be more productive if we at first determine the set of 
capabilities which should be used for the best performance and which 
advanced storage devices can provide and then go down to the lower end 
eliminating the use of the advantage features with sacrificing 
performance. Otherwise, ignoring the "hardware offload" which advanced 
devices provide, we would never achieve the best performance they could 
give.

I'd start the analyze of the best performance facilities from the following:

1. Full set of SCSI queuing and task management control facilities. Namely:

  - SIMPLE, ORDERED, ACA and, maybe, HEAD OF QUEUE commands attributes

  - Never draining the queue to wait for completion of one or more 
commands, except some rare recovery error recovery cases.

  - ACA and UA_INTRCK for protecting the queue order in case if one or 
more commands in it finished abnormally.

  - Use of write back caching by default and switch to write through 
only for "blacklisted" drives.

  - FUA for sequences of few write commands, where either 
SYNCHRONIZE_CACHE command is an overkill, or there is internal order 
dependency between the commands, so they must be written to the media 
exactly in the required order.

So, for instance, a naive sequence of meta-data updates with the 
corresponding journal writes would be a chain of commands:

1. 1st journal write command (SIMPLE)

2. 2d  journal write command (SIMPLE)

3. 3d  journal write command (SIMPLE)

4. SYNCHRONIZE_CACHE for blocks written by those 3 commands (ORDERED)

5. Necessary amount of meta-data update commands (all SIMPLE)

6. SYNCHRONIZE_CACHE for blocks written in 5 (ORDERED)

7. Command marking the transaction committed in the journal (ORDERED)

That's all. No queue draining anywhere. Plus, sending commands without 
internal order requirements as SIMPLE would allow the drive to better 
schedule execution of them among internal storage (actual disks).

For an error recovery case consider command (4) abnormally finished 
because of some external event, like Unit Attention. Then the drive 
would establish ACA condition and suspend the commands queue with 
commands from (5) in the head. Then the system would retry this command 
with ACA attribute. Then, when it finished, would clear the ACA 
condition. Then the drive would resume the queue and commands in the 
head ((5)) started being processed.

For a simpler device (a disk without support for ORDERED queuing) the 
same meta-data updates would be:

1. 1st journal write command

2. 2d  journal write command

3. 3d  journal write command

4. The queue draining.

5. SYNCHRONIZE_CACHE

6. The queue draining.

7. Necessary amount of meta-data update commands

8. The queue draining.

9. SYNCHRONIZE_CACHE for blocks written in 5 (ORDERED)

10. The queue draining.

11. Command marking the transaction committed in the journal (ORDERED)

Then we would need to figure out an interface for file systems to let 
them be able to specify the necessary ordering and cache flushing 
requirements in a generic way. The current interface looks almost good, but:

1. In it semantic of "barrier" is quite overloaded, hence confusing and 
hard to implement.

2. It doesn't allow to bind several requests in an ordered chain.

Vlad
