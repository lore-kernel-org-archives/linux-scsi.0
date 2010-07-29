From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 19:08:19 -0400
Message-ID: <4C5209E3.7010702@redhat.com>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab0G2XIy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 19:08:54 -0400
In-Reply-To: <20100729230406.GI4506@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>ja

On 07/29/2010 07:04 PM, Ted Ts'o wrote:
> On Thu, Jul 29, 2010 at 04:30:54PM -0600, Andreas Dilger wrote:
>    
>> Like James wrote, this is basically everything FUA.  It is OK for
>> ordered mode to allow the device to aggregate the normal filesystem
>> and journal IO, but when the commit block is written it should flush
>> all of the previously written data to disk.  This still allows
>> request re-ordering and merging inside the device, but orders the
>> data vs. the commit block.  Having the proposed "flush ranges"
>> interface to the disk would be ideal, since there would be no wasted
>> time flushing data that does not need it (i.e. other partitions).
>>      
> My understanding is that "everything FUA" can be a performance
> disaster.  That's because it bypasses the track buffer, and things get
> written directly to disk.  So there is no possibility to reorder
> buffers so that they get written in one disk rotation.  Depending on
> the disk, it might even be that if you send N sequential sectors all
> tagged with FUA, it could be slower than sending the N sectors
> followed by a cache flush or SYNCHRONIZE_CACHE command.
>    

You certainly can reorder in a drive with FUA, you just cannot ACK the 
write until the tagged request is on disk.

That clearly depends on the firmware of the device and, if it is an 
uncommon request, firmware people are unlikely to have spent too much 
thought and time doing it right :-)

> It may be worth doing some experiments to see how big N is for various
> disks, but I'm pretty sure that FUA will probably turn out to not be
> such a great idea for ext3/ext4.
>
> 						- Ted
>    

I am also sceptical and would expect a lot of variability in the results,

Ric


