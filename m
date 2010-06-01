From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 13:49:55 +0300
Message-ID: <4C04E5D3.8000709@panasas.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <yq1iq64kv9f.fsf@sermon.lab.mkp.net> <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com> <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:6700 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755604Ab0FAKt7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 06:49:59 -0400
In-Reply-To: <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On 06/01/2010 01:30 PM, Christof Schmitt wrote:
> On Mon, May 31, 2010 at 06:30:05PM +0300, Boaz Harrosh wrote:
>> On 05/31/2010 06:01 PM, James Bottomley wrote:
>>> On Mon, 2010-05-31 at 10:20 -0400, Martin K. Petersen wrote:
>>>>>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
>>>>
>>>> Christof> Since the guard tags are created in Linux, it seems that the
>>>> Christof> data attached to the write request changes between the
>>>> Christof> generation in bio_integrity_generate and the call to
>>>> Christof> sd_prep_fn.
>>>>
>>>> Yep, known bug.  Page writeback locking is messed up for buffer_head
>>>> users.  The extNfs folks volunteered to look into this a while back but
>>>> I don't think they have found the time yet.
>>>>
>>>>
>>>> Christof> Using ext3 or ext4 instead of ext2 does not show the problem.
>>>>
>>>> Last I looked there were still code paths in ext3 and ext4 that
>>>> permitted pages to be changed during flight.  I guess you've just been
>>>> lucky.
>>>
>>> Pages have always been modifiable in flight.  The OS guarantees they'll
>>> be rewritten, so the drivers can drop them if it detects the problem.
>>> This is identical to the iscsi checksum issue (iscsi adds a checksum
>>> because it doesn't trust TCP/IP and if the checksum is generated in
>>> software, there's time between generation and page transmission for the
>>> alteration to occur).  The solution in the iscsi case was not to
>>> complain if the page is still marked dirty.
>>>
>>
>> And also why RAID1 and RAID4/5/6 need the data bounced. I wish VFS
>> would prevent data writing given a device queue flag that requests
>> it. So all these devices and modes could just flag the VFS/filesystems
>> that: "please don't allow concurrent writes, otherwise I need to copy data"
>>
>> From what Chris Mason has said before, all the mechanics are there, and it's
>> what btrfs is doing. Though I don't know how myself?
> 
> I also tested with btrfs and invalid guard tags in writes have been
> encountered as well (again in 2.6.34). The only difference is that no
> error was reported to userspace, although this might be a
> configuration issue.
> 

I think in btrfs you need a raid1/5 multi-device configuration for this
to work. If you use a single device then it is just like ext4.

BTW: you could use DM or MD and it will guard your DIF by coping the
data before IO. 

> What is the best strategy to continue with the invalid guard tags on
> write requests? Should this be fixed in the filesystems?
> 
> Another idea would be to pass invalid guard tags on write requests
> down to the hardware, expect an "invalid guard tag" error and report
> it to the block layer where a new checksum is generated and the
> request is issued again. Basically implement a retry through the whole
> I/O stack. But this also sounds complicated.
> 

I suggest we should talk about this issue in upcoming LSF, because it does
not only affects DIF but any checksum subsystem. And it could enhance Linux
raid performance.

> --
> Christof Schmitt

Boaz
