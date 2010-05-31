From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 31 May 2010 18:30:05 +0300
Message-ID: <4C03D5FD.3000202@panasas.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net> <1275318102.2823.47.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1275318102.2823.47.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 05/31/2010 06:01 PM, James Bottomley wrote:
> On Mon, 2010-05-31 at 10:20 -0400, Martin K. Petersen wrote:
>>>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
>>
>> Christof> Since the guard tags are created in Linux, it seems that the
>> Christof> data attached to the write request changes between the
>> Christof> generation in bio_integrity_generate and the call to
>> Christof> sd_prep_fn.
>>
>> Yep, known bug.  Page writeback locking is messed up for buffer_head
>> users.  The extNfs folks volunteered to look into this a while back but
>> I don't think they have found the time yet.
>>
>>
>> Christof> Using ext3 or ext4 instead of ext2 does not show the problem.
>>
>> Last I looked there were still code paths in ext3 and ext4 that
>> permitted pages to be changed during flight.  I guess you've just been
>> lucky.
> 
> Pages have always been modifiable in flight.  The OS guarantees they'll
> be rewritten, so the drivers can drop them if it detects the problem.
> This is identical to the iscsi checksum issue (iscsi adds a checksum
> because it doesn't trust TCP/IP and if the checksum is generated in
> software, there's time between generation and page transmission for the
> alteration to occur).  The solution in the iscsi case was not to
> complain if the page is still marked dirty.
> 

And also why RAID1 and RAID4/5/6 need the data bounced. I wish VFS
would prevent data writing given a device queue flag that requests
it. So all these devices and modes could just flag the VFS/filesystems
that: "please don't allow concurrent writes, otherwise I need to copy data"

>From what Chris Mason has said before, all the mechanics are there, and it's
what btrfs is doing. Though I don't know how myself?

> James
> 

Boaz
