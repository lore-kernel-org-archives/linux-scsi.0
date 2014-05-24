From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] acornscsi: remove linked command support
Date: Sat, 24 May 2014 15:16:35 +0200
Message-ID: <1400937395.22523.55.camel@x220>
References: <1400926433.31526.89.camel@x220> <538075E0.4080001@suse.de>
	 <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-05-24 at 16:13 +0400, James Bottomley wrote:
> Wait, no, that's not a good idea.  We leave obsolete drivers to bitrot.
> Particularly we try not to touch them unless we have to because there
> might be a few people still using them and the more we tamper, the
> greater the risk that something gets broken.

Which is also a way to notice whether people still use those obsolete
drivers.

> On that principle, since
> there's no real reason to remove the code,

(Unless one carries the hope that any check, treewide, for a CONFIG_*
macro can be linked to a proper Kconfig symbol.)

> it should stay ... until the
> whole driver bitrots to the extent that we can no-longer compile it.

I've run into this depreciation policy before. With aic7xxx_old (which I
eventually convinced Fedora to disable, a few relases before it was
removed from the tree). With aic94xx (which I also convinced Fedora to
disable). I also tried multiple times to shut up advansys' compile
time[1]. It seems SCSI might risk not to notice their bitrot, because
eventually everybody stops compiling these obsolete drivers, leaving
SCSI without feedback on their state.

Anyhow, SCSI seems to be the only subsystem that uses this subcategory
of not-really-maintained drivers. Other subsystems appear to allow
anything to be fixed, even trivialities, which are what I tend to fix,
and only stop allowing fixes if the drivers involved are going to be
removed anyway. But maybe I just never ran into that category in other
subsystems.

> However, I'll do this if the Maintainer (rmk) acks ... because if it
> breaks he gets to fix it.


Paul Bolle

[1] advansys prints a pointless compile time warning, on purpose.
Clearly no one cares about its "wide board" support, but for some reason
that warning needs to stay in. (Fedora declined to disable that driver.)
