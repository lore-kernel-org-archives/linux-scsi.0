From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 24 Nov 2010 10:10:29 +0000
Message-ID: <1290593429.14652.33.camel@mulgrave.site>
References: <549123.75632.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab0KXKKg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Nov 2010 05:10:36 -0500
In-Reply-To: <549123.75632.qm@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>

On Wed, 2010-11-24 at 01:02 -0800, Luben Tuikov wrote:
> I doubt this as very unlikely. Has anyone actually seen a device that
> sends mode parameter data with faux Caching mode page or corrupted
> data that is in fact interpreted as a Caching mode page? Is such a
> device fully operational sans the faux Caching mode page, or does it
> just not work? Is it common to have devices having a faux Caching mode
> page or corrupted mode parameter data resulting in a Caching mode page
> with random data?
> 
> Undoubtedly, as the usb-storage maintainer, you must have variety of
> devices, some broken some not. Could you apply this patch to your tree
> and test some of the devices you have? My tests indicate a stable
> behavior.

The basic problem isn't devices lying ... the worst we'll do is current
behaviour (not SYNC when we should).  The problem is devices that get
confused (or worse simply crash the firmware).  The best way to avoid
the crashing firmware problem ... if we can assume that modern USB
devices are better is to key off the SCSI version.  Unfortunately, in
spite of several attempts, we've never managed to stop usbstorage lying
about this:

		/* Some devices report a SCSI revision level above 2 but are
		 * unable to handle the REPORT LUNS command (for which
		 * support is mandatory at level 3).  Since we already have
		 * a Get-Max-LUN request, we won't lose much by setting the
		 * revision level down to 2.  The only devices that would be
		 * affected are those with sparse LUNs. */
		if (sdev->scsi_level > SCSI_2)
			sdev->sdev_target->scsi_level =
					sdev->scsi_level = SCSI_2;

Untangling all of this would be rather complex, I fear.

The final question is is it worth it?  Since USB devices are supposed to
be hot unpluggable, surely a USB device with a write back cache would be
a disaster: no-one will SYNC the cache on a surprise unplug anyway ...
therefore there shouldn't really be any of them surviving in the wild
(famous last words, I suppose).

James


