From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in
 ses_enclosure_data_process()
Date: Tue, 21 May 2019 13:23:22 -0400
Message-ID: <375352c8-8400-35df-4db9-5e72543012fc@redhat.com>
References: <20190501180535.26718-1-longman@redhat.com>
 <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
 <1558363938.3742.1.camel@linux.ibm.com>
 <3385cf54-7b6c-3f28-e037-f0d4037368eb@redhat.com>
 <1558367212.3742.10.camel@linux.ibm.com>
 <8080a1ae-027e-ecdb-d8f1-5786a6b8853b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8080a1ae-027e-ecdb-d8f1-5786a6b8853b@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/20/19 11:56 AM, Waiman Long wrote:
> On 5/20/19 11:46 AM, James Bottomley wrote:
>> On Mon, 2019-05-20 at 11:24 -0400, Waiman Long wrote:
>>> On 5/20/19 10:52 AM, James Bottomley wrote:
>>>> On Mon, 2019-05-20 at 10:41 -0400, Waiman Long wrote:
>>>> [...]
>>>>>> --- a/drivers/scsi/ses.c
>>>>>> +++ b/drivers/scsi/ses.c
>>>>>> @@ -605,9 +605,14 @@ static void
>>>>>> ses_enclosure_data_process(struct
>>>>>> enclosure_device *edev,
>>>>>>  			     /* these elements are optional */
>>>>>>  			     type_ptr[0] ==
>>>>>> ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
>>>>>>  			     type_ptr[0] ==
>>>>>> ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
>>>>>> -			     type_ptr[0] ==
>>>>>> ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
>>>>>> +			     type_ptr[0] ==
>>>>>> ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS)) {
>>>>>>  				addl_desc_ptr +=
>>>>>> addl_desc_ptr[1]
>>>>>> + 2;
>>>>>>  
>>>>>> +				/* Ensure no out-of-bounds
>>>>>> memory
>>>>>> access */
>>>>>> +				if (addl_desc_ptr >= ses_dev-
>>>>>>> page10 +
>>>>>> +						     ses_dev-
>>>>>>> page10_len)
>>>>>> +					addl_desc_ptr = NULL;
>>>>>> +			}
>>>>>>  		}
>>>>>>  	}
>>>>>>  	kfree(buf);
>>>>> Ping! Any comment on this patch.
>>>> The update looks fine to me:
>>>>
>>>> Reviewed-by: James E.J. Bottomley <jejb@linux.ibm.com>
>>>>
>>>> It might also be interesting to find out how the proliant is
>>>> structuring this descriptor array to precipitate the out of bounds:
>>>> Is it just an off by one or something more serious?
>>> I didn't look into the detail the enclosure message returned by the
>>> hardware, but I believe it may have more description entries (page7)
>>> than extended description entries (page10).
>>>
>>> I can try to reserve the system and find out what exactly is wrong
>>> with that system if you really want to find that out.
>> Please.  What I'm interested in is whether this is simply a bug in the
>> array firmware, in which case the fix is sufficient, or whether there's
>> some problem with the parser, like mismatched expectations over added
>> trailing nulls or something.
>>
>> James
>>
> OK, will let you know once I get hold of the system.

I now have access to the xl450 system that can reproduce the error.  12
enclosure messages are processed during bootup. Of the one that causes
the KASAN warning, the byte dump of page 1 and 10 are:

[   28.185749] ses page 10 (len = 1200):
[   28.185762] a-0000: 0a 00 04 ac 00 00 00 00 16 22 00 00 01 01 00 01
[   28.185768] a-0010: 00 00 00 01 50 01 43 80 33 d4 45 bd 50 01 43 80
[   28.185774] a-0020: 33 d4 45 80 00 00 00 00 00 00 00 00 16 22 00 01
[   28.185779] a-0030: 01 01 00 02 00 00 00 01 50 01 43 80 33 d4 45 bd
[   28.185785] a-0040: 50 01 43 80 33 d4 45 81 00 00 00 00 00 00 00 00
[   28.185790] a-0050: 96 22 00 02 01 01 00 03 00 00 00 00 00 00 00 00
[   28.185794] a-0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185798] a-0070: 00 00 00 00 96 22 00 03 01 01 00 04 00 00 00 00
[   28.185801] a-0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185805] a-0090: 00 00 00 00 00 00 00 00 96 22 00 04 01 01 00 05
[   28.185808] a-00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185812] a-00b0: 00 00 00 00 00 00 00 00 00 00 00 00 96 22 00 05
[   28.185815] a-00c0: 01 01 00 06 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185818] a-00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185822] a-00e0: 96 22 00 06 01 01 00 07 00 00 00 00 00 00 00 00
[   28.185825] a-00f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185829] a-0100: 00 00 00 00 96 22 00 07 01 01 00 08 00 00 00 00
[   28.185832] a-0110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185836] a-0120: 00 00 00 00 00 00 00 00 96 22 00 08 01 01 00 09
[   28.185839] a-0130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185843] a-0140: 00 00 00 00 00 00 00 00 00 00 00 00 96 22 00 09
[   28.185846] a-0150: 01 01 00 0a 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185850] a-0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185853] a-0170: 96 22 00 0a 01 01 00 0b 00 00 00 00 00 00 00 00
[   28.185857] a-0180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185860] a-0190: 00 00 00 00 96 22 00 0b 01 01 00 0c 00 00 00 00
[   28.185864] a-01a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185867] a-01b0: 00 00 00 00 00 00 00 00 96 22 00 0c 01 01 00 0d
[   28.185871] a-01c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185874] a-01d0: 00 00 00 00 00 00 00 00 00 00 00 00 96 22 00 0d
[   28.185877] a-01e0: 01 01 00 0e 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185881] a-01f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185884] a-0200: 96 22 00 0e 01 01 00 0f 00 00 00 00 00 00 00 00
[   28.185888] a-0210: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185891] a-0220: 00 00 00 00 96 22 00 0f 01 01 00 10 00 00 00 00
[   28.185895] a-0230: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185898] a-0240: 00 00 00 00 00 00 00 00 96 22 00 10 01 01 00 11
[   28.185902] a-0250: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185905] a-0260: 00 00 00 00 00 00 00 00 00 00 00 00 96 22 00 11
[   28.185909] a-0270: 01 01 00 12 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185912] a-0280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185916] a-0290: 96 22 00 12 01 01 00 13 00 00 00 00 00 00 00 00
[   28.185919] a-02a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185923] a-02b0: 00 00 00 00 96 22 00 13 01 01 00 14 00 00 00 00
[   28.185926] a-02c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185930] a-02d0: 00 00 00 00 00 00 00 00 96 22 00 14 01 01 00 15
[   28.185933] a-02e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185937] a-02f0: 00 00 00 00 00 00 00 00 00 00 00 00 96 22 00 15
[   28.185940] a-0300: 01 01 00 16 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185944] a-0310: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185947] a-0320: 96 22 00 16 01 01 00 17 00 00 00 00 00 00 00 00
[   28.185951] a-0330: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185954] a-0340: 00 00 00 00 96 22 00 17 01 01 00 18 00 00 00 00
[   28.185958] a-0350: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185961] a-0360: 00 00 00 00 00 00 00 00 96 22 00 18 01 01 00 19
[   28.185965] a-0370: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185968] a-0380: 00 00 00 00 00 00 00 00 00 00 00 00 96 22 00 19
[   28.185972] a-0390: 01 01 00 1a 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185975] a-03a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185979] a-03b0: 96 22 00 1a 01 01 00 1b 00 00 00 00 00 00 00 00
[   28.185982] a-03c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185986] a-03d0: 00 00 00 00 96 22 00 1b 01 01 00 1c 00 00 00 00
[   28.185989] a-03e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185993] a-03f0: 00 00 00 00 00 00 00 00 96 22 00 1c 01 01 00 1d
[   28.185996] a-0400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.185999] a-0410: 00 00 00 00 00 00 00 00 00 00 00 00 96 22 00 1d
[   28.186023] a-0420: 01 01 00 1e 00 00 00 00 00 00 00 00 00 00 00 00
[   28.186026] a-0430: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   28.186030] a-0440: 16 6e 00 47 30 40 00 00 50 01 43 80 33 d4 45 bd
[   28.186034] a-0450: 49 01 4a 02 4b 03 4c 04 4d 05 4e 06 4f 07 50 08
[   28.186038] a-0460: 51 09 52 0a 53 0b 54 0c 55 0d 56 0e 57 0f 58 10
[   28.186041] a-0470: 59 11 5a 12 5b 13 5c 14 5d 15 5e 16 5f 17 60 18
[   28.186045] a-0480: 61 19 62 1a 63 1b 64 1c 65 1d 66 1e ff ff ff ff
[   28.186048] a-0490: 68 ff 69 ff 6a ff 6b ff 6c ff 6d ff 6e ff 6f ff
[   28.186052] a-04a0: 71 ff 72 ff 73 ff 74 ff 75 ff 76 ff 77 ff 78 ff
[   28.188282] ses page 1 (len = 36):
[   28.188290] 1-0000: 17 1e 00 0c 04 03 00 14 89 1e 00 18 07 01 00 0c
[   28.188298] 1-0010: 0e 01 00 10 18 01 00 0c 19 1e 00 14 19 08 00 20
[   28.188302] 1-0020: 19 08 00 20

Page 7 can't be retrieved for this message.

Please let me know what else do you want to have.

Cheers,
Longman
