From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 24 May 2013 10:44:05 +0900
Message-ID: <20130524014405.GB16882@mtj.dyndns.org>
References: <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522143019.GA18541@mtj.dyndns.org>
 <519CDDA4.2050100@redhat.com>
 <20130522193009.GA23845@mtj.dyndns.org>
 <519D360D.4050309@redhat.com>
 <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
 <20130523090222.GA26592@mtj.dyndns.org>
 <519DE5AD.7080303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519DE5AD.7080303@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 23, 2013 at 11:47:25AM +0200, Paolo Bonzini wrote:
> > No no, I'm not talking about it not working for the users - it's just
> > passing the commands, it of course works.  I'm doubting about it being
> > a worthy security isolation layer.  cdb filtering (of any form really)
> > has always been something on the border.  It always was something we
> > got stuck with due to lack of other immediate options.
> 
> I understood correctly then. :)  I agree it's not the best, but it's not
> completely broken either.  It has bugs, and that's what these patches
> try to fix.

The same filtering table being applied to different classes of
hardware is a software bug, but my point is that the practive
essentially entrusts non-insignificant part of security enforcement to
the hardware itself.  The variety of hardware in question is very wide
and significant portion has historically been known to be flaky.

> > I'm wondering whether combining 3 into 4 would be good enough.
> 
> No, it wouldn't.  I learnt it the hard way (by having a patch nacked :))
> at http://thread.gmane.org/gmane.linux.kernel/1311887.

Of course you can't do that by adding dangerous commands to the
existing filtering table which is allowed by default.  I'm saying
"count me out" knob could be good enough.  Neither is perfect but at
least the latter doesn't affect the default cases.

> > Hmmm?  Somebody has to give out the access rights anyway, be it a udev
> > rule or polkit.  While not having to depend on them could be nice, I
> > don't think involving userland is a big deal.  It's already involved
> > in closely related capacities anyway.
> 
> Polkit need not do anything to give out the access rights, it only has
> to just confirm the credentials.  A helper setgid-disk can consult
> polkit, open the file, pass the file descriptor back, and exit.  We
> already do something similar for tap devices.

I see.  It really just comes down to plumbing and doesn't seem like a
particularly challenging one at that.

> Yes, I understand that.  But I don't believe it is a serious concern.
> In the case of tapes, for example, you're not talking about 10 dollar
> USB pendrives whose firmware was written in fire-and-forget mode.
> Firmware bugs would be updated by the manufacturers.

This is being applied to all block devices by default and it's a part
of a vicious circle which is being reinforced by this change.  We
added flawed security mechanism to work around deficiency in software
stack.  The mechanism could be mis-used for other purposed which in
turn developed into other use cases, which then pushes the expansion
of the existing flawed mechanism.  This is a process with postive feed
back built into it.

> I cannot exclude there will _never_ be a bug like this, of course.  But
> even if there will be one, IMHO it would be exceptional enough that we
> can afford fixing it with a per-device quirk.
>
> Scanners have never had any CDB filtering done on them; I searched for
> this kind of bug, and I couldn't find any report.
> 
> What I am trying to do is to reach a compromise.  The one I'm proposing
> is to forbid reserved or vendor-specific commands, while at the same
> time opening the doors on more standardized commands.

I feel pretty uncomfortable about the direction and think we should
reach compromise from the other direction.  If VMs need raw device
access, just entrust the device to those VMs and enforce whatever
extra restriction from hypervisor side.  It sure isn't perfect but
neither is the other compromise and the risk is taken by the ones
wanting to do (relatively) exotic stuff rather than forced on all
others.

-- 
tejun
