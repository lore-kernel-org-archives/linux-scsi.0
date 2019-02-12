From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [5.0-rc5 regression] "scsi: kill off the legacy IO path" causes 5
 minute delay during boot on Sun Blade 2500
Date: Tue, 12 Feb 2019 08:27:13 -0700
Message-ID: <02383850-f55c-ad14-ffb4-e9f987ebe986@kernel.dk>
References: <CAM43=SO6bdDAEULEPArfgdbjLAYDo9OiPBa8gL4fsSg7Dky=gA@mail.gmail.com>
 <1549736341.2971.7.camel@HansenPartnership.com>
 <CAM43=SPUMzOLRmkoT+DQSpzu2DYRTyOhU6o8KRUU_Q902o2e1Q@mail.gmail.com>
 <1549813472.4142.3.camel@HansenPartnership.com>
 <3380ed8e-ae02-96f2-142b-7cce09459df8@kernel.dk>
 <1549815924.4142.8.camel@HansenPartnership.com>
 <0e6e5d67-d305-dd00-2e42-e2299166c8b2@kernel.dk>
 <1549898730.2831.6.camel@HansenPartnership.com>
 <44bb4374-0b7c-733b-a53e-92d2f03f2f49@kernel.dk>
 <1549899773.2831.12.camel@HansenPartnership.com>
 <1a00da0e-cb8e-30ea-8d17-120f97242b2f@kernel.dk>
 <1549902521.2831.23.camel@HansenPartnership.com>
 <fce66227-ff41-3a4e-4c6a-f4c2ca492b95@kernel.dk>
 <1549937598.2857.8.camel@HansenPartnership.com>
 <fc547d40-9a42-a823-b62f-460c3244fe7d@kernel.dk>
 <1549985049.3173.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1549985049.3173.3.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mikael Pettersson <mikpelinux@gmail.com>, Xuewei Zhang <xueweiz@google.com>
Cc: Linux SPARC Kernel Mailing List <sparclinux@vger.kernel.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2/12/19 8:24 AM, James Bottomley wrote:
> On Mon, 2019-02-11 at 19:50 -0700, Jens Axboe wrote:
>> On 2/11/19 7:13 PM, James Bottomley wrote:
>>> On Mon, 2019-02-11 at 09:31 -0700, Jens Axboe wrote:
>>>> On 2/11/19 9:28 AM, James Bottomley wrote:
>>>>> On Mon, 2019-02-11 at 08:46 -0700, Jens Axboe wrote:
>>>>>> On 2/11/19 8:42 AM, James Bottomley wrote:
>>>>>>> On Mon, 2019-02-11 at 08:28 -0700, Jens Axboe wrote:
>>>>>>>> On 2/11/19 8:25 AM, James Bottomley wrote:
>>>>>>>>> On Sun, 2019-02-10 at 09:35 -0700, Jens Axboe wrote:
>>>>>>>>>> On 2/10/19 9:25 AM, James Bottomley wrote:
>>>>>
>>>>> [...]
>>>>>>>>>>> That check wasn't changed by the code removal.
>>>>>>>>>>
>>>>>>>>>> As I said above, for sd. This isn't true for non-
>>>>>>>>>> disks.
>>>>>>>>>
>>>>>>>>> Yes, but the behaviour above doesn't change across a
>>>>>>>>> switch
>>>>>>>>> to MQ, so I don't quite understand how it bisects back
>>>>>>>>> to
>>>>>>>>> that change.  If we're not gathering entropy for the
>>>>>>>>> device
>>>>>>>>> now, we wouldn't have been before the switch, so the
>>>>>>>>> entropy characteristics shouldn't have changed.
>>>>>>>>
>>>>>>>> But it does, as I also wrote in that first email. The
>>>>>>>> legacy
>>>>>>>> queue flags had QUEUE_FLAG_ADD_RANDOM set by default, the
>>>>>>>> MQ
>>>>>>>> ones do not. Hence any non-sd device would previously
>>>>>>>> ALWAYS
>>>>>>>> have ADD_RANDOM set, now none of them do. Also see the
>>>>>>>> patch
>>>>>>>> I sent.
>>>>>>>
>>>>>>> So your theory is that the disk in question never gets to
>>>>>>> the
>>>>>>> rotational check?  because the check will clear the flag if
>>>>>>> it's non-rotational and set it if it's not, so the default
>>>>>>> state of the flag shouldn't matter.
>>>>>>
>>>>>> No, my point is about non-disks, devices that aren't driven
>>>>>> by
>>>>>> sd. The behavior for sd hasn't changed, as it sets/clears it
>>>>>> unconditionally. 
>>>>>
>>>>> I agree, but I don't think any of them were significant entropy
>>>>> contributors before: things like nvme have always been outside
>>>>> of
>>>>> this and sr and st don't really contribute much to the seek
>>>>> load
>>>>> during boot because they're probed but not used by the boot
>>>>> sequence, so I can't see how they would cause this
>>>>> behaviour.  I
>>>>> suppose it could be target probing, but even that seems
>>>>> unlikely
>>>>> because it should be dwarfed by the number of root disk reads
>>>>> during boot.
>>>>>
>>>>> For the rng to take an additional 5 minutes to initialize, we
>>>>> must
>>>>> have lost a significant entropy source somewhere.
>>>>
>>>> I agree it's not a significant amount of entropy, but even just
>>>> one
>>>> bit could mean a long stall if that put us over the edge of just
>>>> not
>>>> having enough for whatever is blocking on /dev/random. Mikael's
>>>> boot
>>>> did have a CDROM, it's not impossible that the handful of
>>>> commands we
>>>> end up doing to that device would have contributed enough entropy
>>>> to
>>>> get the boot done without stalling for minutes.
>>>>
>>>> One way to know for sure, and that's if Mikael tests the patch.
>>>
>>> I think I've got the root cause.  I have one system in my test bed
>>> exhibiting this behaviour.  It turns out the disk in it has no
>>> characteristics VPD page.  The 0xB1 VPD was a SBC-3 addition, so
>>> that's
>>> not surprising.  However, the characteristics check bails before
>>> setting the flags, so it takes the default flag which has flipped.
>>>
>>> We can either fix this by setting the QUEUE_FLAG_ADD_RANDOM if
>>> there's
>>> no 0xB1 page or by setting the default as Jens proposed.
>>
>> I'd recommend just doing my patch, since that'll be the same behavior
>> that SCSI had before.
> 
> I've got the history now, it's this patch
> 
> Author: Xuewei Zhang <xueweiz@google.com>
> Date:   Thu Sep 6 13:37:19 2018 -0700
> 
>     scsi: sd: Contribute to randomness when running rotational device
> 
> It added the else branch to the if (rot == 1).  It's the position of
> that else branch which is wrong because not all disks have a SBC-3
> characteristics VPD page, so they're the ones under MQ which stop
> contributing entropy.  Whichever patch we go with will need a fixes:
> for this.

Ah, makes sense. I'd say we're _probably_ fine just fixing that then,
or at least it should be two separate patches.

-- 
Jens Axboe
