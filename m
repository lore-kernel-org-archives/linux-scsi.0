From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/5] Feature enhancements for ses module
Date: Thu, 23 Oct 2014 03:17:20 +0200
Message-ID: <54485720.1010609@interlog.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com> <C709E4D363AAB64590BFAC54D4C478AAEBC4ABA5@PRN-MBX02-4.TheFacebook.com> <54480181.1010001@fb.com> <54482F99.6070306@interlog.com> <C709E4D363AAB64590BFAC54D4C478AAEBC7D124@PRN-MBX02-4.TheFacebook.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50754 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaJWBRt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2014 21:17:49 -0400
In-Reply-To: <C709E4D363AAB64590BFAC54D4C478AAEBC7D124@PRN-MBX02-4.TheFacebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>

On 14-10-23 01:01 AM, Song Liu wrote:
> Hi Doug,
>
> I am not sure whether I fully understand the scenario. Actually patch 5 tries to clear all reserved bits:
>
> + dest_desc[0] = 0;
> + /* only clear byte 1 for ENCLOSURE_COMPONENT_DEVICE */
> + if (ecomp->type == ENCLOSURE_COMPONENT_DEVICE)
> +   dest_desc[1] = 0;
> + dest_desc[2] &= 0xde;
> + dest_desc[3] &= 0x3c;
>
> Would this work for device that rejects request with 1 in RESERVED areas?


That is a pretty asymmetric element type, assuming we are talking
about the "enclosure control" and "enclosure status" elements
(i.e. etc=0xe). My guess would be:

     dest_desc[0] = 0x80 | (src_desc[0] & 40);
     dest_desc[1] = 0x80 & src_desc[1];
     dest_desc[2] = (pc_req << 6) | pc_delay;
     dest_desc[3] = 0xff & src_desc[3];
or if you have a new power_off_duration:
     dest_desc[3] = (power_off_duration << 2) | (src_desc[3] & 0x3);

In byte 0 the top bit (SELECT) must be set or the enclosure
will ignore any other settings in that element. If the PRDFAIL
bit is already set, then that setting will be maintained.
SES-3 has a note about clearing DISABLE and SWAP.

In byte 1 is if the identifier (LED ?) is active (saying blinking)
prior to this power cycle request, then it will stay blinking
until the power drops. If the enclosure was really clever it might
keep blinking after the power cycle :-)

Also notice that the requested power cycle can be cancelled
up to the "time until power cycle" drops to zero.

>> -----Original Message-----
>> From: Douglas Gilbert [mailto:dgilbert@interlog.com]
>> Sent: Wednesday, October 22, 2014 3:29 PM
>> To: Jens Axboe; Song Liu; linux-scsi@vger.kernel.org
>> Cc: Hannes Reinecke; Dan Williams; Christoph Hellwig
>> Subject: Re: [PATCH 0/5] Feature enhancements for ses module
>>
>> On 14-10-22 09:12 PM, Jens Axboe wrote:
>>> On 08/25/2014 11:34 AM, Song Liu wrote:
>>>> From: Song Liu [mailto:songliubraving@fb.com]
>>>> Sent: Monday, August 25, 2014 10:26 AM
>>>> To: Song Liu
>>>> Subject: [PATCH 0/5] Feature enhancements for ses module
>>>>
>>>> These patches include a few enhancements to ses module:
>>>>
>>>> 1: close potential race condition by at enclosure race condition
>>>>
>>>> 2,3,4: add enclosure id and device slot, so we can create symlink
>>>>          in /dev/disk/by-slot:
>>>>     # ls -d /dev/disk/by-slot/*
>>>>       /dev/disk/by-slot/enclosure-0x5000ae41fc1310ff-slot0
>>>>
>>>> 5: add ability to power on/off device with power_status file in
>>>>      sysfs.
>>
>> Had a rude awakening with sg_ses recently when setting a field in the
>> enclosure control dpage. That is what is being done in point 5: above.
>>
>> The time honoured technique is to read the corresponding enclosure status
>> dpage, find the correct element, twiddle the field of interest, set the SELECT bit
>> and write it back. The idea is maintain any other field settings in that element.
>> And this is what the ses module does.
>>
>> There is at least one SES device out there that rejects the write if there are bits
>> set in RESERVED locations. According to SPC-4 a device may do that. Look at
>> the status (read) and control (write) variants of each element type: many times
>> the control variant has less fields.
>>
>> To fix that the read-modify-write cycle needs to be changed to a read-mask-
>> modify-write cycle where the "mask" is the allowable write mask (there would
>> be one for each element type).
>>
>> This is ugly and may create problems in the future if and when
>> T10 adds a new field in an element. About that time T10 should think about
>> refining the meaning of RESERVED in SES to outlaw SES devices creating this
>> particular time waster.
>>
>> Doug Gilbert
>>
>>>> Dan Williams (4):
>>>>     SES: close potential registration race
>>>>     SES: generate KOBJ_CHANGE on enclosure attach
>>>>     SES: add enclosure logical id
>>>>     SES: add reliable slot attribute
>>>>
>>>> Song Liu (1):
>>>>     SES: Add power_status to SES enclosure component
>>>
>>> Guys, where are we with these? Seemed like they got reviewed (and
>>> updates/fixes posted), then nothing else happened. Would be nice to
>>> get these upstream, so we don't have to carry them at FB.
>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

