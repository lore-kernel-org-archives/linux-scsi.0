From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: What should be done with wrong warning "please use bus_type
	methods." on sd, sr, st and osst?
Date: Mon, 24 Mar 2008 10:24:07 -0500
Message-ID: <1206372247.3494.22.camel@localhost.localdomain>
References: <47E7B40D.1000509@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48298 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758997AbYCXPYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 11:24:12 -0400
In-Reply-To: <47E7B40D.1000509@tremplin-utc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: linux-scsi@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>, Tilman Schmidt <tilman@imap.cc>, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>


On Mon, 2008-03-24 at 15:00 +0100, Eric Piel wrote:
> Since commit 751bf4d7865e4ced406be93b04c7436d866d3684 (scsi_sysfs: 
> restore prep_fn when ULD is removed), the warning "Driver '%s' needs 
> updating - please use bus_type methods." is generated for several scsi 
> drivers (sr, sg, st and osst). It does so because it thinks that the 
> driver remove() functions will not be called (cf 
> __device_release_driver()). Actually, they are called by scsi_bus_remove().
> 
> This has been noted already a couple of times [1] [2] [3], but it seems 
> absolutely nothing conclusive came out of the reports.
> 
> What should be done? Delete the warning? Change it so it doesn't get 
> triggered if drv->bus->remove == scsi_bus_remove? Merge 
> scsi_bus_remove() into the driver remove() functions? Disregard the 
> monthly warming reports?

At least for SCSI, the warning is wrong .. the drivers are properly
converted.  The issue that triggers the warning is that we use the
bus_type power management methods to receive the notifies in the
mid-layer (where we do mid-layer specific stuff) then we notify the
drivers through the driver power management methods.

A solution would be to duplicate the power management methods in the
scsi_driver structure, but this is a complete waste of space since the
generic driver ones aren't going away (at least according to Kay and
Greg).  I still think the best thing to do is just to turn off this
spurious warning.

James


