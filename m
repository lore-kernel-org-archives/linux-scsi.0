From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [PATCH ] remove check_region from drivers_scsi_cpqfcTSinit.c
Date: Tue, 14 Jan 2003 13:46:38 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114025452.E7CC92C279@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

From:  william stinson <wstinson@wanadoo.fr>

  Hi Amy,
  
  this proposed patch for drivers/scsi/cpqfcTSinit.c scsi driver for Linux removes two calls to check_region using request_region instead
  
  I don't have this hardware so patch is not tested. This patch removes all references to check_region in this driver.
  
  Patch also available at the following URL:
              
          http://www.chez.com/wstinson/linux/kernel/patch-scsi-cpqfcTSinit
     
  This is patch number 28 in a series of check_region patches I am doing as
   part of the kernel janitors project. Removal of check_region is one of the
   items on the kernel janitors TODO list (http://www.kerneljanitors.org/TODO)
   - get rid of check_region, use just request_region checking its return (2.2
   request_region returned void) and now the driver init sequence is not to be
   serialized anymore, so races are possible (look at cardbus/pcihotplug code)
  
  Best regards
  William Stinson
  

--- trivial-2.5.57/drivers/scsi/cpqfcTSinit.c.orig	2003-01-14 12:54:31.000000000 +1100
+++ trivial-2.5.57/drivers/scsi/cpqfcTSinit.c	2003-01-14 12:54:31.000000000 +1100
@@ -384,7 +384,8 @@
 
       // Since we have two 256-byte I/O port ranges (upper
       // and lower), check them both
-      if( check_region( cpqfcHBAdata->fcChip.Registers.IOBaseU, 0xff) )
+      if( !request_region( cpqfcHBAdata->fcChip.Registers.IOBaseU,
+      	                   0xff, DEV_NAME ) )
       {
 	printk("  cpqfcTS address in use: %x\n", 
 			cpqfcHBAdata->fcChip.Registers.IOBaseU);
@@ -393,21 +394,21 @@
 	continue;
       }	
       
-      if( check_region( cpqfcHBAdata->fcChip.Registers.IOBaseL, 0xff) )
+      if( !request_region( cpqfcHBAdata->fcChip.Registers.IOBaseL,
+      			   0xff, DEV_NAME ) )
       {
   	printk("  cpqfcTS address in use: %x\n", 
 	      			cpqfcHBAdata->fcChip.Registers.IOBaseL);
+	release_region( cpqfcHBAdata->fcChip.Registers.IOBaseU, 0xff );
 	free_irq( HostAdapter->irq, HostAdapter);
         scsi_unregister( HostAdapter);
 	continue;
       }	
       
-      // OK, we should be able to grab everything we need now.
-      request_region( cpqfcHBAdata->fcChip.Registers.IOBaseL, 0xff, DEV_NAME);
-      request_region( cpqfcHBAdata->fcChip.Registers.IOBaseU, 0xff, DEV_NAME);
-      DEBUG_PCI(printk("  Requesting 255 I/O addresses @ %x\n",
+      // OK, we have grabbed everything we need now.
+      DEBUG_PCI(printk("  Reserved 255 I/O addresses @ %x\n",
         cpqfcHBAdata->fcChip.Registers.IOBaseL ));
-      DEBUG_PCI(printk("  Requesting 255 I/O addresses @ %x\n",
+      DEBUG_PCI(printk("  Reserved 255 I/O addresses @ %x\n",
         cpqfcHBAdata->fcChip.Registers.IOBaseU ));
 
      
-- 
  Don't blame me: the Monkey is driving
  File: william stinson <wstinson@wanadoo.fr>: [PATCH ] remove check_region from drivers_scsi_cpqfcTSinit.c
