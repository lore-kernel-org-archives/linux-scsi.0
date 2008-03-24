From: Greg KH <greg@kroah.com>
Subject: Re: What should be done with wrong warning "please use bus_type
	methods." on sd, sr, st and osst?
Date: Mon, 24 Mar 2008 10:59:22 -0700
Message-ID: <20080324175922.GB13816@kroah.com>
References: <47E7B40D.1000509@tremplin-utc.net> <1206372247.3494.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45900 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYCXRyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Mar 2008 13:54:03 -0400
Content-Disposition: inline
In-Reply-To: <1206372247.3494.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>, linux-scsi@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>, Tilman Schmidt <tilman@imap.cc>, Kay Sievers <kay.sievers@vrfy.org>

On Mon, Mar 24, 2008 at 10:24:07AM -0500, James Bottomley wrote:
> 
> On Mon, 2008-03-24 at 15:00 +0100, Eric Piel wrote:
> > Since commit 751bf4d7865e4ced406be93b04c7436d866d3684 (scsi_sysfs: 
> > restore prep_fn when ULD is removed), the warning "Driver '%s' needs 
> > updating - please use bus_type methods." is generated for several scsi 
> > drivers (sr, sg, st and osst). It does so because it thinks that the 
> > driver remove() functions will not be called (cf 
> > __device_release_driver()). Actually, they are called by scsi_bus_remove().
> > 
> > This has been noted already a couple of times [1] [2] [3], but it seems 
> > absolutely nothing conclusive came out of the reports.
> > 
> > What should be done? Delete the warning? Change it so it doesn't get 
> > triggered if drv->bus->remove == scsi_bus_remove? Merge 
> > scsi_bus_remove() into the driver remove() functions? Disregard the 
> > monthly warming reports?
> 
> At least for SCSI, the warning is wrong .. the drivers are properly
> converted.  The issue that triggers the warning is that we use the
> bus_type power management methods to receive the notifies in the
> mid-layer (where we do mid-layer specific stuff) then we notify the
> drivers through the driver power management methods.
> 
> A solution would be to duplicate the power management methods in the
> scsi_driver structure, but this is a complete waste of space since the
> generic driver ones aren't going away (at least according to Kay and
> Greg).  I still think the best thing to do is just to turn off this
> spurious warning.

Do you have a patch that can detect the usage that you currently have so
that I can change the warning message to not trigger if things are set
up that way instead?

thanks,

greg k-h
