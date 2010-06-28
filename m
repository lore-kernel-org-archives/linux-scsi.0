From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH RFC] support sata odd zero power
Date: Mon, 28 Jun 2010 08:42:11 -0500
Message-ID: <1277732531.10879.7.camel@mulgrave.site>
References: <AANLkTimajvNh3frP9LcytXUhFAGk1gB52wa0LlGe0ZS0@mail.gmail.com>
	 <1277474478.5234.98.camel@mulgrave.site>
	 <AANLkTinKcEEj9Se_BBaDdYDLCaOLPXD66a22n4Hea4Bt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab0F1NmR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2010 09:42:17 -0400
In-Reply-To: <AANLkTinKcEEj9Se_BBaDdYDLCaOLPXD66a22n4Hea4Bt@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: su henry <henry.su.ati@gmail.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, htejun <htejun@gmail.com>

On Mon, 2010-06-28 at 15:35 +0800, su henry wrote:
> On Fri, Jun 25, 2010 at 10:01 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > On Fri, 2010-06-25 at 18:15 +0800, su henry wrote:
> >> From b221e73b802ccfe5338b575dc0ff3b687acdd6fa Mon Sep 17 00:00:00 2001
> >> From: henry su <henry.su.ati@gmail.com>
> >> Date: Fri, 25 Jun 2010 00:08:42 +0800
> >> Subject: [PATCH RFC] support sata odd zero power
> >>
> >> In order to extend the battery life of Mobile PC system, the host should remove
> >> the power supply to the Optical Disc Drive (logical unit) when it detects the
> >> logical unit with no media and tray closed, and the host starts the power
> >> supply to the logical unit when it detects user action to the logical unit that
> >> the power supply is omitted.
> >
> >> The patch evaluates the _PS3 method to remove the power supply to the ODD if
> >> the host detects MEDIUM NOT PRESENT - TRAY CLOSED is reported by REQUEST SENSE
> >> command for a Drawer, Tray or Pop-up type drive, or MEDIUM NOT PRESENT -
> >> TRAY CLOSED for a slot/caddy type drive; on the other hand, the patch evaluates
> >> the _PS0 method to restart the power supply to the ODD when the user
> >> presses the
> >> button on a tray type drive or inserts a CD to a slot/caddy type drive.
> >>
> >> PLDS DS-8A5S, pansonic UJ892 and UJ897 are the ODD samples used to test
> >> the patch on AMD SB800 platforms.
> >>
> >> Signed-off-by: Henry Su <henry.su.ati@gmail.com>
> >
> > The first observation I'd have is a big meta one:  This all needs to
> > work on non ACPI systems ... given that it relies on unstubbed ACPI
> > functions, I don't think it does, does it?
> >
> > What I'd suggest is confining it all to sr_acpi.c and hooking it in to
> > the test unit ready and init/exit ... that way the code only need be
> > present if ACPI is.
> 
> Yes, it only works on a systems that supports ACPI functions, and that
> system BIOS provides the _PS0/_PS3 method to start/stop the power
> supply.
> 
> Besides a new driver to support the zero power odd, another suggestion
> is adding the "#ifdef CONFIG_ACPI" in sr.c to separate the code.

I didn't say add a new driver, I said add a new file to the existing
driver ... it's already split into multiple files.  That way there's no
need to litter #ifdef CONFIG_ACPI to make this compile.

James


