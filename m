From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG: SCSI: usb storage SDHC card doesn't work in 2.6.27-rc1
Date: Wed, 30 Jul 2008 10:15:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807301014420.2584-100000@iolanthe.rowland.org>
References: <1217390922.6103.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54814 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753308AbYG3OPv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 10:15:51 -0400
In-Reply-To: <1217390922.6103.79.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Frost <artusemrys@yahoo.com>, linux-kernel@vger.kernel.org, Matt Frost <artusemrys@sbcglobal.net>, linux-scsi <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Tue, 29 Jul 2008, James Bottomley wrote:

> > Summary:
> > Between 2.6.26-rc9-git10 and rc9-git11, the kernel stopped properly
> > recognizing my USB-card-reader-mounted SDHC 4GB card.  The problem seems to
> > come up between usb-storage recognizing the device, and the handoff to scsi
> > to read the disk properties.  The bug remains in 2.6.26 and 2.6.27-rc1;
> > kernels before 2.6.26-rc9-git10 are unaffected.  On the same EHCI controller,
> > an old-spec SD 1GB card and its reader are unaffected by this bug.

> > After the bug, initialization looks the same until the device scan finishes. 
> > Handoff to scsi produces the following (taken from rc9-git12):

> > sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> > sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> > sd 5:0:0:0: [sdf] Write Protect is off
> > sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> > sd 5:0:0:0: [sdf] Assuming drive cache: write through
> > sd 5:0:0:0: [sdf] Sector size 0 reported, assuming 512.
> > sd 5:0:0:0: [sdf] 1 512-byte hardware sectors (0 MB)
> > sd 5:0:0:0: [sdf] Write Protect is off
> > sd 5:0:0:0: [sdf] Mode Sense: 4b 00 00 08
> > sd 5:0:0:0: [sdf] Assuming drive cache: write through
> >  sdf: sdf1
> >  sdf: p1 exceeds device capacity
> > sd 5:0:0:0: [sdf] Attached SCSI removable disk
> > sd 5:0:0:0: Attached scsi generic sg7 type 0

The problem will most likely be fixed by this patch:

	http://marc.info/?l=linux-usb&m=121734710306509&w=2

Alan Stern

