From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: 14 Jul 2004 17:34:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089848082.3736.21.camel@patibmrh9>
References: <1089741428.3806.3.camel@patibmrh9><1089752141.3786.3.camel@pati
	bmrh9>  <20040714054133.GI3055@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:1430 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265065AbUGNXeq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 19:34:46 -0400
In-Reply-To: <20040714054133.GI3055@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> > --- linux-2.6.8-rc1/drivers/ide/ide-cd.c      2004-07-13 08:26:05.000000000 -0600
> > +++ linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c  2004-07-13 14:33:40.000000000 -0600
> > @@ -3251,6 +3251,7 @@ int ide_cdrom_setup (ide_drive_t *drive)
> >        * set correct block size and read-only for non-ram media
> >        */
> >       set_disk_ro(drive->disk, !CDROM_CONFIG_FLAGS(drive)->ram);
> > +     set_disk_ro(drive->disk, 0);
> 
> Trace that backwards and find out why ->ram isn't getting set.

An answer to that helpfully concrete question is:

2.6.8-rc1 differs from 2.6.7 by lacking the three-line patch below.

Back in the ide_cdrom_probe_capabilities of 2.6.7, we were saying any
drive that offered "feature" x0020 "Random Writable" was set_disk_ro
rewritable.  Now in 2.6.8-rc1 we accept only:

        cap.dvd_ram_write || (drive->media == ide_optical)

That criterion denies the rewritability of the drive I'm testing i.e.
the "Iomega" "RRD" drive.

I'd like Linux to perceive the reality that RRD discs are as rewritable
as DVD RAM discs are - can I help further?

Pat LaVarre

--- linux-2.6.8-rc1/drivers/ide/ide-cd.c	2004-07-13 08:26:05.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c	2004-07-14 17:00:28.000000000 -0600
@@ -2925,7 +2925,7 @@ int ide_cdrom_probe_capabilities (ide_dr
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *cdi = &info->devinfo;
 	struct atapi_capabilities_page cap;
-	int nslots = 1;
+	int nslots = 1, ram_write = 0;
 
 	if (drive->media == ide_optical) {
 		CDROM_CONFIG_FLAGS(drive)->mo_drive = 1;
@@ -2954,6 +2954,10 @@ int ide_cdrom_probe_capabilities (ide_dr
 	if (ide_cdrom_get_capabilities(drive, &cap))
 		return 0;
 
+	if (!cdrom_is_random_writable(cdi, &ram_write))
+		if (ram_write)
+			CDROM_CONFIG_FLAGS(drive)->ram = 1;
+
 	if (cap.lock == 0)
 		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
 	if (cap.eject)


