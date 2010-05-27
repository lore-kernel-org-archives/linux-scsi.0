From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [BUG] Cannot boot any kernel after 2.6.27 if a 256 byte sector SCSI disk is attached
Date: Thu, 27 May 2010 11:49:57 -0400
Message-ID: <201005271149.57742.gene.heskett@gmail.com>
References: <4BFD69CA.5090308@compro.net> <4BFE8759.20604@compro.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BFE8759.20604@compro.net>
Sender: linux-kernel-owner@vger.kernel.org
To: markh@compro.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Mark Hounschell <dmarkh@cfl.rr.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 27 May 2010, Mark Hounschell wrote:
>On 05/26/2010 02:34 PM, Mark Hounschell wrote:
>> My application uses SCSI disks of 256, 512, 768, and 1024 sector sizes.
>> It uses the sg_io interface to talk to these devices. As of 2.6.27 if any
>> SCSI disk is attached that has been formatted with a 256 byte sector
>> size, the boot process hangs when it gets to the point of discovering USB
>> devices. 512, 768, and 1024 sector sizes do not seem to trigger this.
>>
>> I have bisected this problem to the following commit:
>>
>> # git bisect good
>> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
>> commit 427e59f09fdba387547106de7bab980b7fff77be
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date:   Sat Mar 8 18:24:17 2008 -0600
>>
>>     [SCSI] make use of the residue value
>>
>>     USB sometimes doesn't return an error but instead returns a residue
>>     value indicating part (or all) of the command wasn't completed.  So
>> if the driver _done() error processing indicates the command was fully
>> processed, subtract off the residue so that this USB error gets
>> propagated.
>>
>>     Cc: Alan Stern <stern@rowland.harvard.edu>
>>     Signed-off-by: James Bottomley
>> <James.Bottomley@HansenPartnership.com>
>>
>> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd
>>
>> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
>>
>> Now, what the hell USB has to do with my SCSI disks is beyond me. I have
>> a feeling that this commit is just uncovering another problem. I've
>> attached a dmesg from a working kernel and pointed out where the boot
>> hangs and my SCSI disk light is on solid. Once it turns on solid the only
>> recourse is to recycle power to the disk. The reset button does nothing
>> to it. In fact a second will not even see the device because it is out to
>> lunch. Not even a SCSI bus reset clears what ever has happened to the
>> disk.
>>
>> This does the same thing on a 2.6.34 kernel also. Anything I can do to
>> help, I'm available.
>>
>> Thanks and regards
>> Mark
>
>I've attached the output from a serial console while trying to boot the
>kernel with the above commit in. These disks have no partition table BTW.
>
>Thanks
>Mark
>
Humm, I wonder if this is why I'm getting the impression but no real failure 
messages that actually tell me something because we no longer (used to) 
support a 256 byte/sector floppy, in either physical size?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
BOFH excuse #149:

Dew on the telephone lines.
