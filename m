From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid obsolete APIs in sr
Date: Mon, 21 Jun 2004 16:27:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621142702.GB32068@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:39120 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266252AbUFUO1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:27:05 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.110/drivers/scsi/sr.c	2004-06-18 19:06:33 +02:00
+++ edited/drivers/scsi/sr.c	2004-06-20 18:29:03 +02:00
@@ -46,11 +46,14 @@
 #include <linux/blkdev.h>
 #include <asm/uaccess.h>
 
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
+#include <scsi/scsi_request.h>
 
 #include "scsi_logging.h"
 #include "sr.h"
@@ -282,7 +285,7 @@
 			 * user, but make sure that it's not treated as a
 			 * hard error.
 			 */
-			print_sense("sr", SCpnt);
+			scsi_print_sense("sr", SCpnt);
 			SCpnt->result = 0;
 			SCpnt->sense_buffer[0] = 0x0;
 			good_bytes = this_count;
@@ -335,11 +338,11 @@
 
 		memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
 		if (!rq->data_len)
-			SCpnt->sc_data_direction = SCSI_DATA_NONE;
+			SCpnt->sc_data_direction = DMA_NONE;
 		else if (rq_data_dir(rq) == WRITE)
-			SCpnt->sc_data_direction = SCSI_DATA_WRITE;
+			SCpnt->sc_data_direction = DMA_TO_DEVICE;
 		else
-			SCpnt->sc_data_direction = SCSI_DATA_READ;
+			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 
 		this_count = rq->data_len;
 		if (rq->timeout)
@@ -375,10 +378,10 @@
 		if (!cd->device->writeable)
 			return 0;
 		SCpnt->cmnd[0] = WRITE_10;
-		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
+		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
 		SCpnt->cmnd[0] = READ_10;
-		SCpnt->sc_data_direction = SCSI_DATA_READ;
+		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
 		blk_dump_rq_flags(SCpnt->request, "Unknown sr command");
 		return 0;
@@ -674,7 +677,7 @@
 		memset(buffer, 0, 8);
 
 		/* Do the command and wait.. */
-		SRpnt->sr_data_direction = SCSI_DATA_READ;
+		SRpnt->sr_data_direction = DMA_FROM_DEVICE;
 		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
 			      8, SR_TIMEOUT, MAX_RETRIES);
 
--- 1.13/drivers/scsi/sr.h	2004-05-29 19:04:42 +02:00
+++ edited/drivers/scsi/sr.h	2004-06-20 18:23:53 +02:00
@@ -17,18 +17,20 @@
 #ifndef _SR_H
 #define _SR_H
 
-#include "scsi.h"
 #include <linux/genhd.h>
 #include <linux/kref.h>
 
+struct scsi_device;
+
 /* The CDROM is fairly slow, so we need a little extra time */
 /* In fact, it is very slow if it has to spin up first */
 #define IOCTL_TIMEOUT 30*HZ
 
+
 typedef struct scsi_cd {
 	struct scsi_driver *driver;
 	unsigned capacity;	/* size in blocks                       */
-	Scsi_Device *device;
+	struct scsi_device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
 	unsigned long ms_offset;	/* for reading multisession-CD's        */
 	unsigned needs_sector_size:1;	/* needs to get sector size */
--- 1.34/drivers/scsi/sr_ioctl.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/sr_ioctl.c	2004-06-20 18:31:34 +02:00
@@ -10,9 +10,13 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_request.h>
 
 #include "sr.h"
 
@@ -65,7 +69,7 @@
 	cgc.cmd[6] = trk1_te.cdte_addr.msf.minute;
 	cgc.cmd[7] = trk1_te.cdte_addr.msf.second;
 	cgc.cmd[8] = trk1_te.cdte_addr.msf.frame;
-	cgc.data_direction = SCSI_DATA_NONE;
+	cgc.data_direction = DMA_NONE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	return sr_do_ioctl(cdi->handle, &cgc);
 }
@@ -138,7 +142,7 @@
 			if (!cgc->quiet)
 				printk(KERN_INFO "%s: CDROM not ready.  Make sure there is a disc in the drive.\n", cd->cdi.name);
 #ifdef DEBUG
-			print_req_sense("sr", SRpnt);
+			scsi_print_req_sense("sr", SRpnt);
 #endif
 			err = -ENOMEDIUM;
 			break;
@@ -149,14 +153,14 @@
 				/* sense: Invalid command operation code */
 				err = -EDRIVE_CANT_DO_THIS;
 #ifdef DEBUG
-			print_command(cgc->cmd);
-			print_req_sense("sr", SRpnt);
+			__scsi_print_command(cgc->cmd);
+			scsi_print_req_sense("sr", SRpnt);
 #endif
 			break;
 		default:
 			printk(KERN_ERR "%s: CDROM (ioctl) error, command: ", cd->cdi.name);
-			print_command(cgc->cmd);
-			print_req_sense("sr", SRpnt);
+			__scsi_print_command(cgc->cmd);
+			scsi_print_req_sense("sr", SRpnt);
 			err = -EIO;
 		}
 	}
@@ -183,7 +187,7 @@
 	memset(&cgc, 0, sizeof(struct packet_command));
 	cgc.cmd[0] = GPCMD_TEST_UNIT_READY;
 	cgc.quiet = 1;
-	cgc.data_direction = SCSI_DATA_NONE;
+	cgc.data_direction = DMA_NONE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	return sr_do_ioctl(cd, &cgc);
 }
@@ -196,7 +200,7 @@
 	memset(&cgc, 0, sizeof(struct packet_command));
 	cgc.cmd[0] = GPCMD_START_STOP_UNIT;
 	cgc.cmd[4] = (pos == 0) ? 0x03 /* close */ : 0x02 /* eject */ ;
-	cgc.data_direction = SCSI_DATA_NONE;
+	cgc.data_direction = DMA_NONE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	return sr_do_ioctl(cd, &cgc);
 }
@@ -280,7 +284,7 @@
 	cgc.cmd[8] = 24;
 	cgc.buffer = buffer;
 	cgc.buflen = 24;
-	cgc.data_direction = SCSI_DATA_READ;
+	cgc.data_direction = DMA_FROM_DEVICE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	result = sr_do_ioctl(cd, &cgc);
 
@@ -310,7 +314,7 @@
 	cgc.cmd[0] = GPCMD_SET_SPEED;	/* SET CD SPEED */
 	cgc.cmd[2] = (speed >> 8) & 0xff;	/* MSB for speed (in kbytes/sec) */
 	cgc.cmd[3] = speed & 0xff;	/* LSB */
-	cgc.data_direction = SCSI_DATA_NONE;
+	cgc.data_direction = DMA_NONE;
 	cgc.timeout = IOCTL_TIMEOUT;
 
 	if (sr_do_ioctl(cd, &cgc))
@@ -347,7 +351,7 @@
 			cgc.buffer = buffer;
 			cgc.buflen = 12;
 			cgc.quiet = 1;
-			cgc.data_direction = SCSI_DATA_READ;
+			cgc.data_direction = DMA_FROM_DEVICE;
 
 			result = sr_do_ioctl(cd, &cgc);
 
@@ -367,7 +371,7 @@
 			cgc.cmd[8] = 12;		/* LSB of length */
 			cgc.buffer = buffer;
 			cgc.buflen = 12;
-			cgc.data_direction = SCSI_DATA_READ;
+			cgc.data_direction = DMA_FROM_DEVICE;
 
 			result = sr_do_ioctl(cd, &cgc);
 
@@ -393,7 +397,7 @@
 		cgc.cmd[5] = ti->cdti_ind0;
 		cgc.cmd[7] = ti->cdti_trk1;
 		cgc.cmd[8] = ti->cdti_ind1;
-		cgc.data_direction = SCSI_DATA_NONE;
+		cgc.data_direction = DMA_NONE;
 
 		result = sr_do_ioctl(cd, &cgc);
 		if (result == -EDRIVE_CANT_DO_THIS)
@@ -462,7 +466,7 @@
 	}
 	cgc.buffer = dest;
 	cgc.buflen = blksize;
-	cgc.data_direction = SCSI_DATA_READ;
+	cgc.data_direction = DMA_FROM_DEVICE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	return sr_do_ioctl(cd, &cgc);
 }
@@ -503,7 +507,7 @@
 	cgc.cmd[8] = 1;
 	cgc.buffer = dest;
 	cgc.buflen = blksize;
-	cgc.data_direction = SCSI_DATA_READ;
+	cgc.data_direction = DMA_FROM_DEVICE;
 	cgc.timeout = IOCTL_TIMEOUT;
 	rc = sr_do_ioctl(cd, &cgc);
 
--- 1.14/drivers/scsi/sr_vendor.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/sr_vendor.c	2004-06-20 18:33:22 +02:00
@@ -35,16 +35,18 @@
  */
 
 #include <linux/config.h>
+#include <linux/cdrom.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/bcd.h>
-
 #include <linux/blkdev.h>
-#include "scsi.h"
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 
-#include <linux/cdrom.h>
 #include "sr.h"
 
 #if 0
@@ -135,7 +137,7 @@
 	modesel->block_length_lo = blocklength & 0xff;
 	cgc.buffer = buffer;
 	cgc.buflen = sizeof(*modesel);
-	cgc.data_direction = SCSI_DATA_WRITE;
+	cgc.data_direction = DMA_TO_DEVICE;
 	cgc.timeout = VENDOR_TIMEOUT;
 	if (0 == (rc = sr_do_ioctl(cd, &cgc))) {
 		cd->device->sector_size = blocklength;
@@ -182,7 +184,7 @@
 		cgc.buffer = buffer;
 		cgc.buflen = 12;
 		cgc.quiet = 1;
-		cgc.data_direction = SCSI_DATA_READ;
+		cgc.data_direction = DMA_FROM_DEVICE;
 		cgc.timeout = VENDOR_TIMEOUT;
 		rc = sr_do_ioctl(cd, &cgc);
 		if (rc != 0)
@@ -210,7 +212,7 @@
 			cgc.buffer = buffer;
 			cgc.buflen = 0x16;
 			cgc.quiet = 1;
-			cgc.data_direction = SCSI_DATA_READ;
+			cgc.data_direction = DMA_FROM_DEVICE;
 			cgc.timeout = VENDOR_TIMEOUT;
 			rc = sr_do_ioctl(cd, &cgc);
 			if (rc != 0)
@@ -239,7 +241,7 @@
 			cgc.buffer = buffer;
 			cgc.buflen = 4;
 			cgc.quiet = 1;
-			cgc.data_direction = SCSI_DATA_READ;
+			cgc.data_direction = DMA_FROM_DEVICE;
 			cgc.timeout = VENDOR_TIMEOUT;
 			rc = sr_do_ioctl(cd, &cgc);
 			if (rc == -EINVAL) {
@@ -268,7 +270,7 @@
 		cgc.buffer = buffer;
 		cgc.buflen = 0x04;
 		cgc.quiet = 1;
-		cgc.data_direction = SCSI_DATA_READ;
+		cgc.data_direction = DMA_FROM_DEVICE;
 		cgc.timeout = VENDOR_TIMEOUT;
 		rc = sr_do_ioctl(cd, &cgc);
 		if (rc != 0) {
@@ -286,7 +288,7 @@
 		cgc.buffer = buffer;
 		cgc.buflen = 12;
 		cgc.quiet = 1;
-		cgc.data_direction = SCSI_DATA_READ;
+		cgc.data_direction = DMA_FROM_DEVICE;
 		cgc.timeout = VENDOR_TIMEOUT;
 		rc = sr_do_ioctl(cd, &cgc);
 		if (rc != 0) {
