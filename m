From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] acornscsi: remove linked command support
Date: Wed, 28 May 2014 19:28:21 +0200
Message-ID: <1401298101.22486.48.camel@x220>
References: <1400926433.31526.89.camel@x220> <538075E0.4080001@suse.de>
	 <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
	 <1400937395.22523.55.camel@x220>
	 <1401003771.2322.33.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401003771.2322.33.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-05-25 at 11:42 +0400, James Bottomley wrote:
> On Sat, 2014-05-24 at 15:16 +0200, Paul Bolle wrote:
> > On Sat, 2014-05-24 at 16:13 +0400, James Bottomley wrote:
> > > Wait, no, that's not a good idea.  We leave obsolete drivers to bitrot.
> > > Particularly we try not to touch them unless we have to because there
> > > might be a few people still using them and the more we tamper, the
> > > greater the risk that something gets broken.
> > 
> > Which is also a way to notice whether people still use those obsolete
> > drivers.
> 
> Really, no.  We don't deliberately break old drivers to see if anyone
> notices.  Usually the feedback loop is months to years for the long tail
> to notice and by that time fixing the problem becomes a real pain if you
> allow driver churn.

Of course I wasn't advocating deliberately breaking old drivers. But
it's easy to get annoyed by that short remark. It would have been better
if I hadn't made it.

Especially because I didn't also point out, as Cristoph did, that the
code I want removed doesn't get compiled. So removing it can, by
definition I'd say, not break that old driver.

> We keep old drivers that compile until there's a problem caused usually
> by something like API changes.
> 
> > > On that principle, since
> > > there's no real reason to remove the code,
> > 
> > (Unless one carries the hope that any check, treewide, for a CONFIG_*
> > macro can be linked to a proper Kconfig symbol.)
> 
> The check can be fixed.  If you look at what Fengguang Wu does, he has a
> list of expected problems which he diffs.  Don't churn the tree to match
> the checker, make the checker match the tree.

Sure. See my recent patch to scripts/headers_check.pl, which does just
that. But before one special cases a certain hit for a checker one needs
to know that this hit really can't or won't be fixed. And in order to
know that one needs to at least try to fix it first.

> > > it should stay ... until the
> > > whole driver bitrots to the extent that we can no-longer compile it.
> > 
> > I've run into this depreciation policy before. With aic7xxx_old (which I
> > eventually convinced Fedora to disable, a few relases before it was
> > removed from the tree). With aic94xx (which I also convinced Fedora to
> > disable). I also tried multiple times to shut up advansys' compile
> > time[1]. It seems SCSI might risk not to notice their bitrot, because
> > eventually everybody stops compiling these obsolete drivers, leaving
> > SCSI without feedback on their state.
> 
> Why would we care?  If it compiles that's fine, it's not causing a
> problem and it might just be useful to somebody.

Fair point: having code that no one uses doesn't cost a lot.

> The time obsolete drivers cause problems is tree or subsystem wide API
> changes.  Then we look at the amount of work required and sometimes
> remove them or do hack fixes. 
> 
> > Anyhow, SCSI seems to be the only subsystem that uses this subcategory
> > of not-really-maintained drivers. Other subsystems appear to allow
> > anything to be fixed, even trivialities, which are what I tend to fix,
> > and only stop allowing fixes if the drivers involved are going to be
> > removed anyway. But maybe I just never ran into that category in other
> > subsystems.
> 
> Try ide ... they have the same policy.

I never really touched IDE. That might explain why I only ran into this
issue with SCSI.

> Try to understand the reason: we have a long tail of people using
> obsolete systems who we try not to break.  Any change to an unmaintained
> driver which can't be tested risks that ... and I'm the one who would
> have to try to sort out the problem when it's noticed, hence the
> caution.  If we allow trivial churn, by the time the breakage is noticed
> (usually months to years later), the driver will have picked up a ton of
> changes and finding the problem one becomes really hard.  So
> unmaintained drivers get a default deep freeze maintenance policy.

Thanks for taking the time to explain this to me. I appreciate that.
This is the first time, I think, that I've seen you explain that policy.
(I might have missed earlier explanations to other people.) Now I might
not entirely agree with you, but it does help to know where you're
coming from.

Thanks,


Paul Bolle
