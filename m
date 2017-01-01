From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Sun, 1 Jan 2017 10:30:02 -0500
Message-ID: <47d8bea2-4ef6-6392-d816-69315fec67b6@akamai.com>
References: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
 <20161229080250.GA11605@infradead.org>
 <1483226343.2518.32.camel@linux.vnet.ibm.com>
 <1483280506.5512.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483280506.5512.1.camel@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "hch@infradead.org" <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>, "suganath-prabu.subramani@broadcom.com" <suganath-prabu.subramani@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "davem@davemloft.net" <davem@davemloft.net>, "Sreekanth.Reddy@broadcom.com" <Sreekanth.Reddy@broadcom.com>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-scsi@vger.kernel.org



On 01/01/2017 09:22 AM, Bart Van Assche wrote:
> On Sat, 2016-12-31 at 15:19 -0800, James Bottomley wrote:
>> On Thu, 2016-12-29 at 00:02 -0800, Christoph Hellwig wrote:
>>> On Wed, Dec 28, 2016 at 11:30:24PM -0500, Jason Baron wrote:
>>>> Add a new parameter to scsi_internal_device_block() to decide 
>>>> whether or not to invoke scsi_wait_for_queuecommand().
>>> We'll also need to deal with the blk-mq wait path that Bart has been
>>> working on (I think it's already in the scsi tree, but I'd have to
>>> check).
>>>
>>> Also adding a bool flag for the last call in a function is style 
>>> that's a little annoying.
>>>
>>> I'd prefer to add a scsi_internal_device_block_nowait that contains
>>> all the code except for the waiting, and then make
>>> scsi_internal_device_block_nowait a wrapper around it.  Or drop the
>>> annoying internal for both while we're at it :)
>> OK, I know it's new year, but this is an unpatched regression in -rc1
>> that's causing serious issues.  I would like this fixed by -rc3 so we
>> have 3 options
>>
>>    1. revert all the queuecommand wait stuff until it proves it's actually
>>       working without regressions
>>    2. apply this patch and fix the style issues later
>>    3. someone else supplies the correctly styled fix patch
>>
>> The conservative in me says that 1. is probably the most correct thing
>> to do because it gives us time to get the queuecommand wait stuff
>> right; that's what I'll probably do if there's no movement next week. 
>>  However, since we're reasonably early in the -rc cycle, so either 2 or
>> 3 are viable provided no further regressions caused by the queuecommand
>> wait stuff pop up.
> Hello James,
>
> My recommendation is to revert commit 18f6084a989b ("scsi: mpt3sas: Fix
> secure erase premature termination"). Since the mpt3sas driver uses the
> single-queue approach and since the SCSI core unlocks the block layer
> request queue lock before the .queuecommand callback function is called,
> multiple threads can execute that callback function (scsih_qcmd() in this
> case) simultaneously. This means that using scsi_internal_device_block()
> from inside .queuecommand to serialize SCSI command execution is wrong.
>
> Bart.

Hi,

Yes, commit 18f6084a989b looked racy to me as well. I noted that
in a follow up to my patch, and a suggested a way of fixing it:
http://lkml.iu.edu/hypermail/linux/kernel/1612.3/01301.html

Also worth noting is that commit 18f6084a989b was backported
to at least 4.8 stable.

Thanks,

-Jason
