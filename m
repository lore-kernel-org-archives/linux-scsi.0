From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Thu, 23 May 2013 11:47:25 +0200
Message-ID: <519DE5AD.7080303@redhat.com>
References: <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522143019.GA18541@mtj.dyndns.org> <519CDDA4.2050100@redhat.com> <20130522193009.GA23845@mtj.dyndns.org> <519D360D.4050309@redhat.com> <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130523090222.GA26592@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 23/05/2013 11:02, Tejun Heo ha scritto:
> On Thu, May 23, 2013 at 09:45:42AM +0200, Paolo Bonzini wrote:
>> Il 23/05/2013 00:17, Tejun Heo ha scritto:
>>> Then let's make it fit the use case better.  I really can't see much
>>> point in crafting the cdb filter when you basically have to entrust
>>> the device to the user anyway.  Let's either trust the user with the
>>> device or not.  I'm very doubtful that the filtered access via SG_IO
>>> can be reliable or secure enough.  Let's please avoid extending a
>>> broken thing.
>>
>> Sorry to say that, but "I'm very doubtful that..." is just conspiracy
>> theory.
>>
>> It is not broken.  I'm not _that_ clueless, if it were broken I wouldn't
>> have had users use it in production.
> 
> No no, I'm not talking about it not working for the users - it's just
> passing the commands, it of course works.  I'm doubting about it being
> a worthy security isolation layer.  cdb filtering (of any form really)
> has always been something on the border.  It always was something we
> got stuck with due to lack of other immediate options.

I understood correctly then. :)  I agree it's not the best, but it's not
completely broken either.  It has bugs, and that's what these patches
try to fix.

>>> One more thing, is it really necessary to have finer granularity than
>>> provided by file permissions?  What would be the use case?  Do you
>>> expect to have multiple - two - differing levels of access with and
>>> without SG_IO?
>>
>> No, I don't.  I want four levels:
>>
>> 1) no access;
>> 2) read-only access;
>> 3) read-write whitelisted access;
>> 4) generic access;
>>
>> but it's indeed fine to assume that 3 and 4 will never be given together
>> to the same disk.  The important point is that 2 and 3 should not
>> require any privileges except for opening the file.
> 
> I'm wondering whether combining 3 into 4 would be good enough.

No, it wouldn't.  I learnt it the hard way (by having a patch nacked :))
at http://thread.gmane.org/gmane.linux.kernel/1311887.

>> With the opt-out knob, you still need a long-lived privileged process in
>> order to set the knob back to "no access", and that's undesirable.
>> Long-lived privileged processes can be SIGKILLed and leave things open
>> for misuse; instead, if I need something privileged I want to confine it
>> to a helper that opens the file and passes back the file descriptor.
> 
> Hmmm?  Somebody has to give out the access rights anyway, be it a udev
> rule or polkit.  While not having to depend on them could be nice, I
> don't think involving userland is a big deal.  It's already involved
> in closely related capacities anyway.

Polkit need not do anything to give out the access rights, it only has
to just confirm the credentials.  A helper setgid-disk can consult
polkit, open the file, pass the file descriptor back, and exit.  We
already do something similar for tap devices.

>>>> There are many use cases, I listed some in my reply to Martin.
>>>> Sometimes you have trust over the guest and can use count-me-out.  But
>>>> in some cases you don't, and yet the current whitelist is not enough
>>>> (e.g. tapes).
>>>
>>> Can you elaborate?  Why can't a tape device be entrusted to the user?
>
> I was curious why they wouldn't be able to use count-me-out knob.  The
> white list was nasty but we did it anyway because there were some
> horrible commands which, ISTR, could even affect other devices sharing
> the bus and at least at the beginning the list of commands which
> should be allowed were pretty compact.

Exactly.  Though these commands do not really affect other devices
sharing the bus, they affect other initiators trying to use the device.
 And these commands are generic, so they apply to disks as well as tapes.

Unfortunately, a purely userspace whitelist would be too easy to circumvent.

> Whitelisting those commands is likely to be mostly harmless most of
> the time but I would be surprised if there aren't devices out in the
> wild which can be bricked / affected adversely with carefully crafted
> commands within the allowed cdbs.  The level of security isolation
> which can be provided by command code filtering is somewhat flimsy,
> which is why cdb filtering was always seen as a kludge, which in turn
> is why there's reluctance against extending it to more use cases.

Yes, I understand that.  But I don't believe it is a serious concern.
In the case of tapes, for example, you're not talking about 10 dollar
USB pendrives whose firmware was written in fire-and-forget mode.
Firmware bugs would be updated by the manufacturers.

I cannot exclude there will _never_ be a bug like this, of course.  But
even if there will be one, IMHO it would be exceptional enough that we
can afford fixing it with a per-device quirk.

Scanners have never had any CDB filtering done on them; I searched for
this kind of bug, and I couldn't find any report.

What I am trying to do is to reach a compromise.  The one I'm proposing
is to forbid reserved or vendor-specific commands, while at the same
time opening the doors on more standardized commands.

Paolo
