From: Stephen Cameron <steve.cameron@hp.com>
Subject: [PATCH] cpqfc, 2.5.30, lun fix
Date: Fri, 2 Aug 2002 16:46:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802164613.A3445@zuul.cca.cpqcorp.net>
Reply-To: steve.cameron@hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This is basically a port of a patch to 2.4 kernels to fix
the ioctls to pay attention to the lun field.  For 2.5.30,
the passthrough ioctl is pretty broken, and this patch does not
fix that.  (The patch I'm sending after this one does.) 

-- steve

diff -urN linux-2.5.30/drivers/scsi/cpqfc.Readme linux-2.5.30-p1/drivers/scsi/cpqfc.Readme
--- linux-2.5.30/drivers/scsi/cpqfc.Readme	Wed Jul 24 16:03:32 2002
+++ linux-2.5.30-p1/drivers/scsi/cpqfc.Readme	Fri Aug  2 15:13:14 2002
@@ -7,10 +7,15 @@
 SEST size 512 Exchanges (simultaneous I/Os) limited by module kmalloc() 
 	max of 128k bytes contiguous.
 
+Ver 2.5.1  Jul 30, 2002
+   * fix ioctl to pay attention to the specified LUN.
 Ver 2.5.0  Nov 29, 2001
    * eliminated io_request_lock.  This change makes the driver specific
      to the 2.5.x kernels.
    * silenced excessively noisy printks.
+
+Ver 2.1.2  July 23, 2002
+   * initialize DumCmnd->lun in cpqfcTS_ioctl (used in fcFindLoggedInPorts as LUN index)
 
 Ver 2.1.1  Oct 18, 2001
    * reinitialize Cmnd->SCp.sent_command (used to identify commands as
diff -urN linux-2.5.30/drivers/scsi/cpqfcTSinit.c linux-2.5.30-p1/drivers/scsi/cpqfcTSinit.c
--- linux-2.5.30/drivers/scsi/cpqfcTSinit.c	Fri Aug  2 15:11:04 2002
+++ linux-2.5.30-p1/drivers/scsi/cpqfcTSinit.c	Fri Aug  2 15:13:14 2002
@@ -68,7 +68,7 @@
 
 /* Embedded module documentation macros - see module.h */
 MODULE_AUTHOR("Compaq Computer Corporation");
-MODULE_DESCRIPTION("Driver for Compaq 64-bit/66Mhz PCI Fibre Channel HBA v. 2.1.1");
+MODULE_DESCRIPTION("Driver for Compaq 64-bit/66Mhz PCI Fibre Channel HBA v. 2.5.2");
 MODULE_LICENSE("GPL");
   
 int cpqfcTS_TargetDeviceReset( Scsi_Device *ScsiDev, unsigned int reset_flags);
@@ -503,6 +503,7 @@
   // can we find an FC device mapping to this SCSI target?
   DumCmnd.channel = ScsiDev->channel;		// For searching
   DumCmnd.target  = ScsiDev->id;
+  DumCmnd.lun     = ScsiDev->lun;
   pLoggedInPort = fcFindLoggedInPort( fcChip,
     &DumCmnd, // search Scsi Nexus
     0,        // DON'T search linked list for FC port id
diff -urN linux-2.5.30/drivers/scsi/cpqfcTSstructs.h linux-2.5.30-p1/drivers/scsi/cpqfcTSstructs.h
--- linux-2.5.30/drivers/scsi/cpqfcTSstructs.h	Wed Jul 24 16:03:26 2002
+++ linux-2.5.30-p1/drivers/scsi/cpqfcTSstructs.h	Fri Aug  2 15:13:14 2002
@@ -33,7 +33,7 @@
 // don't forget to also change MODULE_DESCRIPTION in cpqfcTSinit.c
 #define VER_MAJOR 2
 #define VER_MINOR 5
-#define VER_SUBMINOR 0
+#define VER_SUBMINOR 2
 
 // Macros for kernel (esp. SMP) tracing using a PCI analyzer
 // (e.g. x86).
diff -urN linux-2.5.30/drivers/scsi/cpqfcTSworker.c linux-2.5.30-p1/drivers/scsi/cpqfcTSworker.c
--- linux-2.5.30/drivers/scsi/cpqfcTSworker.c	Wed Jul 24 16:03:30 2002
+++ linux-2.5.30-p1/drivers/scsi/cpqfcTSworker.c	Fri Aug  2 15:13:14 2002
@@ -3380,6 +3380,8 @@
 	  // Report Luns command
           if( pLoggedInPort->ScsiNexus.LunMasking == 1) 
 	  {
+	    if (Cmnd->lun > sizeof(pLoggedInPort->ScsiNexus.lun))
+		return NULL;
             // we KNOW all the valid LUNs... 0xFF is invalid!
             Cmnd->SCp.have_data_in = pLoggedInPort->ScsiNexus.lun[Cmnd->lun];
 	    if (pLoggedInPort->ScsiNexus.lun[Cmnd->lun] == 0xFF)
