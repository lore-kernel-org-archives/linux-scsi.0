From: "Adam Radford" <aradford@amcc.com>
Subject: [PATCH] 3ware driver update for 2.6.6-rc3
Date: Wed, 21 Apr 2004 16:56:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HWJP6B03.D0B@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:46473 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S263348AbUDUX4h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 19:56:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Here is a patch for the 3ware 3w-xxxx driver for 2.6.6-rc3.  
Bits of this patch are already in 2.6.6-rc2-mm1, but I was told
to re-send since I forgot to cc: linux-scsi.

This patch includes the following driver changes:

   1.26.00.038 - Roll driver minor version to 26 to denote kernel 2.6.
                 Add support for cmds_per_lun module parameter.
   1.26.00.039 - Fix bug in tw_chrdev_ioctl() polling code.
                 Fix data_buffer_length usage in tw_chrdev_ioctl().
                 Update contact information.

Please apply.

Thanks,

-Adam Radford

diff -Naur linux-2.6.6-rc2/drivers/scsi/3w-xxxx.c linux-2.6.6-rc3/drivers/scsi/3w-xxxx.c
--- linux-2.6.6-rc2/drivers/scsi/3w-xxxx.c	2004-04-03 19:38:17.000000000 -0800
+++ linux-2.6.6-rc3/drivers/scsi/3w-xxxx.c	2004-04-21 15:27:29.000000000 -0700
@@ -1,12 +1,12 @@
 /* 
    3w-xxxx.c -- 3ware Storage Controller device driver for Linux.
 
-   Written By: Adam Radford <linux@3ware.com>
+   Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Joel Jacobson <linux@3ware.com>
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2003 3ware Inc.
+   Copyright (C) 1999-2004 3ware Inc.
 
    Kernel compatiblity By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -47,10 +47,10 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 
    Bugs/Comments/Suggestions should be mailed to:                            
-   linux@3ware.com
+   linuxraid@amcc.com
 
    For more information, goto:
-   http://www.3ware.com
+   http://www.amcc.com
 
    History
    -------
@@ -179,6 +179,11 @@
    1.02.00.036 - Increase character ioctl timeout to 60 seconds.
    1.02.00.037 - Fix tw_ioctl() to handle all non-data ATA passthru cmds
                  for 'smartmontools' support.
+   1.26.00.038 - Roll driver minor version to 26 to denote kernel 2.6.
+                 Add support for cmds_per_lun module parameter.
+   1.26.00.039 - Fix bug in tw_chrdev_ioctl() polling code.
+                 Fix data_buffer_length usage in tw_chrdev_ioctl().
+                 Update contact information.
 */
 
 #include <linux/module.h>
@@ -205,6 +210,7 @@
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/moduleparam.h>
 
 #include <asm/errno.h>
 #include <asm/io.h>
@@ -242,10 +248,15 @@
 };
 
 /* Globals */
-char *tw_driver_version="1.02.00.037";
+char *tw_driver_version="1.26.00.039";
 TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 int tw_device_extension_count = 0;
 static int twe_major = -1;
+static int cmds_per_lun;
+
+/* Module parameters */
+module_param(cmds_per_lun, int, 0);
+MODULE_PARM_DESC(cmds_per_lun, "Maximum commands per LUN");
 
 /* Functions */
 
@@ -683,7 +694,7 @@
 			break;
 		case TW_OP_AEN_LISTEN:
 			dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): caught TW_AEN_LISTEN.\n");
-			memset(tw_ioctl->data_buffer, 0, tw_ioctl->data_buffer_length);
+			memset(tw_ioctl->data_buffer, 0, data_buffer_length);
 
 			spin_lock_irqsave(tw_dev->host->host_lock, flags);
 			if (tw_dev->aen_head == tw_dev->aen_tail) {
@@ -738,7 +749,7 @@
 			timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
 
 			/* Now wait for the command to complete */
-			wait_event_interruptible_timeout(tw_dev->ioctl_wqueue, tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
+			timeout = wait_event_interruptible_timeout(tw_dev->ioctl_wqueue, tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
 
 			/* Check if we timed out, got a signal, or didn't get
 			   an interrupt */
@@ -777,7 +788,7 @@
 	}
 
 	/* Now copy the response to userspace */
-	error = copy_to_user((void *)arg, tw_ioctl, sizeof(TW_New_Ioctl) + tw_ioctl->data_buffer_length - 1);
+	error = copy_to_user((void *)arg, tw_ioctl, sizeof(TW_New_Ioctl) + data_buffer_length - 1);
 	if (error == 0)
 		retval = 0;
 out2:
@@ -1141,14 +1152,6 @@
 			/* Set card status as online */
 			tw_dev->online = 1;
 
-#ifdef CONFIG_3W_XXXX_CMD_PER_LUN
-			tw_host->cmd_per_lun = CONFIG_3W_XXXX_CMD_PER_LUN;
-			if (tw_host->cmd_per_lun > TW_MAX_CMDS_PER_LUN)
-				tw_host->cmd_per_lun = TW_MAX_CMDS_PER_LUN;
-#else
-			/* Use SHT cmd_per_lun here */
-			tw_host->cmd_per_lun = TW_MAX_CMDS_PER_LUN;
-#endif
 			tw_dev->free_head = TW_Q_START;
 			tw_dev->free_tail = TW_Q_START;
 			tw_dev->free_wrap = TW_Q_LENGTH - 1;
@@ -3386,13 +3389,13 @@
 
 	dprintk(KERN_WARNING "3w-xxxx: tw_slave_configure()\n");
 
-#ifdef CONFIG_3W_XXXX_CMD_PER_LUN
-	max_cmds = CONFIG_3W_XXXX_CMD_PER_LUN;
-	if (max_cmds > TW_MAX_CMDS_PER_LUN)
+	if (cmds_per_lun) {
+		max_cmds = cmds_per_lun;
+		if (max_cmds > TW_MAX_CMDS_PER_LUN)
+			max_cmds = TW_MAX_CMDS_PER_LUN;
+	} else {
 		max_cmds = TW_MAX_CMDS_PER_LUN;
-#else
-	max_cmds = TW_MAX_CMDS_PER_LUN;
-#endif
+	}
 	scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, max_cmds);
 
 	return 0;
@@ -3488,6 +3491,7 @@
 	.eh_abort_handler	= tw_scsi_eh_abort,
 	.eh_host_reset_handler	= tw_scsi_eh_reset,
 	.bios_param		= tw_scsi_biosparam,
+	.slave_configure	= tw_slave_configure,
 	.can_queue		= TW_Q_LENGTH-2,
 	.this_id		= -1,
 	.sg_tablesize		= TW_MAX_SGL_LENGTH,
diff -Naur linux-2.6.6-rc2/drivers/scsi/3w-xxxx.h linux-2.6.6-rc3/drivers/scsi/3w-xxxx.h
--- linux-2.6.6-rc2/drivers/scsi/3w-xxxx.h	2004-04-03 19:36:45.000000000 -0800
+++ linux-2.6.6-rc3/drivers/scsi/3w-xxxx.h	2004-04-21 15:27:30.000000000 -0700
@@ -1,12 +1,12 @@
 /* 
    3w-xxxx.h -- 3ware Storage Controller device driver for Linux.
    
-   Written By: Adam Radford <linux@3ware.com>
+   Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Joel Jacobson <linux@3ware.com>
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2003 3ware Inc.
+   Copyright (C) 1999-2004 3ware Inc.
 
    Kernel compatiblity By:	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -45,10 +45,10 @@
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 
    Bugs/Comments/Suggestions should be mailed to:                            
-   linux@3ware.com
+   linuxraid@amcc.com
    
    For more information, goto:
-   http://www.3ware.com
+   http://www.amcc.com
 */
 
 #ifndef _3W_XXXX_H

