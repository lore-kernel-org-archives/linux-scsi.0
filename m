From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Thu, 23 May 2013 18:02:22 +0900
Message-ID: <20130523090222.GA26592@mtj.dyndns.org>
References: <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522143019.GA18541@mtj.dyndns.org>
 <519CDDA4.2050100@redhat.com>
 <20130522193009.GA23845@mtj.dyndns.org>
 <519D360D.4050309@redhat.com>
 <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519DC926.4000106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 23, 2013 at 09:45:42AM +0200, Paolo Bonzini wrote:
> Il 23/05/2013 00:17, Tejun Heo ha scritto:
> > Then let's make it fit the use case better.  I really can't see much
> > point in crafting the cdb filter when you basically have to entrust
> > the device to the user anyway.  Let's either trust the user with the
> > device or not.  I'm very doubtful that the filtered access via SG_IO
> > can be reliable or secure enough.  Let's please avoid extending a
> > broken thing.
> 
> Sorry to say that, but "I'm very doubtful that..." is just conspiracy
> theory.
> 
> It is not broken.  I'm not _that_ clueless, if it were broken I wouldn't
> have had users use it in production.

No no, I'm not talking about it not working for the users - it's just
passing the commands, it of course works.  I'm doubting about it being
a worthy security isolation layer.  cdb filtering (of any form really)
has always been something on the border.  It always was something we
got stuck with due to lack of other immediate options.

> > One more thing, is it really necessary to have finer granularity than
> > provided by file permissions?  What would be the use case?  Do you
> > expect to have multiple - two - differing levels of access with and
> > without SG_IO?
> 
> No, I don't.  I want four levels:
> 
> 1) no access;
> 
> 2) read-only access;
> 
> 3) read-write whitelisted access;
> 
> 4) generic access;
> 
> but it's indeed fine to assume that 3 and 4 will never be given together
> to the same disk.  The important point is that 2 and 3 should not
> require any privileges except for opening the file.

I'm wondering whether combining 3 into 4 would be good enough.

> With the opt-out knob, you still need a long-lived privileged process in
> order to set the knob back to "no access", and that's undesirable.
> Long-lived privileged processes can be SIGKILLed and leave things open
> for misuse; instead, if I need something privileged I want to confine it
> to a helper that opens the file and passes back the file descriptor.

Hmmm?  Somebody has to give out the access rights anyway, be it a udev
rule or polkit.  While not having to depend on them could be nice, I
don't think involving userland is a big deal.  It's already involved
in closely related capacities anyway.

> > for the same user, it's pointless to give out SG_IO access to
> > processes while denying for other processes.  As long as ptrace can
> > be attached, hijacking such fd is easy. Making it per-device should
> > be suitable enough, no?
> 
> Yes, and that's what I did.  Such hijacking is why a kernel whitelist is
> necessary in untrusted cases (i.e. you cannot just implement it in
> userspace).

I was thinking about the mentions of SCM_RIGHTS.  Anyways, yeah, it
isn't possible to build any finer granularity than the existing
security domains.

> >> There are many use cases, I listed some in my reply to Martin.
> >> Sometimes you have trust over the guest and can use count-me-out.  But
> >> in some cases you don't, and yet the current whitelist is not enough
> >> (e.g. tapes).
> > 
> > Can you elaborate?  Why can't a tape device be entrusted to the user?
> 
> In general, any device may or may not be entrusted to the user.  In this
> respect, tapes or disks have no difference.
> 
> But while the current whitelist is almost okay for disks, it is not
> usable for tapes.  Too many essential commands are missing; this is why
> extending the whitelist to cover other device types is important for me.
>  And since you don't want to open new commands to all classes with no
> distinction (which I understand), the only choice is per-class whitelists.

I was curious why they wouldn't be able to use count-me-out knob.  The
white list was nasty but we did it anyway because there were some
horrible commands which, ISTR, could even affect other devices sharing
the bus and at least at the beginning the list of commands which
should be allowed were pretty compact.

While the list has grown over time, at times probably too carelessly,
I'm not sure it'd be a good idea to make it fully generic to the
extent where giving out write access to a user means SG_IO access to
most common commands by default.  Count-me-out is attractive mainly
because it involves an explicit step where the additional access is
granted.  It'd be nice if that's good enough for the common use cases.
If not, I don't know.

Whitelisting those commands is likely to be mostly harmless most of
the time but I would be surprised if there aren't devices out in the
wild which can be bricked / affected adversely with carefully crafted
commands within the allowed cdbs.  The level of security isolation
which can be provided by command code filtering is somewhat flimsy,
which is why cdb filtering was always seen as a kludge, which in turn
is why there's reluctance against extending it to more use cases.

-- 
tejun
