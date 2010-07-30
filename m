From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 16:56:41 +0400
Message-ID: <4C52CC09.20706@vlnb.net>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org>	 <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org>	 <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org>	 <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de>	 <4C51DCF1.3010507@redhat.com>	 <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca>	 <20100729230406.GI4506@thunk.org> <1280446105.4441.837.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1280446105.4441.837.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

James Bottomley, on 07/30/2010 03:28 AM wrote:
> On Thu, 2010-07-29 at 19:04 -0400, Ted Ts'o wrote:
>> On Thu, Jul 29, 2010 at 04:30:54PM -0600, Andreas Dilger wrote:
>>> Like James wrote, this is basically everything FUA.  It is OK for
>>> ordered mode to allow the device to aggregate the normal filesystem
>>> and journal IO, but when the commit block is written it should flush
>>> all of the previously written data to disk.  This still allows
>>> request re-ordering and merging inside the device, but orders the
>>> data vs. the commit block.  Having the proposed "flush ranges"
>>> interface to the disk would be ideal, since there would be no wasted
>>> time flushing data that does not need it (i.e. other partitions).
>>
>> My understanding is that "everything FUA" can be a performance
>> disaster.  That's because it bypasses the track buffer, and things get
>> written directly to disk.  So there is no possibility to reorder
>> buffers so that they get written in one disk rotation.  Depending on
>> the disk, it might even be that if you send N sequential sectors all
>> tagged with FUA, it could be slower than sending the N sectors
>> followed by a cache flush or SYNCHRONIZE_CACHE command.
>
> I think we're getting into disk differences here.  This certainly isn't
> correct for SCSI disks.  The standard enterprise configuration for a
> SCSI disk is actually cache set to write through ... so FUA is a nop.
> Even for Write Back cache SCSI devices, FUA is just a wait until I/O is
> on media, which is pretty much equivalent to the write through case for
> the given cache lines.
>
> I can see the problems you describe possibly affecting ATA devices with
> less sophisticated caches ... but, realistically, SATA and SAS devices
> come from virtually the same manufacturing process ... I'd be really
> surprised if they didn't share caching technologies.

Please, don't limit consideration to local disks only!

Vlad
