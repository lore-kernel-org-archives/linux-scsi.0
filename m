From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [PATCH] 3ware driver update for 2.6.0-test5-bk11
Date: Tue, 23 Sep 2003 16:24:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030923162402.6ee8114d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:1161 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263469AbTIWXWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 19:22:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org
Cc: Adam Radford <adam@nmt.edu>


James, could you please pick this up if Linus doesn't merge
it, and review?

Thanks.


Begin forwarded message:

Date: Tue, 23 Sep 2003 17:05:34 -0600
From: Adam Radford <adam@nmt.edu>
To: akpm@osdl.org, davej@redhat.com, torvalds@osdl.org
Subject: [PATCH] 3ware driver update for 2.6.0-test5-bk11


Andrew, Linus, Dave,

Please accept this 3ware driver update for 2.6.0-test5-bk11.
It fixes several things including fixing the character ioctl polling
to use wait_event_interruptible_timeout() instead of 
interruptible_sleep_on_timeout() and several other fixes.  These changes
were already applied to 2.4.22.

Thanks,

--
Adam Radford
Software Engineer
3ware, Inc.

diff -Naur linux-2.6.0-test5-bk10/drivers/scsi/3w-xxxx.c linux-2.6.0-test5-bk11/drivers/scsi/3w-xxxx.c
--- linux-2.6.0-test5-bk10/drivers/scsi/3w-xxxx.c	Mon Sep  8 12:50:29 2003
+++ linux-2.6.0-test5-bk11/drivers/scsi/3w-xxxx.c	Tue Sep 23 15:00:30 2003
@@ -169,6 +169,16 @@
                  Add support for "twe" character device for ioctls.
                  Clean up request_id queueing code.
                  Fix tw_scsi_queue() spinlocks.
+   1.02.00.033 - Fix tw_aen_complete() to not queue 'queue empty' AEN's.
+                 Initialize queues correctly when loading with no valid units.
+   1.02.00.034 - Fix tw_decode_bits() to handle multiple errors.
+                 Add support for user configurable cmd_per_lun.
+                 Add support for sht->slave_configure().
+   1.02.00.035 - Improve tw_allocate_memory() memory allocation.
+                 Fix tw_chrdev_ioctl() to sleep correctly.
+   1.02.00.036 - Increase character ioctl timeout to 60 seconds.
+   1.02.00.037 - Fix tw_ioctl() to handle all non-data ATA passthru cmds
+                 for 'smartmontools' support.
 */
 
 #include <linux/module.h>
@@ -232,7 +242,7 @@
 };
 
 /* Globals */
-char *tw_driver_version="1.02.00.032";
+char *tw_driver_version="1.02.00.037";
 TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -271,25 +281,24 @@
 			printk(KERN_WARNING "3w-xxxx: scsi%d: Received AEN %d.\n", tw_dev->host->host_no, aen);
 		}
 	}
-	if (aen != 0x0) 
+	if (aen != TW_AEN_QUEUE_EMPTY) {
 		tw_dev->aen_count++;
 
-	/* Now queue the code */
-	tw_dev->aen_queue[tw_dev->aen_tail] = aen;
-	if (tw_dev->aen_tail == TW_Q_LENGTH - 1) {
-		tw_dev->aen_tail = TW_Q_START;
-	} else {
-		tw_dev->aen_tail = tw_dev->aen_tail + 1;
-	}
-	if (tw_dev->aen_head == tw_dev->aen_tail) {
-		if (tw_dev->aen_head == TW_Q_LENGTH - 1) {
-			tw_dev->aen_head = TW_Q_START;
+		/* Now queue the code */
+		tw_dev->aen_queue[tw_dev->aen_tail] = aen;
+		if (tw_dev->aen_tail == TW_Q_LENGTH - 1) {
+			tw_dev->aen_tail = TW_Q_START;
 		} else {
-			tw_dev->aen_head = tw_dev->aen_head + 1;
+			tw_dev->aen_tail = tw_dev->aen_tail + 1;
+		}
+		if (tw_dev->aen_head == tw_dev->aen_tail) {
+			if (tw_dev->aen_head == TW_Q_LENGTH - 1) {
+				tw_dev->aen_head = TW_Q_START;
+			} else {
+				tw_dev->aen_head = tw_dev->aen_head + 1;
+			}
 		}
-	}
 
-	if (aen != TW_AEN_QUEUE_EMPTY) {
 		error = tw_aen_read_queue(tw_dev, request_id);
 		if (error) {
 			printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing AEN.\n", tw_dev->host->host_no);
@@ -551,29 +560,29 @@
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_allocate_memory()\n");
 
-	for (i=0;i<TW_Q_LENGTH;i++) {
-		cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, size, &dma_handle);
-		if (cpu_addr == NULL) {
-			printk(KERN_WARNING "3w-xxxx: pci_alloc_consistent() failed.\n");
-			return 1;
-		}
+	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, &dma_handle);
+	if (cpu_addr == NULL) {
+		printk(KERN_WARNING "3w-xxxx: pci_alloc_consistent() failed.\n");
+		return 1;
+	}
 
-		if ((unsigned long)cpu_addr % (tw_dev->tw_pci_dev->device == TW_DEVICE_ID ? TW_ALIGNMENT_6000 : TW_ALIGNMENT_7000)) {
-			printk(KERN_WARNING "3w-xxxx: Couldn't allocate correctly aligned memory.\n");
-			pci_free_consistent(tw_dev->tw_pci_dev, size, cpu_addr, dma_handle);
-			return 1;
-		}
+	if ((unsigned long)cpu_addr % (tw_dev->tw_pci_dev->device == TW_DEVICE_ID ? TW_ALIGNMENT_6000 : TW_ALIGNMENT_7000)) {
+		printk(KERN_WARNING "3w-xxxx: Couldn't allocate correctly aligned memory.\n");
+		pci_free_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, cpu_addr, dma_handle);
+		return 1;
+	}
 
+	memset(cpu_addr, 0, size*TW_Q_LENGTH);
+
+	for (i=0;i<TW_Q_LENGTH;i++) {
 		switch(which) {
 		case 0:
-			tw_dev->command_packet_virtual_address[i] = cpu_addr;
-			tw_dev->command_packet_physical_address[i] = dma_handle;
-			memset(tw_dev->command_packet_virtual_address[i], 0, size);
+			tw_dev->command_packet_physical_address[i] = dma_handle+(i*size);
+			tw_dev->command_packet_virtual_address[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
 			break;
 		case 1:
-			tw_dev->alignment_virtual_address[i] = cpu_addr;
-			tw_dev->alignment_physical_address[i] = dma_handle;
-			memset(tw_dev->alignment_virtual_address[i], 0, size);
+			tw_dev->alignment_physical_address[i] = dma_handle+(i*size);
+			tw_dev->alignment_virtual_address[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
 			break;
 		default:
 			printk(KERN_WARNING "3w-xxxx: tw_allocate_memory(): case slip in tw_allocate_memory()\n");
@@ -621,11 +630,11 @@
 	int error, request_id;
 	dma_addr_t dma_handle;
 	unsigned short tw_aen_code;
-	unsigned long before;
 	unsigned long flags;
 	unsigned int data_buffer_length = 0;
 	unsigned long data_buffer_length_adjusted = 0;
 	unsigned long *cpu_addr;
+	long timeout;
 	TW_New_Ioctl *tw_ioctl;
 	TW_Passthru *passthru;
 	TW_Device_Extension *tw_dev = tw_device_extension_list[iminor(inode)];
@@ -726,30 +735,30 @@
 			tw_post_command_packet(tw_dev, request_id);
 			spin_unlock_irqrestore(&tw_dev->tw_lock, flags);
 
+			timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
+
 			/* Now wait for the command to complete */
-			before = jiffies;
+			wait_event_interruptible_timeout(tw_dev->ioctl_wqueue, tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
 
-			while (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) 
-			{
-				/* FIXME: race condition on the wait*/
-				interruptible_sleep_on_timeout(&tw_dev->ioctl_wqueue, 1);
-				if (time_after(jiffies, before + HZ *TW_IOCTL_CHRDEV_TIMEOUT)) {
-					/* Now we need to reset the board */
+			/* Check if we timed out, got a signal, or didn't get
+			   an interrupt */
+			if ((timeout <= 0) && (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE)) {
+				/* Now we need to reset the board */
+				if (timeout == -ERESTARTSYS) {
+					retval = timeout;
+				} else {
 					printk(KERN_WARNING "3w-xxxx: scsi%d: Character ioctl (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, cmd);
-					spin_lock_irqsave(&tw_dev->tw_lock, flags);
-					tw_dev->state[request_id] = TW_S_COMPLETED;
-					tw_state_request_finish(tw_dev, request_id);
-					tw_dev->posted_request_count--;
-					if (tw_reset_device_extension(tw_dev)) {
-						printk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): Reset failed for card %d.\n", tw_dev->host->host_no);
-					}
-					spin_unlock_irqrestore(&tw_dev->tw_lock, flags);
-					if (signal_pending(current))
-						retval = -EINTR;
-					else
-						retval = -EIO;
-					goto out2;
+					retval = -EIO;
+				}
+				spin_lock_irqsave(&tw_dev->tw_lock, flags);
+				tw_dev->state[request_id] = TW_S_COMPLETED;
+				tw_state_request_finish(tw_dev, request_id);
+				tw_dev->posted_request_count--;
+				if (tw_reset_device_extension(tw_dev)) {
+					printk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): Reset failed for card %d.\n", tw_dev->host->host_no);
 				}
+				spin_unlock_irqrestore(&tw_dev->tw_lock, flags);
+				goto out2;
 			}
 
 			/* Now copy in the command packet response */
@@ -877,30 +886,33 @@
 	else
 		host[0] = '\0';
 
-	switch (status_reg_value & TW_STATUS_UNEXPECTED_BITS) {
-	case TW_STATUS_PCI_PARITY_ERROR:
+	if (status_reg_value & TW_STATUS_PCI_PARITY_ERROR) {
 		printk(KERN_WARNING "3w-xxxx:%s PCI Parity Error: clearing.\n", host);
 		outl(TW_CONTROL_CLEAR_PARITY_ERROR, tw_dev->registers.control_reg_addr);
-		break;
-	case TW_STATUS_MICROCONTROLLER_ERROR:
-		if (tw_dev->reset_print == 0) {
-			printk(KERN_WARNING "3w-xxxx:%s Microcontroller Error: clearing.\n", host);
-			tw_dev->reset_print = 1;
-		}
-		return 1;
-	case TW_STATUS_PCI_ABORT:
+	}
+
+	if (status_reg_value & TW_STATUS_PCI_ABORT) {
 		printk(KERN_WARNING "3w-xxxx:%s PCI Abort: clearing.\n", host);
 		outl(TW_CONTROL_CLEAR_PCI_ABORT, tw_dev->registers.control_reg_addr);
 		pci_write_config_word(tw_dev->tw_pci_dev, PCI_STATUS, TW_PCI_CLEAR_PCI_ABORT);
-		break;
-	case TW_STATUS_QUEUE_ERROR:
+	}
+
+	if (status_reg_value & TW_STATUS_QUEUE_ERROR) {
 		printk(KERN_WARNING "3w-xxxx:%s Controller Queue Error: clearing.\n", host);
 		outl(TW_CONTROL_CLEAR_QUEUE_ERROR, tw_dev->registers.control_reg_addr);
-		break;
-	case TW_STATUS_SBUF_WRITE_ERROR:
+	}
+
+	if (status_reg_value & TW_STATUS_SBUF_WRITE_ERROR) {
 		printk(KERN_WARNING "3w-xxxx:%s SBUF Write Error: clearing.\n", host);
 		outl(TW_CONTROL_CLEAR_SBUF_WRITE_ERROR, tw_dev->registers.control_reg_addr);
-		break;
+	}
+
+	if (status_reg_value & TW_STATUS_MICROCONTROLLER_ERROR) {
+		if (tw_dev->reset_print == 0) {
+			printk(KERN_WARNING "3w-xxxx:%s Microcontroller Error: clearing.\n", host);
+			tw_dev->reset_print = 1;
+		}
+		return 1;
 	}
 	
 	return 0;
@@ -1036,8 +1048,6 @@
 			}
 			memset(tw_dev, 0, sizeof(TW_Device_Extension));
 			
-			init_MUTEX(&tw_dev->ioctl_sem);
-
 			/* Save pci_dev struct to device extension */
 			tw_dev->tw_pci_dev = tw_pci_dev;
 
@@ -1131,13 +1141,17 @@
 			/* Set card status as online */
 			tw_dev->online = 1;
 
-			/* Calculate max cmds per lun, and setup queues */
-			if (tw_dev->num_units > 0) {
-				/* Use SHT cmd_per_lun here */
-				tw_dev->free_head = TW_Q_START;
-				tw_dev->free_tail = TW_Q_START;
-				tw_dev->free_wrap = TW_Q_LENGTH - 1;
-			}
+#ifdef CONFIG_3W_XXXX_CMD_PER_LUN
+			tw_host->cmd_per_lun = CONFIG_3W_XXXX_CMD_PER_LUN;
+			if (tw_host->cmd_per_lun > TW_MAX_CMDS_PER_LUN)
+				tw_host->cmd_per_lun = TW_MAX_CMDS_PER_LUN;
+#else
+			/* Use SHT cmd_per_lun here */
+			tw_host->cmd_per_lun = TW_MAX_CMDS_PER_LUN;
+#endif
+			tw_dev->free_head = TW_Q_START;
+			tw_dev->free_tail = TW_Q_START;
+			tw_dev->free_wrap = TW_Q_LENGTH - 1;
 
 			/* Register the card with the kernel SCSI layer */
 			host = scsi_register(tw_host, sizeof(TW_Device_Extension));
@@ -1176,6 +1190,10 @@
 			if (host->hostdata) {
 				tw_dev2 = (TW_Device_Extension *)host->hostdata;
 				memcpy(tw_dev2, tw_dev, sizeof(TW_Device_Extension));
+				/* Need to init the sem/wqueue after the copy */
+				init_MUTEX(&tw_dev2->ioctl_sem);
+				init_waitqueue_head(&tw_dev2->ioctl_wqueue);
+
 				tw_device_extension_list[tw_device_extension_count] = tw_dev2;
 				numcards++;
 				tw_device_extension_count = numcards;
@@ -1232,17 +1250,14 @@
 /* This function will free up device extension resources */
 void tw_free_device_extension(TW_Device_Extension *tw_dev)
 {
-	int i;
-
 	dprintk(KERN_NOTICE "3w-xxxx: tw_free_device_extension()\n");
+
 	/* Free command packet and generic buffer memory */
-	for (i=0;i<TW_Q_LENGTH;i++) {
-		if (tw_dev->command_packet_virtual_address[i]) 
-			pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Sector), tw_dev->command_packet_virtual_address[i], tw_dev->command_packet_physical_address[i]);
+	if (tw_dev->command_packet_virtual_address[0])
+		pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Command)*TW_Q_LENGTH, tw_dev->command_packet_virtual_address[0], tw_dev->command_packet_physical_address[0]);
 
-		if (tw_dev->alignment_virtual_address[i])
-			pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Sector), tw_dev->alignment_virtual_address[i], tw_dev->alignment_physical_address[i]);
-	}
+	if (tw_dev->alignment_virtual_address[0])
+		pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Sector)*TW_Q_LENGTH, tw_dev->alignment_virtual_address[0], tw_dev->alignment_physical_address[0]);
 } /* End tw_free_device_extension() */
 
 /* Clean shutdown routine */
@@ -1352,7 +1367,6 @@
 	tw_dev->pending_tail = TW_Q_START;
 	spin_lock_init(&tw_dev->tw_lock);
 	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
-	init_waitqueue_head(&tw_dev->ioctl_wqueue);
 
 	return 0;
 } /* End tw_initialize_device_extension() */
@@ -1606,6 +1620,7 @@
 						}
 					} else {
 						tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+						wake_up(&tw_dev->ioctl_wqueue);
 					}
 				} else {
 				switch (tw_dev->srb[request_id]->cmnd[0]) {
@@ -1804,12 +1819,15 @@
 			}
 
 			passthru = (TW_Passthru *)tw_dev->command_packet_virtual_address[request_id];
-			passthru->sg_list[0].length = passthru->sector_count*512;
-			if (passthru->sg_list[0].length > TW_MAX_PASSTHRU_BYTES) {
-				printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Passthru size (%d) too big.\n", passthru->sg_list[0].length);
-				return 1;
+			/* Don't load sg_list for non-data ATA cmds */
+			if ((passthru->param != 0) && (passthru->param != 0x8)) {
+				passthru->sg_list[0].length = passthru->sector_count*512;
+				if (passthru->sg_list[0].length > TW_MAX_PASSTHRU_BYTES) {
+					printk(KERN_WARNING "3w-xxxx: tw_ioctl(): Passthru size (%d) too big.\n", passthru->sg_list[0].length);
+					return 1;
+				}
+				passthru->sg_list[0].address = tw_dev->alignment_physical_address[request_id];
 			}
-			passthru->sg_list[0].address = tw_dev->alignment_physical_address[request_id];
 			tw_post_command_packet(tw_dev, request_id);
 			return 0;
 		case TW_CMD_PACKET:
@@ -2060,7 +2078,14 @@
 	switch (ioctl->opcode) {
 		case TW_ATA_PASSTHRU:
 			passthru = (TW_Passthru *)ioctl->data;
-			memcpy(buff, tw_dev->alignment_virtual_address[request_id], passthru->sector_count * 512);
+			/* Don't return data for non-data ATA cmds */
+			if ((passthru->param != 0) && (passthru->param != 0x8))
+				memcpy(buff, tw_dev->alignment_virtual_address[request_id], passthru->sector_count * 512);
+			else {
+				/* For non-data cmds, return cmd pkt */
+				if (tw_dev->srb[request_id]->request_bufflen >= sizeof(TW_Command))
+					memcpy(buff, tw_dev->command_packet_virtual_address[request_id], sizeof(TW_Command));
+			}
 			break;
 		case TW_CMD_PACKET_WITH_DATA:
 			dprintk(KERN_WARNING "3w-xxxx: tw_ioctl_complete(): caught TW_CMD_PACKET_WITH_DATA.\n");
@@ -3354,6 +3379,25 @@
 	return 0;
 } /* End tw_shutdown_device() */
 
+/* This function will configure individual target parameters */
+int tw_slave_configure(Scsi_Device *SDptr)
+{
+	int max_cmds;
+
+	dprintk(KERN_WARNING "3w-xxxx: tw_slave_configure()\n");
+
+#ifdef CONFIG_3W_XXXX_CMD_PER_LUN
+	max_cmds = CONFIG_3W_XXXX_CMD_PER_LUN;
+	if (max_cmds > TW_MAX_CMDS_PER_LUN)
+		max_cmds = TW_MAX_CMDS_PER_LUN;
+#else
+	max_cmds = TW_MAX_CMDS_PER_LUN;
+#endif
+	scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, max_cmds);
+
+	return 0;
+} /* End tw_slave_configure() */
+
 /* This function will soft reset the controller */
 void tw_soft_reset(TW_Device_Extension *tw_dev) 
 {
@@ -3450,7 +3494,7 @@
 	.max_sectors		= TW_MAX_SECTORS,
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,	
 	.use_clustering		= ENABLE_CLUSTERING,
-	.emulated		= 1,
+	.emulated		= 1
 };
 #include "scsi_module.c"
 
diff -Naur linux-2.6.0-test5-bk10/drivers/scsi/3w-xxxx.h linux-2.6.0-test5-bk11/drivers/scsi/3w-xxxx.h
--- linux-2.6.0-test5-bk10/drivers/scsi/3w-xxxx.h	Mon Sep  8 12:49:58 2003
+++ linux-2.6.0-test5-bk11/drivers/scsi/3w-xxxx.h	Tue Sep 23 15:00:31 2003
@@ -89,7 +89,7 @@
 	[0x02D] = "ERROR: Encountered bad sector during rebuild: Port #",
 	[0x02E] = "ERROR: Replacement drive is too small: Port #",
 	[0x02F] = "WARNING: Verify error: Unit not previously initialized: Unit #",
-	[0x030] = "ERROR: Drive not supported: Port #",
+	[0x030] = "ERROR: Drive not supported: Port #"
 };
 
 /*
@@ -109,10 +109,10 @@
   {0xd0, 0x0b, 0x00, 0x00}, // Device busy                  Aborted command
   {0xd1, 0x0b, 0x00, 0x00}, // Device busy                  Aborted command
   {0x37, 0x02, 0x04, 0x00}, // Unit offline                 Not ready
+  {0x09, 0x02, 0x04, 0x00}, // Unrecovered disk error       Not ready
 
   /* Codes for older firmware */
                             // 3ware Error                  SCSI Error
-  {0x09, 0x0b, 0x00, 0x00}, // Unrecovered disk error       Aborted command
   {0x51, 0x0b, 0x00, 0x00}  // Unspecified                  Aborted command
 };
 
@@ -229,7 +229,7 @@
 #define TW_ISR_DONT_COMPLETE                  2
 #define TW_ISR_DONT_RESULT                    3
 #define TW_IOCTL_TIMEOUT                      25 /* 25 seconds */
-#define TW_IOCTL_CHRDEV_TIMEOUT               25 /* 25 seconds */
+#define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
 #define TW_IOCTL_CHRDEV_FREE                  -1
 
 /* Macros */
@@ -486,6 +486,7 @@
 		  unsigned char *val);
 int tw_setup_irq(TW_Device_Extension *tw_dev);
 int tw_shutdown_device(TW_Device_Extension *tw_dev);
+int tw_slave_configure(Scsi_Device *SDptr);
 void tw_soft_reset(TW_Device_Extension *tw_dev);
 int tw_state_request_finish(TW_Device_Extension *tw_dev,int request_id);
 int tw_state_request_start(TW_Device_Extension *tw_dev, int *request_id);
