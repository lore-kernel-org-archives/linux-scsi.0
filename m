From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 10:08:12 -0500
Message-ID: <45C0B0DC.8030501@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com> <45BFF3D6.9050605@rtr.ca> <45C00AEE.1090708@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C00AEE.1090708@emc.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: "Eric D. Mudama" <edmudama@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

Ric Wheeler wrote:
> Mark Lord wrote:
>> Eric D. Mudama wrote:
>>> Actually, it's possibly worse, since each failure in libata will 
>>> generate 3-4 retries. 

(note: libata does *not* generate retries for medium errors;
 the looping is driven by the SCSI mid-layer code).

>> It really beats the alternative of a forced reboot
>> due to, say, superblock I/O failing because it happened
>> to get merged with an unrelated I/O which then failed..
>> Etc..
>>
>> Definitely an improvement.
>>
>> The number of retries is an entirely separate issue.
>> If we really care about it, then we should fix SD_MAX_RETRIES.
>>
>> The current value of 5 is *way* too high.  It should be zero or one.
..
> I think that drives retry enough, we should leave retry at zero for 
> normal (non-removable) drives. Should this  be a policy we can set like 
> we do with NCQ queue depth via /sys ?

Or perhaps we could have the mid-layer always "early-exit"
without retries for "MEDIUM_ERROR", and still do retries for the rest.

When libata reports a MEDIUM_ERROR to us, we *know* it's non-recoverable,
as the drive itself has already done internal retries (libata uses the
"with retry" ATA opcodes for this).

But meanwhile, we still have the original issue too, where a single stray
bad sector can blow a system out of the water, because the mid-layer
currently aborts everything after it from a large merged request.

Thus the original patch from this thread.  :)

Cheers
