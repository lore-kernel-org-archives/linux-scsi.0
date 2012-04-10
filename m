From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline except
 SATA
Date: Tue, 10 Apr 2012 21:55:49 +0200
Message-ID: <4F849045.9070806@kernel.dk>
References: <20120410133708.GE21801@redhat.com> <4F843C17.5050004@kernel.dk> <20120410142148.GG21801@redhat.com> <20120410151042.GH21801@redhat.com> <4F847EC4.7040604@kernel.dk> <20120410185318.GL21801@redhat.com> <4F848253.6060303@kernel.dk> <20120410191121.GM21801@redhat.com> <4F8487D0.3010503@kernel.dk> <CAMM=eLeQzLM3MMHkKk=mVE4O8V+w8vvPbau8A1Z3mme-G4KiLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54452 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2DJTzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Apr 2012 15:55:55 -0400
In-Reply-To: <CAMM=eLeQzLM3MMHkKk=mVE4O8V+w8vvPbau8A1Z3mme-G4KiLA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux kernel mailing list <linux-kernel@vger.kernel.org>, Moyer Jeff Moyer <jmoyer@redhat.com>, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org

On 2012-04-10 21:43, Mike Snitzer wrote:
> On Tue, Apr 10, 2012 at 3:19 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2012-04-10 21:11, Vivek Goyal wrote:
>>> On Tue, Apr 10, 2012 at 08:56:19PM +0200, Jens Axboe wrote:
>>>> On 2012-04-10 20:53, Vivek Goyal wrote:
>>>>> On Tue, Apr 10, 2012 at 08:41:08PM +0200, Jens Axboe wrote:
>>>>>
>>>>> [..]
>>>>>>> So we are back to the question of can scsi devices find out if a Lun
>>>>>>> is backed by single disk or multiple disks.
>>>>>>
>>>>>> The cleanest would be to have the driver signal these attributes at
>>>>>> probe time. You could even adjust CFQ properties based on this, driving
>>>>>> the queue depth harder etc. Realistically, going forward, most fast
>>>>>> flash devices will be driven by a noop-like scheduler on multiqueue. So
>>>>>> CPU cost of the IO scheduler can mostly be ignored, since CFQ cost on
>>>>>> even big RAIDs isn't an issue due to the low IOPS rates.
>>>>>
>>>>> Agreed that on RAID CPU cost is not a problem. Just that idling and low
>>>>> queue depth kills the performance.
>>>>
>>>> Exactly, and both of these are trivially adjustable as long as we know
>>>> when to do it.
>>>>
>>>>> So apart from "rotational" if driver can give some hints about underlying
>>>>> devices being RAID (or multi device), it will help. Just that it looks
>>>>> like scsi does not have a way to determine that.
>>>>
>>>> This sort of thing should be done with a udev rule.
>>>
>>> [CCing kay]
>>>
>>> Kay does not like the idea of doing something along this line in udev.
>>> He thinks that kernel changes over a period of time making udev rules
>>> stale and hence it should be done in kernel. :-) I think he has had
>>> some not so good experiences in the past.
>>>
>>> Though personally I think that anything which is not set in stone should
>>> go to udev. It atleast allows for easy change if user does not like the
>>> setting. (disable the rule, modify the rule etc). And then rules evolve
>>> as things change in kernel.
>>>
>>> Anyway, this point can be detabted later once we figure out what's the
>>> set of atrributes to look at.
>>
>> It's a bit tricky. But supposedly sysfs files are part of the ABI, no
>> matter how silly that may be. For these particular tunables, that means
>> that some parts of the ABI are only valid/there if others contain a
>> specific value. So I'm assuming that udev does not want to rely on that.
>> Now I don't know a lot about udev or udev rules, but if you could make
>> it depend on the value of <dev>/queue/scheduler, then it should
>> (supposedly) be stable and safe to rely on. It all depends on what kind
>> of logic you can stuff into the rules.
>>
>> In any case, I'm sure that udev does not want to ship with those rules.
>> It would have to be a separate package. Which is fine, in my opinion.
>>
>>>> It should not be too
>>>> hard to match for the most popular arrays, catching the majority of the
>>>> setups by default. Or you could ask the SCSI folks for some heuristics,
>>>> it's not unlikely that a few different attributes could make that bullet
>>>> proof, pretty much.
>>>
>>> I am wondering what will happen to request based multipath targets in
>>> this scheme. There will have to be I guess additional rules to look for
>>> underlying paths and then change the io scheduler accordingly.
>>
>> If each path is a device, each device should get caught and matched.
> 
> I'm still missing your position (other than you now wanting to make it
> a userspace concern).
> 
> Put differently: why should CFQ still be the default?
> 
> It is pretty widely held that deadline is the more sane default
> (multiple distros are now using it, deadline is default for guests,
> etc).  CFQ has become more niche.  The Linux default really should
> reflect this.
> 
> The only case where defaulting to CFQ seems to make sense is
> rotational SATA (and USB).

That's the precisely the reason it should still be the default. The
default settings should reflect a good user experience out of the box.
Most desktop machines are still using SATA drives. And even those that
made the leap to SSD, lots of those are still pretty sucky at high queue
depths or without read/write separation. So I'm quite sure the default
still makes a lot of sense.

Punt tuning to the server side. If you absolutely want the best
performance out of your _particular_ workload, you are expecting and
required to tune things anyway. Not just the IO scheduler, but in
general. You can't make the same requirements for the desktop.

As to kernel vs user, I just see little reason for doing it in the
kernel if we can put that policy in user space.

-- 
Jens Axboe

