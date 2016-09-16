From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: TRIM/UNMAP/DISCARD via ATA Passthrough
Date: Fri, 16 Sep 2016 11:53:35 -0400
Message-ID: <c2c154db-67fe-dcaa-a46a-48a53e15d1cf@gmail.com>
References: <CAHmME9q4TV4EVAK-4X8Fx9x_YYT3fh4zbtQgjnFR4ut7dTUUfA@mail.gmail.com>
 <yq1d1k6l43x.fsf@sermon.lab.mkp.net>
 <CAHmME9pX1sSdFLfsgBqunh=5ttmPg5-vAzvTEfD1Xt4NBk6JzA@mail.gmail.com>
 <yq1twdhb0zr.fsf@sermon.lab.mkp.net>
 <CAHmME9qq5vSC+hZckCystU6cdRPihO492U2B2-pozbwg=3_5nw@mail.gmail.com>
 <5af202ea-a632-28c2-515f-c361e27de5da@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34071 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757207AbcIPPyR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2016 11:54:17 -0400
In-Reply-To: <5af202ea-a632-28c2-515f-c361e27de5da@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On 2016-09-16 07:16, Hannes Reinecke wrote:
> On 09/15/2016 10:52 PM, Jason A. Donenfeld wrote:
>> Hi Martin,
>>
>> On Thu, Sep 15, 2016 at 6:07 PM, Martin K. Petersen
>>> But how do they signal that ATA passthrough is possible? Is there an ATA
>>> Information VPD page? Is REPORT SUPPORTED OPERATION CODES supported?
>>>
>>> We need really solid discovery data before we can entertain enabling
>>> something like this.
>>
>> `sg_opcodes` said invalid request, so I think there isn't REPORT
>> SUPPORTED OPERATION CODES, and `sg_vpd -p ai` came up illegal too.
>>
>> However, sg_sat_identify worked reliably, which means a solid way of
>> probing this would be to send IDENTIFY DEVICE ATA via SG_ATA_16 or
>> SG_ATA_12.
>>
>> Let me know and I can give you access to the hardware if you're curious.
>>
> Sadly, that's not sufficient.
> linux is not the only provider of an SATL (mpt3sas being the most
> prominent other one).
> And while they might support ATA_12/ATA_16, there is no indication that
> you can pass DSM TRIM that way.
So it's better to not support it at all than to support it on hardware 
we can reliably identify?

I get that having feature parity is a good thing, but the discussion 
isn't about providing support for all SATL devices, it's specifically 
about UAS connected SATL devices.  Last I checked, mpt3sas doesn't do 
anything with UAS, which means it's kind of irrelevant WRT supporting 
this for UAS devices.

It's pretty easy to tell that something is a UAS device (the uas driver 
wouldn't be bound to it otherwise), so if we check that and then check 
whether or not IDENTIFY DEVICE ATA works when sent via SG_ATA_16 or 
SG_ATA_12, it should be relatively safe (ignoring of course the fact 
that there will inevitably be some brain-dead hardware that for some 
obscure reason translates the command into something that will corrupt 
data).  I've got three USB 3.0 UAS SATA adapters (all ASMedia branded 
chips) that behave pretty much identically to what Jason is describing, 
so it appears that at least one brand behaves this way in a reliable and 
reproducible manner.
