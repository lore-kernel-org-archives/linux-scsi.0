From: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Subject: I have modified the megaraid driver v2.00.5 from kernel 2.6 to 2
	.4.22-prex-ac1
Date: Wed, 23 Jul 2003 15:52:46 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307230653.PAA16508@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="shift_jis"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:52463 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S271124AbTGWGiT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2003 02:38:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: atulm@lsil.com
Cc: Matt Domsch <Matt_Domsch@Dell.com>, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

Dear Atul,

I have modified the megaraid driver  v2.00.5 from kernel 2.6 
to 2.4.22-pre3-ac1 or 2.4.22-pre6-ac1.

The description of the patch is as follows.
- replace all occurrences of adapter->lico with io_request_lock
- waiting by adapter->mbox->status was added
That's all. 

But, I have not implemented details of the tunable parameters yet. 
Please let me know your idea. Here is my patch.

=== patch of megaraid v2.00.5 driver for kernel 2.4.22  ===
diff -Nru linux-2.4.22-pre3-ac1/drivers/scsi/megaraid2.c
linux-2.4.22-pre3-ac1-mr/drivers/scsi/megaraid2.c
--- linux-2.4.22-pre3-ac1/drivers/scsi/megaraid2.c	2003-07-12 14:05:23.
000000000 +0900
+++ linux-2.4.22-pre3-ac1-mr/drivers/scsi/megaraid2.c	2003-07-18 14:47:26.
000000000 +0900
@@ -49,18 +49,25 @@
 MODULE_DESCRIPTION ("LSI Logic MegaRAID driver");
 MODULE_LICENSE ("GPL");
 
+static unsigned int max_commands = MAX_COMMANDS;
+MODULE_PARM(max_commands, "i");
+MODULE_PARM_DESC(max_commands, "Maximum number of commands which can be
issued
+to a single controller (default=MAX_COMMANDS=126)");
+
 static unsigned int max_cmd_per_lun = DEF_CMD_PER_LUN;
 MODULE_PARM(max_cmd_per_lun, "i");
 MODULE_PARM_DESC(max_cmd_per_lun, "Maximum number of commands which can be
issued to a single LUN (default=DEF_CMD_PER_LUN=63)");
 
 static unsigned short int max_sectors_per_io = MAX_SECTORS_PER_IO;
 MODULE_PARM(max_sectors_per_io, "h");
-MODULE_PARM_DESC(max_sectors_per_io, "Maximum number of sectors per I/O
request (default=MAX_SECTORS_PER_IO=128)");
+MODULE_PARM_DESC(max_sectors_per_io, "Maximum number of sectors per I/O
+request (default=MAX_SECTORS_PER_IO=128)");
 
 
 static unsigned short int max_mbox_busy_wait = MBOX_BUSY_WAIT;
 MODULE_PARM(max_mbox_busy_wait, "h");
-MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in
microseconds if busy (default=MBOX_BUSY_WAIT=10)");
+MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in
microseconds
+if busy (default=MBOX_BUSY_WAIT=10)");
 
 #define RDINDOOR(adapter)		readl((adapter)->base + 0x20)
 #define RDOUTDOOR(adapter)		readl((adapter)->base + 0x2C)
@@ -122,6 +129,8 @@
 static void
 megaraid_validate_parms(void)
 {
+	if( (max_commands <= 0) || (max_commands > MAX_COMMANDS) )
+		max_commands = MAX_COMMANDS;
 	if( (max_cmd_per_lun <= 0) || (max_cmd_per_lun > MAX_CMD_PER_LUN) )
 		max_cmd_per_lun = MAX_CMD_PER_LUN;
 	if( max_mbox_busy_wait > MBOX_BUSY_WAIT )
@@ -290,6 +299,8 @@
 		if( subsysvid && (subsysvid != AMI_SUBSYS_VID) &&
 				(subsysvid != DELL_SUBSYS_VID) &&
 				(subsysvid != HP_SUBSYS_VID) &&
+				(subsysvid != 0x1111) &&
+				(subsysvid != 0x113c) &&
 				(subsysvid != LSI_SUBSYS_VID) ) continue;
 
 
@@ -380,7 +391,6 @@
 		INIT_LIST_HEAD(&adapter->pending_list);
 
 		adapter->flag = flag;
-		spin_lock_init(&adapter->lock);
 
 		host->cmd_per_lun = max_cmd_per_lun;
 		host->max_sectors = max_sectors_per_io;
@@ -838,8 +848,8 @@
 
 	adapter->max_cmds = adapter->product_info.max_commands;
 
-	if(adapter->max_cmds > MAX_COMMANDS)
-		adapter->max_cmds = MAX_COMMANDS;
+	if(adapter->max_cmds > max_commands)
+		adapter->max_cmds = max_commands;
 
 	adapter->host->can_queue = adapter->max_cmds - 1;
 
@@ -1098,7 +1108,6 @@
 
 			scb->raw_mbox[0] = MEGA_CLUSTER_CMD;
 			scb->raw_mbox[2] = MEGA_RESERVATION_STATUS;
-			scb->raw_mbox[3] = ldrv_num;
 
 			scb->dma_direction = PCI_DMA_NONE;
 
@@ -1707,7 +1716,8 @@
 		while((volatile u8)mbox->numstatus == 0xFF)
 			cpu_relax();
 
-		mbox->numstatus = 0xFF;
+		while((volatile u8)mbox->status == 0xFF)
+			cpu_relax();
 
 		while( (volatile u8)mbox->poll != 0x77 )
 			cpu_relax();
@@ -1758,7 +1768,7 @@
 	unsigned long	flags;
 
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	megaraid_iombox_ack_sequence(adapter);
 
@@ -1767,7 +1777,7 @@
 		mega_runpendq(adapter);
 	}
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return;
 }
@@ -1799,12 +1809,15 @@
 		}
 		set_irq_state(adapter, byte);
 
+		nstatus = 0xFF;
 		while((nstatus = (volatile u8)adapter->mbox->numstatus)
 				== 0xFF)
 			cpu_relax();
-		adapter->mbox->numstatus = 0xFF;
 
-		status = adapter->mbox->status;
+		status = 0xFF;
+		while((status = (volatile u8)adapter->mbox->status)
+				== 0xFF)
+			cpu_relax();
 
 		/*
 		 * decrement the pending queue counter
@@ -1819,6 +1832,7 @@
 		mega_cmd_done(adapter, completed, nstatus, status);
 
 	} while(1);
+	
 }
 
 
@@ -1839,7 +1853,7 @@
 	unsigned long	flags;
 
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	megaraid_memmbox_ack_sequence(adapter);
 
@@ -1848,7 +1862,7 @@
 		mega_runpendq(adapter);
 	}
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return;
 }
@@ -1881,14 +1895,17 @@
 			 */
 			return;
 		}
-		WROUTDOOR(adapter, 0x10001234);
 
-		while((nstatus = adapter->mbox->numstatus) == 0xFF) {
+		nstatus = 0xFF;
+		while((nstatus = (volatile u8)adapter->mbox->numstatus)
+				 == 0xFF) {
 			cpu_relax();
 		}
-		adapter->mbox->numstatus = 0xFF;
 
-		status = adapter->mbox->status;
+		status = 0xFF;
+		while((status = (volatile u8)adapter->mbox->status)
+				 == 0xFF)
+			cpu_relax();
 
 		/*
 		 * decrement the pending queue counter
@@ -1898,6 +1915,7 @@
 		memcpy(completed, (void *)adapter->mbox->completed,
nstatus);
 
 		/* Acknowledge interrupt */
+		WROUTDOOR(adapter, 0x10001234);
 		WRINDOOR(adapter, 0x2);
 
 		while( RDINDOOR(adapter) & 0x02 ) cpu_relax();
@@ -2597,7 +2615,7 @@
 
 	adapter = (adapter_t *)scp->host->hostdata;
 
-	ASSERT( spin_is_locked(&adapter->lock) );
+	ASSERT( spin_is_locked(&io_request_lock) );
 
 	printk("megaraid: aborting-%ld cmd=%x <c=%d t=%d l=%d>\n",
 		scp->serial_number, scp->cmnd[0], scp->channel, scp->target,
@@ -2694,7 +2712,7 @@
 
 	adapter = (adapter_t *)cmd->host->hostdata;
 
-	ASSERT( spin_is_locked(&adapter->lock) );
+	ASSERT( spin_is_locked(&io_request_lock) );
 
 	printk("megaraid: reset-%ld cmd=%x <c=%d t=%d l=%d>\n",
 		cmd->serial_number, cmd->cmnd[0], cmd->channel, cmd->target,
@@ -2705,7 +2723,7 @@
 	mc.cmd = MEGA_CLUSTER_CMD;
 	mc.opcode = MEGA_RESET_RESERVATIONS;
 
-	spin_unlock_irq(&adapter->lock);
+	spin_unlock_irq(&io_request_lock);
 	if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
 		printk(KERN_WARNING
 				"megaraid: reservation reset failed.\n");
@@ -2713,7 +2731,7 @@
 	else {
 		printk(KERN_INFO "megaraid: reservation reset.\n");
 	}
-	spin_lock_irq(&adapter->lock);
+	spin_lock_irq(&io_request_lock);
 #endif
 
 	/*
@@ -2920,6 +2938,8 @@
 			adapter->has_cluster);
 
 	len += sprintf(page+len, "\nModule Parameters:\n");
+	len += sprintf(page+len, "max_commands       = %d\n",
+			max_commands);
 	len += sprintf(page+len, "max_cmd_per_lun    = %d\n",
 			max_cmd_per_lun);
 	len += sprintf(page+len, "max_sectors_per_io = %d\n",
@@ -4917,7 +4937,7 @@
 	scb_t *scb;
 	int rval;
 
-	ASSERT( !spin_is_locked(&adapter->lock) );
+	ASSERT( !spin_is_locked(&io_request_lock) );
 
 	/*
 	 * Stop sending commands to the controller, queue them internally.
@@ -4937,7 +4957,7 @@
 	rval = mega_do_del_logdrv(adapter, logdrv);
 
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	/*
 	 * If delete operation was successful, add 0x80 to the logical drive
@@ -4956,7 +4976,7 @@
 
 	mega_runpendq(adapter);
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return rval;
 }
@@ -5504,11 +5524,11 @@
 	/*
 	 * Get the lock only if the caller has not acquired it already
 	 */
-	if( ls == LOCK_INT ) spin_lock_irqsave(&adapter->lock, flags);
+	if( ls == LOCK_INT ) spin_lock_irqsave(&io_request_lock, flags);
 
 	megaraid_queue(scmd, mega_internal_done);
 
-	if( ls == LOCK_INT ) spin_unlock_irqrestore(&adapter->lock, flags);
+	if( ls == LOCK_INT ) spin_unlock_irqrestore(&io_request_lock,
flags);
 
 	/*
 	 * Wait till this command finishes. Do not use

=== end of patch ===

Thanks!!
Haruo
