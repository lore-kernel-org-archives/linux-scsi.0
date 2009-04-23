From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Thu, 23 Apr 2009 12:43:04 +0200
Message-ID: <20090423104304.GV4593@kernel.dk>
References: <20090422090929.GA14928@havoc.gtf.org> <49EEE225.3010700@garzik.org> <20090423063542.GK4593@kernel.dk> <49F0456B.2050502@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:57477 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZDWKnF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 06:43:05 -0400
Content-Disposition: inline
In-Reply-To: <49F0456B.2050502@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>

On Thu, Apr 23 2009, Jeff Garzik wrote:
> Jens Axboe wrote:
>> On Wed, Apr 22 2009, Jeff Garzik wrote:
>>> Jeff Garzik wrote:
>>>> Currently, libata creates a Scsi_Host per port.  This was originally
>>>> done to leverage SCSI's infrastructure to arbitrate among master/slave
>>>> devices, but is not needed for most modern SATA controllers.   And I
>>>> _think_ it is not needed for master/slave if done properly, either.
>>> BTW note the above, with regards to the libata SCSI->block 
>>> conversion.  libata currently relies on SCSI for some amount of 
>>> generic device  arbitration, in several situations (see ->qc_defer,   
>>> SCSI_MLQUEUE_.*_BUSY).  libata expects SCSI to be intelligent and not 
>>>  starve devices, etc.
>>
>> Defer looks like internal policy, I don't see that functioning any
>> different in the block layer. SCSI_MLQUEUE_*_BUSY in SCSI is primarily
>> using the block layer functionality of BLKPREP_DEFER to begin with, so I
>> think we're pretty close to providing all that already.
>
> It's not quite that simple.  I am referring mainly to arbitration across  
> multiple request_queue's.  SCSI has useful code in place to deal with  
> target-busy and host-busy conditions, both of which could potentially be  
> blocking and unblocking multiple request queues.
>
> mlqueue is much more than just a wrapper over block requeueing  
> functions.  Read scsi_next_command() and scsi_run_queue(), and grep for  
> starved_list, host_{busy,blocked}, target_{busy,blocked},  
> device_{busy,blocked}.
>
> In our master/slave case, we must choose between queue A and queue B,  
> making sure to starve neither.  For simplex DMA, we potentially have  
> queues A, B, C and D serving requests across the "bus bottleneck," and  
> must ensure no starvation of A, B, C or D.
>
>
> Although I have no code to back this up, my gut feeling is that a  
> "request queue group" object, with associated functions, that would be  
> the appropriate place for cross-queue or "host-wide" (as in, struct  
> Scsi_Host or struct ata_host) functionality.
>
> Whatever the solution, libata definitely makes use of SCSI's  
> cross-request_queue arbitration, so any move to block will require  
> similar functionality.

Agree, I think we discussed this many years ago as well. I guess a
request queue grouping with fair arbitration would suffice. If you need
to defer for a device beyond that, a simple BLKPREP_DEFER would just
postpone service until the next round. Probably allow both "skip until
next round", or "defer the entire group, service me again next time
first".

-- 
Jens Axboe

