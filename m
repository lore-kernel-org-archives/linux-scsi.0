From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] retire CDC_RAM
Date: 16 Jul 2004 11:28:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089998933.3781.6.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:25798 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266610AbUGPR3E
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 13:29:04 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

> > > I have no time myself these days.

For if/ when you choose to pursue your idea of retiring CDC_RAM ...

> > Subject: Re: open write failure not predicted by blockdev getro
> > Subject: Re: [PATCH] fix cdrom mt rainier probe
> ...
> we should probably just drop CDC_RAM again and
> just let cdrom_open_write() return whether we
> are allowed to open the media for write or not.
> Now that CDC_RAM is a per-media capability
> flag, it doesn't make sense to set/clear it on
> every open when you can just return ok or not.

This patch works for me with r/w and r/o Iomega REV discs, YMMV with
other more massively distributed devices.

This patch is incremental, created in 2.6.8-rc1 after applying:

Subject: Re: [PATCH] fix cdrom mt rainier probe
http://marc.theaimsgroup.com/?l=linux-scsi&m=108999477700527

In this patch you can see CDC_RAM has existed long enough that removing
CDC_RAM now requires us to change:

a) when cdrom_open_write decides to try cdrom_ram_open_write
b) when cdrom_open decides to believe cdrom_open_write
c) when cdrom_release decides to try cdrom_close_write
d) which distinctions among devices cdrom_sysctl_info reports
e) how scsi/sr.c decides cd->device->writeable

You can see the changes I've drafted here are to brutally remove all
guards.

Pat LaVarre

P.S. scsi ->writeable looks useless to me.

After removing CDC_RAM, I see no kernel.org code that uses ->writeable,
except for scsi/sd.c.  And there I'm thinking we'll find ->writeable set
always, since no one ever changes ->writeable, except that scsi_add_lun
explicitly sets ->writeable for x00 TYPE_DISK and every other PDT
excepting only x04 TYPE_WORM, x05 TYPE_ROM, and default.

diff -urp /home/pat/k/o/include/linux/cdrom.h linux-2.6.8-rc1-pel/include/linux/cdrom.h
--- /home/pat/k/o/include/linux/cdrom.h	2004-07-16 10:22:12.000000000 -0600
+++ linux-2.6.8-rc1-pel/include/linux/cdrom.h	2004-07-16 10:26:27.000000000 -0600
@@ -389,7 +389,7 @@ struct cdrom_generic_command
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
 #define CDC_MRW			0x80000 /* drive can read MRW */
 #define CDC_MRW_W		0x100000 /* drive can write MRW */
-#define CDC_RAM			0x200000 /* ok to open for WRITE */
+/* fine CDC_RAM			0x200000 // ok to open for WRITE */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
diff -urp /home/pat/k/o/drivers/cdrom/cdrom.c linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c
--- /home/pat/k/o/drivers/cdrom/cdrom.c	2004-07-16 10:22:12.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c	2004-07-16 10:31:21.000000000 -0600
@@ -696,22 +696,6 @@ int cdrom_has_defect_mgt(struct cdrom_de
 }
 
 
-int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
-{
-	struct rwrt_feature_desc rfd;
-	int ret;
-
-	*write = 0;
-
-	if ((ret = cdrom_get_random_writable(cdi, &rfd)))
-		return ret;
-
-	if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
-		*write = 1;
-
-	return 0;
-}
-
 static int cdrom_media_erasable(struct cdrom_device_info *cdi)
 {
 	disc_information di;
@@ -826,15 +810,13 @@ static int cdrom_ram_open_write(struct c
  */
 static int cdrom_open_write(struct cdrom_device_info *cdi)
 {
-	int mrw, mrw_write, ram_write;
+	int mrw, mrw_write;
 	int ret = 1;
 
 	mrw = 0;
 	if (!cdrom_is_mrw(cdi, &mrw_write))
 		mrw = 1;
 
-	(void) cdrom_is_random_writable(cdi, &ram_write);
-
 	if (mrw)
 		cdi->mask &= ~CDC_MRW;
 	else
@@ -845,20 +827,14 @@ static int cdrom_open_write(struct cdrom
 	else
 		cdi->mask |= CDC_MRW_W;
 
-	if (ram_write)
-		cdi->mask &= ~CDC_RAM;
-	else
-		cdi->mask |= CDC_RAM;
-
 	if (CDROM_CAN(CDC_MRW_W))
 		ret = cdrom_mrw_open_write(cdi);
 	else if (CDROM_CAN(CDC_DVD_RAM))
 		ret = cdrom_dvdram_open_write(cdi);
- 	else if (CDROM_CAN(CDC_RAM) &&
- 		 !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_MRW))
- 		ret = cdrom_ram_open_write(cdi);
 	else if (CDROM_CAN(CDC_MO_DRIVE))
 		ret = mo_open_write(cdi);
+ 	else
+ 		ret = cdrom_ram_open_write(cdi);
 
 	return ret;
 }
@@ -899,8 +875,6 @@ int cdrom_open(struct cdrom_device_info 
 			ret = -EROFS;
 			if (cdrom_open_write(cdi))
 				goto err;
-			if (!CDROM_CAN(CDC_RAM))
-				goto err;
 			ret = 0;
 		}
 	}
@@ -1104,7 +1078,7 @@ int cdrom_release(struct cdrom_device_in
 	/*
 	 * flush cache on last write release
 	 */
-	if (CDROM_CAN(CDC_RAM) && !cdi->use_count && cdi->for_data)
+	if (!cdi->use_count && cdi->for_data)
 		cdrom_close_write(cdi);
 
 	cdo->release(cdi);
@@ -2909,7 +2883,6 @@ EXPORT_SYMBOL(cdrom_mode_sense);
 EXPORT_SYMBOL(init_cdrom_command);
 EXPORT_SYMBOL(cdrom_get_media_event);
 EXPORT_SYMBOL(cdrom_is_mrw);
-EXPORT_SYMBOL(cdrom_is_random_writable);
 
 #ifdef CONFIG_SYSCTL
 
@@ -3014,10 +2987,6 @@ int cdrom_sysctl_info(ctl_table *ctl, in
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MRW_W) != 0);
 
-	pos += sprintf(info+pos, "\nCan write RAM:\t");
-	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
-	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_RAM) != 0);
-
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
diff -urp /home/pat/k/o/drivers/ide/ide-cd.c linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c
--- /home/pat/k/o/drivers/ide/ide-cd.c	2004-07-16 10:22:12.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/ide/ide-cd.c	2004-07-16 10:26:47.000000000 -0600
@@ -2846,7 +2846,7 @@ static struct cdrom_device_ops ide_cdrom
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
 				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_MRW |
-				CDC_MRW_W | CDC_RAM,
+				CDC_MRW_W,
 	.generic_packet		= ide_cdrom_packet,
 };
 
diff -urp /home/pat/k/o/drivers/scsi/sr.c linux-2.6.8-rc1-pel/drivers/scsi/sr.c
--- /home/pat/k/o/drivers/scsi/sr.c	2004-07-16 10:22:12.000000000 -0600
+++ linux-2.6.8-rc1-pel/drivers/scsi/sr.c	2004-07-16 10:27:38.000000000 -0600
@@ -71,7 +71,7 @@ MODULE_PARM(xa_test, "i");	/* see sr_ioc
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
-	 CDC_MRW|CDC_MRW_W|CDC_RAM)
+	 CDC_MRW|CDC_MRW_W)
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
@@ -375,8 +375,6 @@ static int sr_init_command(struct scsi_c
 	}
 
 	if (rq_data_dir(SCpnt->request) == WRITE) {
-		if (!cd->device->writeable)
-			return 0;
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
@@ -876,14 +874,6 @@ static void get_capabilities(struct scsi
 	/*else    I don't think it can close its tray
 		cd->cdi.mask |= CDC_CLOSE_TRAY; */
 
-	/*
-	 * if DVD-RAM of MRW-W, we are randomly writeable
-	 */
-	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM)) !=
-			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM)) {
-		cd->device->writeable = 1;
-	}
-
 	scsi_release_request(SRpnt);
 	kfree(buffer);
 }


