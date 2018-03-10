From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: resolve COMMAND_SIZE at compile time
Date: Sat, 10 Mar 2018 16:16:45 -0500
Message-ID: <ef5dc446-b60f-662a-678b-786088526458@interlog.com>
References: <20180309232933.14e39858@heffalump.sk2.org>
 <20180309223355.21222-1-steve@sk2.org> <1520635631.2907.16.camel@wdc.com>
 <20180310142930.0692200b@heffalump.sk2.org>
 <1520714957.4495.5.camel@linux.vnet.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520714957.4495.5.camel@linux.vnet.ibm.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Stephen Kitt <steve@sk2.org>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-scsi@vger.kernel.org

On 2018-03-10 03:49 PM, James Bottomley wrote:
> On Sat, 2018-03-10 at 14:29 +0100, Stephen Kitt wrote:
>> Hi Bart,
>>
>> On Fri, 9 Mar 2018 22:47:12 +0000, Bart Van Assche <Bart.VanAssche@wd
>> c.com>
>> wrote:
>>>
>>> On Fri, 2018-03-09 at 23:33 +0100, Stephen Kitt wrote:
>>>>
>>>> +/*
>>>> + * SCSI command sizes are as follows, in bytes, for fixed size
>>>> commands,
>>>> per
>>>> + * group: 6, 10, 10, 12, 16, 12, 10, 10. The top three bits of
>>>> an opcode
>>>> + * determine its group.
>>>> + * The size table is encoded into a 32-bit value by subtracting
>>>> each
>>>> value
>>>> + * from 16, resulting in a value of 1715488362
>>>> + * (6 << 28 + 6 << 24 + 4 << 20 + 0 << 16 + 4 << 12 + 6 << 8 + 6
>>>> << 4 +
>>>> 10).
>>>> + * Command group 3 is reserved and should never be used.
>>>> + */
>>>> +#define COMMAND_SIZE(opcode) \
>>>> +	(16 - (15 & (1715488362 >> (4 * (((opcode) >> 5) &
>>>> 7)))))
>>>
>>> To me this seems hard to read and hard to verify. Could this have
>>> been
>>> written as a combination of ternary expressions, e.g. using a gcc
>>> statement
>>> expression to ensure that opcode is evaluated once?
>>
>> That’s what I’d tried initially, e.g.
>>
>> #define COMMAND_SIZE(opcode) ({ \
>> int index = ((opcode) >> 5) & 7; \
>> index == 0 ? 6 : (index == 4 ? 16 : index == 3 || index == 5 ? 12 :
>> 10); \
>> })
>>
>> But gcc still reckons that results in a VLA, defeating the initial
>> purpose of
>> the exercise.
>>
>> Does it help if I make the magic value construction clearer?
>>
>> #define SCSI_COMMAND_SIZE_TBL (	\
>> 	   (16 -  6)		\
>> 	+ ((16 - 10) <<  4)	\
>> 	+ ((16 - 10) <<  8)	\
>> 	+ ((16 - 12) << 12)	\
>> 	+ ((16 - 16) << 16)	\
>> 	+ ((16 - 12) << 20)	\
>> 	+ ((16 - 10) << 24)	\
>> 	+ ((16 - 10) << 28))
>>
>> #define COMMAND_SIZE(opcode)						
>> \
>>    (16 - (15 & (SCSI_COMMAND_SIZE_TBL >> (4 * (((opcode) >> 5) &
>> 7)))))
> 
> Couldn't we do the less clever thing of making the array a static const
> and moving it to a header?  That way the compiler should be able to
> work it out at compile time.

And maybe add a comment that as of now (SPC-5 rev 19), COMMAND_SIZE is not
valid for opcodes 0x7e and 0x7f plus everything above and including 0xc0.
The latter ones are vendor specific and are loosely constrained, probably
all even numbered lengths in the closed range: [6,260].


If the SCSI command sets want to keep up with NVMe, they may want to think
about how they can gainfully use cdb_s that are > 64 bytes long. WRITE
SCATTERED got into SBC-4 but READ GATHERED didn't, due to lack of interest.
The READ GATHERED proposed was a bidi command, but it could have been a
a simpler data-in command with a looong cdb (holding LBA, number_of_blocks
pairs).

Doug Gilbert
