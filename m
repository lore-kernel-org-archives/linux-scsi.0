From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] cpqfcTSinit cleanup
Date: Fri, 3 Oct 2003 16:32:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031003163225.0f2fa17e.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:16814 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261605AbTJCXlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2003 19:41:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: jejb <james.bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, support@compaq.com

Hi,

Please apply to 2.6.0-testX-current.

Thanks,
--
~Randy


patch_name:	drivers_clean.patch
patch_version:	2003-09-09.17:01:58
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	fix to remove these warnings:
  drivers/scsi/cpqfcTSinit.c:1583: warning: unused variable `timeout'
  drivers/scsi/cpqfcTSinit.c:1584: warning: unused variable `retries'
  drivers/scsi/cpqfcTSinit.c:1585: warning: unused variable `scsi_cdb'
  drivers/scsi/cpqfcTSinit.c:471: warning: `my_ioctl_done' defined but not used
product:	Linux
product_versions: 2.6.0-test6
changelog:	ifdef around my_ioctl_done();
		write a new, smaller version of cpqfcTS_TargetDeviceReset(),
		but keep the previous version for future updates;
maintainer:	Chase Maupin (support@compaq.com)
diffstat:	=
 drivers/scsi/cpqfcTSinit.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)


diff -Naurp ./drivers/scsi/cpqfcTSinit.c~clean ./drivers/scsi/cpqfcTSinit.c
--- ./drivers/scsi/cpqfcTSinit.c~clean	2003-09-08 12:49:52.000000000 -0700
+++ ./drivers/scsi/cpqfcTSinit.c	2003-09-09 16:54:19.000000000 -0700
@@ -467,6 +467,7 @@ int cpqfcTS_detect(Scsi_Host_Template *S
   return NumberOfAdapters;
 }
 
+#ifdef SUPPORT_RESET
 static void my_ioctl_done (Scsi_Cmnd * SCpnt)
 {
     struct request * req;
@@ -477,7 +478,7 @@ static void my_ioctl_done (Scsi_Cmnd * S
     if (req->CPQFC_WAITING != NULL)
 	CPQFC_COMPLETE(req->CPQFC_WAITING);
 }   
-
+#endif
 
 static int cpqfc_alloc_private_data_pool(CPQFCHBA *hba)
 {
@@ -1577,6 +1578,8 @@ Done:
 // See dpANS Fibre Channel Protocol for SCSI
 // X3.269-199X revision 12, pg 25
 
+#ifdef SUPPORT_RESET
+
 int cpqfcTS_TargetDeviceReset( Scsi_Device *ScsiDev, 
                                unsigned int reset_flags)
 {
@@ -1592,8 +1595,7 @@ int cpqfcTS_TargetDeviceReset( Scsi_Devi
 // around the 2.5.30 kernel.  Scsi_Cmnd replaced with 
 // Scsi_Request, etc.
 // For now, so people don't fall into a hole...
-return -ENOTSUPP;
-/*
+
   // printk("   ENTERING cpqfcTS_TargetDeviceReset() - flag=%d \n",reset_flags);
 
   if (ScsiDev->host->eh_active) return FAILED;
@@ -1647,7 +1649,6 @@ return -ENOTSUPP;
 		   SCpnt->sense_buffer[2] & 0xf);
 	    
       };
-*/    
   result = SCpnt->result;
 
   SDpnt = SCpnt->device;
@@ -1658,6 +1659,14 @@ return -ENOTSUPP;
   return SUCCESS;
 }
 
+#else
+int cpqfcTS_TargetDeviceReset( Scsi_Device *ScsiDev, 
+                               unsigned int reset_flags)
+{
+	return -ENOTSUPP;
+}
+
+#endif /* SUPPORT_RESET */
 
 int cpqfcTS_eh_device_reset(Scsi_Cmnd *Cmnd)
 {
