From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: [PATCH] [SCSI] sr: Fix multi-drive performance by using
 per-device mutexes
Date: Fri, 4 Jan 2013 16:26:46 -0500
Message-ID: <20130104212646.GA18875@animx.eu.org>
References: <50E2F09A.6030606@sister-shadow.de>
 <50E61021.20709@sister-shadow.de>
 <20130104205027.062c808a@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:46629 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab3ADVqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jan 2013 16:46:47 -0500
Content-Disposition: inline
In-Reply-To: <20130104205027.062c808a@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Otto Meta <otto.kernel.02e4af24@sister-shadow.de>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> On Jan 04 Otto Meta wrote:
> > Otto Meta wrote:
> > > The single mutex for the sr module, introduced as a BKL replacement,
> > > globally serialises all sr ioctls, which hurts multi-drive performance.
> > > 
> > > This patch replaces sr_mutex with per-device mutexes in struct scsi_cd,
> > > allowing concurrent ioctls on different sr devices.
> > 
> > Unfortunately it wasn't as easy as that. The patch seems to introduce
> > a race condition that corrupts a drive's state under certain circumstances.
> > 
> > When two drives (e.g. sr0 and sr1) are attached to the same IDE cable, one
> > drive has its door locked, which will usually be the case after any operation
> > on the drive with inserted media (and whenever it feels like it, even with
> > dev.cdrom.lock=0), and the other drive is unlocked, then executing
> > 
> >   $ eject sr0 & eject sr1
> > 
> > will eject the unlocked drive and the locked drive will return
> > 
> >   eject: unable to eject, last error: Inappropriate ioctl for device
> > 
> > 
> > Other drivers down the road probably don't expect concurrent ioctls, so this
> > patch cannot be applied safely at this time. Sorry about the noise.
> > 
> > For the record: Tested with kernels 3.2.35 and 3.8.0-rc1, using IDE CD/DVD
> > drives connected via the drivers ata_piix and pata_pdc202xx_old.
> 
> As yo may have seen in the mailinglist archive, when Wakko and I tested
> with sr_mutex removed without any replacement, we were not able to trigger
> any race condition.  However, we certainly did not attempt this very
> particular test (two drives on the same PATA cable, one locked and one
> unlocked, and "eject" called on both of them at the same time).  I wonder
> if this is a PATA idiosyncrasy.
> 
> I will see whether I can do some tests tomorrow.  I can easily test master
> and slave PATA drives on a single cable behind a PATA-to-1394 bridge; but
> testing two drives on a single cable behind a PATA-to-PCI controller would
> be a bit more involved because the case of my PATA-equipped Linux PC is
> rather cramped.

I myself have not tried this specific test.  I do not have any systems with
2 PATA DVDroms on the same cable.  The only system I have that has PATA, the
drives are on seperate cables with nothing else on the cable.  My other
system is all SATA.  I have no other systems with more than 1 CD/DVD drive.
