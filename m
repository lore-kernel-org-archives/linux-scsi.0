From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] until blockdev --setrw /dev/scd$n works
Date: 05 Dec 2003 18:24:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070673881.2939.20.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:30873 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264887AbTLFBYx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 20:24:53 -0500
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, patmans@us.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I say, as yet, `blockdev --setrw /dev/scd$n` does not work as well as
`blockdev --setrw /dev/hd$v`.

Do you agree?

Do you agree we (e.g. I) should fix that?

Here I show only the very very little I may know so far i.e. Where the
FIXME comments should go, not yet what to substitute for those FIXME
comments.

Pat LaVarre

diff -Nurp linux-2.6.0-test11/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.6.0-test11/drivers/ide/ide-cd.c	2003-11-26 13:43:50.000000000 -0700
+++ linux/drivers/ide/ide-cd.c	2003-12-05 17:34:01.000000000 -0700
@@ -3211,8 +3211,9 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	nslots = ide_cdrom_probe_capabilities (drive);
 
-	if (CDROM_CONFIG_FLAGS(drive)->dvd_ram)
-		set_disk_ro(drive->disk, 0);
+	set_disk_ro(drive->disk, 0);
+	if (!CDROM_CONFIG_FLAGS(drive)->dvd_ram)
+		printk("lk 2.5 ide-cd.c would refuse write\n");
 
 #if 0
 	drive->dsc_overlap = (HWIF(drive)->no_dsc) ? 0 : 1;
diff -Nurp linux-2.6.0-test11/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test11/drivers/scsi/sr.c	2003-11-26 13:43:25.000000000 -0700
+++ linux/drivers/scsi/sr.c	2003-12-05 17:34:17.000000000 -0700
@@ -328,7 +328,7 @@ static int sr_init_command(struct scsi_c
 
 	if (rq_data_dir(SCpnt->request) == WRITE) {
 		if (!cd->device->writeable)
-			return 0;
+			printk("lk 2.5 sr.c would refuse write\n");
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
diff -Nurp linux-2.6.0-test11/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test11/drivers/cdrom/cdrom.c	2003-11-26 13:43:07.000000000 -0700
+++ linux/drivers/cdrom/cdrom.c	2003-12-05 17:33:49.000000000 -0700
@@ -427,7 +427,7 @@ int cdrom_open(struct cdrom_device_info 
 		ret = cdi->ops->open(cdi, 1);
 	else {
 		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
-			return -EROFS;
+			printk("lk 2.5 cdrom.c would refuse write\n");
 
 		ret = open_for_data(cdi);
 	}


