From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: 16 Jul 2004 09:58:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089993519.7028.26.camel@patibmrh9>
References: <1089848082.3736.21.camel@patibmrh9><1089938380.3667.19.camel@p
	atibmrh9> <20040716122554.GD2025@suse.de><20040716122845.GE2025@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:21169 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266560AbUGPP6u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 11:58:50 -0400
In-Reply-To: <20040716122845.GE2025@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> cdrom_open ... transposing the two checks ...
> cdrom_decode_status ... set_disk_ro ... needs to go ... unless ...
> ide_cdrom_setup ...
> get_capabilities ... These are fine.

This e-mail ends with that four part patch you describe, thank you for
those clear instructions.

I also specifically confirmed that deleting rq_data_dir has no side
effect:

$ grep rq_data_dir include/linux/*
include/linux/blkdev.h:#define rq_data_dir(rq)          ((rq)->flags & 1)
$

> Now that CDC_RAM is a per-media capability flag, it doesn't make sense
> to set/clear it on every open when you can just return ok or not.

Agreed.

I had suggested always trying a fetch of mode page x2A "Capabilities"
before op x46 "GET CONFIGURATION" out of fear of legacy DVD/ CD choking
over the new op.

I see in the release early often spirit we can try simplifying our host
code first and waiting for someone to complain, maybe no one ever
actually will.

> > +			if (!CDROM_CAN(CDC_RAM))
> > +				goto err;
> ...
> >  			if (cdrom_open_write(cdi))
> ...
> This looks strange - 
> cdrom_open_write() is the one that checks whether 
> the media is suitable for writing or not

Agreed.

Me thinking like this is why I don't understand how CDC_RAM ever got set
in my patched PATAPI code.  But since we're abandoning CDC_RAM, I won't
analyse that mystery further, unless you tell me I should.

> Date: Fri, 16 Jul 2004 14:28:45 +0200
> Date: Fri, 16 Jul 2004 14:25:55 +0200

Ouch I was asleep then.  (: I need to route my e-mail to my phone. :)

Pat LaVarre

diff -urp linux-2.6.8-rc1/drivers/cdrom/cdrom.c linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c
--- linux-2.6.8-rc1/drivers/cdrom/cdrom.c	2004-07-13 08:26:02.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c	2004-07-16 09:40:22.765020896 -0600
@@ -897,10 +897,10 @@ int cdrom_open(struct cdrom_device_info 
 			goto err;
 		if (fp->f_mode & FMODE_WRITE) {
 			ret = -EROFS;
-			if (!CDROM_CAN(CDC_RAM))
-				goto err;
 			if (cdrom_open_write(cdi))
 				goto err;
+			if (!CDROM_CAN(CDC_RAM))
+				goto err;
 			ret = 0;
 		}
 	}
diff -urp linux-2.6.8-rc1/drivers/ide/ide-cd.c linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c
--- linux-2.6.8-rc1/drivers/ide/ide-cd.c	2004-07-13 08:26:05.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c	2004-07-16 09:37:07.613688408 -0600
@@ -785,14 +785,6 @@ static int cdrom_decode_status(ide_drive
 				do_end_request = 1;
 		} else if (sense_key == ILLEGAL_REQUEST ||
 			   sense_key == DATA_PROTECT) {
-			/*
-			 * check if this was a write protected media
-			 */
-			if (rq_data_dir(rq) == WRITE) {
-				printk("ide-cd: media marked write protected\n");
-				set_disk_ro(drive->disk, 1);
-			}
-
 			/* No point in retrying after an illegal
 			   request or data protect error.*/
 			ide_dump_status (drive, "command error", stat);
@@ -3248,9 +3240,8 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	nslots = ide_cdrom_probe_capabilities (drive);
 
 	/*
-	 * set correct block size and read-only for non-ram media
+	 * set correct block size
 	 */
-	set_disk_ro(drive->disk, !CDROM_CONFIG_FLAGS(drive)->ram);
 	blk_queue_hardsect_size(drive->queue, CD_FRAMESIZE);
 
 #if 0
diff -urp linux-2.6.8-rc1/drivers/scsi/sr.c linux-2.6.8-rc1-pel/drivers/scsi/sr.c
--- linux-2.6.8-rc1/drivers/scsi/sr.c	2004-07-13 08:26:16.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/scsi/sr.c	2004-07-15 14:29:34.000000000 -0600
@@ -775,9 +775,6 @@ static void get_capabilities(struct scsi
 		""
 	};
 
-	/* Set read only initially */
-	set_disk_ro(cd->disk, 1);
-
 	/* allocate a request for the TEST_UNIT_READY */
 	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
 	if (!SRpnt) {
@@ -885,7 +882,6 @@ static void get_capabilities(struct scsi
 	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM)) !=
 			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM)) {
 		cd->device->writeable = 1;
-		set_disk_ro(cd->disk, 0);
 	}
 
 	scsi_release_request(SRpnt);


