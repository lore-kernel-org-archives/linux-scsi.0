From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 10:24:42 -0400
Message-ID: <4862552A.5010900@gmail.com>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:26161 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYFYOYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2008 10:24:08 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1108952waf.23
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 07:24:08 -0700 (PDT)
In-Reply-To: <20080625134705.GZ20851@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Thu, Jun 19 2008, Matthew Wilcox wrote:
>   
>> Use the noop elevator by default for drives that do not spin
>>
>> [Not for applying]
>>
>> SSDs do not benefit from the elevator.  It just wastes precious CPU cycles.
>> By selecting the noop elevator by default, we can shave a few microseconds
>> off each IO.
>>
>> I've brazenly stolen sd_vpd_inquiry from mkp's patch here:
>>
>> http://marc.info/?l=linux-scsi&m=121264354724277&w=2
>>
>> No need to have two copies of that ... but this will conflict with his code.
>>
>> On to the self-criticism:
>>
>> I don't intend the final version of this patch to include a printk for
>> the RPM or even a printk to say we switched IO elevator.  I think we're
>> too verbose in SCSI as it is.
>>
>> I think there's an opportunity to improve sd_vpd_inquiry() to remove
>> some of the duplicate code between sd_set_elevator() and sd_block_limits,
>> but it's not terribly important.
>>
>> The switching of the elevators isn't particularly nice.  I assume that
>> elevator_init("noop") cannot fail, which isn't true.  It would be nice
>> to use the #if 0 block instead, but that causes a null ptr dereference
>> inside sysfs -- I suspect something isn't set up correctly.
>>     
>
> I disagree with this approach. For now, lets just add a queue flag that
> says the device doesn't have a seek penalty and let the io schedulers do
> what they need to avoid that (it'd be a one-liner change to cfq and as).
> There's more to io scheduling than just seek reduction, so this is the
> wrong direction to take imo.
>
>   
Very true - you still will get a significant win by coalescing IO's (say 
for example, to do larger, aligned writes to flash devices).

ric


