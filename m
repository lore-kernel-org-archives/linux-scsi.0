From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 6/6] scsi_scan: Fixup scsilun_to_int()
Date: Tue, 10 Jun 2014 10:55:40 -0400
Message-ID: <53971C6C.6060601@interlog.com>
References: <1401785937-43581-1-git-send-email-hare@suse.de>	 <1401785937-43581-7-git-send-email-hare@suse.de> <5396EE0C.3070108@acm.org> <1402409172.2185.3.camel@dabdike.int.hansenpartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55032 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbaFJOzy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 10:55:54 -0400
In-Reply-To: <1402409172.2185.3.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "bvanassche@acm.org" <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "emilne@redhat.com" <emilne@redhat.com>, "hare@suse.de" <hare@suse.de>

On 14-06-10 10:06 AM, James Bottomley wrote:
> On Tue, 2014-06-10 at 13:37 +0200, Bart Van Assche wrote:
>> On 06/03/14 10:58, Hannes Reinecke wrote:
>>> + *     Given a struct scsi_lun of: d2 04 0b 03 00 00 00 00, this function
>>> + *     returns the integer: 0x0b03d204
>>> + *
>>> + *     This encoding will return a standard integer LUN for LUNs smaller
>>> + *     than 256, which typically use a single level LUN structure with
>>> + *     addressing method 0.
>>>    **/
>>>   u64 scsilun_to_int(struct scsi_lun *scsilun)
>>>   {
>>> @@ -1279,7 +1280,7 @@ u64 scsilun_to_int(struct scsi_lun *scsilun)
>>>
>>>   	lun = 0;
>>>   	for (i = 0; i < sizeof(lun); i += 2)
>>> -		lun = lun | (((scsilun->scsi_lun[i] << 8) |
>>> +		lun = lun | (((scsilun->scsi_lun[i] << ((i + 1) *8)) |
>>>   			      scsilun->scsi_lun[i + 1]) << (i * 8));
>>>   	return lun;
>>>   }
>>
>> The above code doesn't match the comment header. Parentheses have been
>> placed such that each byte with an even index is shifted left (2*i+1)*8
>> bits instead of (i+1)*8.
>
> I don't see that in the code, which parentheses do you mean?

For sizeof(int)==4 then
   unsigned char << 32
   unsigned char << 40
<etc>
does _not_ give a 64 bit quantity. It is undefined but seems to
wrap on a 32 bit unsigned int (i.e. 32 bits). One solution: the
left argument to "<<" needs to be a 64 bit quantity
(e.g. uint64_t).

Get sg_luns (from sg3_utils version 1.36 or later) and try this
hierarchical LUN:
   sg_luns -t 0105020603070408
Decoded LUN:
   Peripheral device addressing: bus_id=1, target=5
   >>Second level addressing:
     Peripheral device addressing: bus_id=2, target=6
   >>Third level addressing:
     Peripheral device addressing: bus_id=3, target=7
   >>Fourth level addressing:
     Peripheral device addressing: bus_id=4, target=8

Now ask for a Linux integer translation (in hex) using the
first function I showed in my previous post:
   sg_luns -t 0105020603070408L -H
Linux 'word flipped' integer LUN representation: 0x408030702060105
Decoded LUN:
<same as before>

As expected.

Now ask for a Linux integer translation (in hex) using the
second function (that Bart is objecting to):
   $ sg_luns -t 0105020603070408W -H
64 bit LUN in T10 preferred (hex) format:  01 05 02 06 03 07 04 08
Linux internal 64 bit LUN representation: 0x60e0307
Decoded LUN:
<same as before>

The undocumented "W" suffix calls sg_luns' t10_2linux_lun64bitBR()
function. That function never sets any bits between bit 32 and 63.

Doug Gilbert





