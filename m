From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT 3.2-rc PATCH 0/8] isci: platform and hardware enabling
 updates
Date: Wed, 21 Dec 2011 15:05:26 -0600
Message-ID: <1324501526.17423.13.camel@dabdike.int.hansenpartnership.com>
References: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
	 <1324216168.3091.7.camel@dabdike.int.hansenpartnership.com>
	 <CABE8wws_0WJgcgB1=Qtzkwr1nBQt2fLo_6S9oRzMfCOGURcjRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33346 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab1LUVFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2011 16:05:30 -0500
In-Reply-To: <CABE8wws_0WJgcgB1=Qtzkwr1nBQt2fLo_6S9oRzMfCOGURcjRA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2011-12-18 at 10:46 -0800, Williams, Dan J wrote: 
> On Sun, Dec 18, 2011 at 5:49 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2011-12-16 at 16:53 -0800, Dan Williams wrote:
> >> These are priority updates, targeted for inclusion in 3.2-final, for the
> >> driver to honor the latest definition of oem parameters and support the
> >> latest revision of silicon.  The oem parameter format (phy configuration
> >> settings passed along from platform firmware) has been updated to
> >> revision 1.3, current driver only supports 1.0.  The C1 silicon update
> >> involves updates to the per-silicon-revision hard-coded phy tuning
> >> recipes.
> >
> > The -rc tree is for bug fixes only, not whatever you choose to call
> > "priority updates".  We have long established the position that a driver
> > update, even to support new hardware, isn't a bug fix ...
> 
> These updates are aiming to get ahead of the bug reports that will be
> filed as these platform changes get distributed.  Public bugzillas
> seem to be the difference compared to some of the platform revision
> specific updates that went into -rc6 via the drm tree.
> 
> > the
> > distributions apply it through their enhancement processes. See below
> > for the individual comments
> >
> >> This also updates the driver version from v1.0 to v1.1 to remove the
> >> stale EXPERIMENTAL tag and reflect the C1 level of silicon support.
> >>
> >> A performance fix and a fix for a crash that can be triggered by
> >> enabling a dev_dbg() statement are also included.
> >>
> >> Please apply, or pull from:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git fixes
> >>
> >> ...to receive:
> >>
> >> Dan Williams (2):
> >>       isci: cleanup oem parameter and recipe handling
> >
> > This isn't a bug fix
> 
> Certainly not, but I wanted git blame on the subsequent settings to
> point to the commit where the value actually changed before adding
> more line wrapped register writes.

Anyone who uses git blame knows how to cope with that.  If we adopted
that principle; we'd have tons of whitespace and code motion type
changes in the stable trees, which isn't a good precedent.

> >>       isci: update version to 1.1
> 
> Mainline currently has v1.0+, and this reverts d962480e "[SCSI]
> libsas: fix try_test_sas_gpio_gp_bit() build error", because it was
> the wrong fix.
> 
> >>
> >> Dave Jiang (1):
> >>       isci: oem parameter format v1.1 (ssc select)
> >> Jeff Skirvin (3):
> >>       isci: update afe (analog-front-end) recipe for C1
> >>       isci: oem parameter format v1.3 (cable select)
> >
> > New silicon support is an enhancement not a bug fix (last three patches)
> 
> I hate being put between a platform definition revision and a -rc window.
> 
> 3.2 has an opportunity to ship with support for these settings that
> affect link stability and meet signal integrity targets so I felt it
> was worth calling these patches out separately from the wider updates
> targeted for 3.3.

The process for updates is that they go into the next merge window (i.e.
for the 3.3 kernel).  If there's a case for adding this to 3.2 or
earlier kernels, then the distros will do it.

> >> Maciej Trela (1):
> >>       isci: remove unused 'isci_tmf->device' field
> >
> > This isn't a bug fix.
> 
> Yeah, "kernel crash" made me throw it in the 'fixes' pile, but since
> it is hidden behind enabling a dev_dbg() statement it can certainly be
> deferred.

What kernel crash?  The changelog doesn't mention anything about it.

> >> Marcin Tomczak (1):
> >>       isci: performance-fix, shorten default "no outbound task" timeout
> >
> > I don't quite see from the description how this is a performance
> > enhancement?  It does nothing in the single initiator case, right?
> 
> This rate limits the link arbitration for how often the hardware
> switches to a different remote-node-context.  At higher queue depths
> we would see IOPs performance drop off rather than saturate, adjusting
> this timeout corrected that condition.

I think I still don't understand what this is.  All outbound links have
to switch context rapidly in a multi-target environment with switches on
the order of microseconds ... where exactly is this 10s timeout you
reduce to 2s triggered?

James


