From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
Date: Fri, 11 Feb 2011 10:06:06 -0600
Message-ID: <1297440366.4967.83.camel@mulgrave.site>
References: <201102091515.16202.bzolnier@gmail.com>
	 <1297274408.3016.29.camel@mulgrave.site>
	 <AANLkTimE1H=hos+YMW3Ge9vkETC9f1k1Dt6AMi5iLHGW@mail.gmail.com>
	 <1297350456.4933.25.camel@mulgrave.site>
	 <AANLkTinbsTuvRWQXt8ViTKaD+VbH9YG9X-RqzvsdEV_h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757588Ab1BKQGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2011 11:06:12 -0500
In-Reply-To: <AANLkTinbsTuvRWQXt8ViTKaD+VbH9YG9X-RqzvsdEV_h@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 10:52 +0100, Bartlomiej Zolnierkiewicz wrote:
> On Thu, Feb 10, 2011 at 4:07 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > On Thu, 2011-02-10 at 10:18 +0100, Bartlomiej Zolnierkiewicz wrote:
> >> On Wed, Feb 9, 2011 at 7:00 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> >> > On Wed, 2011-02-09 at 15:15 +0100, Bartlomiej Zolnierkiewicz wrote:
> >> >> Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
> >> >> config option) to allow disabling of scsi_devinfo infrastructure.
> >> >>
> >> >> The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=n
> >> >> (as measured on x86-32):
> >> >
> >> > I don't understand the point of this patch ... without the quirks SCSI
> >> > will do the wrong thing on a whole bunch of stuff.  The savings look to
> >> > be tiny ... since the SCSI module is habitually a lot larger than your
> >> > figures suggest.
> >>
> >> The patch was originally done for embedded ATA-only setups.
> >
> > Well, if it's for ATA only then the better course would be extracting
> > libata from scsi.  It's also a bit misleading to do sizings on x86,
> > because that doesn't imply embedded to me.  Aren't there still ATAPI
> > devices that require the quirks?
> 
> According to my knowledge all ATAPI quirks are handled locally in libata & sr.

Then look again: libata handles the transport quirks and sr handles the
capability quirks.  SCSI handles the protocol quirks.

> > Most embedded setups include some form of USB ... again, the pluggable
> > CD/DVD use the quirks table.
> 
> This was done long time ago specifically for embedded 486-like
> embedded system w/o USB support and only using flash storage but
> indeed this is not a common case.
> 
> > Given the potential for disaster even on embedded systems, I don't
> > really think something like this is a good idea.
> 
> Well, I don't insist on applying it upstream as it is, it is more to
> show the direction where the possible room for improvements is in case
> of older/embedded systems and reducing memory/code size usage.  [
> There were some concerns about it during recent proposal to use more
> generalized code for support of some rare Intel-like PATA chipsets
> (which seem to cost ~20k as measured on x86-64 in terms of additional
> memory/code requirements, though most such systems are x86-32 only so
> the incurred cost is probably smaller) .]
> 
> BTW with some effort we can do on-demand quirk table loading if it
> ever grows too big in the future.

But we already have that, if you look.  Part of what you're removing is
the proc interface that allows on demand loading.  If you just want the
ability to compile out the built in table and load everything from boot,
that's about a two line patch.

James


