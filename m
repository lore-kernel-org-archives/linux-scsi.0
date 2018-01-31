From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: implement IMMED bit
Date: Wed, 31 Jan 2018 17:40:22 -0500
Message-ID: <68ee8bca-c5ea-0cc1-d990-2537532d3717@interlog.com>
References: <20180130055445.20244-1-dgilbert@interlog.com>
 <ed3a63f0-2cbb-8fac-fee7-4f08b1e1e8e2@wdc.com>
 <a59aa2e7-fa26-6e24-9e79-5a14307fb49a@interlog.com>
 <1517436314.7325.6.camel@wdc.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34078 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbeAaWk3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 17:40:29 -0500
In-Reply-To: <1517436314.7325.6.camel@wdc.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On 2018-01-31 05:05 PM, Bart Van Assche wrote:
> On Wed, 2018-01-31 at 15:26 -0500, Douglas Gilbert wrote:
>> On 2018-01-31 12:06 PM, Bart Van Assche wrote:
>>> On 01/29/18 21:54, Douglas Gilbert wrote:
>>>> +static const struct opcode_info_t sync_cache_iarr[] = {
>>>> +    {0, 0x91, 0, F_LONG_DELAY | F_M_ACCESS, resp_sync_cache, NULL,
>>>> +        {16,  0x7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>>>
>>>                     ^^^
>>> Can you clarify the choice of "0x7" in the above? After having had a look at
>>> SBC-4 I was expecting 0x2 (the mask for the IMMED bit) since all other bits in
>>> that command byte are either reserved or obsolete.
>>
>> As a general rule when you see "obsolete" that means that field was used
>> in an earlier standard (bit 0 was RELADDR and bit 2 was SYNC_NV). So
>> application clients complying with earlier versions of SBC might set those
>> bits. If they are set and the mask is being enforced I choose to not fail
>> the command as an illegal request. Basically accept and ignore.
> 
> I agree with setting bits for obsolete flags. The reason I was asking about that
> mask is because I found the following in SBC-4 for byte 1 of SYNCHRONIZE CACHE(16):
> * Bits 7..3: reserved.
> * Bit 2: obsolete.
> * Bit 1: IMMED.
> * Bit 0: reserved.

I did see the discrepancy between byte 1 bit 0 in SYNCHRONIZE CACHE(10)
where it is "obsolete" and SYNCHRONIZE CACHE(16) where it is "reserved"
initially thinking it might be a typo. So I went for the more permissive.
I'm now guessing (because I don't have the drafts between SBC(-1) and
SBC-2 and for some reason T10 wants you to be a member to download older
drafts) that RELADDR was removed before SYNCHRONIZE CACHE(16) was added
(as there was no 64 LBA support in SBC-1). So if there never was a
publicly available draft where SYNCHRONIZE CACHE(16) had a RELADDR bit
defined, then why mark it as obsolete? Reserved means a later
draft/standard may use that bit/field.

BTW There is no requirement for a device server to enforce the mask and
most don't (from my testing). The mask is provided as an aid to the
application client and is required by the implementation of REPORT
SUPPORTED OPERATION CODES which is why I have it in scsi_debug. By default
the scsi_debug driver does not enforce the mask (but does when strict=1).

Anyway, aren't we splitting hairs here? Does this really justify a new
patch being rolled?

Doug Gilbert

>>>> -    return 0;
>>>> +    return (cmd[1] & 0x1) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */
>>>
>>> Shouldn't the mask 0x2 be used to check for the IMMED bit?
>>
>> That comment needs a little more context:
> 
> Sorry, I confused byte 1 of the START STOP command with that of the SYNCHRONIZE
> CACHE command so please ignore the above comment.
> 
> Bart.
> 
