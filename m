From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] misc cleanups for sr
Date: Sun, 27 Oct 2002 18:28:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027182827.A16427@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

bring it back in line with sd:
* get rid of typedefs where possible
* tab-align all credits entries
* line-wrap after 80 characters
* use C99-initializers

--- 1.58/drivers/scsi/sr.c	Tue Oct 22 13:06:06 2002
+++ edited/drivers/scsi/sr.c	Sun Oct 27 17:06:02 2002
@@ -7,34 +7,34 @@
  *      Linux scsi disk driver by
  *              Drew Eckhardt <drew@colorado.edu>
  *
- *      Modified by Eric Youngdale ericy@andante.org to
- *      add scatter-gather, multiple outstanding request, and other
- *      enhancements.
+ *	Modified by Eric Youngdale ericy@andante.org to
+ *	add scatter-gather, multiple outstanding request, and other
+ *	enhancements.
  *
- *          Modified by Eric Youngdale eric@andante.org to support loadable
- *          low-level scsi drivers.
+ *      Modified by Eric Youngdale eric@andante.org to support loadable
+ *      low-level scsi drivers.
  *
- *       Modified by Thomas Quinot thomas@melchior.cuivre.fdn.fr to
- *       provide auto-eject.
+ *      Modified by Thomas Quinot thomas@melchior.cuivre.fdn.fr to
+ *      provide auto-eject.
  *
- *          Modified by Gerd Knorr <kraxel@cs.tu-berlin.de> to support the
- *          generic cdrom interface
+ *      Modified by Gerd Knorr <kraxel@cs.tu-berlin.de> to support the
+ *      generic cdrom interface
  *
- *       Modified by Jens Axboe <axboe@suse.de> - Uniform sr_packet()
- *       interface, capabilities probe additions, ioctl cleanups, etc.
+ *      Modified by Jens Axboe <axboe@suse.de> - Uniform sr_packet()
+ *      interface, capabilities probe additions, ioctl cleanups, etc.
  *
- *       Modified by Richard Gooch <rgooch@atnf.csiro.au> to support devfs
+ *	Modified by Richard Gooch <rgooch@atnf.csiro.au> to support devfs
  *
- *       Modified by Jens Axboe <axboe@suse.de> - support DVD-RAM
- *	 transparently and loose the GHOST hack
- *
- *	 Modified by Arnaldo Carvalho de Melo <acme@conectiva.com.br>
- *	 check resource allocation in sr_init and some cleanups
+ *	Modified by Jens Axboe <axboe@suse.de> - support DVD-RAM
+ *	transparently and loose the GHOST hack
  *
+ *	Modified by Arnaldo Carvalho de Melo <acme@conectiva.com.br>
+ *	check resource allocation in sr_init and some cleanups
  */
 
-#include <linux/module.h>
+#define MAJOR_NR SCSI_CDROM_MAJOR
 
+#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -45,29 +45,32 @@
 #include <linux/cdrom.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
-#include <asm/system.h>
-#include <asm/io.h>
+#include <linux/blk.h>
 #include <asm/uaccess.h>
 
-#define MAJOR_NR SCSI_CDROM_MAJOR
-#define LOCAL_END_REQUEST
-#include <linux/blk.h>
 #include "scsi.h"
 #include "hosts.h"
-#include "sr.h"
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
 
+#include "sr.h"
+
+
 MODULE_PARM(xa_test, "i");	/* see sr_ioctl.c */
 
 #define MAX_RETRIES	3
 #define SR_TIMEOUT	(30 * HZ)
+#define SR_CAPABILITIES \
+	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
+	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
+	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
+	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_GENERIC_PACKET)
 
 static int sr_init(void);
-static int sr_attach(Scsi_Device *);
-static int sr_detect(Scsi_Device *);
-static void sr_detach(Scsi_Device *);
+static int sr_attach(struct scsi_device *);
+static int sr_detect(struct scsi_device *);
+static void sr_detach(struct scsi_device *);
 
-static int sr_init_command(Scsi_Cmnd *);
+static int sr_init_command(struct scsi_cmnd *);
 
 static struct Scsi_Device_Template sr_template = {
 	.module		= THIS_MODULE,
@@ -83,19 +86,19 @@
 	.init_command	= sr_init_command
 };
 
-static Scsi_CD *scsi_CDs;
+static struct scsi_cd *scsi_CDs;
 
 static int sr_open(struct cdrom_device_info *, int);
-static void get_sectorsize(Scsi_CD *);
-static void get_capabilities(Scsi_CD *);
-static int sr_init_one(Scsi_CD *, int);
+static void get_sectorsize(struct scsi_cd *);
+static void get_capabilities(struct scsi_cd *);
+static int sr_init_one(struct scsi_cd *, int);
 
 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_command *);
 
 static void sr_release(struct cdrom_device_info *cdi)
 {
-	Scsi_CD *cd = cdi->handle;
+	struct scsi_cd *cd = cdi->handle;
 
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
@@ -106,28 +109,21 @@
 		__MOD_DEC_USE_COUNT(sr_template.module);
 }
 
-static struct cdrom_device_ops sr_dops =
-{
-	open:			sr_open,
-	release:		sr_release,
-	drive_status:		sr_drive_status,
-	media_changed:		sr_media_change,
-	tray_move:		sr_tray_move,
-	lock_door:		sr_lock_door,
-	select_speed:		sr_select_speed,
-	get_last_session:	sr_get_last_session,
-	get_mcn:		sr_get_mcn,
-	reset:			sr_reset,
-	audio_ioctl:		sr_audio_ioctl,
-	dev_ioctl:		sr_dev_ioctl,
-	capability:		CDC_CLOSE_TRAY | CDC_OPEN_TRAY | CDC_LOCK |
-				CDC_SELECT_SPEED | CDC_SELECT_DISC |
-				CDC_MULTI_SESSION | CDC_MCN |
-				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO |
-				CDC_RESET | CDC_IOCTLS | CDC_DRIVE_STATUS |
-				CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
-				CDC_DVD_RAM | CDC_GENERIC_PACKET,
-	generic_packet:		sr_packet,
+static struct cdrom_device_ops sr_dops = {
+	.open			= sr_open,
+	.release	 	= sr_release,
+	.drive_status	 	= sr_drive_status,
+	.media_changed		= sr_media_change,
+	.tray_move		= sr_tray_move,
+	.lock_door		= sr_lock_door,
+	.select_speed		= sr_select_speed,
+	.get_last_session	= sr_get_last_session,
+	.get_mcn		= sr_get_mcn,
+	.reset			= sr_reset,
+	.audio_ioctl		= sr_audio_ioctl,
+	.dev_ioctl		= sr_dev_ioctl,
+	.capability		= SR_CAPABILITIES,
+	.generic_packet		= sr_packet,
 };
 
 /*
@@ -142,7 +138,7 @@
 
 int sr_media_change(struct cdrom_device_info *cdi, int slot)
 {
-	Scsi_CD *cd = cdi->handle;
+	struct scsi_cd *cd = cdi->handle;
 	int retval;
 
 	if (CDSL_CURRENT != slot) {
@@ -183,28 +179,29 @@
 }
 
 /*
- * rw_intr is the interrupt routine for the device driver.  It will be notified on the
- * end of a SCSI read / write, and will take on of several actions based on success or failure.
+ * rw_intr is the interrupt routine for the device driver.
+ *
+ * It will be notified on the end of a SCSI read / write, and will take on
+ * of several actions based on success or failure.
  */
-
-static void rw_intr(Scsi_Cmnd * SCpnt)
+static void rw_intr(struct scsi_cmnd * SCpnt)
 {
 	int result = SCpnt->result;
 	int this_count = SCpnt->bufflen >> 9;
 	int good_sectors = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
-	Scsi_CD *cd = SCpnt->request->rq_disk->private_data;
+	struct scsi_cd *cd = SCpnt->request->rq_disk->private_data;
 
 #ifdef DEBUG
 	printk("sr.c done: %x %p\n", result, SCpnt->request->bh->b_data);
 #endif
+
 	/*
-	   Handle MEDIUM ERRORs or VOLUME OVERFLOWs that indicate partial success.
-	   Since this is a relatively rare error condition, no care is taken to
-	   avoid unnecessary additional work such as memcpy's that could be avoided.
+	 * Handle MEDIUM ERRORs or VOLUME OVERFLOWs that indicate partial
+	 * success.  Since this is a relatively rare error condition, no
+	 * care is taken to avoid unnecessary additional work such as
+	 * memcpy's that could be avoided.
 	 */
-
-
 	if (driver_byte(result) != 0 &&		/* An error occurred */
 	    SCpnt->sense_buffer[0] == 0xF0 &&	/* Sense data is valid */
 	    (SCpnt->sense_buffer[2] == MEDIUM_ERROR ||
@@ -243,15 +240,17 @@
 	scsi_io_completion(SCpnt, good_sectors, block_sectors);
 }
 
-static int sr_init_command(Scsi_Cmnd * SCpnt)
+static int sr_init_command(struct scsi_cmnd * SCpnt)
 {
 	int block=0, this_count, s_size, timeout = SR_TIMEOUT;
-	Scsi_CD *cd = SCpnt->request->rq_disk->private_data;
+	struct scsi_cd *cd = SCpnt->request->rq_disk->private_data;
 
-	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n", cd->disk->disk_name, block));
+	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
+				cd->disk->disk_name, block));
 
 	if (!cd->device || !cd->device->online) {
-		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", SCpnt->request->nr_sectors));
+		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
+					SCpnt->request->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
@@ -326,7 +325,8 @@
 	/*
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
-	if (((unsigned int)SCpnt->request->sector % (s_size >> 9)) || (SCpnt->request_bufflen % s_size)) {
+	if (((unsigned int)SCpnt->request->sector % (s_size >> 9)) ||
+	    (SCpnt->request_bufflen % s_size)) {
 		printk("sr: unaligned transfer\n");
 		return 0;
 	}
@@ -335,9 +335,10 @@
 
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
-                                   cd->cdi.name,
-		   (rq_data_dir(SCpnt->request) == WRITE) ? "writing" : "reading",
-				 this_count, SCpnt->request->nr_sectors));
+				cd->cdi.name,
+				(rq_data_dir(SCpnt->request) == WRITE) ?
+					"writing" : "reading",
+				this_count, SCpnt->request->nr_sectors));
 
 	SCpnt->cmnd[1] = 0;
 	block = (unsigned int)SCpnt->request->sector / (s_size >> 9);
@@ -392,26 +393,26 @@
 
 static int sr_block_open(struct inode *inode, struct file *file)
 {
-	Scsi_CD *cd = inode->i_bdev->bd_disk->private_data;
+	struct scsi_cd *cd = inode->i_bdev->bd_disk->private_data;
 	return cdrom_open(&cd->cdi, inode, file);
 }
 
 static int sr_block_release(struct inode *inode, struct file *file)
 {
-	Scsi_CD *cd = inode->i_bdev->bd_disk->private_data;
+	struct scsi_cd *cd = inode->i_bdev->bd_disk->private_data;
 	return cdrom_release(&cd->cdi, file);
 }
 
 static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 			  unsigned long arg)
 {
-	Scsi_CD *cd = inode->i_bdev->bd_disk->private_data;
+	struct scsi_cd *cd = inode->i_bdev->bd_disk->private_data;
 	return cdrom_ioctl(&cd->cdi, inode, cmd, arg);
 }
 
 static int sr_block_media_changed(struct gendisk *disk)
 {
-	Scsi_CD *cd = disk->private_data;
+	struct scsi_cd *cd = disk->private_data;
 	return cdrom_media_changed(&cd->cdi);
 }
 
@@ -426,7 +427,7 @@
 
 static int sr_open(struct cdrom_device_info *cdi, int purpose)
 {
-	Scsi_CD *cd = cdi->handle;
+	struct scsi_cd *cd = cdi->handle;
 
 	if (!cd->device)
 		return -ENXIO;	/* No such device */
@@ -454,7 +455,7 @@
 	return 0;
 }
 
-static int sr_detect(Scsi_Device * SDp)
+static int sr_detect(struct scsi_device * SDp)
 {
 
 	if (SDp->type != TYPE_ROM && SDp->type != TYPE_WORM)
@@ -463,9 +464,9 @@
 	return 1;
 }
 
-static int sr_attach(Scsi_Device * SDp)
+static int sr_attach(struct scsi_device * SDp)
 {
-	Scsi_CD *cpnt;
+	struct scsi_cd *cpnt;
 	int i;
 
 	if (SDp->type != TYPE_ROM && SDp->type != TYPE_WORM)
@@ -491,7 +492,8 @@
 		panic("scsi_devices corrupt (sr)");
 
 	printk("Attached scsi CD-ROM %s at scsi%d, channel %d, id %d, lun %d\n",
-	       scsi_CDs[i].cdi.name, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
+	       scsi_CDs[i].cdi.name, SDp->host->host_no, SDp->channel,
+	       SDp->id, SDp->lun);
 	return 0;
 
 fail:
@@ -500,13 +502,13 @@
 }
 
 
-static void get_sectorsize(Scsi_CD *cd)
+static void get_sectorsize(struct scsi_cd *cd)
 {
 	unsigned char cmd[10];
 	unsigned char *buffer;
 	int the_result, retries = 3;
 	int sector_size;
-	Scsi_Request *SRpnt = NULL;
+	struct scsi_request *SRpnt = NULL;
 	request_queue_t *queue;
 
 	buffer = kmalloc(512, GFP_DMA);
@@ -519,13 +521,13 @@
 	do {
 		cmd[0] = READ_CAPACITY;
 		memset((void *) &cmd[1], 0, 9);
-		SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;	/* Mark as really busy */
+		/* Mark as really busy */
+		SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
 		SRpnt->sr_cmd_len = 0;
 
 		memset(buffer, 0, 8);
 
 		/* Do the command and wait.. */
-
 		SRpnt->sr_data_direction = SCSI_DATA_READ;
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
 			      8, SR_TIMEOUT, MAX_RETRIES);
@@ -603,7 +605,7 @@
 	goto out;
 }
 
-void get_capabilities(Scsi_CD *cd)
+void get_capabilities(struct scsi_cd *cd)
 {
 	struct cdrom_generic_command cgc;
 	unsigned char *buffer;
@@ -656,11 +658,11 @@
 	printk("%s: scsi3-mmc drive: %dx/%dx %s%s%s%s%s%s\n", cd->cdi.name,
 	       ((buffer[n + 14] << 8) + buffer[n + 15]) / 176,
 	       cd->cdi.speed,
-	       buffer[n + 3] & 0x01 ? "writer " : "",	/* CD Writer */
+	       buffer[n + 3] & 0x01 ? "writer " : "", /* CD Writer */
 	       buffer[n + 3] & 0x20 ? "dvd-ram " : "",
-	       buffer[n + 2] & 0x02 ? "cd/rw " : "",	/* can read rewriteable */
-	       buffer[n + 4] & 0x20 ? "xa/form2 " : "",		/* can read xa/from2 */
-	       buffer[n + 5] & 0x01 ? "cdda " : "",	/* can read audio data */
+	       buffer[n + 2] & 0x02 ? "cd/rw " : "", /* can read rewriteable */
+	       buffer[n + 4] & 0x20 ? "xa/form2 " : "",	/* can read xa/from2 */
+	       buffer[n + 5] & 0x01 ? "cdda " : "", /* can read audio data */
 	       loadmech[buffer[n + 6] >> 5]);
 	if ((buffer[n + 6] >> 5) == 0)
 		/* caddy drives can't close tray... */
@@ -704,7 +706,8 @@
  * sr_packet() is the entry point for the generic commands generated
  * by the Uniform CD-ROM layer. 
  */
-static int sr_packet(struct cdrom_device_info *cdi, struct cdrom_generic_command *cgc)
+static int sr_packet(struct cdrom_device_info *cdi,
+		struct cdrom_generic_command *cgc)
 {
 	if (cgc->timeout <= 0)
 		cgc->timeout = IOCTL_TIMEOUT;
@@ -724,7 +727,8 @@
 
 	if (!sr_registered) {
 		if (register_blkdev(MAJOR_NR, "sr", &sr_bdops)) {
-			printk("Unable to get major %d for SCSI-CD\n", MAJOR_NR);
+			printk("Unable to get major %d for SCSI-CD\n",
+					MAJOR_NR);
 			return 1;
 		}
 		sr_registered++;
@@ -733,10 +737,10 @@
 		return 0;
 
 	sr_template.dev_max = sr_template.dev_noticed + SR_EXTRA_DEVS;
-	scsi_CDs = kmalloc(sr_template.dev_max * sizeof(Scsi_CD), GFP_ATOMIC);
+	scsi_CDs = kmalloc(sr_template.dev_max * sizeof(struct scsi_cd), GFP_ATOMIC);
 	if (!scsi_CDs)
 		goto cleanup_dev;
-	memset(scsi_CDs, 0, sr_template.dev_max * sizeof(Scsi_CD));
+	memset(scsi_CDs, 0, sr_template.dev_max * sizeof(struct scsi_cd));
 	for (i = 0; i < sr_template.dev_max; i++)
 		sprintf(scsi_CDs[i].cdi.name, "sr%d", i);
 	return 0;
@@ -747,7 +751,7 @@
 	return 1;
 }
 
-static int sr_init_one(Scsi_CD *cd, int first_minor)
+static int sr_init_one(struct scsi_cd *cd, int first_minor)
 {
 	struct gendisk *disk;
 
@@ -799,9 +803,9 @@
 	return 0;
 }
 
-static void sr_detach(Scsi_Device * SDp)
+static void sr_detach(struct scsi_device * SDp)
 {
-	Scsi_CD *cpnt;
+	struct scsi_cd *cpnt;
 	int i;
 
 	for (cpnt = scsi_CDs, i = 0; i < sr_template.dev_max; i++, cpnt++) {
===== drivers/scsi/sr.h 1.6 vs edited =====
--- 1.6/drivers/scsi/sr.h	Sun Oct  6 16:06:49 2002
+++ edited/drivers/scsi/sr.h	Sun Oct 27 16:58:21 2002
@@ -24,7 +24,7 @@
 /* In fact, it is very slow if it has to spin up first */
 #define IOCTL_TIMEOUT 30*HZ
 
-typedef struct {
+typedef struct scsi_cd {
 	unsigned capacity;	/* size in blocks                       */
 	Scsi_Device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
===== drivers/scsi/sr_ioctl.c 1.21 vs edited =====
--- 1.21/drivers/scsi/sr_ioctl.c	Thu Oct 17 13:52:39 2002
+++ edited/drivers/scsi/sr_ioctl.c	Sun Oct 27 17:02:51 2002
@@ -5,15 +5,14 @@
 #include <asm/uaccess.h>
 #include <linux/errno.h>
 #include <linux/string.h>
-#include <linux/buffer_head.h>		/* for invalidate_buffers() */
-
 #include <linux/blk.h>
 #include <linux/blkpg.h>
+#include <linux/cdrom.h>
+
 #include "scsi.h"
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>
 
-#include <linux/cdrom.h>
 #include "sr.h"
 
 #if 0
@@ -76,8 +75,8 @@
 
 int sr_do_ioctl(Scsi_CD *cd, struct cdrom_generic_command *cgc)
 {
-	Scsi_Request *SRpnt;
-	Scsi_Device *SDev;
+	struct scsi_request *SRpnt;
+	struct scsi_device *SDev;
         struct request *req;
 	int result, err = 0, retries = 0;
 	char *bounce_buffer;
@@ -555,21 +554,3 @@
 	Scsi_CD *cd = cdi->handle;
 	return scsi_ioctl(cd->device, cmd, (void *)arg);
 }
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * tab-width: 8
- * End:
- */
