From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] acornscsi: remove linked command support
Date: Sun, 25 May 2014 11:42:51 +0400
Message-ID: <1401003771.2322.33.camel@dabdike.int.hansenpartnership.com>
References: <1400926433.31526.89.camel@x220> <538075E0.4080001@suse.de>
	 <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
	 <1400937395.22523.55.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49972 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbaEYHm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2014 03:42:56 -0400
In-Reply-To: <1400937395.22523.55.camel@x220>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Hannes Reinecke <hare@suse.de>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, 2014-05-24 at 15:16 +0200, Paul Bolle wrote:
> On Sat, 2014-05-24 at 16:13 +0400, James Bottomley wrote:
> > Wait, no, that's not a good idea.  We leave obsolete drivers to bitrot.
> > Particularly we try not to touch them unless we have to because there
> > might be a few people still using them and the more we tamper, the
> > greater the risk that something gets broken.
> 
> Which is also a way to notice whether people still use those obsolete
> drivers.

Really, no.  We don't deliberately break old drivers to see if anyone
notices.  Usually the feedback loop is months to years for the long tail
to notice and by that time fixing the problem becomes a real pain if you
allow driver churn.

We keep old drivers that compile until there's a problem caused usually
by something like API changes.

> > On that principle, since
> > there's no real reason to remove the code,
> 
> (Unless one carries the hope that any check, treewide, for a CONFIG_*
> macro can be linked to a proper Kconfig symbol.)

The check can be fixed.  If you look at what Fengguang Wu does, he has a
list of expected problems which he diffs.  Don't churn the tree to match
the checker, make the checker match the tree.

> > it should stay ... until the
> > whole driver bitrots to the extent that we can no-longer compile it.
> 
> I've run into this depreciation policy before. With aic7xxx_old (which I
> eventually convinced Fedora to disable, a few relases before it was
> removed from the tree). With aic94xx (which I also convinced Fedora to
> disable). I also tried multiple times to shut up advansys' compile
> time[1]. It seems SCSI might risk not to notice their bitrot, because
> eventually everybody stops compiling these obsolete drivers, leaving
> SCSI without feedback on their state.

Why would we care?  If it compiles that's fine, it's not causing a
problem and it might just be useful to somebody.

The time obsolete drivers cause problems is tree or subsystem wide API
changes.  Then we look at the amount of work required and sometimes
remove them or do hack fixes. 

> Anyhow, SCSI seems to be the only subsystem that uses this subcategory
> of not-really-maintained drivers. Other subsystems appear to allow
> anything to be fixed, even trivialities, which are what I tend to fix,
> and only stop allowing fixes if the drivers involved are going to be
> removed anyway. But maybe I just never ran into that category in other
> subsystems.

Try ide ... they have the same policy.

Try to understand the reason: we have a long tail of people using
obsolete systems who we try not to break.  Any change to an unmaintained
driver which can't be tested risks that ... and I'm the one who would
have to try to sort out the problem when it's noticed, hence the
caution.  If we allow trivial churn, by the time the breakage is noticed
(usually months to years later), the driver will have picked up a ton of
changes and finding the problem one becomes really hard.  So
unmaintained drivers get a default deep freeze maintenance policy.

Even for a maintained driver, if the maintainer has little access to the
hardware and few users they may also choose a deep freeze maintenance
policy for the same reasons above; that's why no changes without
maintainer ack.

James


