From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH: scsi-sd-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 10:48:15 -0600
Message-ID: <1200847695.3105.12.camel@localhost.localdomain>
References: <47931E8A.60905@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34310 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298AbYATQsV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jan 2008 11:48:21 -0500
In-Reply-To: <47931E8A.60905@hhs.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Guillaume Bedot <littletux@zarb.org>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, David Brown <usb-storage2@davidb.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org


On Sun, 2008-01-20 at 11:12 +0100, Hans de Goede wrote:
> Hi all,
> 
> This patch adds a new scsi_device flag for devices which contain a bug where
> the device crashes when the last sector is read in a larger then 1 sector read.
> 
> This is for example the case with sdcards in the HP PSC1350 printer cardreader
> and in the HP PSC1610 printer cardreader.
> 
> Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

This could have done with running through checkpatch.pl:

ERROR: trailing whitespace
#28: FILE: drivers/scsi/sd.c:398:
+^I/* $

ERROR: trailing whitespace
#32: FILE: drivers/scsi/sd.c:402:
+^Iif (unlikely(sdp->last_sector_bug && $

WARNING: braces {} are not necessary for single statement blocks
#32: FILE: drivers/scsi/sd.c:402:
+       if (unlikely(sdp->last_sector_bug && 
+           rq->nr_sectors > sdp->sector_size / 512 &&
+           block + this_count == get_capacity(disk))) {
+               this_count -= sdp->sector_size / 512;
+       }

ERROR: use tabs not spaces
#34: FILE: drivers/scsi/sd.c:404:
+ ^I    block + this_count == get_capacity(disk))) {$

WARNING: line over 80 characters
#49: FILE: include/scsi/scsi_device.h:142:
+       unsigned last_sector_bug:1;     /* Always read last sector in a
1 sector read */

total: 3 errors, 2 warnings, 23 lines checked

I've fixed all of these up.

James


