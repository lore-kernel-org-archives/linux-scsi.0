From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] [SCSI] sr: Fix multi-drive performance by using
 per-device mutexes
Date: Fri, 4 Jan 2013 20:50:27 +0100
Message-ID: <20130104205027.062c808a@stein>
References: <50E2F09A.6030606@sister-shadow.de>
	<50E61021.20709@sister-shadow.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51152 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3ADTvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2013 14:51:07 -0500
In-Reply-To: <50E61021.20709@sister-shadow.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Otto Meta <otto.kernel.02e4af24@sister-shadow.de>
Cc: linux-scsi@vger.kernel.org, Wakko Warner <wakko@animx.eu.org>

On Jan 04 Otto Meta wrote:
> Otto Meta wrote:
> > The single mutex for the sr module, introduced as a BKL replacement,
> > globally serialises all sr ioctls, which hurts multi-drive performance.
> > 
> > This patch replaces sr_mutex with per-device mutexes in struct scsi_cd,
> > allowing concurrent ioctls on different sr devices.
> 
> Unfortunately it wasn't as easy as that. The patch seems to introduce
> a race condition that corrupts a drive's state under certain circumstances.
> 
> When two drives (e.g. sr0 and sr1) are attached to the same IDE cable, one
> drive has its door locked, which will usually be the case after any operation
> on the drive with inserted media (and whenever it feels like it, even with
> dev.cdrom.lock=0), and the other drive is unlocked, then executing
> 
>   $ eject sr0 & eject sr1
> 
> will eject the unlocked drive and the locked drive will return
> 
>   eject: unable to eject, last error: Inappropriate ioctl for device
> 
> 
> Other drivers down the road probably don't expect concurrent ioctls, so this
> patch cannot be applied safely at this time. Sorry about the noise.
> 
> For the record: Tested with kernels 3.2.35 and 3.8.0-rc1, using IDE CD/DVD
> drives connected via the drivers ata_piix and pata_pdc202xx_old.

As yo may have seen in the mailinglist archive, when Wakko and I tested
with sr_mutex removed without any replacement, we were not able to trigger
any race condition.  However, we certainly did not attempt this very
particular test (two drives on the same PATA cable, one locked and one
unlocked, and "eject" called on both of them at the same time).  I wonder
if this is a PATA idiosyncrasy.

I will see whether I can do some tests tomorrow.  I can easily test master
and slave PATA drives on a single cable behind a PATA-to-1394 bridge; but
testing two drives on a single cable behind a PATA-to-PCI controller would
be a bit more involved because the case of my PATA-equipped Linux PC is
rather cramped.
-- 
Stefan Richter
-=====-===-= ---= --=--
http://arcgraph.de/sr/
