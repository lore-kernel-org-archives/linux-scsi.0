From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Thu, 1 Nov 2018 12:13:06 +0100
Message-ID: <4dbfc5c0-e824-0186-03df-0e235b3901f3@interlog.com>
References: <20181027082019.20838-1-hch@lst.de>
 <f9423180-e0fc-efba-e759-dfa4725953ad@kernel.dk>
 <20181030074542.GB24697@lst.de>
 <ea317f79-37bb-1149-fc43-fb07f46c15e9@electrozaur.com>
 <57a73f2b-29be-6301-2f4b-df582b7d23ff@interlog.com>
 <a711a25d-e866-aabe-95c8-53bcd212a173@electrozaur.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a711a25d-e866-aabe-95c8-53bcd212a173@electrozaur.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-11-01 1:03 a.m., Boaz Harrosh wrote:
> On 31/10/18 23:10, Douglas Gilbert wrote:
>> On 2018-10-31 4:57 p.m., Boaz Harrosh wrote:
>>> On 30/10/18 09:45, Christoph Hellwig wrote:
>>>> On Mon, Oct 29, 2018 at 02:42:12PM -0600, Jens Axboe wrote:
>>>>> LGTM, for both:
>>>>
>>>> I also have this one on top as requested by Martin.  The core block
>>>> bidi support is unfortunately also used by bsg-lib, although it is
>>>> not anywhere near as invasive.  But that is another argument for
>>>> looking into moving bsg-lib away from using block queues..
>>>>
>>>
>>> BUT this patch is very very wrong.
>>>
>>> Totally apart from T10-OSD and its use in the field. Support for scsi BIDI
>>> commands is not exclusive to T10-OSD at all. Even the simple scsi-array
>>> command-set has BIDI operations defined. for example the write-return-xor
>>> and so on.
>>>
>>> Also some private administrative CDBs of some vendor devices uses SCSI-BIDI.
>>> So this patch just broke some drivers. (User-mode apps use bsg pass through)
>>>
>>> Also you might (try hard and) remove all usage of scsi-bidi as an initiator
>>> from the Linux Kernel. But what about target mode. As a target we have supported
>>> on the wire bidi protocols like write-return-xor and others for a long time.
>>> Are you willing to silently break all these setups in the field on the next update?
>>> Are you so sure these are never used?
>>>
>>> PLEASE, I beg of you guys. Do not remove SCSI-BIDI. It is a cry of generations.
>>>
>>> And I think by the rules of Linus, as far as target mode. You are not allowed
>>> to break users in this way.
>>
>> Hi,
>> I'm in the process of rebuilding the sg driver with the following goals:
>>
>>     - undo 20 years of road wear, some of which is caused by literally
>>       hundreds of "laparoscopic" patches that gradually ruin a driver,
>>       at least from the maintainer's viewpoint. Comments that once made
>>       sense become cryptic or just nonsense; naming schemes that
>>       obliterate variable names to the extent that a random name
>>       generator would be easier to follow; and just plain broken code.
>>       For example, why sort out the existing locking at a particular
>>       level when you can add a new lock in a completely non-orthogonal
>>       way? [Yes, I looking at you, google.] Anyway, my first cut at this
>>       is out there (on the linux-scsi list, see: "[PATCH v3 0/8] sg:
>>       major cleanup, remove max_queue limit"). Not much new there,
>>       unless you look very closely
>>
>>     - the next step is to add to the sg driver async SCSI command
>>       capability based on the sg_io_v4 structure previously only used
>>       by the bsg driver and now removed from bsg. The main advantage
>>       of the sg_io_v4 structure over previous pass-through interface
>>       attempts is the support of SCSI bidi commands
>>
>>     - as part of this effort introduce two new ioctls: SG_IOSUBMIT and
>>       SG_IORECEIVE to replace the write()/read() technique currently
>>       in use (since Linux 1.0 in 1992). The write()/read() technique
>>       seems to be responsible for various security folks losing clumps
>>       of their hair. One advantage of ioctls, as Alan Cox pointed out,
>>       is the ability to write to and read back from the kernel in a way
>>       that is naturally synchronized. [Actually, those security folks
>>       shouldn't look too closely at sg_read() in that respect.]
>>
>> In discussions with several folks who are on the T10 committee, I
>> wondered why there was no READ GATHERED command (there has been a
>> WRITE SCATTERED for 2 years). The answer was lack of interest ***,
>> plus the difficultly of implementation. You see, READ GATHERED needs
>> to send a scatter gather list to the device and get the corresponding
>> data back (as a linear array). And that requires either:
>>     a) bidi commands (scatter gather list in the data-out, corresponding
>>        "read" data in the data-in), or
>>     b) loooong SCSI commands, up to around 256 bytes long in which the
>>        sgat list is the latter part of that command
>>
>> And the T10 folks say neither of those options is well supported or
>> is expensive.
> 
> It is supported in Linux scsi/osd driver is a proof of that. And expensive
> it is not. I have demonstrated the ability to saturate a 10G link over
> a raid of devices from a single writer. In OSD everything is bidi.
> 
>> I'm guessing they are referring to Linux and Windows.
>> I haven't argued much beyond that point, but it looks like a bit of
>> a chicken and egg situation.
>>
>>
>> Don't know too much about the T10 OSD stuff. But I can see that it
>> uses both long SCSI commands and a lot of bidi. IMO it seems to be
>> 10 or 20 years before its time. Maybe ibm/redhat need to
>> (re-)discover it for it to catch on.
>>
>>
>> Plus there are proprietary SCSI bidi commands out there. People contact
>> me and ask me how to issue them with sg3_utils package. Easy, I tell them,
>> just use sg_raw with a bsg device. Typically, in my experience, "no news
>> is good news" after suggestions like that. When I give bad advice, I
>> usually hear back relatively quickly. Anyone who wants SCSI bidi _async_
>> support is currently out of luck.

And I forgot to mention that the scsi_debug driver has had an implementation
of the SCSI XDWRITEREAD(10) command with T10 semantics. That is a bidi
command and facilitates testing of SCSI bidi from other block/SCSI
drivers and user space programs. It has been there for over 4 years with
no problems reported. As mentioned above it can be exercised with the
sg_raw utility in the sg3_utils package via a bsg device.

Doug Gilbert
