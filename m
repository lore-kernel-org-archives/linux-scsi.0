From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] cpqfc: remove unused variables/function
Date: Tue, 9 Sep 2003 17:01:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030909170144.271af2f4.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57297 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265090AbTIJAHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2003 20:07:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb <james.bottomley@steeleye.com>, support@compaq.com, compaqandlinux@cpqlin.van-dijk.net


cpqfcTSinit.c has unused variables in cpqfcTS_TargetDeviceReset().
After I cleaned that up, the  my_ioctl_done() function was no longer
used.

This patch adds a local #ifdef for "SUPPORT_RESET" to control
compilation of these functions.  If it is not defined (default),
TargetDeviceReset() just returns -ENOTSUPP, as before, but
much cleaner.

Patch is for 2.6.0-test5.

--
~Randy



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
