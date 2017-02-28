From: Jens Axboe <axboe@kernel.dk>
Subject: Re: SCSI regression in 4.11
Date: Tue, 28 Feb 2017 10:31:58 -0700
Message-ID: <f675804f-84a6-6c91-bb67-8e44e5b94bd7@kernel.dk>
References: <20170227152955.1362aabb@xeon-e3>
 <20170227171931.30b9f619@xeon-e3> <20170228140812.GC20197@lst.de>
 <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
 <1488301573.3046.9.camel@linux.vnet.ibm.com>
 <20170228091607.724d1883@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35280 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdB1Rl3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 12:41:29 -0500
Received: by mail-it0-f52.google.com with SMTP id 203so83079816ith.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 09:40:45 -0800 (PST)
In-Reply-To: <20170228091607.724d1883@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org

On 02/28/2017 10:16 AM, Stephen Hemminger wrote:
> On Tue, 28 Feb 2017 09:06:13 -0800
> James Bottomley <jejb@linux.vnet.ibm.com> wrote:
> 
>> On Tue, 2017-02-28 at 08:32 -0700, Jens Axboe wrote:
>>> On 02/28/2017 07:08 AM, Christoph Hellwig wrote:  
>>>> On Mon, Feb 27, 2017 at 05:19:31PM -0800, Stephen Hemminger wrote:  
>>>>> Fixes: ee5242360424 ("scsi: zero per-cmd driver data before each
>>>>> I/O")
>>>>>
>>>>> but that is already in linux-next.
>>>>>
>>>>> Noticed another place where memset(of the data was being done not
>>>>> the extra bits.
>>>>> Tried this, but didn't fix it either...  
>>>>
>>>> Are you using blk-mq or the legacy request code?  
>>>
>>> Stephen doesn't have MQ set in the config he posted, I'm assuming he 
>>> didn't boot with scsi_mod.use_blk_mq=true. In a previous email, I 
>>> asked if turning on MQ makes a difference.  
>>
>> OK, since we're not making much progress, Stephen, could you insert
>> some debugging into the storvsc driver?  The trace clearly shows we're
>> getting zeros back in the buffer when we should have data from the
>> initial scan.  Firstly, does the vmbus think it's transferring any data
>> for the INQUIRY and READ_CAPACITY commands (looks like
>> storvsc_command_completion() data_transfer_length)?  If it does,
>> there's probably an issue initialising the sg list.  If it doesn't,
>> we're probably sending bogus commands.
>>
>> James
> 
> I tried booting with scsi_mod.use_blk_mq=true and that did nothing.
> Rebuilding now with 
> CONFIG_SCSI_MQ_DEFAULT=y

If you already booted with scsi_mod.use_blk_mq=true and tested that,
then don't bother with the config option. They basically toggle
the same switch.

> Sure, can instrument. after that test.

That'd be great!

-- 
Jens Axboe
