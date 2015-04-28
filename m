From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/3] megaraid: use dev_printk when possible
Date: Tue, 28 Apr 2015 18:14:04 -0500
Message-ID: <20150428231404.10378.48874.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use dev_printk() when possible to make messages more useful.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/megaraid.c |   92 ++++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index bc7b34c..47cda02 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -268,7 +268,7 @@ mega_query_adapter(adapter_t *adapter)
 		raw_mbox[2] = NC_SUBOP_PRODUCT_INFO;	/* i.e. 0x0E */
 
 		if ((retval = issue_scb_block(adapter, raw_mbox)))
-			printk(KERN_WARNING
+			dev_warn(&adapter->dev->dev,
 			"megaraid: Product_info cmd failed with error: %d\n",
 				retval);
 
@@ -334,7 +334,7 @@ mega_query_adapter(adapter_t *adapter)
 		adapter->bios_version[4] = 0;
 	}
 
-	printk(KERN_NOTICE "megaraid: [%s:%s] detected %d logical drives.\n",
+	dev_notice(&adapter->dev->dev, "[%s:%s] detected %d logical drives.\n",
 		adapter->fw_version, adapter->bios_version, adapter->numldrv);
 
 	/*
@@ -342,7 +342,7 @@ mega_query_adapter(adapter_t *adapter)
 	 */
 	adapter->support_ext_cdb = mega_support_ext_cdb(adapter);
 	if (adapter->support_ext_cdb)
-		printk(KERN_NOTICE "megaraid: supports extended CDBs.\n");
+		dev_notice(&adapter->dev->dev, "supports extended CDBs.\n");
 
 
 	return 0;
@@ -678,7 +678,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 
 			if(!(adapter->flag & (1L << cmd->device->channel))) {
 
-				printk(KERN_NOTICE
+				dev_notice(&adapter->dev->dev,
 					"scsi%d: scanning scsi channel %d ",
 						adapter->host->host_no,
 						cmd->device->channel);
@@ -983,7 +983,7 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
 	case READ_CAPACITY:
 		if(!(adapter->flag & (1L << cmd->device->channel))) {
 
-			printk(KERN_NOTICE
+			dev_notice(&adapter->dev->dev,
 				"scsi%d: scanning scsi channel %d [P%d] ",
 					adapter->host->host_no,
 					cmd->device->channel, channel);
@@ -1045,7 +1045,7 @@ mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
 	case READ_CAPACITY:
 		if(!(adapter->flag & (1L << cmd->device->channel))) {
 
-			printk(KERN_NOTICE
+			dev_notice(&adapter->dev->dev,
 				"scsi%d: scanning scsi channel %d [P%d] ",
 					adapter->host->host_no,
 					cmd->device->channel, channel);
@@ -1241,7 +1241,7 @@ issue_scb_block(adapter_t *adapter, u_char *raw_mbox)
 	return mbox->m_in.status;
 
 bug_blocked_mailbox:
-	printk(KERN_WARNING "megaraid: Blocked mailbox......!!\n");
+	dev_warn(&adapter->dev->dev, "Blocked mailbox......!!\n");
 	udelay (1000);
 	return -1;
 }
@@ -1454,7 +1454,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			 * Make sure f/w has completed a valid command
 			 */
 			if( !(scb->state & SCB_ISSUED) || scb->cmd == NULL ) {
-				printk(KERN_CRIT
+				dev_crit(&adapter->dev->dev,
 					"megaraid: invalid command ");
 				printk("Id %d, scb->state:%x, scsi cmd:%p\n",
 					cmdid, scb->state, scb->cmd);
@@ -1467,7 +1467,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			 */
 			if( scb->state & SCB_ABORT ) {
 
-				printk(KERN_WARNING
+				dev_warn(&adapter->dev->dev,
 				"megaraid: aborted cmd [%x] complete.\n",
 					scb->idx);
 
@@ -1486,7 +1486,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			 */
 			if( scb->state & SCB_RESET ) {
 
-				printk(KERN_WARNING
+				dev_warn(&adapter->dev->dev,
 				"megaraid: reset cmd [%x] complete.\n",
 					scb->idx);
 
@@ -1553,7 +1553,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 			if( sg_page(sgl) ) {
 				c = *(unsigned char *) sg_virt(&sgl[0]);
 			} else {
-				printk(KERN_WARNING
+				dev_warn(&adapter->dev->dev,
 				       "megaraid: invalid sg.\n");
 				c = 0;
 			}
@@ -1902,11 +1902,10 @@ megaraid_reset(struct scsi_cmnd *cmd)
 	mc.opcode = MEGA_RESET_RESERVATIONS;
 
 	if( mega_internal_command(adapter, &mc, NULL) != 0 ) {
-		printk(KERN_WARNING
-				"megaraid: reservation reset failed.\n");
+		dev_warn(&adapter->dev->dev, "reservation reset failed.\n");
 	}
 	else {
-		printk(KERN_INFO "megaraid: reservation reset.\n");
+		dev_info(&adapter->dev->dev, "reservation reset.\n");
 	}
 #endif
 
@@ -1939,7 +1938,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	struct list_head	*pos, *next;
 	scb_t			*scb;
 
-	printk(KERN_WARNING "megaraid: %s cmd=%x <c=%d t=%d l=%d>\n",
+	dev_warn(&adapter->dev->dev, "%s cmd=%x <c=%d t=%d l=%d>\n",
 	     (aor == SCB_ABORT)? "ABORTING":"RESET",
 	     cmd->cmnd[0], cmd->device->channel,
 	     cmd->device->id, (u32)cmd->device->lun);
@@ -1963,7 +1962,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 			 */
 			if( scb->state & SCB_ISSUED ) {
 
-				printk(KERN_WARNING
+				dev_warn(&adapter->dev->dev,
 					"megaraid: %s[%x], fw owner.\n",
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					scb->idx);
@@ -1976,7 +1975,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 				 * Not yet issued! Remove from the pending
 				 * list
 				 */
-				printk(KERN_WARNING
+				dev_warn(&adapter->dev->dev,
 					"megaraid: %s-[%x], driver owner.\n",
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					scb->idx);
@@ -2197,7 +2196,7 @@ proc_show_rebuild_rate(struct seq_file *m, void *v)
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_puts(m, "Adapter inquiry failed.\n");
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		dev_warn(&adapter->dev->dev, "inquiry failed.\n");
 		goto free_inquiry;
 	}
 
@@ -2241,7 +2240,7 @@ proc_show_battery(struct seq_file *m, void *v)
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_puts(m, "Adapter inquiry failed.\n");
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		dev_warn(&adapter->dev->dev, "inquiry failed.\n");
 		goto free_inquiry;
 	}
 
@@ -2350,7 +2349,7 @@ proc_show_pdrv(struct seq_file *m, adapter_t *adapter, int channel)
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_puts(m, "Adapter inquiry failed.\n");
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		dev_warn(&adapter->dev->dev, "inquiry failed.\n");
 		goto free_inquiry;
 	}
 
@@ -2525,7 +2524,7 @@ proc_show_rdrv(struct seq_file *m, adapter_t *adapter, int start, int end )
 
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		seq_puts(m, "Adapter inquiry failed.\n");
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		dev_warn(&adapter->dev->dev, "inquiry failed.\n");
 		goto free_inquiry;
 	}
 
@@ -2799,7 +2798,7 @@ mega_create_proc_entry(int index, struct proc_dir_entry *parent)
 	dir = adapter->controller_proc_dir_entry =
 		proc_mkdir_data(string, 0, parent, adapter);
 	if(!dir) {
-		printk(KERN_WARNING "\nmegaraid: proc_mkdir failed\n");
+		dev_warn(&adapter->dev->dev, "\nproc_mkdir failed\n");
 		return;
 	}
 
@@ -2807,7 +2806,7 @@ mega_create_proc_entry(int index, struct proc_dir_entry *parent)
 		de = proc_create_data(f->name, S_IRUSR, dir, &mega_proc_fops,
 				      f->show);
 		if (!de) {
-			printk(KERN_WARNING "\nmegaraid: proc_create failed\n");
+			dev_warn(&adapter->dev->dev, "\nproc_create failed\n");
 			return;
 		}
 
@@ -2874,7 +2873,7 @@ megaraid_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 				return rval;
 		}
 
-		printk(KERN_INFO
+		dev_info(&adapter->dev->dev,
 		"megaraid: invalid partition on this disk on channel %d\n",
 				sdev->channel);
 
@@ -2936,7 +2935,7 @@ mega_init_scb(adapter_t *adapter)
 		scb->sgl = (mega_sglist *)scb->sgl64;
 
 		if( !scb->sgl ) {
-			printk(KERN_WARNING "RAID: Can't allocate sglist.\n");
+			dev_warn(&adapter->dev->dev, "RAID: Can't allocate sglist.\n");
 			mega_free_sgl(adapter);
 			return -1;
 		}
@@ -2946,7 +2945,7 @@ mega_init_scb(adapter_t *adapter)
 				&scb->pthru_dma_addr);
 
 		if( !scb->pthru ) {
-			printk(KERN_WARNING "RAID: Can't allocate passthru.\n");
+			dev_warn(&adapter->dev->dev, "RAID: Can't allocate passthru.\n");
 			mega_free_sgl(adapter);
 			return -1;
 		}
@@ -2956,7 +2955,7 @@ mega_init_scb(adapter_t *adapter)
 				&scb->epthru_dma_addr);
 
 		if( !scb->epthru ) {
-			printk(KERN_WARNING
+			dev_warn(&adapter->dev->dev,
 				"Can't allocate extended passthru.\n");
 			mega_free_sgl(adapter);
 			return -1;
@@ -3154,7 +3153,7 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			 * Do we support this feature
 			 */
 			if( !adapter->support_random_del ) {
-				printk(KERN_WARNING "megaraid: logdrv ");
+				dev_warn(&adapter->dev->dev, "logdrv ");
 				printk("delete on non-supporting F/W.\n");
 
 				return (-EINVAL);
@@ -3179,7 +3178,7 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		if( uioc.uioc_rmbox[0] == MEGA_MBOXCMD_PASSTHRU64 ||
 			uioc.uioc_rmbox[0] == MEGA_MBOXCMD_EXTPTHRU ) {
 
-			printk(KERN_WARNING "megaraid: rejected passthru.\n");
+			dev_warn(&adapter->dev->dev, "rejected passthru.\n");
 
 			return (-EINVAL);
 		}
@@ -3683,11 +3682,11 @@ mega_enum_raid_scsi(adapter_t *adapter)
 
 	for( i = 0; i < adapter->product_info.nchannels; i++ ) { 
 		if( (adapter->mega_ch_class >> i) & 0x01 ) {
-			printk(KERN_INFO "megaraid: channel[%d] is raid.\n",
+			dev_info(&adapter->dev->dev, "channel[%d] is raid.\n",
 					i);
 		}
 		else {
-			printk(KERN_INFO "megaraid: channel[%d] is scsi.\n",
+			dev_info(&adapter->dev->dev, "channel[%d] is scsi.\n",
 					i);
 		}
 	}
@@ -3893,7 +3892,7 @@ mega_do_del_logdrv(adapter_t *adapter, int logdrv)
 
 	/* log this event */
 	if(rval) {
-		printk(KERN_WARNING "megaraid: Delete LD-%d failed.", logdrv);
+		dev_warn(&adapter->dev->dev, "Delete LD-%d failed.", logdrv);
 		return rval;
 	}
 
@@ -4244,11 +4243,8 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	subsysvid = pdev->subsystem_vendor;
 	subsysid = pdev->subsystem_device;
 
-	printk(KERN_NOTICE "megaraid: found 0x%4.04x:0x%4.04x:bus %d:",
-		id->vendor, id->device, pci_bus);
-
-	printk("slot %d:func %d\n",
-		PCI_SLOT(pci_dev_func), PCI_FUNC(pci_dev_func));
+	dev_notice(&pdev->dev, "found 0x%4.04x:0x%4.04x\n",
+		id->vendor, id->device);
 
 	/* Read the base port and IRQ from PCI */
 	mega_baseport = pci_resource_start(pdev, 0);
@@ -4259,14 +4255,13 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		flag |= BOARD_MEMMAP;
 
 		if (!request_mem_region(mega_baseport, 128, "megaraid")) {
-			printk(KERN_WARNING "megaraid: mem region busy!\n");
+			dev_warn(&pdev->dev, "mem region busy!\n");
 			goto out_disable_device;
 		}
 
 		mega_baseport = (unsigned long)ioremap(mega_baseport, 128);
 		if (!mega_baseport) {
-			printk(KERN_WARNING
-			       "megaraid: could not map hba memory\n");
+			dev_warn(&pdev->dev, "could not map hba memory\n");
 			goto out_release_region;
 		}
 	} else {
@@ -4285,7 +4280,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	adapter = (adapter_t *)host->hostdata;
 	memset(adapter, 0, sizeof(adapter_t));
 
-	printk(KERN_NOTICE
+	dev_notice(&pdev->dev,
 		"scsi%d:Found MegaRAID controller at 0x%lx, IRQ:%d\n",
 		host->host_no, mega_baseport, irq);
 
@@ -4323,21 +4318,20 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	adapter->mega_buffer = pci_alloc_consistent(adapter->dev,
 		MEGA_BUFFER_SIZE, &adapter->buf_dma_handle);
 	if (!adapter->mega_buffer) {
-		printk(KERN_WARNING "megaraid: out of RAM.\n");
+		dev_warn(&pdev->dev, "out of RAM.\n");
 		goto out_host_put;
 	}
 
 	adapter->scb_list = kmalloc(sizeof(scb_t) * MAX_COMMANDS, GFP_KERNEL);
 	if (!adapter->scb_list) {
-		printk(KERN_WARNING "megaraid: out of RAM.\n");
+		dev_warn(&pdev->dev, "out of RAM.\n");
 		goto out_free_cmd_buffer;
 	}
 
 	if (request_irq(irq, (adapter->flag & BOARD_MEMMAP) ?
 				megaraid_isr_memmapped : megaraid_isr_iomapped,
 					IRQF_SHARED, "megaraid", adapter)) {
-		printk(KERN_WARNING
-			"megaraid: Couldn't register IRQ %d!\n", irq);
+		dev_warn(&pdev->dev, "Couldn't register IRQ %d!\n", irq);
 		goto out_free_scb_list;
 	}
 
@@ -4357,7 +4351,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!strcmp(adapter->fw_version, "3.00") ||
 				!strcmp(adapter->fw_version, "3.01")) {
 
-			printk( KERN_WARNING
+			dev_warn(&pdev->dev,
 				"megaraid: Your  card is a Dell PERC "
 				"2/SC RAID controller with  "
 				"firmware\nmegaraid: 3.00 or 3.01.  "
@@ -4390,7 +4384,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!strcmp(adapter->fw_version, "H01.07") ||
 		    !strcmp(adapter->fw_version, "H01.08") ||
 		    !strcmp(adapter->fw_version, "H01.09") ) {
-			printk(KERN_WARNING
+			dev_warn(&pdev->dev,
 				"megaraid: Firmware H.01.07, "
 				"H.01.08, and H.01.09 on 1M/2M "
 				"controllers\n"
@@ -4503,7 +4497,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	adapter->has_cluster = mega_support_cluster(adapter);
 	if (adapter->has_cluster) {
-		printk(KERN_NOTICE
+		dev_notice(&pdev->dev,
 			"megaraid: Cluster driver, initiator id:%d\n",
 			adapter->this_id);
 	}
@@ -4571,7 +4565,7 @@ __megaraid_shutdown(adapter_t *adapter)
 	issue_scb_block(adapter, raw_mbox);
 	
 	if (atomic_read(&adapter->pend_cmds) > 0)
-		printk(KERN_WARNING "megaraid: pending commands!!\n");
+		dev_warn(&adapter->dev->dev, "pending commands!!\n");
 
 	/*
 	 * Have a delibrate delay to make sure all the caches are
