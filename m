From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: 15 Jul 2004 18:39:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089938380.3667.19.camel@patibmrh9>
References: <1089741428.3806.3.camel@patibmrh9><1089752141.3786.3.camel@pati
	bmrh9>  <20040714054133.GI3055@suse.de><1089848082.3736.21.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:2214 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266474AbUGPAjw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2004 20:39:52 -0400
In-Reply-To: <1089848082.3736.21.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

Annihilating the calls to set_disk_ro from scsi/sr.c and ide/ide-cd.c
withdraws blanket write protection from all USB/ PATAPI etc. DVD/ CD
devices, and instead gives to all DVD/ CD only the late, open-time,
distinction between rewritable and read-only discs.

For example, with this patch applied, I see:

$ sudo blockdev --getro /dev/hdd /dev/scd0
0
0
$
$ sudo dd of=/dev/hdd bs=64K seek=0 count=1 if=/dev/zero
dd: opening `/dev/hdd': Read-only file system
$
$ # eject read-only disc, insert rewritable disc
$
$ sudo dd of=/dev/hdd bs=64K seek=0 count=1 if=/dev/zero
1+0 records in
1+0 records out
$

As expected, I saw exactly the same results with USB /dev/scd0 as with
the PATAPI /dev/hdd shown above.

Do you like this behaviour better than what we have now in 2.6.8-rc1?

(I do, because USB and PATAPI come into agreement with each other, and
because Iomega RRD discs correctly become rewritable by default.)

This idea, kindly suggested to me offline, is enough simpler than
learning to call set_disk_ro after each disc change that I am able to
propose the specific patch quoted inline below.

In this patch you will see four parts, to give you two choices I thought
you might like to consider.

1) The first part changes cdrom_open to check CDC_RAM earlier in an
FMODE_WRITE open i.e. before open_for_data.  I'm asking you to choose to
check earlier or not.

2) The second part draws your attention to a set_disk_ro I actually did
not delete.  That remaining set_disk_ro dynamically forces ro true in
response to particular write errors.  The /* != scsi/sr.c */ text of the
comment I used to draw you attention to that source line means to say
that this is an asymmetry between ide/ide-cd.c and scsi/sr.c, in that
only ide/ide-cd.c works this hard.  I'm asking you to choose to delete
that call to set_disk_ro, to comment on its asymmetry, or to leave it
unchanged.

3, 4) The last two parts of the patch merely delete the once-per-plugin
calls to set_disk_ro.

Pat LaVarre

diff -urp linux-2.6.8-rc1/drivers/cdrom/cdrom.c linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c
--- linux-2.6.8-rc1/drivers/cdrom/cdrom.c	2004-07-13 08:26:02.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c	2004-07-15 18:21:48.564652904 -0600
@@ -892,13 +892,16 @@ int cdrom_open(struct cdrom_device_info 
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS)) {
 		ret = cdi->ops->open(cdi, 1);
 	} else {
+		if (fp->f_mode & FMODE_WRITE) {
+			ret = -EROFS;
+			if (!CDROM_CAN(CDC_RAM))
+				goto err;
+		}
 		ret = open_for_data(cdi);
 		if (ret)
 			goto err;
 		if (fp->f_mode & FMODE_WRITE) {
 			ret = -EROFS;
-			if (!CDROM_CAN(CDC_RAM))
-				goto err;
 			if (cdrom_open_write(cdi))
 				goto err;
 			ret = 0;
diff -urp linux-2.6.8-rc1/drivers/ide/ide-cd.c linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c
--- linux-2.6.8-rc1/drivers/ide/ide-cd.c	2004-07-13 08:26:05.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c	2004-07-15 14:38:23.000000000 -0600
@@ -790,7 +790,7 @@ static int cdrom_decode_status(ide_drive
 			 */
 			if (rq_data_dir(rq) == WRITE) {
 				printk("ide-cd: media marked write protected\n");
-				set_disk_ro(drive->disk, 1);
+				set_disk_ro(drive->disk, 1); /* != scsi/sr.c */
 			}
 
 			/* No point in retrying after an illegal
@@ -3248,9 +3248,8 @@ int ide_cdrom_setup (ide_drive_t *drive)
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


