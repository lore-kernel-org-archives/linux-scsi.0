From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 31 May 2010 19:25:17 +0300
Message-ID: <4C03E2ED.808@panasas.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <yq1iq64kv9f.fsf@sermon.lab.mkp.net> <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com> <20100531154925.GO9453@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531154925.GO9453@laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 05/31/2010 06:49 PM, Nick Piggin wrote:
> On Mon, May 31, 2010 at 06:30:05PM +0300, Boaz Harrosh wrote:
>> And also why RAID1 and RAID4/5/6 need the data bounced. I wish VFS
>> would prevent data writing given a device queue flag that requests
>> it. So all these devices and modes could just flag the VFS/filesystems
>> that: "please don't allow concurrent writes, otherwise I need to copy data"
>>
>> >From what Chris Mason has said before, all the mechanics are there, and it's
>> what btrfs is doing. Though I don't know how myself?
> 
> The filesystems can do it themselves, they should have everything
> required.
> 
> Easiest way would be to not unlock page during the writeback, unmap
> mmaps before taking the checksum, and using vm_flags to prevent
> get_user_pages.
> 
> More complex and maybe more performant would be to avoid holding page
> lock but wait_on_page_writeback in page-modification (write, fault)
> paths. More complex again could opportunistically replace the page
> with a duplicate one and allow modification ops to continue from there.
> 
> That's all possible by overriding existing callbacks though. I don't
> think I would like to put branches and flag dependent locking all
> over existing functions.
> 

Thanks. I'll need to get to this soon enough when doing raid5/6.
At the exofs level at least. This is most valuable information.
I'll keep it in mind. (And I'll also need to do it at NFS which
will be a fight)

I agree that doing it clean at VFS level is match harder. But then
also duplicating code all over is also hard. As it stands RAID copies
data, and iscsi checksums are turned off by distros. And so will DIF.
I guess we need to leave room for the HW vendors, out there ;-)

Boaz
