From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: megaraid v2.00rc5
Date: Mon, 23 Sep 2002 09:45:15 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209230937050.27515-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tux.us.dell.com (tux.us.dell.com [143.166.152.29])
	by smtp3.us.dell.com (8.12.1/8.12.5) with ESMTP id g8NEjFfA006349
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 09:45:15 -0500
Received: from humbolt.us.dell.com ([10.180.92.254])
	by tux.us.dell.com (8.11.0/8.11.0) with ESMTP id g8NEjFj10130
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 09:45:15 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

(Atul is out first half of this week, but I wanted to get people's 
feedback started).

Posted at http://domsch.com/linux/megaraid/megaraid-v2.00rc5.tar.gz is
a new Release Candidate version of the megaraid driver.  This is
intended to apply against the Red Hat Linux Advanced Server 2.1, Linux
7.3, and the "Null" public beta kernels as-is.  The diff between RC4
and RC5 is appended for comment.


Against 2.4.x current (Marcelo's tree), the differences are really only two:
1) replace adapter->lock with io_request_lock - stock 2.4.x kernels don't 
have separate per-SCSI-adapter locks.
2) Remove can_do_varyio flag in megaraid.h, again doesn't exist in 2.4.x.

Patch appended applies against megaraid 2.00rc5 copied into a current 
stock 2.4.x tree.  I haven't tested it beyond "it compiles cleanly".

It hasn't been fixed up to run on 2.5.x current kernels yet - WIP.


Atul's release notes:
Attached please find the 2.00rc5 driver, which has passed our UT and
going through integration testing.

The changes made over 2.00rc4 driver are:

1.  Prerelease controller comments removed

2.  Extra checks for module parameters

3.  Find adapters made modular.

4.  Check and request mem regions before doing ioremap()

5.  Initialize host base and port values appropriately.

6.  Initialize the initiator ids, even if cluster support is turned
    off.

7.  Track the scb transition from allocation thru completion, and
    during aborts and reset.

8.  Make sure to read the correct values of status and number of
    status in ISR.

9. Additional checks for aborted and reset commands, e.g., who is the
   owner - driver or firmware.

10.  call pci_unmap_page() instead of pci_unmap_single() for use_sg ==
      0 case.

11. remove some unused variables.

12. correctly set the boundaries on buffers allocated internally for
    commands issued within the driver. Make sure these buffers are always
    allocate <4GB address range.

13.  Disallows the (NIT) ioctl calls since the mailbox definition is
     under flux because of High Performance Engine (HPE) driver
     and firmware.

14.  Added pci_dma_sync*() calls in appropriate places.

15.  missing assignment scb->dma_type = MEGA_SGLIST, resulting in no
     pci_unmap_sg() in mega_free_scb()

16.  Display message in ISR for commands aborted/reset
     earlier.


Feedback appreciated - please send to linux-megaraid-devel@dell.com.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com


************************************************************************
Patch from RC4 to get RC5
************************************************************************
diff -urNp --exclude-from=/home/mdomsch/excludes --minimal megaraid-v2.00rc4/megaraid.c megaraid-v2.00rc5/megaraid.c
--- megaraid-v2.00rc4/megaraid.c	Tue Jul 30 20:36:48 2002
+++ megaraid-v2.00rc5/megaraid.c	Sun Sep 22 12:59:17 2002
@@ -14,7 +14,7 @@
  *	  - speed-ups (list handling fixes, issued_list, optimizations.)
  *	  - lots of cleanups.
  *
- * Version : v2.00rc4 (July 30, 2002) - Atul Mukker <Atul.Mukker@lsil.com>
+ * Version : v2.00rc5 (Sep 20, 2002) - Atul Mukker <Atul.Mukker@lsil.com>
  *
  * Description: Linux device driver for LSI Logic MegaRAID controller
  *
@@ -89,8 +89,6 @@ static struct mega_hbas mega_hbas[MAX_CO
 /*
  * The File Operations structure for the serial/ioctl interface of the driver
  */
-/* For controller re-ordering */ 
-
 static struct file_operations megadev_fops = {
 	ioctl:		megadev_ioctl,
 	open:		megadev_open,
@@ -122,9 +120,9 @@ static int major;
 static void
 megaraid_validate_parms(void)
 {
-	if (max_commands > MAX_COMMANDS)
+	if( (max_commands <= 0) || (max_commands > MAX_COMMANDS) )
 		max_commands = MAX_COMMANDS;
-	if (max_cmd_per_lun > MAX_CMD_PER_LUN)
+	if( (max_cmd_per_lun <= 0) || (max_cmd_per_lun > MAX_CMD_PER_LUN) )
 		max_cmd_per_lun = MAX_CMD_PER_LUN;
 	if( max_mbox_busy_wait > MBOX_BUSY_WAIT )
 		max_mbox_busy_wait = MBOX_BUSY_WAIT;
@@ -137,13 +135,30 @@ megaraid_validate_parms(void)
  *
  * the detect entry point for the mid-layer.
  * We scan the PCI bus for our controllers and start them.
+ *
+ * Note: PCI_DEVICE_ID_PERC4_DI below represents the PERC4/Di class of
+ * products.  All of them share the same vendor id, device id, and
+ * subsystem vendor id but different subsystem ids.  As of now, driver
+ * does not use the subsystem id.
  */
 static int
 megaraid_detect(Scsi_Host_Template *host_template)
 {
 	int	i;
+	u16	dev_sw_table[] = {	/* Table of all supported
+					   vendor/device ids */
+
+		PCI_VENDOR_ID_DELL,		PCI_DEVICE_ID_DISCOVERY, 
+		PCI_VENDOR_ID_DELL,		PCI_DEVICE_ID_PERC4_DI, 
+		PCI_VENDOR_ID_LSI_LOGIC,	PCI_DEVICE_ID_PERC4_QC_VERDE, 
+		PCI_VENDOR_ID_AMI,		PCI_DEVICE_ID_AMI_MEGARAID, 
+		PCI_VENDOR_ID_AMI,		PCI_DEVICE_ID_AMI_MEGARAID2, 
+		PCI_VENDOR_ID_AMI,		PCI_DEVICE_ID_AMI_MEGARAID3, 
+		PCI_VENDOR_ID_INTEL,		PCI_DEVICE_ID_AMI_MEGARAID3, 
+		PCI_VENDOR_ID_LSI_LOGIC,	PCI_DEVICE_ID_AMI_MEGARAID3 };
 
 	host_template->proc_name = "megaraid";
+
 	printk(KERN_NOTICE "megaraid: " MEGARAID_VERSION);
 
 	megaraid_validate_parms();
@@ -152,32 +167,14 @@ megaraid_detect(Scsi_Host_Template *host
 
 	hba_count = 0;
 
-	mega_find_card(host_template, PCI_VENDOR_ID_AMI,
-					PCI_DEVICE_ID_AMI_MEGARAID);
-
-	mega_find_card (host_template, PCI_VENDOR_ID_AMI,
-					PCI_DEVICE_ID_AMI_MEGARAID2);
-
-	mega_find_card(host_template, 0x8086, PCI_DEVICE_ID_AMI_MEGARAID3);
-
-	mega_find_card(host_template, PCI_VENDOR_ID_AMI,
-			PCI_DEVICE_ID_AMI_MEGARAID3);
-
-	mega_find_card(host_template, PCI_VENDOR_ID_DISCOVERY,
-				PCI_DEVICE_ID_DISCOVERY);
-
-	mega_find_card(host_template, PCI_VENDOR_ID_LSI_LOGIC,
-				PCI_DEVICE_ID_AMI_MEGARAID3);
-
-	mega_find_card(host_template, PCI_VENDOR_ID_LSI_LOGIC,
-				PCI_DEVICE_ID_LSI_MEGARAID1);
-
-	mega_find_card(host_template, PCI_VENDOR_ID_PERC4_DI_YSTONE,
-				PCI_DEVICE_ID_PERC4_DI_YSTONE);
-
-	mega_find_card(host_template, PCI_VENDOR_ID_PERC4_QC_VERDE,
-				PCI_DEVICE_ID_PERC4_QC_VERDE);
+	/*
+	 * Scan PCI bus for our all devices.
+	 */
+	for( i = 0; i < sizeof(dev_sw_table)/sizeof(u16); i += 2 ) {
 
+		mega_find_card(host_template, dev_sw_table[i],
+				dev_sw_table[i+1]);
+	}
 
 	if(hba_count) {
 		/*
@@ -257,6 +254,7 @@ mega_find_card(Scsi_Host_Template *host_
 	u8	alloc_scb_f = 0;
 	u8	got_irq_f = 0;
 	u8	did_setup_mbox_f = 0;
+	unsigned long	tbase;
 	unsigned long	flag = 0;
 	int	i, j;
 
@@ -271,9 +269,9 @@ mega_find_card(Scsi_Host_Template *host_
 		 * For these vendor and device ids, signature offsets are not
 		 * valid and 64 bit is implicit
 		 */
-		if( (pci_vendor == PCI_VENDOR_ID_PERC4_DI_YSTONE &&
-			pci_device == PCI_DEVICE_ID_PERC4_DI_YSTONE) ||
-			(pci_vendor == PCI_VENDOR_ID_PERC4_QC_VERDE &&
+		if( (pci_vendor == PCI_VENDOR_ID_DELL &&
+			pci_device == PCI_DEVICE_ID_PERC4_DI) ||
+			(pci_vendor == PCI_VENDOR_ID_LSI_LOGIC &&
 			pci_device == PCI_DEVICE_ID_PERC4_QC_VERDE) ) {
 
 			flag |= BOARD_64BIT;
@@ -294,7 +292,7 @@ mega_find_card(Scsi_Host_Template *host_
 			if (magic64 == HBA_SIGNATURE_64BIT)
 				flag |= BOARD_64BIT;
 		}
-		
+
 		subsysvid = pdev->subsystem_vendor;
 		subsysid = pdev->subsystem_device;
 
@@ -308,8 +306,7 @@ mega_find_card(Scsi_Host_Template *host_
 				(subsysvid != LSI_SUBSYS_VID) ) continue;
 
 
-		printk(KERN_NOTICE
-			"megaraid: found 0x%4.04x:0x%4.04x:bus %d:",
+		printk(KERN_NOTICE "megaraid: found 0x%4.04x:0x%4.04x:bus %d:",
 			pci_vendor, pci_device, pci_bus);
 
 		printk("slot %d:func %d\n",
@@ -319,14 +316,27 @@ mega_find_card(Scsi_Host_Template *host_
 		mega_baseport = pci_resource_start(pdev, 0);
 		irq = pdev->irq;
 
+		tbase = mega_baseport;
+
 		if( pci_resource_flags(pdev, 0) & IORESOURCE_MEM ) {
 
+			if( check_mem_region(mega_baseport, 128) ) {
+				printk(KERN_WARNING
+					"megaraid: mem region busy!\n");
+				continue;
+			}
+			request_mem_region(mega_baseport, 128,
+					"MegaRAID: LSI Logic Corporation.");
+
 			mega_baseport =
 				(unsigned long)ioremap(mega_baseport, 128);
 
 			if( !mega_baseport ) {
 				printk(KERN_WARNING
 					"megaraid: could not map hba memory\n");
+
+				release_mem_region(tbase, 128);
+
 				continue;
 			}
 
@@ -361,6 +371,8 @@ mega_find_card(Scsi_Host_Template *host_
 			"scsi%d:Found MegaRAID controller at 0x%lx, IRQ:%d\n",
 			host->host_no, mega_baseport, irq);
 
+		adapter->base = mega_baseport;
+
 		/* Copy resource info into structure */
 		INIT_LIST_HEAD(&adapter->free_list);
 		INIT_LIST_HEAD(&adapter->pending_list);
@@ -369,16 +381,23 @@ mega_find_card(Scsi_Host_Template *host_
 		adapter->flag = flag;
 		spin_lock_init(&adapter->lock);
 		host->lock = &adapter->lock;
-		host->can_queue = max_commands;
+
 		host->cmd_per_lun = max_cmd_per_lun;
 		host->max_sectors = max_sectors_per_io;
 
 		adapter->dev = pdev;
 		adapter->host = host;
-		adapter->base = mega_baseport;
+
 		adapter->host->irq = irq;
-		adapter->host->io_port = mega_baseport;
-		adapter->host->n_io_port = 16;
+
+		if( flag & BOARD_MEMMAP ) {
+			adapter->host->base = tbase;
+		}
+		else {
+			adapter->host->io_port = tbase;
+			adapter->host->n_io_port = 16;
+		}
+
 		adapter->host->unique_id = (pci_bus << 8) | pci_dev_func;
 
 		/*
@@ -575,14 +594,21 @@ mega_find_card(Scsi_Host_Template *host_
 
 
 		/* Set the Mode of addressing to 64 bit if we can */
-		if((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t) == 8))
+		if((adapter->flag & BOARD_64BIT)&&(sizeof(dma_addr_t) == 8)) {
 			pci_set_dma_mask(pdev, 0xffffffffffffffff);
-		else 
+			adapter->has_64bit_addr = 1;
+		}
+		else  {
 			pci_set_dma_mask(pdev, 0xffffffff);
+			adapter->has_64bit_addr = 0;
+		}
 		
 		init_MUTEX(&adapter->int_mtx);
 		init_waitqueue_head(&adapter->int_waitq);
 
+		adapter->this_id = DEFAULT_INITIATOR_ID;
+		adapter->host->this_id = DEFAULT_INITIATOR_ID;
+
 #if MEGA_HAVE_CLUSTERING
 		/*
 		 * Is cluster support enabled on this controller
@@ -627,8 +653,10 @@ fail_attach:
 
 		if( did_scsi_reg_f ) scsi_unregister(host);
 
-		if( did_ioremap_f )
+		if( did_ioremap_f ) {
 			iounmap((void *)mega_baseport);
+			release_mem_region(tbase, 128);
+		}
 
 		if( did_req_region_f )
 			release_region(mega_baseport, 16);
@@ -783,6 +811,10 @@ mega_query_adapter(adapter_t *adapter)
 			"megaraid: Product_info cmd failed with error: %d\n",
 				retval);
 
+		pci_dma_sync_single(adapter->dev, prod_info_dma_handle,
+				sizeof(mega_product_info),
+				PCI_DMA_FROMDEVICE);
+
 		pci_unmap_single(adapter->dev, prod_info_dma_handle,
 				sizeof(mega_product_info), PCI_DMA_FROMDEVICE);
 	}
@@ -889,7 +921,7 @@ megaraid_queue(Scsi_Cmnd *scmd, void (*d
 	scb = mega_build_cmd(adapter, scmd, &busy);
 
 	if(scb) {
-		scb->state = SCB_PENDQ;
+		scb->state |= SCB_PENDQ;
 		list_add_tail(&scb->list, &adapter->pending_list);
 
 		/*
@@ -1117,8 +1149,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
 			pthru->cdblen = cmd->cmd_len;
 			memcpy(pthru->cdb, cmd->cmnd, cmd->cmd_len);
 
-			if( (adapter->flag & BOARD_64BIT) &&
-					(sizeof(dma_addr_t)==8) ) {
+			if( adapter->has_64bit_addr ) {
 				mbox->cmd = MEGA_MBOXCMD_PASSTHRU64;
 			}
 			else {
@@ -1159,8 +1190,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
 			 * A little hack: 2nd bit is zero for all scsi read
 			 * commands and is set for all scsi write commands
 			 */
-			if((adapter->flag & BOARD_64BIT) &&
-				(sizeof(dma_addr_t)==8)) {
+			if( adapter->has_64bit_addr ) {
 				mbox->cmd = (*cmd->cmnd & 0x02) ?
 					MEGA_MBOXCMD_LWRITE64:
 					MEGA_MBOXCMD_LREAD64 ;
@@ -1347,8 +1377,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_
 					channel, target);
 
 			/* Initialize mailbox */
-			if( (adapter->flag & BOARD_64BIT) &&
-					(sizeof(dma_addr_t)==8) ) {
+			if( adapter->has_64bit_addr ) {
 				mbox->cmd = MEGA_MBOXCMD_PASSTHRU64;
 			}
 			else {
@@ -1546,7 +1575,7 @@ __mega_runpendq(adapter_t *adapter)
 
 		scb = list_entry(pos, scb_t, list);
 
-		if( scb->state == SCB_PENDQ ) {
+		if( !(scb->state & SCB_ISSUED) ) {
 
 			if( issue_scb(adapter, scb) != 0 )
 				return;
@@ -1594,14 +1623,6 @@ issue_scb(adapter_t *adapter, scb_t *scb
 	 */
 	atomic_inc(&adapter->pend_cmds);
 
-
-	/*
-	 * This scb is on pending queue, take if off and change it's state
-	 * from SCB_PENDQ to SCB_ACTIVE. SCB_ACTIVE scbs are not on any list
-	 */
-	list_del_init(&scb->list);
-	scb->state = SCB_ACTIVE;
-
 	switch (mbox->cmd) {
 	case MEGA_MBOXCMD_LREAD64:
 	case MEGA_MBOXCMD_LWRITE64:
@@ -1619,6 +1640,8 @@ issue_scb(adapter_t *adapter, scb_t *scb
 	/*
 	 * post the command
 	 */
+	scb->state |= SCB_ISSUED;
+
 	if( likely(adapter->flag & BOARD_MEMMAP) ) {
 		mbox->poll = 0;
 		mbox->ack = 0;
@@ -1629,8 +1652,6 @@ issue_scb(adapter_t *adapter, scb_t *scb
 		issue_command(adapter);
 	}
 
-	scb->state = SCB_ISSUED;
-
 	return 0;
 }
 
@@ -1724,8 +1745,9 @@ bug_blocked_mailbox:
  * @devp - pointer to our soft state
  * @regs - unused
  *
- * Interrupt service routine. Find out if our device is interrupting. If yes,
- * acknowledge the interrupt and service the completed commands.
+ * Interrupt service routine for io-mapped controllers.
+ * Find out if our device is interrupting. If yes, acknowledge the interrupt
+ * and service the completed commands.
  */
 static void
 megaraid_isr_iomapped(int irq, void *devp, struct pt_regs *regs)
@@ -1733,7 +1755,6 @@ megaraid_isr_iomapped(int irq, void *dev
 	adapter_t	*adapter = devp;
 	unsigned long	flags;
 	u8	status;
-	u32	dword = 0;
 	u8	nstatus;
 	u8	completed[MAX_FIRMWARE_STATUS];
 	u8	byte;
@@ -1756,8 +1777,13 @@ megaraid_isr_iomapped(int irq, void *dev
 		}
 		set_irq_state(adapter, byte);
 
-		nstatus = adapter->mbox->numstatus;
-		status = adapter->mbox->status;
+		nstatus = 0xFF;
+		while((nstatus = adapter->mbox->numstatus) == 0xFF)
+			cpu_relax();
+
+		status = 0xFF;
+		while((status = adapter->mbox->status) == 0xFF)
+			cpu_relax();
 
 		/*
 		 * decrement the pending queue counter
@@ -1823,8 +1849,13 @@ megaraid_isr_memmapped(int irq, void *de
 			return;
 		}
 
-		nstatus = adapter->mbox->numstatus;
-		status = adapter->mbox->status;
+		nstatus = 0xFF;
+		while((nstatus = adapter->mbox->numstatus) == 0xFF)
+			cpu_relax();
+
+		status = 0xFF;
+		while((status = adapter->mbox->status) == 0xFF)
+			cpu_relax();
 
 		/*
 		 * decrement the pending queue counter
@@ -1894,17 +1925,57 @@ mega_cmd_done(adapter_t *adapter, u8 com
 			 * passthru or 64-bit passthru
 			 */
 			pthru = scb->pthru;
+
 		}
 		else {
 			scb = &adapter->scb_list[cmdid];
+
+			/*
+			 * Make sure f/w has completed a valid command
+			 */
+			if( !(scb->state & SCB_ISSUED) || scb->cmd == NULL ) {
+				printk(KERN_CRIT
+				"megaraid: invalid command Id %d, scb->state:%x, scsi cmd:%p\n",
+					cmdid, scb->state, scb->cmd);
+				/* this may not be right, but it's better than BUG() */
+				continue;
+			}
+
+			/*
+			 * Was a abort issued for this command
+			 */
+			if( scb->state & SCB_ABORT ) {
+
+				printk(KERN_WARNING
+				"megaraid: aborted cmd %lx[%x] complete.\n",
+					scb->cmd->serial_number, scb->idx);
+
+				scb->cmd->result = (DID_ABORT << 16);
+
+				list_add_tail(SCSI_LIST(scb->cmd),
+						&adapter->completed_list);
+
+				mega_free_scb(adapter, scb);
+
+				continue;
+			}
+
 			/*
 			 * Was a reset issued for this command
 			 */
-			if (scb->state == SCB_RESET) {
-				mega_free_scb (adapter, scb);
+			if( scb->state & SCB_RESET ) {
+
+				printk(KERN_WARNING
+				"megaraid: reset cmd %lx[%x] complete.\n",
+					scb->cmd->serial_number, scb->idx);
+
 				scb->cmd->result = (DID_RESET << 16);
+
 				list_add_tail(SCSI_LIST(scb->cmd),
 						&adapter->completed_list);
+
+				mega_free_scb (adapter, scb);
+
 				continue;
 			}
 
@@ -2049,8 +2120,20 @@ mega_cmd_done(adapter_t *adapter, u8 com
 		/*
 		 * Only free SCBs for the commands coming down from the
 		 * mid-layer, not for which were issued internally
+		 *
+		 * For internal command, restore the status returned by the
+		 * firmware so that user can interpret it.
 		 */
-		if( cmdid < max_commands ) {
+		if( cmdid == CMDID_INT_CMDS ) { /* internal command */
+			cmd->result = status;
+
+			/*
+			 * Remove the internal command from the pending list
+			 */
+			list_del_init(&scb->list);
+			scb->state = SCB_FREE;
+		}
+		else {
 			mega_free_scb(adapter, scb);
 		}
 
@@ -2095,19 +2178,39 @@ mega_free_scb(adapter_t *adapter, scb_t 
 		break;
 
 	case MEGA_BULK_DATA:
-		pci_unmap_single(adapter->host->pci_dev, scb->dma_h_bulkdata,
+		pci_unmap_page(adapter->host->pci_dev, scb->dma_h_bulkdata,
 			scb->cmd->request_bufflen, scb->dma_direction);
+
+		if( scb->dma_direction == PCI_DMA_FROMDEVICE ) {
+			pci_dma_sync_single(adapter->host->pci_dev,
+					scb->dma_h_bulkdata,
+					scb->cmd->request_bufflen,
+					PCI_DMA_FROMDEVICE);
+		}
+
 		break;
 
 	case MEGA_SGLIST:
 		pci_unmap_sg(adapter->host->pci_dev, scb->cmd->request_buffer,
 			scb->cmd->use_sg, scb->dma_direction);
+
+		if( scb->dma_direction == PCI_DMA_FROMDEVICE ) {
+			pci_dma_sync_sg(adapter->host->pci_dev,
+					scb->cmd->request_buffer,
+					scb->cmd->use_sg, PCI_DMA_FROMDEVICE);
+		}
+
 		break;
 
 	default:
 		break;
 	}
 
+	/*
+	 * Remove from the pending list
+	 */
+	list_del_init(&scb->list);
+
 	/* Link the scb back into free list */
 	scb->state = SCB_FREE;
 	scb->cmd = NULL;
@@ -2174,8 +2277,7 @@ mega_build_sglist(adapter_t *adapter, sc
 		 * We need to handle special 64-bit commands that need a
 		 * minimum of 1 SG
 		 */
-		if((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t)==8)) {
-
+		if( adapter->has_64bit_addr ) {
 			scb->sgl64[0].address = scb->dma_h_bulkdata;
 			scb->sgl64[0].length = cmd->request_bufflen;
 			*buf = (u32)scb->sgl_dma_addr;
@@ -2187,6 +2289,13 @@ mega_build_sglist(adapter_t *adapter, sc
 			*len = (u32)cmd->request_bufflen;
 		}
 
+		if( scb->dma_direction == PCI_DMA_TODEVICE ) {
+			pci_dma_sync_single(adapter->host->pci_dev,
+					scb->dma_h_bulkdata,
+					cmd->request_bufflen,
+					PCI_DMA_TODEVICE);
+		}
+
 		return 0;
 	}
 
@@ -2200,12 +2309,13 @@ mega_build_sglist(adapter_t *adapter, sc
 	sgcnt = pci_map_sg(adapter->host->pci_dev, sgl, cmd->use_sg,
 			scb->dma_direction);
 
+	scb->dma_type = MEGA_SGLIST;
+
 	if( sgcnt > adapter->sglen ) BUG();
 
 	for( idx = 0; idx < sgcnt; idx++, sgl++ ) {
 
-		if((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t)==8)) {
-
+		if( adapter->has_64bit_addr ) {
 			scb->sgl64[idx].address = sg_dma_address(sgl);
 			scb->sgl64[idx].length = sg_dma_len(sgl);
 		}
@@ -2224,6 +2334,11 @@ mega_build_sglist(adapter_t *adapter, sc
 	 */
 	*len = (u32)cmd->request_bufflen;
 
+	if( scb->dma_direction == PCI_DMA_TODEVICE ) {
+		pci_dma_sync_sg(adapter->host->pci_dev, sgl, cmd->use_sg,
+				PCI_DMA_TODEVICE);
+	}
+
 	/* Return count of SG requests */
 	return sgcnt;
 }
@@ -2294,7 +2409,6 @@ megaraid_release(struct Scsi_Host *host)
 	mbox_t	*mbox;
 	u_char	raw_mbox[16];
 	char	buf[12] = { 0 };
-	int	i;
 
 	adapter = (adapter_t *)host->hostdata;
 	mbox = (mbox_t *)raw_mbox;
@@ -2322,6 +2436,7 @@ megaraid_release(struct Scsi_Host *host)
 	/* Free our resources */
 	if( adapter->flag & BOARD_MEMMAP ) {
 		iounmap((void *)adapter->base);
+		release_mem_region(adapter->host->base, 128);
 	}
 	else {
 		release_region(adapter->base, 16);
@@ -2497,41 +2612,18 @@ megaraid_command (Scsi_Cmnd *cmd)
 static int
 megaraid_abort(Scsi_Cmnd *cmd)
 {
-	struct list_head	*pos, *next;
 	adapter_t	*adapter;
-	scb_t	*scb;
-	int	rval = 1;
-
-
-	adapter = (adapter_t *) cmd->host->hostdata;
-
-	list_for_each_safe(pos, next, &adapter->pending_list) {
-		scb = list_entry(pos, scb_t, list);
-		if (scb->cmd == cmd) { /* Found an aborting command */
-
-			/*
-			 * Remove from the pending list
-			 */
-			list_del_init(&scb->list);
-			mega_free_scb (adapter, scb);
-
-			cmd->result = (DID_ABORT << 16);
-
-			list_add_tail(SCSI_LIST(cmd), &adapter->completed_list);
-
-			rval = 0;
-
-			break;
+	int		rval;
 
-		}
-	}
+	adapter = (adapter_t *)cmd->host->hostdata;
 
+	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_ABORT);
 
 	/*
 	 * This is required here to complete any completed requests
 	 * to be communicated over to the mid layer.
 	 */
-	mega_rundoneq (adapter);
+	mega_rundoneq(adapter);
 
 	return rval;
 }
@@ -2542,14 +2634,10 @@ megaraid_reset(Scsi_Cmnd *cmd)
 {
 	adapter_t	*adapter;
 	megacmd_t	mc;
+	int		rval;
 
 	adapter = (adapter_t *)cmd->host->hostdata;
 
-	printk(KERN_NOTICE
-		"megaraid reset: %.08lx cmd=%.02x <c=%d.t=%d.l=%d>\n",
-		cmd->serial_number, cmd->cmnd[0], cmd->channel,
-		cmd->target, cmd->lun);
-
 #if MEGA_HAVE_CLUSTERING
 	mc.cmd = MEGA_CLUSTER_CMD;
 	mc.opcode = MEGA_RESET_RESERVATIONS;
@@ -2559,18 +2647,101 @@ megaraid_reset(Scsi_Cmnd *cmd)
 	 * 'host lock' since mid-layer has it before calling us.
 	 */
 	if( mega_internal_command(adapter, LOCK_EXT, &mc, NULL) != 0 ) {
-		printk(KERN_WARNING "megaraid: reservation reset failed.\n");
-
-		return FALSE;
+		printk(KERN_WARNING
+				"megaraid: reservation reset failed.\n");
 	}
 	else {
 		printk(KERN_INFO "megaraid: reservation reset.\n");
+	}
+#endif
 
-		return TRUE;
+	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
+
+	/*
+	 * This is required here to complete any completed requests
+	 * to be communicated over to the mid layer.
+	 */
+	mega_rundoneq(adapter);
+
+	return rval;
+}
+
+
+
+/**
+ * megaraid_abort_and_reset()
+ * @adapter - megaraid soft state
+ * @cmd - scsi command to be aborted or reset
+ * @aor - abort or reset flag
+ *
+ * Try to locate the scsi command in the pending queue. If found and is not
+ * issued to the controller, abort/reset it. Otherwise return failure
+ */
+static int
+megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
+{
+	struct list_head	*pos, *next;
+	scb_t			*scb;
+
+	printk(KERN_WARNING "megaraid: %s-%lx cmd=%x <c=%d t=%d l=%d>\n",
+	     (aor == SCB_ABORT)? "ABORTING":"RESET", cmd->serial_number,
+	     cmd->cmnd[0], cmd->channel, cmd->target, cmd->lun);
+
+	if(list_empty(&adapter->pending_list))
+		return FALSE;
+
+	list_for_each_safe(pos, next, &adapter->pending_list) {
+
+		scb = list_entry(pos, scb_t, list);
+
+		if (scb->cmd == cmd) { /* Found command */
+
+			scb->state |= aor;
+
+			/*
+			 * Check if this command has firmare owenership. If
+			 * yes, we cannot reset this command. Whenever, f/w
+			 * completes this command, we will return appropriate
+			 * status from ISR.
+			 */
+			if( scb->state & SCB_ISSUED ) {
+
+				printk(KERN_WARNING
+					"megaraid: %s-%lx[%x], fw owner.\n",
+					(aor==SCB_ABORT) ? "ABORTING":"RESET",
+					cmd->serial_number, scb->idx);
+
+				return FALSE;
+			}
+			else {
+
+				/*
+				 * Not yet issued! Remove from the pending
+				 * list
+				 */
+				printk(KERN_WARNING
+					"megaraid: %s-%lx[%x], driver owner.\n",
+					(aor==SCB_ABORT) ? "ABORTING":"RESET",
+					cmd->serial_number, scb->idx);
+
+				mega_free_scb(adapter, scb);
+
+				if( aor == SCB_ABORT ) {
+					cmd->result = (DID_ABORT << 16);
+				}
+				else {
+					cmd->result = (DID_RESET << 16);
+				}
+
+				list_add_tail(SCSI_LIST(cmd),
+						&adapter->completed_list);
+
+				return TRUE;
+			}
+		}
 	}
-#else
+
 	return FALSE;
-#endif
 }
 
 
@@ -2686,9 +2857,13 @@ proc_read_config(char *page, char **star
 		len += sprintf(page+len,
 		"Controller capable of 64-bit memory addressing\n");
 	}
-	if(sizeof(dma_addr_t) == 8 && (adapter->flag & BOARD_64BIT)) {
+	if( adapter->has_64bit_addr ) {
 		len += sprintf(page+len,
-			"Controller using of 64-bit memory addressing\n");
+			"Controller using 64-bit memory addressing\n");
+	}
+	else {
+		len += sprintf(page+len,
+			"Controller is not using 64-bit memory addressing\n");
 	}
 
 	len += sprintf(page+len, "Base = %08lx, Irq = %d, ", adapter->base,
@@ -2848,10 +3023,32 @@ proc_rebuild_rate(char *page, char **sta
 	adapter_t	*adapter = (adapter_t *)data;
 	dma_addr_t	dma_handle;
 	caddr_t		inquiry;
+	struct pci_dev	*pdev;
 	int	len = 0;
 
-	if((len = mega_adapinq(adapter, &inquiry, &dma_handle, page)) != 0) {
+	if( make_local_pdev(adapter, &pdev) != 0 ) {
+		*eof = 1;
+		return len;
+	}
+
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
+		free_local_pdev(pdev);
+		*eof = 1;
+		return len;
+	}
+
+	if( mega_adapinq(adapter, dma_handle) != 0 ) {
+
+		len = sprintf(page, "Adapter inquiry failed.\n");
+
+		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+
+		free_local_pdev(pdev);
+
+		mega_free_inquiry(inquiry, dma_handle, pdev);
+
 		*eof = 1;
+
 		return len;
 	}
 
@@ -2865,7 +3062,10 @@ proc_rebuild_rate(char *page, char **sta
 			inquiry)->raid_inq.adapter_info.rebuild_rate);
 	}
 
-	mega_free_adapinq(adapter, inquiry, dma_handle);
+
+	free_local_pdev(pdev);
+
+	mega_free_inquiry(inquiry, dma_handle, pdev);
 
 	*eof = 1;
 
@@ -2891,11 +3091,31 @@ proc_battery(char *page, char **start, o
 	adapter_t	*adapter = (adapter_t *)data;
 	dma_addr_t	dma_handle;
 	caddr_t		inquiry;
+	struct pci_dev	*pdev;
 	u8	battery_status = 0;
 	char	str[256];
 	int	len = 0;
 
-	if( (len = mega_adapinq(adapter, &inquiry, &dma_handle, page)) != 0 ) {
+	if( make_local_pdev(adapter, &pdev) != 0 ) {
+		*eof = 1;
+		return len;
+	}
+
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
+		free_local_pdev(pdev);
+		*eof = 1;
+		return len;
+	}
+
+	if( mega_adapinq(adapter, dma_handle) != 0 ) {
+
+		len = sprintf(page, "Adapter inquiry failed.\n");
+
+		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+
+		free_local_pdev(pdev);
+
+		mega_free_inquiry(inquiry, dma_handle, pdev);
 
 		*eof = 1;
 
@@ -2941,7 +3161,10 @@ proc_battery(char *page, char **start, o
 
 	len = sprintf(page, "%s\n", str);
 
-	mega_free_adapinq(adapter, inquiry, dma_handle);
+
+	free_local_pdev(pdev);
+
+	mega_free_inquiry(inquiry, dma_handle, pdev);
 
 	*eof = 1;
 
@@ -3055,6 +3278,7 @@ proc_pdrv(adapter_t *adapter, char *page
 	char		*scsi_inq;
 	dma_addr_t	scsi_inq_dma_handle;
 	caddr_t		inquiry;
+	struct pci_dev	*pdev;
 	u8	*pdrv_state;
 	u8	state;
 	int	tgt;
@@ -3063,18 +3287,38 @@ proc_pdrv(adapter_t *adapter, char *page
 	char	str[80];
 	int	i;
 
-	if( (len = mega_adapinq(adapter, &inquiry, &dma_handle, page)) != 0 ) {
+	if( make_local_pdev(adapter, &pdev) != 0 ) {
 		return len;
 	}
 
-	scsi_inq = pci_alloc_consistent(adapter->dev, 256,
-			&scsi_inq_dma_handle);
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
+		free_local_pdev(pdev);
+		return len;
+	}
+
+	if( mega_adapinq(adapter, dma_handle) != 0 ) {
+
+		len = sprintf(page, "Adapter inquiry failed.\n");
+
+		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+
+		free_local_pdev(pdev);
+
+		mega_free_inquiry(inquiry, dma_handle, pdev);
+
+		return len;
+	}
+
+
+	scsi_inq = pci_alloc_consistent(pdev, 256, &scsi_inq_dma_handle);
 
 	if( scsi_inq == NULL ) {
 		len = sprintf(page, "memory not available for scsi inq.\n");
 
-		pci_free_consistent(adapter->dev, sizeof(mega_inquiry3),
-				inquiry, dma_handle);
+		free_local_pdev(pdev);
+
+		mega_free_inquiry(inquiry, dma_handle, pdev);
+
 		return len;
 	}
 
@@ -3153,9 +3397,11 @@ proc_pdrv(adapter_t *adapter, char *page
 		len += mega_print_inquiry(page+len, scsi_inq);
 	}
 
-	pci_free_consistent(adapter->dev, 256, scsi_inq, scsi_inq_dma_handle);
+	pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
 
-	mega_free_adapinq(adapter, inquiry, dma_handle);
+	free_local_pdev(pdev);
+
+	mega_free_inquiry(inquiry, dma_handle, pdev);
 
 	return len;
 }
@@ -3318,13 +3564,32 @@ proc_rdrv(adapter_t *adapter, char *page
 	char		*disk_array;
 	dma_addr_t	disk_array_dma_handle;
 	caddr_t		inquiry;
+	struct pci_dev	*pdev;
 	u8	*rdrv_state;
 	int	num_ldrv;
 	u32	array_sz;
 	int	len = 0;
 	int	i;
 
-	if( (len = mega_adapinq(adapter, &inquiry, &dma_handle, page)) != 0 ) {
+	if( make_local_pdev(adapter, &pdev) != 0 ) {
+		return len;
+	}
+
+	if( (inquiry = mega_allocate_inquiry(&dma_handle, pdev)) == NULL ) {
+		free_local_pdev(pdev);
+		return len;
+	}
+
+	if( mega_adapinq(adapter, dma_handle) != 0 ) {
+
+		len = sprintf(page, "Adapter inquiry failed.\n");
+
+		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+
+		free_local_pdev(pdev);
+
+		mega_free_inquiry(inquiry, dma_handle, pdev);
+
 		return len;
 	}
 
@@ -3347,14 +3612,16 @@ proc_rdrv(adapter_t *adapter, char *page
 			raid_inq.logdrv_info.num_ldrv;
 	}
 
-	disk_array = pci_alloc_consistent(adapter->dev, array_sz,
+	disk_array = pci_alloc_consistent(pdev, array_sz,
 			&disk_array_dma_handle);
 
 	if( disk_array == NULL ) {
 		len = sprintf(page, "memory not available.\n");
 
-		pci_free_consistent(adapter->dev, sizeof(mega_inquiry3),
-				inquiry, dma_handle);
+		free_local_pdev(pdev);
+
+		mega_free_inquiry(inquiry, dma_handle, pdev);
+
 		return len;
 	}
 
@@ -3368,12 +3635,12 @@ proc_rdrv(adapter_t *adapter, char *page
 
 			len = sprintf(page, "40LD read config failed.\n");
 
-			pci_free_consistent(adapter->dev,
-					sizeof(mega_inquiry3), inquiry,
-					dma_handle);
+			free_local_pdev(pdev);
 
-			pci_free_consistent(adapter->dev, array_sz,
-					disk_array, disk_array_dma_handle);
+			mega_free_inquiry(inquiry, dma_handle, pdev);
+
+			pci_free_consistent(pdev, array_sz, disk_array,
+					disk_array_dma_handle);
 
 			return len;
 		}
@@ -3392,12 +3659,13 @@ proc_rdrv(adapter_t *adapter, char *page
 				len = sprintf(page,
 					"8LD read config failed.\n");
 
-				pci_free_consistent(adapter->dev,
-						sizeof(mega_inquiry3),
-						inquiry, dma_handle);
+				free_local_pdev(pdev);
 
-				pci_free_consistent(adapter->dev, array_sz,
-					disk_array, disk_array_dma_handle);
+				mega_free_inquiry(inquiry, dma_handle, pdev);
+
+				pci_free_consistent(pdev, array_sz,
+						disk_array,
+						disk_array_dma_handle);
 
 				return len;
 			}
@@ -3518,9 +3786,11 @@ proc_rdrv(adapter_t *adapter, char *page
 		}
 	}
 
-	mega_free_adapinq(adapter, inquiry, dma_handle);
+	free_local_pdev(pdev);
 
-	pci_free_consistent(adapter->dev, array_sz, disk_array,
+	mega_free_inquiry(inquiry, dma_handle, pdev);
+
+	pci_free_consistent(pdev, array_sz, disk_array,
 			disk_array_dma_handle);
 
 	return len;
@@ -3877,6 +4147,7 @@ megadev_ioctl(struct inode *inode, struc
 	megastat_t	*ustats;
 	int		num_ldrv;
 	u32		uxferaddr = 0;
+	struct pci_dev	*pdev;
 
 	ustats = NULL; /* avoid compilation warnings */
 	num_ldrv = 0;
@@ -3897,6 +4168,7 @@ megadev_ioctl(struct inode *inode, struc
 	 * the inteface layer will also provide us with the required user
 	 * addresses.
 	 */
+	memset(&uioc, 0, sizeof(nitioctl_t));
 	if( (rval = mega_m_to_n( (void *)arg, &uioc)) != 0 )
 		return rval;
 
@@ -4032,15 +4304,23 @@ megadev_ioctl(struct inode *inode, struc
 			return (-EINVAL);
 		}
 
+		/*
+		 * For all internal commands, the buffer must be allocated in
+		 * <4GB address range
+		 */
+		if( make_local_pdev(adapter, &pdev) != 0 )
+			return -EIO;
+
 		/* Is it a passthru command or a DCMD */
 		if( uioc.uioc_rmbox[0] == MEGA_MBOXCMD_PASSTHRU ) {
 			/* Passthru commands */
 
-			pthru = pci_alloc_consistent(adapter->dev,
+			pthru = pci_alloc_consistent(pdev,
 					sizeof(mega_passthru),
 					&pthru_dma_hndl);
 
 			if( pthru == NULL ) {
+				free_local_pdev(pdev);
 				return (-ENOMEM);
 			}
 
@@ -4055,10 +4335,12 @@ megadev_ioctl(struct inode *inode, struc
 			if( copy_from_user(pthru, (char *)upthru,
 						sizeof(mega_passthru)) ) {
 
-				pci_free_consistent(adapter->dev,
+				pci_free_consistent(pdev,
 						sizeof(mega_passthru), pthru,
 						pthru_dma_hndl);
 
+				free_local_pdev(pdev);
+
 				return (-EFAULT);
 			}
 
@@ -4066,16 +4348,18 @@ megadev_ioctl(struct inode *inode, struc
 			 * Is there a data transfer
 			 */
 			if( pthru->dataxferlen ) {
-				data = pci_alloc_consistent(adapter->dev,
+				data = pci_alloc_consistent(pdev,
 						pthru->dataxferlen,
 						&data_dma_hndl);
 
 				if( data == NULL ) {
-					pci_free_consistent(adapter->dev,
+					pci_free_consistent(pdev,
 							sizeof(mega_passthru),
 							pthru,
 							pthru_dma_hndl);
 
+					free_local_pdev(pdev);
+
 					return (-ENOMEM);
 				}
 
@@ -4136,14 +4420,15 @@ megadev_ioctl(struct inode *inode, struc
 
 freemem_and_return:
 			if( pthru->dataxferlen ) {
-				pci_free_consistent(adapter->dev,
+				pci_free_consistent(pdev,
 						pthru->dataxferlen, data,
 						data_dma_hndl);
 			}
 
-			pci_free_consistent(adapter->dev,
-					sizeof(mega_passthru), pthru,
-					pthru_dma_hndl);
+			pci_free_consistent(pdev, sizeof(mega_passthru),
+					pthru, pthru_dma_hndl);
+
+			free_local_pdev(pdev);
 
 			return rval;
 		}
@@ -4154,11 +4439,11 @@ freemem_and_return:
 			 * Is there a data transfer
 			 */
 			if( uioc.xferlen ) {
-				data = pci_alloc_consistent(adapter->dev,
-						uioc.xferlen,
-						&data_dma_hndl);
+				data = pci_alloc_consistent(pdev,
+						uioc.xferlen, &data_dma_hndl);
 
 				if( data == NULL ) {
+					free_local_pdev(pdev);
 					return (-ENOMEM);
 				}
 
@@ -4175,9 +4460,12 @@ freemem_and_return:
 				if( copy_from_user(data, (char *)uxferaddr,
 							uioc.xferlen) ) {
 
-					pci_free_consistent(adapter->dev,
+					pci_free_consistent(pdev,
 							uioc.xferlen,
 							data, data_dma_hndl);
+
+					free_local_pdev(pdev);
+
 					return (-EFAULT);
 				}
 			}
@@ -4195,11 +4483,13 @@ freemem_and_return:
 
 			if( rval ) {
 				if( uioc.xferlen ) {
-					pci_free_consistent(adapter->dev,
+					pci_free_consistent(pdev,
 							uioc.xferlen, data,
 							data_dma_hndl);
 				}
 
+				free_local_pdev(pdev);
+
 				return rval;
 			}
 
@@ -4209,16 +4499,19 @@ freemem_and_return:
 			if( uioc.xferlen && (uioc.flags & UIOC_RD) ) {
 				if( copy_to_user((char *)uxferaddr, data,
 							uioc.xferlen) ) {
+
 					rval = (-EFAULT);
 				}
 			}
 
 			if( uioc.xferlen ) {
-				pci_free_consistent(adapter->dev,
+				pci_free_consistent(pdev,
 						uioc.xferlen, data,
 						data_dma_hndl);
 			}
 
+			free_local_pdev(pdev);
+
 			return rval;
 		}
 
@@ -4229,7 +4522,6 @@ freemem_and_return:
 	return 0;
 }
 
-
 /**
  * mega_m_to_n()
  * @arg - user address
@@ -4261,9 +4553,18 @@ mega_m_to_n(void *arg, nitioctl_t *uioc)
 
 	if( memcmp(signature, "MEGANIT", 7) == 0 ) {
 
+		/*
+		 * NOTE NOTE: The nit ioctl is still under flux because of
+		 * change of mailbox definition, in HPE. No applications yet
+		 * use this interface and let's not have applications use this
+		 * interface till the new specifitions are in place.
+		 */
+		return -EINVAL;
+#if 0
 		if( copy_from_user(uioc, (char *)arg, sizeof(nitioctl_t)) )
 			return (-EFAULT);
 		return 0;
+#endif
 	}
 
 	/*
@@ -4494,12 +4795,14 @@ mega_enum_raid_scsi(adapter_t *adapter)
 	}
 
 	for( i = 0; i < adapter->product_info.nchannels; i++ ) { 
-		if( (adapter->mega_ch_class >> i) & 0x01 )
+		if( (adapter->mega_ch_class >> i) & 0x01 ) {
 			printk(KERN_INFO "megaraid: channel[%d] is raid.\n",
 					i);
-		else
+		}
+		else {
 			printk(KERN_INFO "megaraid: channel[%d] is scsi.\n",
 					i);
+		}
 	}
 
 	return;
@@ -4794,23 +5097,19 @@ mega_support_cluster(adapter_t *adapter)
 	 */
 	raw_mbox[0] = MEGA_GET_TARGET_ID;
 
-	if( issue_scb_block(adapter, raw_mbox) ) {
+	if( issue_scb_block(adapter, raw_mbox) == 0 ) {
 
-		/* We do not support clustering */
-		adapter->this_id = DEFAULT_INITIATOR_ID;
-		adapter->host->this_id = DEFAULT_INITIATOR_ID;
+		/*
+		 * Cluster support available. Get the initiator target id.
+		 * Tell our id to mid-layer too.
+		 */
+		adapter->this_id = *(u32 *)adapter->mega_buffer;
+		adapter->host->this_id = adapter->this_id;
 
-		return 0;
+		return 1;
 	}
 
-	/*
-	 * Cluster support available. Get the initiator target id.
-	 * Tell our id to mid-layer too.
-	 */
-	adapter->this_id = *(u32 *)adapter->mega_buffer;
-	adapter->host->this_id = adapter->this_id;
-
-	return 1;
+	return 0;
 }
 
 
@@ -5055,37 +5354,17 @@ mega_swap_hosts (struct Scsi_Host *shone
 
 /**
  * mega_adapinq()
- * @adapter - pointer to our soft state (in)
- * @inquiry - pointer to inquiry3 buffer (out)
- * @dma_handle - pointer to DMA address of the buffer (out)
- * @page - /proc data (out)
+ * @adapter - pointer to our soft state
+ * @dma_handle - DMA address of the buffer
  *
  * Issue internal comamnds while interrupts are available.
  * We only issue direct mailbox commands from within the driver. ioctl()
  * interface using these routines can issue passthru commands.
  */
 static int
-mega_adapinq(adapter_t *adapter, caddr_t *inquiry, dma_addr_t *dma_handle,
-		char *page)
+mega_adapinq(adapter_t *adapter, dma_addr_t dma_handle)
 {
 	megacmd_t	mc;
-	int		len = 0;
-	caddr_t		buffer;
-
-
-	/*
-	 * Warning: we allocate memory for enquiry3, even though it'll be used
-	 * for raid inquiry for 8LD controllers. This will not cause issue,
-	 * because the sizeof raid-inquiry for 8ld controllers is much smaller
-	 * than sizeof enquiry3
-	 */
-	buffer = pci_alloc_consistent(adapter->dev, sizeof(mega_inquiry3),
-			dma_handle);
-
-	if( buffer == NULL ) {
-		len = sprintf(page, "memory not available!!\n");
-		return len;
-	}
 
 	memset(&mc, 0, sizeof(megacmd_t));
 
@@ -5098,39 +5377,34 @@ mega_adapinq(adapter_t *adapter, caddr_t
 		mc.cmd = MEGA_MBOXCMD_ADPEXTINQ;
 	}
 
-	mc.xferaddr = (u32)*dma_handle;
+	mc.xferaddr = (u32)dma_handle;
 
 	if ( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
-
-		len = sprintf(page, "Adapter inquiry failed.\n");
-
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
-
-		pci_free_consistent(adapter->dev, sizeof(mega_inquiry3),
-				buffer, *dma_handle);
-		return len;
+		return -1;
 	}
 
-	*inquiry = buffer;
-
 	return 0;
 }
 
 
-
 /**
- * mega_free_adapinq()
- * @adapter - pointer to our soft state (in)
- * @inquiry - pointer to inquiry3 buffer (in)
- * @dma_handle - pointer to DMA address of the buffer (in)
+ * mega_allocate_inquiry()
+ * @dma_handle - handle returned for dma address
+ * @pdev - handle to pci device
  *
- * Free resources allocated for issuing adapter inquiry
+ * allocates memory for inquiry structure
  */
-static void
-mega_free_adapinq(adapter_t *adapter, void *inquiry, dma_addr_t dma_handle)
+static inline caddr_t
+mega_allocate_inquiry(dma_addr_t *dma_handle, struct pci_dev *pdev)
 {
-	pci_free_consistent(adapter->dev, sizeof(mega_inquiry3), inquiry,
-			dma_handle);
+	return pci_alloc_consistent(pdev, sizeof(mega_inquiry3), dma_handle);
+}
+
+
+static inline void
+mega_free_inquiry(caddr_t inquiry, dma_addr_t dma_handle, struct pci_dev *pdev)
+{
+	pci_free_consistent(pdev, sizeof(mega_inquiry3), inquiry, dma_handle);
 }
 
 
@@ -5150,12 +5424,22 @@ mega_internal_dev_inquiry(adapter_t *ada
 	dma_addr_t	pthru_dma_handle;
 	megacmd_t	mc;
 	int		rval;
+	struct pci_dev	*pdev;
 
 
-	pthru = pci_alloc_consistent(adapter->dev, sizeof(mega_passthru),
+	/*
+	 * For all internal commands, the buffer must be allocated in <4GB
+	 * address range
+	 */
+	if( make_local_pdev(adapter, &pdev) != 0 ) return -1;
+
+	pthru = pci_alloc_consistent(pdev, sizeof(mega_passthru),
 			&pthru_dma_handle);
 
-	if( pthru == NULL ) return -1;
+	if( pthru == NULL ) {
+		free_local_pdev(pdev);
+		return -1;
+	}
 
 	pthru->timeout = 2;
 	pthru->ars = 1;
@@ -5186,9 +5470,11 @@ mega_internal_dev_inquiry(adapter_t *ada
 
 	rval = mega_internal_command(adapter, LOCK_INT, &mc, pthru);
 
-	pci_free_consistent(adapter->dev, sizeof(mega_passthru), pthru,
+	pci_free_consistent(pdev, sizeof(mega_passthru), pthru,
 			pthru_dma_handle);
 
+	free_local_pdev(pdev);
+
 	return rval;
 }
 
@@ -5235,7 +5521,7 @@ mega_internal_command(adapter_t *adapter
 	scmd->buffer = (void *)scb;
 	scmd->cmnd[0] = MEGA_INTERNAL_CMD;
 
-	scb->state = SCB_ACTIVE;
+	scb->state |= SCB_ACTIVE;
 	scb->cmd = scmd;
 
 	memcpy(scb->raw_mbox, mc, sizeof(megacmd_t));
@@ -5274,6 +5560,15 @@ mega_internal_command(adapter_t *adapter
 	rval = scmd->result;
 	mc->status = scmd->result;
 
+	/*
+	 * Print a debug message for all failed commands. Applications can use
+	 * this information.
+	 */
+	if( scmd->result ) {
+		printk(KERN_DEBUG "megaraid: cmd [%x, %x, %x] status:[%x]\n",
+			mc->cmd, mc->opcode, mc->subopcode, scmd->result);
+	}
+
 	up(&adapter->int_mtx);
 
 	return rval;
@@ -5305,6 +5600,31 @@ mega_internal_done(Scsi_Cmnd *scmd)
 	wake_up(&adapter->int_waitq);
 
 }
+
+
+static inline int
+make_local_pdev(adapter_t *adapter, struct pci_dev **pdev)
+{
+	*pdev = kmalloc(sizeof(struct pci_dev), GFP_KERNEL);
+
+	if( *pdev == NULL ) return -1;
+
+	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
+
+	if( pci_set_dma_mask(*pdev, 0xffffffff) != 0 ) {
+		kfree(*pdev);
+		return -1;
+	}
+
+	return 0;
+}
+
+static inline void
+free_local_pdev(struct pci_dev *pdev)
+{
+	kfree(pdev);
+}
+
 
 static Scsi_Host_Template driver_template = MEGARAID;
 
diff -urNp --exclude-from=/home/mdomsch/excludes --minimal megaraid-v2.00rc4/megaraid.h megaraid-v2.00rc5/megaraid.h
--- megaraid-v2.00rc4/megaraid.h	Tue Jul 30 20:36:18 2002
+++ megaraid-v2.00rc5/megaraid.h	Sun Sep 22 12:48:47 2002
@@ -6,7 +6,7 @@
 
 
 #define MEGARAID_VERSION	\
-	"v2.00rc4-UT (Release Date: Tue Jul 30 18:26:50 EDT 2002)\n"
+	"v2.00rc5 (Release Date: Sat Sep 21 20:48:18 EDT 2002)\n"
 
 /*
  * Driver features - change the values to enable or disable features in the
@@ -44,6 +44,7 @@
  */
 #define MEGA_HAVE_ENH_PROC	1
 
+#define MAX_DEV_TYPE	32
 
 #ifndef PCI_VENDOR_ID_LSI_LOGIC
 #define PCI_VENDOR_ID_LSI_LOGIC		0x1000
@@ -53,6 +54,14 @@
 #define PCI_VENDOR_ID_AMI		0x101E
 #endif
 
+#ifndef PCI_VENDOR_ID_DELL
+#define PCI_VENDOR_ID_DELL		0x1028
+#endif
+
+#ifndef PCI_VENDOR_ID_INTEL
+#define PCI_VENDOR_ID_INTEL		0x8086
+#endif
+
 #ifndef PCI_DEVICE_ID_AMI_MEGARAID
 #define PCI_DEVICE_ID_AMI_MEGARAID	0x9010
 #endif
@@ -65,17 +74,8 @@
 #define PCI_DEVICE_ID_AMI_MEGARAID3	0x1960
 #endif
 
-#ifndef PCI_DEVICE_ID_LSI_MEGARAID1
-#define PCI_DEVICE_ID_LSI_MEGARAID1	0x0407
-#endif
-
-#define PCI_VENDOR_ID_DISCOVERY		0x1028
 #define PCI_DEVICE_ID_DISCOVERY		0x000E
-
-#define PCI_VENDOR_ID_PERC4_DI_YSTONE	0x1028
-#define PCI_DEVICE_ID_PERC4_DI_YSTONE	0x000F
-
-#define PCI_VENDOR_ID_PERC4_QC_VERDE	0x1000
+#define PCI_DEVICE_ID_PERC4_DI		0x000F
 #define PCI_DEVICE_ID_PERC4_QC_VERDE	0x0407
 
 /* Sub-System Vendor IDs */
@@ -260,13 +260,16 @@ typedef struct {
 	mega_ext_passthru	*epthru;
 	dma_addr_t		epthru_dma_addr;
 } scb_t;
-#define SCB_FREE     0x0
-#define SCB_ACTIVE   0x1
-#define SCB_PENDQ    0x2
-#define SCB_ISSUED   0x3
-#define SCB_COMPLETE 0x4
-#define SCB_ABORTED  0x5
-#define SCB_RESET    0x6
+
+/*
+ * Flags to follow the scb as it transitions between various stages
+ */
+#define SCB_FREE	0x0000	/* on the free list */
+#define SCB_ACTIVE	0x0001	/* off the free list */
+#define SCB_PENDQ	0x0002	/* on the pending queue */
+#define SCB_ISSUED	0x0004	/* issued - owner f/w */
+#define SCB_ABORT	0x0008	/* Got an abort for this one */
+#define SCB_RESET	0x0010	/* Got a reset for this one */
 
 
 /* I/O Port offsets */
@@ -928,6 +931,7 @@ typedef struct {
 
 #endif
 
+	int	has_64bit_addr;		/* are we using 64-bit addressing */
 	int	support_ext_cdb;
 	int	boot_ldrv_enabled;
 	int	boot_ldrv;
@@ -1095,6 +1099,7 @@ static int megaraid_release (struct Scsi
 static int megaraid_command (Scsi_Cmnd *);
 static int megaraid_abort(Scsi_Cmnd *);
 static int megaraid_reset(Scsi_Cmnd *);
+static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam (Disk *, kdev_t, int *);
 static int megaraid_proc_info (char *, char **, off_t, int, int, int);
 static int mega_print_inquiry(char *, char *);
@@ -1143,9 +1148,12 @@ static int proc_rdrv_40(char *, char **,
 static int proc_rdrv(adapter_t *, char *, int, int);
 #endif
 
-static int mega_adapinq(adapter_t *, caddr_t *, dma_addr_t *, char *);
-static void mega_free_adapinq(adapter_t *, void *, dma_addr_t);
+static int mega_adapinq(adapter_t *, dma_addr_t);
 static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
+static inline caddr_t mega_allocate_inquiry(dma_addr_t *, struct pci_dev *);
+static inline void mega_free_inquiry(caddr_t, dma_addr_t, struct pci_dev *);
+static inline int make_local_pdev(adapter_t *, struct pci_dev **);
+static inline void free_local_pdev(struct pci_dev *);
 
 static int mega_support_ext_cdb(adapter_t *);
 static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,
@@ -1164,7 +1172,6 @@ static int mega_internal_command(adapter
 		mega_passthru *);
 static void mega_internal_done(Scsi_Cmnd *);
 static int mega_support_cluster(adapter_t *);
-
 #endif
 
 /* vi: set ts=8 sw=8 tw=78: */



************************************************************************
Patch against RC5 to let it work on 2.4.x stock
************************************************************************
--- /home/mdomsch/megaraid/megaraid-v2.00rc5/megaraid.c	Sun Sep 22 12:59:17 2002
+++ linux-2.4-megaraid/drivers/scsi/megaraid.c	Sun Sep 22 14:20:26 2002
@@ -379,8 +379,6 @@
 		INIT_LIST_HEAD(&adapter->completed_list);
 
 		adapter->flag = flag;
-		spin_lock_init(&adapter->lock);
-		host->lock = &adapter->lock;
 
 		host->cmd_per_lun = max_cmd_per_lun;
 		host->max_sectors = max_sectors_per_io;
@@ -1763,7 +1761,7 @@
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	do {
 		/* Check if a valid interrupt is pending */
@@ -1772,7 +1770,7 @@
 			/*
 			 * No more pending commands
 			 */
-			spin_unlock_irqrestore(&adapter->lock, flags);
+			spin_unlock_irqrestore(&io_request_lock, flags);
 			return;
 		}
 		set_irq_state(adapter, byte);
@@ -1806,7 +1804,7 @@
 
 	} while(1);
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return;
 }
@@ -1836,7 +1834,7 @@
 	/*
 	 * loop till F/W has more commands for us to complete.
 	 */
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	do {
 		/* Check if a valid interrupt is pending */
@@ -1845,7 +1843,7 @@
 			/*
 			 * No more pending commands
 			 */
-			spin_unlock_irqrestore(&adapter->lock, flags);
+			spin_unlock_irqrestore(&io_request_lock, flags);
 			return;
 		}
 
@@ -1881,7 +1879,7 @@
 
 	} while(1);
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return;
 }
@@ -4968,7 +4966,7 @@
 
 	rval = mega_do_del_logdrv(adapter, logdrv);
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	/*
 	 * If delete operation was successful, add 0x80 to the logical drive
@@ -4987,7 +4985,7 @@
 
 	mega_runpendq(adapter);
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return rval;
 }
@@ -5541,11 +5539,11 @@
 	/*
 	 * Get the lock only if the caller has not acquired it already
 	 */
-	if( ls == LOCK_INT ) spin_lock_irqsave(&adapter->lock, flags);
+	if( ls == LOCK_INT ) spin_lock_irqsave(&io_request_lock, flags);
 
 	megaraid_queue(scmd, mega_internal_done);
 
-	if( ls == LOCK_INT ) spin_unlock_irqrestore(&adapter->lock, flags);
+	if( ls == LOCK_INT ) spin_unlock_irqrestore(&io_request_lock, flags);
 
 	/*
 	 * Wait till this command finishes. Do not use
--- /home/mdomsch/megaraid/megaraid-v2.00rc5/megaraid.h	Sun Sep 22 12:48:47 2002
+++ linux-2.4-megaraid/drivers/scsi/megaraid.h	Sun Sep 22 14:20:02 2002
@@ -145,7 +145,6 @@
 	eh_bus_reset_handler:		megaraid_reset,		\
 	eh_host_reset_handler:		megaraid_reset,		\
 	highmem_io:			1,			\
-	can_do_varyio:			1			\
 }
 

