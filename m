From: Mark Haverkamp <markh@osdl.org>
Subject: [Patch] aacraid driver for 2.5
Date: 14 Mar 2003 08:11:35 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1047658294.7714.18.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-8xoHcM7z080lWW5ZjjM0"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-8xoHcM7z080lWW5ZjjM0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This changes the cmd_per_lun element of the aacraid Scsi_Host_Template
to 1.  The larger number is not needed and exceeds the depth limit for
scsi_adjust_queue_depth.  Also updated struct initializers.


-- 
Mark Haverkamp <markh@osdl.org>

--=-8xoHcM7z080lWW5ZjjM0
Content-Disposition: attachment; filename=aacraid-2.5.64.diff
Content-Type: text/plain; name=aacraid-2.5.64.diff; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

===== drivers/scsi/aacraid/linit.c 1.12 vs edited =====
--- 1.12/drivers/scsi/aacraid/linit.c	Mon Feb 24 13:03:30 2003
+++ edited/drivers/scsi/aacraid/linit.c	Fri Mar 14 08:04:51 2003
@@ -679,27 +679,26 @@
  */
  
 static Scsi_Host_Template driver_template = {
-	module:			THIS_MODULE,
-	name:           	"AAC",
-	proc_info:      	aac_procinfo,
-	detect:         	aac_detect,
-	release:        	aac_release,
-	info:           	aac_driverinfo,
-	ioctl:          	aac_ioctl,
-	queuecommand:   	aac_queuecommand,
-	bios_param:     	aac_biosparm,	
-	slave_configure:	aac_slave_configure,
-	can_queue:      	AAC_NUM_IO_FIB,	
-	this_id:        	16,
-	sg_tablesize:   	16,
-	max_sectors:    	128,
-	cmd_per_lun:    	AAC_NUM_IO_FIB,
-	eh_abort_handler:       aac_eh_abort,
-	eh_device_reset_handler:aac_eh_device_reset,
-	eh_bus_reset_handler:	aac_eh_bus_reset,
-	eh_host_reset_handler:	aac_eh_reset,
-
-	use_clustering:		ENABLE_CLUSTERING,
+	.module				= THIS_MODULE,
+	.name           		= "AAC",
+	.proc_info      		= aac_procinfo,
+	.detect         		= aac_detect,
+	.release        		= aac_release,
+	.info           		= aac_driverinfo,
+	.ioctl          		= aac_ioctl,
+	.queuecommand   		= aac_queuecommand,
+	.bios_param     		= aac_biosparm,	
+	.slave_configure		= aac_slave_configure,
+	.can_queue      		= AAC_NUM_IO_FIB,	
+	.this_id        		= 16,
+	.sg_tablesize   		= 16,
+	.max_sectors    		= 128,
+	.cmd_per_lun    		= 1,
+	.eh_abort_handler       	= aac_eh_abort,
+	.eh_device_reset_handler 	= aac_eh_device_reset,
+	.eh_bus_reset_handler		= aac_eh_bus_reset,
+	.eh_host_reset_handler		= aac_eh_reset,
+	.use_clustering			= ENABLE_CLUSTERING,
 };
 
 #include "scsi_module.c"

--=-8xoHcM7z080lWW5ZjjM0--
