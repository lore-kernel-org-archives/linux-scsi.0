From: Mike Christie <mikenc@us.ibm.com>
Subject: [PATCH] fixes compile errors in psi240i.c
Date: Mon, 21 Apr 2003 16:42:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EA481F7.8080403@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030307060901030908020408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:31882 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262693AbTDUXbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 19:31:45 -0400
Received: from northrelay01.pok.ibm.com (northrelay01.pok.ibm.com [9.56.224.149])
	by e4.ny.us.ibm.com (8.12.9/8.12.2) with ESMTP id h3LNhisZ139020
	for <linux-scsi@vger.kernel.org>; Mon, 21 Apr 2003 19:43:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030307060901030908020408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch fixes the compile errors in psi240i.c described in 
Bugzilla bug #468 at http://bugme.osdl.org/show_bug.cgi?id=468. It was 
built against 2.5.68. I do not have the hardware, so I have only 
verified that it compiles correctly.

Mike Christie
mikenc@us.ibm.com

psi240i.c |   57 ++++++++++++++++++++++++++++-----------------------------
1 files changed, 28 insertions(+), 29 deletions(-)


--------------030307060901030908020408
Content-Type: text/plain;
 name="psi_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="psi_patch"

--- linux-2.5.68-orig/drivers/scsi/psi240i.c	Sat Apr 19 19:50:09 2003
+++ linux-2.5.68/drivers/scsi/psi240i.c	Mon Apr 21 15:45:02 2003
@@ -54,7 +54,7 @@
 #define DEB(x)
 #endif
 
-#define MAXBOARDS 2	/* Increase this and the sizes of the arrays below, if you need more. */
+#define MAXBOARDS 6	/* Increase this and the sizes of the arrays below, if you need more. */
 
 #define	PORT_DATA				0
 #define	PORT_ERROR				1
@@ -390,8 +390,8 @@ static void do_Irq_Handler (int irq, voi
 int Psi240i_QueueCommand (Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 	{
 	UCHAR		   *cdb = (UCHAR *)SCpnt->cmnd;					// Pointer to SCSI CDB
-	PADAPTER240I	padapter = HOSTDATA(SCpnt->host);			// Pointer to adapter control structure
-	POUR_DEVICE		pdev	 = &padapter->device[SCpnt->target];// Pointer to device information
+	PADAPTER240I	padapter = HOSTDATA (SCpnt->device->host); 			// Pointer to adapter control structure
+	POUR_DEVICE 		pdev	 = &padapter->device [SCpnt->device->id];// Pointer to device information
 	UCHAR			rc;											// command return code
 
 	SCpnt->scsi_done = done;
@@ -566,25 +566,25 @@ int Psi240i_Detect (Scsi_Host_Template *
 	int					count = 0;
 	int					unit;
 	int					z;
-	USHORT				port;
+	USHORT				port, port_range = 16;
 	CHIP_CONFIG_N		chipConfig;
 	CHIP_DEVICE_N		chipDevice[8];
 	struct Scsi_Host   *pshost;
-	ULONG				flags;
 
-	for ( board = 0;  board < 6;  board++ )					// scan for I/O ports
+	for ( board = 0;  board < MAXBOARDS;  board++ )					// scan for I/O ports
 		{
+		pshost = NULL;
 		port = portAddr[board];								// get base address to test
-		if ( check_region (port, 16) )						// test for I/O addresses available
-			continue;										//   nope
-		if ( inb_p (port + REG_FAIL) != CHIP_ID )			// do the first test for likley hood that it is us
+		if ( !request_region (port, port_range, "psi240i") )
 			continue;
+		if ( inb_p (port + REG_FAIL) != CHIP_ID )			// do the first test for likley hood that it is us
+			goto host_init_failure;
 		outb_p (SEL_NONE, port + REG_SEL_FAIL);				// setup EEPROM/RAM access
 		outw (0, port + REG_ADDRESS);						// setup EEPROM address zero
 		if ( inb_p (port) != 0x55 )							// test 1st byte
-			continue;										//   nope
+			goto host_init_failure;									//   nope
 		if ( inb_p (port + 1) != 0xAA )						// test 2nd byte
-			continue;										//   nope
+			goto host_init_failure;								//   nope
 
 		// at this point our board is found and can be accessed.  Now we need to initialize
 		// our informatation and register with the kernel.
@@ -595,20 +595,11 @@ int Psi240i_Detect (Scsi_Host_Template *
 		ReadChipMemory (&ChipSetup, CHIP_EEPROM_DATA, sizeof (ChipSetup), port);
 
 		if ( !chipConfig.numDrives )						// if no devices on this board
-			continue;
+			goto host_init_failure;
 
 		pshost = scsi_register (tpnt, sizeof(ADAPTER240I));
 		if(pshost == NULL)
-			continue;
-
-		save_flags (flags);
-		cli ();
-		if ( request_irq (chipConfig.irq, do_Irq_Handler, 0, "psi240i", pshost) )
-			{
-			printk ("Unable to allocate IRQ for PSI-240I controller.\n");
-			restore_flags (flags);
-			goto unregister;
-			}
+			goto host_init_failure;	
 
 		PsiHost[chipConfig.irq - 10] = pshost;
 		pshost->unique_id = port;
@@ -642,14 +633,22 @@ int Psi240i_Detect (Scsi_Host_Template *
 			DEB (printk ("\n          blocks    = %lX", HOSTDATA(pshost)->device[unit].blocks));
 			}
 
-		restore_flags (flags);
-		printk("\nPSI-240I EIDE CONTROLLER: at I/O = %x  IRQ = %d\n", port, chipConfig.irq);
-		printk("(C) 1997 Perceptive Solutions, Inc. All rights reserved\n\n");
-		count++;
-		continue;
+		if ( request_irq (chipConfig.irq, do_Irq_Handler, 0, "psi240i", pshost) == 0 ) 
+			{
+			printk("\nPSI-240I EIDE CONTROLLER: at I/O = %x  IRQ = %d\n", port, chipConfig.irq);
+		        printk("(C) 1997 Perceptive Solutions, Inc. All rights reserved\n\n");
+		        count++;
+		        continue;
+			}
+
+		printk ("Unable to allocate IRQ for PSI-240I controller.\n");
+           
+host_init_failure:
+		
+		release_region (port, port_range);
+		if (pshost)
+			scsi_unregister (pshost);
 
-unregister:;
-		scsi_unregister (pshost);
 		}
 	return count;
 	}

--------------030307060901030908020408--

