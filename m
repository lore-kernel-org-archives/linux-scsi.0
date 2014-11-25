From: Tim Small <tim@seoss.co.uk>
Subject: [PATCH 0/4] Fix performance burning or extracting audio etc. from multiple optical drives.
Date: Tue, 25 Nov 2014 14:09:18 +0000
Message-ID: <1416924562-16849-1-git-send-email-tim@seoss.co.uk>
References: <20141121100210.GC8866@infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecuredomains.com ([78.47.234.210]:51603 "EHLO
	relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbaKYOyN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 09:54:13 -0500
In-Reply-To: <20141121100210.GC8866@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tim@buttersideup.com, Christoph Hellwig <hch@infradead.org>
Cc: Tim Small <tim@seoss.co.uk>, Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>

Fix performance burning or extracting audio etc. from multiple optical
drives.

Patches are against 3.18.0-rc6+

Currently each CDROM driver uses it's own per-driver mutex to protect
non-thread-safe code within their ioctl paths.

These per-driver mutexes were created during the removal of the BKL.

An in-progress ioctl on one optical drive will force an ioctl on
another optical drive in the same system to block (as long as both
drives use the same driver e.g. sr_mod).

Since user-space programs which carry out tasks such as recording
data, or reading raw audio must use ioctls to do-so, this makes it
impractical to carry out more than one such operation simultaneosly
on systems with multiple optical drives (e.g. record two DVDs at the
same time, and/or extract raw audio data from two CDs simultaneously).

The calls scsi_ioctl() and related now happen without any locking, as
these are thread-safe (e.g. as called by sd.c or sg.c).

With these patches applied, the time to simultaneously extract audio
from 10 CDs, using the 'cdparanoia' utility, reduced more than 100
fold from around 18 hours to 10 minutes.

I've only done little bits and bobs of driver development in the past,
so hopefully this first attempt isn't too far of the mark...

I've tested the IDE and SCSI subsystem patches, but I don't have any
paride, or GDROM hardware (however the changes which are specific to
these two are trivial).

Cheers,

Tim.


Tim Small (4):
  enable cdrom_ioctl() to be called without holding ex-BKL mutexes
  Remove ex-BKL lock from ioctl path; fix simultaneous record on >1
    drive
  Remove ex-BKL lock from ioctl path; fix simultaneous record on >1
    drive
  Remove ex-BKL lock from ioctl path; fix simultaneous record on >1
    drive

 drivers/block/paride/pcd.c |  8 +----
 drivers/cdrom/cdrom.c      | 86 +++++++++++++++++++++++++++++++---------------
 drivers/cdrom/gdrom.c      |  8 +----
 drivers/ide/ide-cd.c       | 42 ++++++++++------------
 drivers/scsi/sr.c          | 14 +++-----
 include/linux/cdrom.h      |  1 +
 6 files changed, 85 insertions(+), 74 deletions(-)

-- 
2.1.3

