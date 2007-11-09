From: bo yang <bo.yang@lsi.com>
Subject: PATCH 6/6] scsi: megaraid_sas - Update version and changelog
Date: Fri, 09 Nov 2007 04:44:56 -0500
Message-ID: <1194601496.6297.16.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37028 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbXKIVjo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 16:39:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com

Update version and changelog

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 Documentation/scsi/ChangeLog.megaraid_sas |  155 ++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.c      |   10 -
 drivers/scsi/megaraid/megaraid_sas.h      |    8 -
 3 files changed, 164 insertions(+), 9 deletions(-)

diff -rupN linux-2.6.22_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.22_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.22_orig/Documentation/scsi/ChangeLog.megaraid_sas	2007-11-07 02:42:15.908757968 -0500
+++ linux-2.6.22_new/Documentation/scsi/ChangeLog.megaraid_sas	2007-11-07 02:51:31.273329720 -0500
@@ -1,3 +1,158 @@
+1 Release Date    : Thur. Nov. 07 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+
+2 Current Version : 00.00.03.16
+3 Older Version   : 00.00.03.15
+
+1. Increased MFI_POLL_TIMEOUT_SECS to 60 seconds from 10. FW may take a max of 60 seconds to 
+	respond to the INIT cmd.
+
+1 Release Date    : Fri. Sep. 07 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+
+2 Current Version : 00.00.03.15
+3 Older Version   : 00.00.03.14
+
+1. Added module parameter "poll_mode_io" to support for "polling" (reduced interrupt operation).
+	In this mode, IO completion interrupts are delayed. At the end of initiating IOs,
+	the driver schedules for cmd completion if there are pending cmds to be completed.
+	A timer-based interrupt has also been added to prevent IO completion processing from
+	being delayed indefinitely in the case that no new IOs are initiated.
+
+1 Release Date    : Fri. Sep. 07 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+
+2 Current Version : 00.00.03.14
+3 Older Version   : 00.00.03.13
+
+1. Setting the max_sectors_per_req based on max SGL supported by the FW. Prior versions calculated 
+	this value from controller info (max_sectors_1, max_sectors_2). For certain controllers/FW,
+	this was resulting in a value greater than max SGL supported by the FW. Issue was first
+	reported by users running LUKS+XFS with megaraid_sas.
+	Thanks to RB for providing the logs and duplication steps that helped to get to the root 
+	cause of the issue.
+2. Increased MFI_POLL_TIMEOUT_SECS to 60 seconds from 10. FW may take a max of 60 seconds to 
+	respond to the INIT cmd.
+
+1 Release Date    : Fri. June. 15 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+
+2 Current Version : 00.00.03.13
+3 Older Version   : 00.00.03.12
+
+1. Added the megasas_reset_timer routine to intercept cmd timeout and throttle io.
+
+On Fri, 2007-03-16 at 16:44 -0600, James Bottomley wrote:
+It looks like megaraid_sas at least needs this to throttle its commands
+> as they begin to time out.  The code keeps the existing transport
+> template use of eh_timed_out (and allows the transport to override the
+> host if they both have this callback).
+> 
+> James
+
+1 Release Date    : Sat May. 12 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+
+2 Current Version : 00.00.03.12
+3 Older Version   : 00.00.03.11
+
+1.  When MegaSAS driver receives reset call from OS, driver waits in reset
+routine for max 3 minutes for all pending command completion. Now driver will
+call completion routine every 5 seconds from the reset routine instead of
+waiting for depending on cmd completion from isr path.
+
+1 Release Date    : Mon Apr. 30 10:25:52 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+
+2 Current Version : 00.00.03.11
+3 Older Version   : 00.00.03.09
+
+	1. Memory Manager for IOCTL removed for 2.6 kernels.
+	   pci_alloc_consistent replaced by dma_alloc_coherent. With this 
+	   change there is no need of memory manager in the driver code
+
+	On Wed, 2007-02-07 at 13:30 -0800, Andrew Morton wrote:
+	> I suspect all this horror is due to stupidity in the DMA API.
+	>
+	> pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas
+	> the caller (megasas_mgmt_fw_ioctl) would have been perfectly happy
+	> to use GFP_KERNEL.
+	>
+	> I bet this fixes it
+
+	It does, but the DMA API was expanded to cope with this exact case, so
+	use dma_alloc_coherent() directly in the megaraid code instead.  The dev
+	is just &pci_dev->dev.
+
+	James <James.Bottomley@SteelEye.com>
+
+	3. SYNCHRONIZE_CACHE is not supported by FW and thus blocked by driver.
+	4. Hibernation support added
+	5. Performing diskdump while running IO in RHEL 4 was failing. Fixed.
+		
+1 Release Date    : Fri Feb. 09 14:36:28 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+
+2 Current Version : 00.00.03.09
+3 Older Version   : 00.00.03.08
+
+i.	Under heavy IO mid-layer prints "DRIVER_TIMEOUT" errors  
+
+	The driver now waits for 10 seconds to elapse instead of 5 (as in
+	previous release) to resume IO.
+
+1 Release Date    : Mon Feb. 05 11:35:24 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang 
+2 Current Version : 00.00.03.08
+3 Older Version   : 00.00.03.07
+
+i.	Under heavy IO mid-layer prints "DRIVER_TIMEOUT" errors  
+
+	Fix:	The driver is now throttling IO.
+	Checks added in megasas_queue_command to know if FW is able to 
+	process commands within timeout period. If number of retries
+	is 2 or greater,the driver stops sending cmd to FW temporarily. IO is
+	resumed if pending cmd count reduces to 16 or 5 seconds has elapsed
+	from the time cmds were last sent to FW.
+
+ii.	FW enables WCE bit in Mode Sense cmd for drives that are configured 
+	as WriteBack. The OS may send "SYNCHRONIZE_CACHE" cmd when Logical
+	Disks are exposed with WCE=1. User is advised to enable Write Back
+	mode only when the controller has battery backup. At this time 
+	Synhronize cache is not supported by the FW. Driver will short-cycle 
+	the cmd and return sucess without sending down to FW.
+
+1 Release Date    : Sun Jan. 14 11:21:32 PDT 2007 -
+		 Sumant Patro <Sumant.Patro@lsil.com>/Bo Yang
+2 Current Version : 00.00.03.07
+3 Older Version   : 00.00.03.06
+
+i.	bios_param entry added in scsi_host_template that returns disk geometry
+	information.
+
+1 Release Date    : Fri Oct 20 11:21:32 PDT 2006 - Sumant Patro <Sumant.Patro@lsil.com>/Bo Yang
+2 Current Version : 00.00.03.06
+3 Older Version   : 00.00.03.05
+
+1. Added new memory management module to support the IOCTL memory allocation. For IOCTL we try to allocate from the memory pool created during driver initialization. If mem pool is empty then we allocate at run time.
+2. Added check in megasas_queue_command and dpc/isr routine to see if we have already declared adapter dead
+   (hw_crit_error=1). If hw_crit_error==1, now we donot accept any processing of pending cmds/accept any cmd from OS
 
 1 Release Date    : Mon Oct 02 11:21:32 PDT 2006 - Sumant Patro <Sumant.Patro@lsil.com>
 2 Current Version : 00.00.03.05
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:42:37.248513832 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 02:43:34.125867160 -0500
@@ -2,7 +2,7 @@
  *
  *		Linux MegaRAID driver for SAS based RAID controllers
  *
- * Copyright (c) 2003-2005  LSI Logic Corporation.
+ * Copyright (c) 2003-2005  LSI Corporation.
  *
  *	   This program is free software; you can redistribute it and/or
  *	   modify it under the terms of the GNU General Public License
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.10-rc5
+ * Version	: v00.00.03.16-rc1
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
@@ -57,7 +57,7 @@ MODULE_PARM_DESC(poll_mode_io,
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
-MODULE_DESCRIPTION("LSI Logic MegaRAID SAS Driver");
+MODULE_DESCRIPTION("LSI MegaRAID SAS Driver");
 
 /*
  * PCI ID table for all supported controllers
@@ -1181,7 +1181,7 @@ megasas_service_aen(struct megasas_insta
 static struct scsi_host_template megasas_template = {
 
 	.module = THIS_MODULE,
-	.name = "LSI Logic SAS based MegaRAID driver",
+	.name = "LSI SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
 	.slave_configure = megasas_slave_configure,
 	.queuecommand = megasas_queue_command,
@@ -1965,7 +1965,7 @@ static int megasas_init_mfi(struct megas
 	 */
 	instance->base_addr = pci_resource_start(instance->pdev, 0);
 
-	if (pci_request_regions(instance->pdev, "megasas: LSI Logic")) {
+	if (pci_request_regions(instance->pdev, "megasas: LSI")) {
 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
 		return -EBUSY;
 	}
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:42:37.915412448 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 02:45:29.711295504 -0500
@@ -2,7 +2,7 @@
  *
  *		Linux MegaRAID driver for SAS based RAID controllers
  *
- * Copyright (c) 2003-2005  LSI Logic Corporation.
+ * Copyright (c) 2003-2005  LSI Corporation.
  *
  *		This program is free software; you can redistribute it and/or
  *		modify it under the terms of the GNU General Public License
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.10-rc5"
-#define MEGASAS_RELDATE				"May 17, 2007"
-#define MEGASAS_EXT_VERSION			"Thu May 17 10:09:32 PDT 2007"
+#define MEGASAS_VERSION				"00.00.03.16-rc1"
+#define MEGASAS_RELDATE				"Nov. 07, 2007"
+#define MEGASAS_EXT_VERSION			"Thu. Nov. 07 10:09:32 PDT 2007"
 
 /*
  * Device IDs


