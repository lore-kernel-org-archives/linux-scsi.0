From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] switch scsi core and sd to <scsi/*.h> headers
Date: Sun, 20 Jun 2004 13:26:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620112609.GA13741@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:19642 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265407AbUFTL0P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 07:26:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.18/drivers/scsi/constants.c	2004-05-12 17:46:20 +02:00
+++ edited/drivers/scsi/constants.c	2004-06-19 16:43:56 +02:00
@@ -6,13 +6,16 @@
  *   by D. Gilbert and aeb (20020609)
  */
 
-#include <linux/module.h>
-
 #include <linux/config.h>
 #include <linux/blkdev.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
-#include "scsi.h"
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_request.h>
+
 
 #define CONST_COMMAND   0x01
 #define CONST_STATUS    0x02
===== drivers/scsi/hosts.c 1.98 vs edited =====
--- 1.98/drivers/scsi/hosts.c	2004-05-15 08:11:56 +02:00
+++ edited/drivers/scsi/hosts.c	2004-06-19 16:35:38 +02:00
@@ -27,13 +27,11 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/init.h>
-#include <linux/list.h>
 #include <linux/completion.h>
-#include <linux/unistd.h>
 
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
-#include "scsi.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
===== drivers/scsi/scsi.c 1.143 vs edited =====
--- 1.143/drivers/scsi/scsi.c	2004-04-28 18:32:09 +02:00
+++ edited/drivers/scsi/scsi.c	2004-06-19 16:38:34 +02:00
@@ -56,8 +56,14 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include "scsi.h"
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_request.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -400,7 +406,7 @@
 			 * output in scsi_log_completion.
 			 */
 			printk("                 ");
-			print_command(cmd->cmnd);
+			scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
 				       " done = 0x%p, queuecommand 0x%p\n",
@@ -468,13 +474,13 @@
 				printk("UNKNOWN");
 			}
 			printk(" %8x ", cmd->result);
-			print_command(cmd->cmnd);
+			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION) {
 				/*
 				 * XXX The print_sense formatting/prefix
 				 * doesn't match this function.
 				 */
-				print_sense("", cmd);
+				scsi_print_sense("", cmd);
 			}
 			if (level > 3) {
 				printk(KERN_INFO "scsi host busy %d failed %d\n",
===== drivers/scsi/scsi_devinfo.c 1.19 vs edited =====
--- 1.19/drivers/scsi/scsi_devinfo.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/scsi_devinfo.c	2004-06-19 16:48:22 +02:00
@@ -6,11 +6,12 @@
 #include <linux/moduleparam.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_devinfo.h>
 
-#include "scsi.h"
-#include <scsi/scsi_host.h>
 #include "scsi_priv.h"
+
 
 /*
  * scsi_dev_info_list: structure to hold black/white listed devices.
===== drivers/scsi/scsi_error.c 1.77 vs edited =====
--- 1.77/drivers/scsi/scsi_error.c	2004-06-06 13:19:15 +02:00
+++ edited/drivers/scsi/scsi_error.c	2004-06-19 16:47:16 +02:00
@@ -23,10 +23,14 @@
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/smp_lock.h>
-#include <scsi/scsi_ioctl.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_request.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -655,7 +659,7 @@
 		SCSI_LOG_ERROR_RECOVERY(3, printk("sense requested for %p"
 						  " result %x\n", scmd,
 						  scmd->result));
-		SCSI_LOG_ERROR_RECOVERY(3, print_sense("bh", scmd));
+		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense("bh", scmd));
 
 		rtn = scsi_decide_disposition(scmd);
 
===== drivers/scsi/scsi_ioctl.c 1.27 vs edited =====
--- 1.27/drivers/scsi/scsi_ioctl.c	2004-06-18 22:44:28 +02:00
+++ edited/drivers/scsi/scsi_ioctl.c	2004-06-19 16:42:28 +02:00
@@ -5,23 +5,21 @@
  *   for the ones that remain
  */
 #include <linux/module.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/system.h>
-#include <asm/page.h>
-
+#include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/string.h>
+#include <asm/uaccess.h>
 
-#include <linux/blkdev.h>
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_request.h>
 
 #include "scsi_logging.h"
 
===== drivers/scsi/scsi_lib.c 1.128 vs edited =====
--- 1.128/drivers/scsi/scsi_lib.c	2004-05-25 03:59:39 +02:00
+++ edited/drivers/scsi/scsi_lib.c	2004-06-19 16:40:25 +02:00
@@ -16,9 +16,13 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include "scsi.h"
+#include <scsi/scsi_request.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -837,8 +841,8 @@
 			printk("scsi%d: ERROR on channel %d, id %d, lun %d, CDB: ",
 			       cmd->device->host->host_no, (int) cmd->device->channel,
 			       (int) cmd->device->id, (int) cmd->device->lun);
-			print_command(cmd->data_cmnd);
-			print_sense("", cmd);
+			__scsi_print_command(cmd->data_cmnd);
+			scsi_print_sense("", cmd);
 			cmd = scsi_end_request(cmd, 0, block_bytes, 1);
 			return;
 		default:
@@ -862,7 +866,7 @@
 		       cmd->device->lun, result);
 
 		if (driver_byte(result) & DRIVER_SENSE)
-			print_sense("", cmd);
+			scsi_print_sense("", cmd);
 		/*
 		 * Mark a single buffer as not uptodate.  Queue the remainder.
 		 * We sometimes get this cruft in the event that a medium error
===== drivers/scsi/scsi_proc.c 1.40 vs edited =====
--- 1.40/drivers/scsi/scsi_proc.c	2004-05-29 19:09:36 +02:00
+++ edited/drivers/scsi/scsi_proc.c	2004-06-19 16:55:42 +02:00
@@ -27,8 +27,9 @@
 #include <linux/seq_file.h>
 #include <asm/uaccess.h>
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include "scsi.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
===== drivers/scsi/scsi_scan.c 1.125 vs edited =====
--- 1.125/drivers/scsi/scsi_scan.c	2004-06-06 13:20:50 +02:00
+++ edited/drivers/scsi/scsi_scan.c	2004-06-19 16:49:19 +02:00
@@ -32,11 +32,13 @@
 #include <linux/blkdev.h>
 #include <asm/semaphore.h>
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_request.h>
 #include <scsi/scsi_transport.h>
-#include "scsi.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
===== drivers/scsi/scsi_syms.c 1.48 vs edited =====
--- 1.48/drivers/scsi/scsi_syms.c	2004-06-18 22:44:28 +02:00
+++ edited/drivers/scsi/scsi_syms.c	2004-06-19 16:52:12 +02:00
@@ -5,24 +5,15 @@
 #include <linux/config.h>
 #include <linux/module.h>
 
-#include <linux/sched.h>
-#include <linux/timer.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/blkdev.h>
-#include <linux/fs.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/dma.h>
-
+#include <scsi/scsi.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_request.h>
 #include <scsi/scsicam.h>
-#include "scsi.h"
 
 #include "scsi_logging.h"
 
===== drivers/scsi/scsi_sysfs.c 1.47 vs edited =====
--- 1.47/drivers/scsi/scsi_sysfs.c	2004-04-30 11:53:56 +02:00
+++ edited/drivers/scsi/scsi_sysfs.c	2004-06-19 16:50:30 +02:00
@@ -12,9 +12,10 @@
 #include <linux/blkdev.h>
 #include <linux/device.h>
 
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
-#include "scsi.h"
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
===== drivers/scsi/scsicam.c 1.15 vs edited =====
--- 1.15/drivers/scsi/scsicam.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/scsicam.c	2004-06-19 16:45:02 +02:00
@@ -11,16 +11,15 @@
  */
 
 #include <linux/module.h>
-
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <asm/unaligned.h>
-#include "scsi.h"
-#include <scsi/scsi_host.h>
+
 #include <scsi/scsicam.h>
+
 
 static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
 		   unsigned int *secs);
===== drivers/scsi/sd.c 1.153 vs edited =====
--- 1.153/drivers/scsi/sd.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/sd.c	2004-06-19 16:38:40 +02:00
@@ -44,18 +44,20 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
-#include <linux/reboot.h>
-#include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/kref.h>
 #include <asm/uaccess.h>
 
-#include "scsi.h"
-#include <scsi/scsi_host.h>
-
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_request.h>
 #include <scsi/scsicam.h>
 
 #include "scsi_logging.h"
@@ -769,7 +771,7 @@
 			 * Inform the user, but make sure that it's not treated
 			 * as a hard error.
 			 */
-			print_sense("sd", SCpnt);
+			scsi_print_sense("sd", SCpnt);
 			SCpnt->result = 0;
 			SCpnt->sense_buffer[0] = 0x0;
 			good_bytes = this_count;
@@ -918,7 +920,7 @@
 			 * probably pointless to loop */
 			if(!spintime) {
 				printk(KERN_NOTICE "%s: Unit Not Ready, sense:\n", diskname);
-				print_req_sense("", SRpnt);
+				scsi_print_req_sense("", SRpnt);
 			}
 			break;
 		}
@@ -987,7 +989,7 @@
 		       driver_byte(the_result));
 
 		if (driver_byte(the_result) & DRIVER_SENSE)
-			print_req_sense("sd", SRpnt);
+			scsi_print_req_sense("sd", SRpnt);
 		else
 			printk("%s : sense not available. \n", diskname);
 
@@ -1542,7 +1544,7 @@
 				    status_byte(res), msg_byte(res),
 				    host_byte(res), driver_byte(res));
 			if (driver_byte(res) & DRIVER_SENSE)
-				print_req_sense("sd", sreq);
+				scsi_print_req_sense("sd", sreq);
 	}
 	
 	scsi_release_request(sreq);
