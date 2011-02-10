From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: make scsi_devinfo infrastructure optional
Date: Thu, 10 Feb 2011 09:07:36 -0600
Message-ID: <1297350456.4933.25.camel@mulgrave.site>
References: <201102091515.16202.bzolnier@gmail.com>
	 <1297274408.3016.29.camel@mulgrave.site>
	 <AANLkTimE1H=hos+YMW3Ge9vkETC9f1k1Dt6AMi5iLHGW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimE1H=hos+YMW3Ge9vkETC9f1k1Dt6AMi5iLHGW@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-02-10 at 10:18 +0100, Bartlomiej Zolnierkiewicz wrote:
> On Wed, Feb 9, 2011 at 7:00 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> > On Wed, 2011-02-09 at 15:15 +0100, Bartlomiej Zolnierkiewicz wrote:
> >> Add SCSI_QUIRKS config option (default y and dependent on EMBEDDED
> >> config option) to allow disabling of scsi_devinfo infrastructure.
> >>
> >> The output code size savings are ~14k for CONFIG_SCSI_QUIRKS=n
> >> (as measured on x86-32):
> >
> > I don't understand the point of this patch ... without the quirks SCSI
> > will do the wrong thing on a whole bunch of stuff.  The savings look to
> > be tiny ... since the SCSI module is habitually a lot larger than your
> > figures suggest.
> 
> The patch was originally done for embedded ATA-only setups.

Well, if it's for ATA only then the better course would be extracting
libata from scsi.  It's also a bit misleading to do sizings on x86,
because that doesn't imply embedded to me.  Aren't there still ATAPI
devices that require the quirks?

Most embedded setups include some form of USB ... again, the pluggable
CD/DVD use the quirks table.

Given the potential for disaster even on embedded systems, I don't
really think something like this is a good idea.

James
