From: Francis Wiran <francis.wiran@hp.com>
Subject: [PATCH]2.5.40, cpqfc, fix ioctl sense buffer memcpy size
Date: Wed, 9 Oct 2002 13:44:41 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210091337070.1500-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@suse.de


This patch fixes hangs after doing an ioctl to cpqfc due to the different 
size of the defined sense buffer, causing memcpy to write stuff where it 
shouldn't.

Also submitted to SourceForge as cpqfc-2.5.3-to-2.5.4.patch


--- linux-2.5.40/drivers/scsi/cpqfc.Readme	Tue Oct  1 01:07:47 2002
+++ linux-2.5.40-p1/drivers/scsi/cpqfc.Readme	Fri Oct  4 16:56:34 2002
@@ -7,6 +7,8 @@
 SEST size 512 Exchanges (simultaneous I/Os) limited by module kmalloc() 
 	max of 128k bytes contiguous.
 
+Ver 2.5.4  Oct 03, 2002
+   * fixed memcpy of sense buffer in ioctl to copy the smaller defined size
 Ver 2.5.3  Aug 01, 2002
    * fix the passthru ioctl to handle the Scsi_Cmnd->request being a pointer
 Ver 2.5.1  Jul 30, 2002
--- linux-2.5.40/drivers/scsi/cpqfcTSstructs.h	Tue Oct  1 01:06:57 2002
+++ linux-2.5.40-p1/drivers/scsi/cpqfcTSstructs.h	Fri Oct  4 17:01:28 2002
@@ -33,7 +33,7 @@
 // don't forget to also change MODULE_DESCRIPTION in cpqfcTSinit.c
 #define VER_MAJOR 2
 #define VER_MINOR 5
-#define VER_SUBMINOR 3
+#define VER_SUBMINOR 4
 
 // Macros for kernel (esp. SMP) tracing using a PCI analyzer
 // (e.g. x86).
--- linux-2.5.40/drivers/scsi/cpqfcTSinit.c	Fri Oct  4 16:52:28 2002
+++ linux-2.5.40-p1/drivers/scsi/cpqfcTSinit.c	Fri Oct  4 17:00:46 2002
@@ -68,7 +68,7 @@
 
 /* Embedded module documentation macros - see module.h */
 MODULE_AUTHOR("Compaq Computer Corporation");
-MODULE_DESCRIPTION("Driver for Compaq 64-bit/66Mhz PCI Fibre Channel HBA v. 2.5.3");
+MODULE_DESCRIPTION("Driver for Compaq 64-bit/66Mhz PCI Fibre Channel HBA v. 2.5.4");
 MODULE_LICENSE("GPL");
   
 int cpqfcTS_TargetDeviceReset( Scsi_Device *ScsiDev, unsigned int reset_flags);
@@ -668,7 +668,11 @@
 	{
 	  memcpy( vendor_cmd->sense_data, // see struct def - size=40
 		  ScsiPassThruReq->sr_sense_buffer, 
-		  sizeof(ScsiPassThruReq->sr_sense_buffer)); 
+		  sizeof(ScsiPassThruReq->sr_sense_buffer) <
+                  sizeof(vendor_cmd->sense_data)           ?
+                  sizeof(ScsiPassThruReq->sr_sense_buffer) :
+                  sizeof(vendor_cmd->sense_data)
+                ); 
 	}
         SDpnt = ScsiPassThruReq->sr_device;
 	/* upper_private_data is already freed in call_scsi_done() */

