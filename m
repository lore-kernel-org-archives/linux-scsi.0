From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: blk_iopoll_enabled
Date: Thu, 13 Mar 2014 20:48:50 +0200
Message-ID: <5321FD92.6020700@dev.mellanox.co.il>
References: <53209ACB.2080708@dev.mellanox.co.il> <532128AB.6010803@kernel.dk> <5321CFF0.8020209@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53755 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaCMSsy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2014 14:48:54 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so595428eek.24
        for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2014 11:48:52 -0700 (PDT)
In-Reply-To: <5321CFF0.8020209@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 3/13/2014 5:34 PM, Jens Axboe wrote:
> On 03/12/2014 09:40 PM, Jens Axboe wrote:
>> On 2014-03-12 11:35, Sagi Grimberg wrote:
>>> Hey Jens,
>>>
>>> So I'm looking at blk_iopoll for iSER & SRP and I have one gap I would
>>> like to get your input on.
>>>
>>> In blk-iopoll.c I see:
>>> int blk_iopoll_enabled = 1;
>>> EXPORT_SYMBOL(blk_iopoll_enabled);
>>>
>>> This is set to 1 and exported for everyone to condition and *modify* 
>>> it.
>>> The documentation says the user must check this when using blk_iopoll.
>>>
>>> My question is why? it should always be true shouldn't it?
>>> Moreover, isn't it better to protect it using a get() function of it?
>>> can't someone set it to 0 and shutdown the lights on everyone else?
>>
>> We can kill it. IIRC, it was mostly used during development to test
>> functionality and performance (and wired to a sysfs toggle file).
>>
>> But... Just because it's exported doesn't mean that random users are
>> allowed to just disable it. What's left now is an always-on, so we can
>> remove it.
>
> It _is_ still exported, I just forgot it was put in sysctl. I'll kill 
> it off completely now. It's safe to toggle from user space, but only 
> practically so if IO is idle. It makes no attempt to ensure that, as 
> it was just a debug thing.
>

Thanks

Sagi.
