From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [16/27]
Date: Thu, 17 Feb 2005 12:37:05 -0500
Message-ID: <4214D641.4050906@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:18578 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262331AbVBQRhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:37:15 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHb9r31332
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:09 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHb8b21372
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

OSM code.  Part 3/3.

+
+/* 
+ * Function:
+ *	asd_pci_dev_remove()
+ *
+ * Description:
+ *	This routine is called when the controller is removed or during 
+ *	module unloading. 
+ */
+static void
+asd_pci_dev_remove(struct pci_dev *pdev)
+{
+	struct asd_softc	*asd;
+	unsigned long		 flags;
+	
+	asd = (struct asd_softc *) pci_get_drvdata(pdev);
+	
+	if (asd_get_softc(asd) != NULL) {
+		asd_list_lock(&flags);	
+		list_del(&asd->link);
+		asd_list_unlock(&flags);
+		asd_free_softc(asd);
+	}
+}
+
+int
+asd_platform_alloc(struct asd_softc *asd)
+{
+	asd->platform_data = asd_alloc_mem(sizeof(struct asd_platform_data),
+					   GFP_ATOMIC);
+	if (asd->platform_data == NULL)
+		return (-ENOMEM);
+	memset(asd->platform_data, 0, sizeof(struct asd_platform_data));
+
+	asd_lock_init(asd);
+	INIT_LIST_HEAD(&asd->platform_data->pending_os_scbs);
+	INIT_LIST_HEAD(&asd->platform_data->device_runq);
+	INIT_LIST_HEAD(&asd->platform_data->completeq);
+	INIT_LIST_HEAD(&asd->platform_data->lru_ddb_q);
+	init_MUTEX_LOCKED(&asd->platform_data->discovery_sem);
+	init_MUTEX_LOCKED(&asd->platform_data->discovery_ending_sem);
+	init_MUTEX_LOCKED(&asd->platform_data->ehandler_sem);
+	init_MUTEX_LOCKED(&asd->platform_data->ehandler_ending_sem);
+	init_MUTEX_LOCKED(&asd->platform_data->eh_sem);
+	init_MUTEX_LOCKED(&asd->platform_data->wait_sem);
+	init_waitqueue_head(&asd->platform_data->waitq);
+
+	asd_init_tasklets(asd);
+
+#ifdef ASD_EH_SIMULATION
+	init_MUTEX_LOCKED(&asd->platform_data->eh_simul_sem);
+#endif	
+	
+	asd->platform_data->num_domains = ASD_MAX_PORTS;
+
+	return (0);
+}
+
+void
+asd_platform_free(struct asd_softc *asd)
+{
+	struct asd_io_handle	*io_handle;
+	struct asd_domain	*dm;
+	struct asd_target	*targ;
+	struct asd_device	*dev;
+	u_int			 i;
+	u_int			 j;
+	u_int			 k;
+
+	/* Kill any threads that we created. */
+	asd_kill_discovery_thread(asd);
+	asd_kill_ehandler_thread(asd);
+#ifdef ASD_EH_SIMULATION	
+	asd_kill_eh_simul_thread(asd);
+#endif
+
+	asd_kill_tasklets(asd);
+
+	/* Deregister the Scsi Host with the OS. */
+	if (asd->platform_data->scsi_host) {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+		scsi_remove_host(asd->platform_data->scsi_host);
+		scsi_host_put(asd->platform_data->scsi_host);
+#else
+		scsi_unregister(asd->platform_data->scsi_host);
+#endif
+	}
+	
+	/* Free up any allocated linux domains, targets and devices. */
+	for (i = 0; i < asd->hw_profile.max_phys; i++) {
+		dm = asd->platform_data->domains[i];	
+		if (dm == NULL)
+			continue;
+
+		for (j = 0; j < ASD_MAX_TARGETS; j++) {
+			targ = dm->targets[j];
+			if (targ == NULL) 
+				continue;
+
+			for (k = 0; k < ASD_MAX_LUNS; k++) {
+				dev = targ->devices[k];
+				if (dev == NULL)
+					continue;
+
+				asd_free_device(asd, dev);
+			}
+			/* 
+			 * For target with no devices allocated previously,
+			 * we need to free target explicitly.
+			 */
+			if (dm->targets[j] != NULL)
+				asd_free_mem(dm->targets[j]);
+		}
+		/* 
+		 * For domain with no targets allocated previously,
+		 * we need to free domain explicitly.
+		 */
+		if (asd->platform_data->domains[i] != NULL)
+			asd_free_mem(asd->platform_data->domains[i]);
+	}
+
+	/*
+	 * Disable chip interrupts if we have successfully mapped
+	 * the controller.  We do this *before* unregistering
+	 * our interrupt handler so that stray interrupts from
+	 * our controller do not hang the machine.
+	 */
+	if (asd->io_handle_cnt != 0)
+		asd_intr_enable(asd, 0);
+
+	/* Unregister the interrupt handler. */
+	if (asd_init_stat.asd_irq_registered == 1)
+		free_irq(asd_pci_dev(asd)->irq, asd);
+
+	/* Lock PCIC_MBAR_KEY. */
+	asd_pcic_write_dword(asd, PCIC_MBAR_KEY, 0xFFFFFFFF);	
+
+	/* Free the IO Handle(s). */
+	for ( ; asd->io_handle_cnt != 0; ) {
+		io_handle = asd->io_handle[(--asd->io_handle_cnt)];
+		if (io_handle->type == ASD_MEMORY_SPACE) {
+			release_mem_region(io_handle->bar_base, 
+					   io_handle->length);
+		} else {
+			release_region(io_handle->bar_base, io_handle->length);
+		}	
+		asd_free_mem(io_handle);
+	}
+}
+
+/* 
+ * Function:
+ *	asd_init_hw()
+ *
+ * Description:
+ *	This routine will call the hwi layer to initialize the controller.
+ *	Allocate any required memory, private data structures (such as scb, 
+ *	edb, dl, etc) for the controller.
+ */
+static int
+asd_init_hw(struct asd_softc *asd)
+{
+	uint32_t	mbar_key;
+	uint32_t	cmd_stat_reg;
+	int 		error;
+
+	/* TODO: Revisit */
+	//ASD_LOCK_ASSERT(asd);
+
+	/* Only support for Rev. B0 chip. */
+	if (asd->hw_profile.rev_id != AIC9410_DEV_REV_B0) {
+		asd_print("Only AIC-9410 Rev. B0 is supported !\n");
+		error = -ENODEV;
+		goto exit;
+	}
+		
+	/*
+	 * Check if the PCIC_MBAR_KEY is not unlocked without permission.
+	 * Value 0x0 means it has been unlocked.
+	 */
+	mbar_key = asd_pcic_read_dword(asd, PCIC_MBAR_KEY);
+       	if (mbar_key == 0x0)
+		asd_log(ASD_DBG_INFO, "MBAR_KEY has been unlocked !!\n");
+	
+	/* Map the IO handle. */
+	error = asd_map_io_handle(asd);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to map IO Handle.\n");
+		goto exit;
+	}		
+
+	/* Check if bus master is enabled. Enabled it if it is not. */
+	cmd_stat_reg = asd_pcic_read_dword(asd, PCIC_COMMAND);
+	if (!(cmd_stat_reg & MST_EN)) {
+		cmd_stat_reg |= MST_EN;
+		asd_pcic_write_dword(asd, PCIC_COMMAND, cmd_stat_reg);	
+	}
+	
+	/*
+	 * Now, unlock the PCIC_MBAR_KEY for write access to MBAR.
+	 * Read the value from the register and write it back to the register
+	 * to unlcok MBAR.
+	 */
+	mbar_key = asd_pcic_read_dword(asd, PCIC_MBAR_KEY);	
+	if (mbar_key != 0x0)
+		asd_pcic_write_dword(asd, PCIC_MBAR_KEY, mbar_key);
+	
+	/*
+	 * AIC9410 CHIP Rev. A1 has the issue where the data transfer hangs
+	 * on the host write DMA. The workaround for this issue is to disable
+	 * PCIX Rewind feature.
+	 */ 
+	if (asd->hw_profile.rev_id == AIC9410_DEV_REV_A1) {
+		asd_pcic_write_dword(asd,  PCIC_HSTPCIX_CNTRL, 
+				    (asd_pcic_read_dword(asd, 
+							 PCIC_HSTPCIX_CNTRL) | 
+							 REWIND_DIS));
+	}
+		
+	error = asd_hwi_init_hw(asd);
+	if (error != 0) {
+		asd_log(ASD_DBG_ERROR, "Init HW failed.\n");
+		goto exit;
+	}
+	
+	/* Register the interrupt handler with the OS. */
+	error = request_irq(asd_pci_dev(asd)->irq, asd_isr, SA_SHIRQ,
+			    ASD_DRIVER_NAME, asd);
+	if (error != 0)
+	     asd_log(ASD_DBG_ERROR, "Failed to register IRQ handler.\n"); 
+
+	asd_init_stat.asd_irq_registered = 1;
+exit:
+	return (error);
+}
+
+/* 
+ * Function:
+ *	asd_map_io_handle()
+ *
+ * Description:
+ *	Map the IO handles for the register access.
+ */
+static int
+asd_map_io_handle(struct asd_softc *asd)
+{
+	uint32_t	cmd_stat_reg;
+	int		error;
+
+	asd->io_handle = asd_alloc_mem((sizeof(struct asd_io_handle) * 
+					ASD_MAX_IO_HANDLES), GFP_KERNEL);
+	if (asd->io_handle == NULL)
+		return (-ENOMEM);
+						
+	cmd_stat_reg = asd_pcic_read_dword(asd, PCIC_COMMAND);
+	
+	/* Whenever possible, map the IO handles using Memory Mapped. */
+	if (cmd_stat_reg & MEM_EN) {
+		error = asd_mem_mapped_io_handle(asd);
+		if (error == 0)
+			goto exit;
+		/*
+		 * We will fall back to IO Mapped if we failed to map using
+		 * Memory Mapped.
+		 */
+	}	
+	
+	if (cmd_stat_reg & IO_EN)
+		error = asd_io_mapped_io_handle(asd);	
+	else
+		error = -ENOMEM;
+exit:
+	return (error);	
+}
+
+/*
+ * asd_mem_mapped_io_handle()
+ *
+ * Description:
+ *	Map the IO Handle using Memory Mapped.
+ */
+static int
+asd_mem_mapped_io_handle(struct asd_softc *asd)
+{
+	struct asd_io_handle	*io_handle;
+	int			 error;
+	uint32_t		 base_addr;
+	uint32_t		 base_page;
+	uint32_t		 base_offset;
+	uint32_t		 bar_type;
+	uint32_t		 bar_len;
+	uint8_t			 index;
+#if 0
+	uint32_t		scb_pro;	
+#endif
+
+#define ASD_FREE_PREV_IO_HANDLE(asd)					    \
+do {									    \
+	for ( ; asd->io_handle_cnt != 0; ) {				    \
+		io_handle = asd->io_handle[(--asd->io_handle_cnt)];	    \
+		release_mem_region(io_handle->bar_base, io_handle->length); \
+		asd_free_mem(io_handle);				    \
+	}								    \
+} while (0)
+
+	/*
+	 * TBRV: MBAR0 and MBAR1 of the controller are both 64-bit. 
+	 *	 Linux PCI isn't aware of 64-bit BAR.
+	 *	 For now, it is fine we just map the first 32-bit, as the upper
+	 *	 32-bit are set to 0.
+	 */	
+	for (index = 0; index < 3; index = index+2) {
+		/*
+		 * Acquire the base addr, length of the region to be mapped.
+		 */
+		base_addr = pci_resource_start(asd_dev_to_pdev(asd->dev), 
+					       index);
+		bar_type = pci_resource_flags(asd_dev_to_pdev(asd->dev), 
+					      index);
+		
+		if (index == PCIC_MBAR0_OFFSET) {
+			uint32_t	mbar0_mask;
+			
+			/* 
+		 	 * For MBAR0, we need to figure out the size of 
+			 * the region to be mapped.  The configured size
+			 * of the bar is 8K * 2^N, where N is the number of
+			 * bits set in the MBAR0 size mask.
+		 	 */
+
+			mbar0_mask = asd_pcic_read_dword(asd, PCIC_MBAR0_MASK);
+			mbar0_mask = PCIC_MBAR0_SIZE(mbar0_mask);
+			bar_len = 0x2000;
+			while (mbar0_mask != 0) {
+				mbar0_mask >>= 1;
+				bar_len <<= 1;
+			}
+		} else {
+			/* For MBAR1, we will map 128K. */
+			bar_len = 0x20000;
+		}
+		
+		/*
+		 * Sanity checking.
+		 * TBRV: Shoud we allow to proceed if we failed to map MBAR1 ?
+		 */
+		if ((base_addr == 0) || (bar_len == 0)) { 
+			asd_log(ASD_DBG_ERROR, "Failed in getting "
+				"PCI resources.\n");
+			ASD_FREE_PREV_IO_HANDLE(asd);
+			error = -ENOMEM;
+			goto exit;
+		}
+			
+		io_handle = asd_alloc_mem(sizeof(*io_handle), GFP_KERNEL);
+		if (io_handle == NULL) {
+			asd_log(ASD_DBG_ERROR, "Out of memory resources.\n");
+			ASD_FREE_PREV_IO_HANDLE(asd);
+			error = -ENOMEM;
+			goto exit;		
+		}
+		memset(io_handle, 0x0, sizeof(*io_handle));
+		io_handle->bar_base = base_addr;	
+		io_handle->length = bar_len;
+		io_handle->index = index;
+		io_handle->type = ASD_MEMORY_SPACE;
+			
+		if (request_mem_region(base_addr, bar_len,
+				       ASD_DRIVER_NAME) == 0) {
+			asd_log(ASD_DBG_ERROR, "Failed to request region for "
+				"idx = %d, addr = 0x%x, len = 0x%x.\n",
+				index, base_addr, bar_len);
+			asd_free_mem(io_handle);		
+			ASD_FREE_PREV_IO_HANDLE(asd); 
+			error = -ENOMEM;
+			goto exit;
+		}
+		base_page = base_addr & PAGE_MASK;
+		base_offset = base_addr - base_page;
+		/*
+		 * Request the MBAR to be remapped in the non-cached region.
+		 */
+		io_handle->baseaddr.membase = ioremap_nocache(base_page,
+							      (bar_len +
+							       base_offset));
+		if (io_handle->baseaddr.membase == NULL) {
+			asd_log(ASD_DBG_ERROR, "Failed to perform ioremap "
+				"for addr = 0x%x, len = 0x%x.\n",
+				base_page, (bar_len + base_offset));
+			release_mem_region(base_addr, bar_len);
+			asd_free_mem(io_handle);
+			ASD_FREE_PREV_IO_HANDLE(asd);
+			error = -ENOMEM;
+			goto exit;
+		}	
+
+		asd->io_handle[asd->io_handle_cnt] = io_handle;		
+		asd->io_handle_cnt++;
+	}
+
+	/*
+	 * Do a simple test that the region is properly mapped.
+	 * We are going to read SCBPRO register, and check the upper 16-bits
+	 * value which represent read-only SCBCONS. 
+	 * Write any random value to SCBCONS shouldn't take any effect. 
+	 */
+#if 0
+	/* XXX At this point, we do not know if the central sequencer is
+	 *     running or not, so touching the producer index is *not*
+	 *     safe.  We should either map our sliding window before this
+	 *     test so we can pause the CSEQ or come up with a different
+	 *     register to use for this test.
+	 */
+	scb_pro = asd_read_dword(asd, SCBPRO);
+	scb_pro++;
+	scb_pro &= SCBPRO_MASK;
+	asd_write_dword(asd, SCBPRO, scb_pro);
+	if (asd_read_dword(asd, SCBPRO) == scb_pro) {
+		/* 
+		 * If both values matched, that means the SCBCONS got changed.
+		 */
+		asd_log(ASD_DBG_ERROR, "Failed in testing register mapping.\n");
+		ASD_FREE_PREV_IO_HANDLE(asd);
+		error = -ENOMEM;
+		goto exit; 
+	}	
+#endif
+	/* Reaching here means we succeed in mapping the region. */
+	error = 0;
+exit:
+	return (error);
+}
+
+/*
+ * asd_io_mapped_io_handle()
+ *
+ * Description:
+ *	Map the IO Handle using IO Mapped.
+ */
+static int
+asd_io_mapped_io_handle(struct asd_softc *asd)
+{
+	struct asd_io_handle	*io_handle;
+	int			 error;
+	uint32_t		 base_addr;
+	uint32_t		 bar_type;
+	uint32_t		 bar_len;
+	uint8_t			 index;
+
+	/*
+	 * TBRV: IOBAR of the controller is 64-bit. 
+	 *	 Linux PCI doesn't aware of 64-bit BAR.
+	 *	 For now, it is fine we just map the first 32-bit, as the upper
+	 *	 32-bit is set to 0.
+	 */
+	index = PCIC_IOBAR_OFFSET;
+			
+	/* Acquire the base addr, length of the region to be mapped. */
+	base_addr = pci_resource_start(asd_dev_to_pdev(asd->dev), index);
+	bar_type = pci_resource_flags(asd_dev_to_pdev(asd->dev), index);
+	bar_len = pci_resource_len(asd_dev_to_pdev(asd->dev), index);
+	
+	if ((base_addr == 0) || (bar_len == 0)) { 
+		asd_log(ASD_DBG_ERROR, "Failed in getting PCI resources.\n");
+	       	error = -ENOMEM;
+	       	goto exit;
+       	}
+
+       	io_handle = asd_alloc_mem(sizeof(*io_handle), GFP_KERNEL);
+       	if (io_handle == NULL) {
+       		asd_log(ASD_DBG_ERROR, "Out of memory resources.\n");
+       		error = -ENOMEM;
+       		goto exit;		
+       	}
+	memset(io_handle, 0x0, sizeof(*io_handle));	
+	io_handle->baseaddr.iobase = base_addr;		
+       	io_handle->length = bar_len;
+       	io_handle->index = index;
+       	io_handle->type = ASD_IO_SPACE;
+
+ 	if (request_region(base_addr, bar_len, ASD_DRIVER_NAME) == 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to request region for "
+			"idx = %d, addr = 0x%x, len = 0x%x.\n",
+			index, base_addr, bar_len);
+		asd_free_mem(io_handle);	 
+		error = -ENOMEM;
+		goto exit;
+       	}	 
+	
+	/* Reaching here means we succeed in mapping the region. */
+	asd->io_handle[asd->io_handle_cnt] = io_handle;
+	asd->io_handle_cnt++;	 	 
+	error = 0;
+exit:
+	return (error);	
+}
+
+/*
+ * asd_isr()
+ *
+ * Description:
+ *	This is the interrupt handler. Check if we have any interrupt pending.
+ *	If there is, process it. Otherwise, just return.
+ */
+irqreturn_t
+asd_isr(int  irq, void  *dev_id, struct pt_regs  *regs)
+{
+	struct asd_softc	*asd;
+	unsigned long		 flags;
+	int			 irq_retval;
+
+	asd = (struct asd_softc *) dev_id;
+
+	asd_lock(asd, &flags);
+
+	irq_retval = asd_hwi_process_irq(asd);
+
+	if (asd_next_device_to_run(asd) != NULL)
+		asd_schedule_runq(asd);
+
+	asd_unlock(asd, &flags);
+	
+	return IRQ_RETVAL(irq_retval);
+}
+
+/*
+ * asd_queue()
+ *
+ * Description:
+ *	Execute the requested IO.
+ */
+static int
+asd_queue(Scsi_Cmnd  *cmd, void (*scsi_done)(Scsi_Cmnd *))
+{
+	struct asd_softc	*asd;
+	struct asd_device	*dev;
+
+	asd = *((struct asd_softc **) cmd->device->host->hostdata);
+
+	/*
+	 * Save the callback on completion function.
+	 */
+	cmd->scsi_done = scsi_done;
+	asd_sml_lock(asd);
+
+	/*
+	 * Close the race of a command that was in the process of
+	 * being queued to us just as our controller was frozen.
+	 */
+	if (asd->platform_data->qfrozen != 0) {
+		asd_sml_unlock(asd);
+		asd_cmd_set_retry_status(cmd);
+		cmd->scsi_done(cmd);
+		return (0);
+	}
+
+	dev = asd_get_device(asd, cmd->device->channel, cmd->device->id,
+			     cmd->device->lun, /*alloc*/1);
+	if (dev == NULL) {
+		asd_sml_unlock(asd);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+		asd_cmd_set_host_status(cmd, DID_NO_CONNECT);
+#else
+		asd_cmd_set_offline_status(cmd);
+#endif
+		cmd->scsi_done(cmd);
+		return (0);
+	} else if (((dev->flags & ASD_DEV_UNCONFIGURED) != 0) && 
+		   (cmd->device->type != -1)) {
+		/*
+		 * Configure devices that have already successfully
+		 * completed an inquiry. This handles the case of
+		 * devices being destroyed due to transient selection
+		 * timeouts.
+		 */
+		dev->flags &= ~ASD_DEV_UNCONFIGURED;
+	 	dev->scsi_device = cmd->device;
+		asd_set_device_queue_depth(asd, dev);
+	} else {
+		/*
+		 * The target is in the process of being destroyed as
+		 * it had been hot-removed. Return the IO back to the
+		 * scsi layer.
+		 */
+		if (dev->target->flags & ASD_TARG_HOT_REMOVED) {
+			asd_sml_unlock(asd);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+			asd_cmd_set_host_status(cmd, DID_NO_CONNECT);
+#else
+			asd_cmd_set_offline_status(cmd);
+#endif
+			cmd->scsi_done(cmd);
+			return (0);
+		}
+	}
+
+	/*
+	 * DC: Need extra storage for SSP_LONG tasks to hold the CDB.
+	 *     For now, just limit the CDB to what we can embed in the SCB.
+ 	 */
+	if (cmd->cmd_len > SCB_EMBEDDED_CDB_SIZE) {
+		asd_cmd_set_host_status(cmd, DID_BAD_TARGET);
+		asd_sml_unlock(asd);
+		cmd->scsi_done(cmd);
+		asd_print("%s: asd94xx_queue -"
+			  "CDB length of %d exceeds max!\n",
+			  asd_name(asd), cmd->cmd_len);
+		return (0);
+	}
+
+#ifdef ASD_EH_SIMULATION	
+	++cmd_cnt;
+	if ((cmd_cnt != 0) && ((cmd_cnt % 888) == 0x0)) {
+		asd_print("Setting up cmd %p for eh simulation.\n", cmd);
+		asd_cmd_set_host_status(cmd, 0x88);
+	} else {
+		asd_cmd_set_host_status(cmd, CMD_REQ_INPROG);
+	}
+#else
+	/*
+	 * Workaround for some kernel versions, when the cmd is retried but
+         * the cmd->result is not clear.
+	 */
+	cmd->result = 0;
+	asd_cmd_set_host_status(cmd, CMD_REQ_INPROG);
+#endif /* ASD_EH_SIMULATION */ 	
+
+	list_add_tail(&((union asd_cmd *)cmd)->acmd_links, &dev->busyq);
+	if ((dev->flags & ASD_DEV_ON_RUN_LIST) == 0) {
+		list_add_tail(&dev->links, &asd->platform_data->device_runq);
+		dev->flags |= ASD_DEV_ON_RUN_LIST;
+		asd_run_device_queues(asd);
+	}
+
+	asd_sml_unlock(asd);
+	return (0);
+} 
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+/*
+ * asd_select_queue_depth()
+ *
+ * Description:
+ *	Adjust the queue depth for each device attached to our controller.
+ */
+static void
+asd_select_queue_depth(struct Scsi_Host *host, Scsi_Device *scsi_devs)
+{
+	struct asd_softc	*asd;
+	Scsi_Device 		*device;
+	Scsi_Device 		*ldev;
+	u_long			 flags;
+
+	asd = *((struct asd_softc **)host->hostdata);
+	asd_lock(asd, &flags);
+	for (device = scsi_devs; device != NULL; device = device->next) {
+		/*
+		 * Watch out for duplicate devices.  This works around
+		 * some quirks in how the SCSI scanning code does its
+		 * device management.
+		 */
+		for (ldev = scsi_devs; ldev != device; ldev = ldev->next) {
+			if (ldev->host == device->host
+			 && ldev->channel == device->channel
+			 && ldev->id == device->id
+			 && ldev->lun == device->lun)
+				break;
+		}
+		/* Skip duplicate. */
+		if (ldev != device)
+			continue;
+
+		if (device->host == host) {
+			struct asd_device *dev;
+
+			/*
+			 * Since Linux has attached to the device, configure
+			 * it so we don't free and allocate the device
+			 * structure on every command.
+			 */
+			dev = asd_get_device(asd, device->channel,
+					     device->id, device->lun,
+					     /*alloc*/1);
+			if (dev != NULL) {
+				dev->flags &= ~ASD_DEV_UNCONFIGURED;
+				dev->scsi_device = device;
+				asd_set_device_queue_depth(asd, dev);
+				device->queue_depth = dev->openings + 
+						      dev->active;
+				if ((dev->flags & (ASD_DEV_Q_BASIC | 
+						   ASD_DEV_Q_TAGGED)) == 0) {
+					/*
+					 * We allow the OS to queue 2 untagged
+					 * transactions to us at any time even
+					 * though we can only execute them
+					 * serially on the controller/device.
+					 * This should remove some latency.
+					 */
+					device->queue_depth = 2;
+				}
+			}
+		}
+	}
+	asd_unlock(asd, &flags);
+}
+
+#else
+
+static int
+asd_slave_alloc(Scsi_Device *scsi_devs)
+{
+	struct asd_softc *asd;
+
+	asd = *((struct asd_softc **) scsi_devs->host->hostdata);
+	asd_log(ASD_DBG_INFO, "%s: Slave Alloc %d %d %d\n", asd_name(asd),
+		scsi_devs->channel, scsi_devs->id, scsi_devs->lun);
+
+	return (0);	
+}
+	
+static int
+asd_slave_configure(Scsi_Device *scsi_devs)
+{
+	struct asd_softc 	*asd;
+	struct asd_device	*dev;
+	u_long			 flags;	
+
+	asd = *((struct asd_softc **) scsi_devs->host->hostdata);
+	asd_log(ASD_DBG_INFO, "%s: Slave Configure %d %d %d\n", asd_name(asd),
+		scsi_devs->channel, scsi_devs->id, scsi_devs->lun);
+
+	asd_lock(asd, &flags);
+	/*
+	 * Since Linux has attached to the device, configure it so we don't 
+	 * free and allocate the device structure on every command.
+	 */
+	dev = asd_get_device(asd, scsi_devs->channel, scsi_devs->id, 
+			     scsi_devs->lun, /*alloc*/1);
+	if (dev != NULL) {
+		dev->flags &= ~ASD_DEV_UNCONFIGURED;
+		dev->flags |= ASD_DEV_SLAVE_CONFIGURED;
+		dev->scsi_device = scsi_devs;
+		asd_set_device_queue_depth(asd, dev);
+	}
+	asd_unlock(asd, &flags);
+
+	return (0);
+}
+
+static void
+asd_slave_destroy(Scsi_Device *scsi_devs)
+{
+	struct asd_softc 	*asd;
+	struct asd_device 	*dev;
+	u_long			 flags;	
+
+	asd = *((struct asd_softc **) scsi_devs->host->hostdata);
+	asd_log(ASD_DBG_INFO, "%s: Slave Destroy %d %d %d\n", asd_name(asd),
+		scsi_devs->channel, scsi_devs->id, scsi_devs->lun);
+
+	asd_lock(asd, &flags);
+
+	dev = asd_get_device(asd, scsi_devs->channel, scsi_devs->id, 
+			     scsi_devs->lun, /*alloc*/0);
+
+	if (dev == NULL) {
+		asd_unlock(asd, &flags);
+		return;
+	}
+
+	if ((dev->flags & ASD_DEV_SLAVE_CONFIGURED) != 0) {
+		if ((list_empty(&dev->busyq)) && (dev->active == 0) &&
+		   ((dev->flags & ASD_DEV_TIMER_ACTIVE) == 0)) {
+			if (dev->target->refcount == 1) {
+				if( dev->target->flags & ASD_TARG_HOT_REMOVED) {
+					asd_free_ddb(
+						asd,
+						dev->target->ddb_profile.conn_handle);
+					/* Free the allocated device. */
+					asd_free_device(asd, dev);
+				} else {
+					dev->flags |= ASD_DEV_UNCONFIGURED;
+					dev->flags &= ~ASD_DEV_SLAVE_CONFIGURED;
+					dev->scsi_device = NULL;
+				}
+			}
+		}
+	}
+
+	asd_unlock(asd, &flags);
+}
+
+static int
+asd_initiate_bus_scan(struct asd_softc *asd)
+{
+	int	error;
+
+	error = scsi_add_host(asd->platform_data->scsi_host, asd->dev);
+	if (error != 0)	
+		return (error);
+		
+	scsi_scan_host(asd->platform_data->scsi_host);
+	return (0);
+}
+
+#endif
+
+/*
+ * Return the disk geometry for the given SCSI device.
+ */
+static int
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+asd_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+	       sector_t capacity, int geom[])
+{
+#else
+asd_bios_param(Disk *disk, kdev_t dev, int geom[])
+{
+	u_long			 capacity = disk->capacity;
+#endif
+	int	 heads;
+	int	 sectors;
+	int	 cylinders;
+
+	heads = 64;
+	sectors = 32;
+	cylinders = asd_sector_div(capacity, heads, sectors);
+	
+	if (cylinders >= 1024) {
+		heads = 255;
+		sectors = 63;
+		cylinders = asd_sector_div(capacity, heads, sectors);
+	}
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = cylinders;
+
+	return (0);
+}
+
+
+/*
+ * Function:
+ *	asd_get_user_tagdepth()
+ *	
+ * Description:
+ *	Return the user specified device queue depth.
+ * 	If none specified, return a default queue depth.
+ */
+static u_int
+asd_get_user_tagdepth(struct asd_softc *asd, struct asd_device *dev)
+{
+	/*
+	 * No queuing support yet for SATA II devices.
+ 	 */
+	if ((dev->target->command_set_type == ASD_COMMAND_SET_ATA) ||
+	    (dev->target->command_set_type == ASD_COMMAND_SET_ATAPI))
+		return 0;
+
+	if (cmd_per_lun < ASD_MIN_TCQ_PER_DEVICE ||
+	    cmd_per_lun > ASD_MAX_TCQ_PER_DEVICE) {
+		asd_print(ASD_DRIVER_NAME": cmd_per_lun:%d out of range, "
+			  "setting default:%d\n",
+			  cmd_per_lun, ASD_DEF_TCQ_PER_DEVICE);
+		cmd_per_lun = ASD_DEF_TCQ_PER_DEVICE;
+	}	
+
+	return cmd_per_lun;
+}
+
+/*
+ * Function:
+ *	asd_set_device_queue_depth()
+ *
+ * Description: 	  
+ * 	Determines the queue depth for a given device.
+ */
+static void
+asd_set_device_queue_depth(struct asd_softc *asd, struct asd_device *dev)
+{
+	u_int	tags;
+
+	ASD_LOCK_ASSERT(asd);
+
+	tags = asd_get_user_tagdepth(asd, dev);
+	if (tags != 0 && dev->scsi_device != NULL && 
+	    dev->scsi_device->tagged_supported != 0) {
+		asd_set_tags(asd, dev, ASD_QUEUE_TAGGED);
+
+		asd_print("(%s:%d:%d:%d): Tagged Queuing enabled.  Depth %d\n",
+			  asd_name(asd),
+			  dev->target->domain->channel_mapping,
+			  dev->target->target, dev->lun,
+			  dev->openings + dev->active);
+	} else {
+		asd_set_tags(asd, dev, ASD_QUEUE_NONE);
+	}
+}
+
+/*
+ * Function:
+ *	asd_set_tags()
+ *
+ * Description: 	  
+ * 	Set the device queue depth.
+ */
+static void
+asd_set_tags(struct asd_softc *asd, struct asd_device *dev, asd_queue_alg alg)
+{
+	int was_queuing;
+	int now_queuing;
+
+	was_queuing = dev->flags & (ASD_DEV_Q_BASIC|ASD_DEV_Q_TAGGED);
+	switch (alg) {
+	default:
+	case ASD_QUEUE_NONE:
+		now_queuing = 0;
+		break; 
+	case ASD_QUEUE_BASIC:
+		now_queuing = ASD_DEV_Q_BASIC;
+		break;
+	case ASD_QUEUE_TAGGED:
+		now_queuing = ASD_DEV_Q_TAGGED;
+		break;
+	}
+
+	dev->flags &= ~(ASD_DEV_Q_BASIC|ASD_DEV_Q_TAGGED);
+	if (now_queuing) {
+		u_int usertags;
+
+		usertags = asd_get_user_tagdepth(asd, dev);
+		if (!was_queuing) {
+			/*
+			 * Start out agressively and allow our
+			 * dynamic queue depth algorithm to take
+			 * care of the rest.
+			 */
+			dev->maxtags = usertags;
+			dev->openings = dev->maxtags - dev->active;
+		}
+		if (dev->maxtags == 0)
+			/*
+			 * Queueing is disabled by the user.
+			 */
+			dev->openings = 1;
+		else if (alg == ASD_QUEUE_TAGGED)
+			dev->flags |= ASD_DEV_Q_TAGGED;
+		else
+			dev->flags |= ASD_DEV_Q_BASIC;
+	} else {
+		/* We can only have one opening. */
+		dev->maxtags = 0;
+		dev->openings =  1 - dev->active;
+	}
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	if (dev->scsi_device != NULL) {
+		switch ((dev->flags & (ASD_DEV_Q_BASIC|ASD_DEV_Q_TAGGED))) {
+		case ASD_DEV_Q_BASIC:
+			scsi_adjust_queue_depth(dev->scsi_device,
+						MSG_SIMPLE_TAG,
+						dev->maxtags);
+			break;
+		case ASD_DEV_Q_TAGGED:
+			scsi_adjust_queue_depth(dev->scsi_device,
+						MSG_ORDERED_TAG,
+						dev->maxtags);
+			break;
+		default:
+			/*
+			 * We allow the OS to queue 2 untagged transactions to
+			 * us at any time even though we can only execute them
+			 * serially on the controller/device.  This should
+			 * remove some latency.
+			 */
+			scsi_adjust_queue_depth(dev->scsi_device,
+						/* NON-TAGGED */ 0,
+						/* Queue Depth */ 2);
+			break;
+		}
+	}
+#endif
+}
+
+		       
+/*
+ * asd_info()
+ *
+ * Description:
+ *	Return an info regarding the driver to the OS.
+ */
+static const char *
+asd_info(struct Scsi_Host  *scsi_host)
+{
+	struct asd_softc	*asd;
+	const char		*info;
+	
+	info = "";
+	asd = *((struct asd_softc **) scsi_host->hostdata);
+		
+	if (asd_get_softc(asd) != NULL) {
+		info = ((struct asd_pci_driver_data *) 
+				(asd->pci_entry->driver_data))->description;
+	}
+
+	return (info);
+}
+
+
+/**************************** OS Error Handling *******************************/
+
+/*
+ * Function:
+ *	asd_ehandler_thread()
+ *
+ * Description:
+ *	Thread to handle error recovery.
+ */ 
+static int
+asd_ehandler_thread(void *data)
+{
+	struct asd_softc	*asd;
+	u_long			 flags;	
+
+	asd = (struct asd_softc *) data;
+
+	lock_kernel();
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
+	/*
+	 * Don't care about any signals.
+	 */
+	siginitsetinv(&current->blocked, 0);
+	daemonize();
+	sprintf(current->comm, "asd_eh_%d", asd->profile.unit);
+#else
+	daemonize("asd_eh_%d", asd->profile.unit);
+	current->flags |= PF_FREEZE;	
+#endif
+	unlock_kernel();
+
+	while (1) {
+		/*
+		 * Use down_interruptible() rather than down() to
+		 * avoid this thread to be counted in the load average as
+		 * a running process.
+		 */
+		down_interruptible(&asd->platform_data->ehandler_sem);
+
+		/* Check to see if we've been signaled to exit. */
+		asd_lock(asd, &flags);
+		if ((asd->platform_data->flags & ASD_RECOVERY_SHUTDOWN) != 0) {
+			asd_unlock(asd, &flags);
+			break;
+		}
+		/* 
+		 * Check if any timedout commands that required 
+		 * error handling. 
+		 */
+		if (list_empty(&asd->timedout_scbs)) {
+			asd_unlock(asd, &flags);
+			continue;
+		}
+		asd_unlock(asd, &flags);
+
+		asd_recover_cmds(asd);
+	}
+
+	up(&asd->platform_data->ehandler_ending_sem);
+
+	return (0);
+}
+
+/*
+ * Function:
+ * 	asd_kill_ehandler_thread()
+ * 
+ * Description:
+ * 	Kill the error handling thread.
+ */
+static void
+asd_kill_ehandler_thread(struct asd_softc *asd)
+{
+	u_long	flags;
+
+	asd_lock(asd, &flags);
+
+	if (asd->platform_data->ehandler_pid != 0) {
+		asd->platform_data->flags |= ASD_RECOVERY_SHUTDOWN;
+		asd_unlock(asd, &flags);
+		up(&asd->platform_data->ehandler_sem);
+		asd->platform_data->ehandler_pid = 0;
+	} else {
+		asd_unlock(asd, &flags);
+	}
+}
+
+static void
+asd_ehandler_done(struct asd_softc *asd, struct scb *scb)
+{
+	scb->platform_data->flags &= ~ASD_SCB_UP_EH_SEM;
+	asd_wakeup_sem(&asd->platform_data->eh_sem);
+}
+
+/*
+ * asd_abort()
+ *
+ * Description:
+ *	Perform abort for the requested command.
+ */
+static int
+asd_abort(Scsi_Cmnd *cmd)
+{
+	struct asd_softc	*asd;
+	struct asd_device	*dev;
+	struct scb		*scb_to_abort;
+	union asd_cmd 		*acmd;
+	union asd_cmd 		*list_acmd;
+	int			 retval;
+	int			 found;
+
+	asd_print("(scsi%d: Ch %d Id %d Lun %d): ",
+		  cmd->device->host->host_no,
+		  cmd->device->channel, cmd->device->id, cmd->device->lun);
+	asd_print("Abort requested for SCSI cmd %p, opcode 0x%x.\n", cmd,
+		  cmd->cmnd[0]);
+
+	asd = *(struct asd_softc **) cmd->device->host->hostdata;
+	acmd = (union asd_cmd *) cmd;
+	found = 0;
+	retval = SUCCESS;
+
+	asd_sml_lock(asd);
+
+	/* See if any existing device owns this command. */
+	dev = asd_get_device(asd, cmd->device->channel,
+			     cmd->device->id, cmd->device->lun, 0);
+	if (dev == NULL) {
+		/*
+		 * No device exists that owns this command. 
+		 * Return abort successful for the requested command.
+		 */
+		asd_print("(scsi%d: Ch %d Id %d Lun %d): ",
+			  cmd->device->host->host_no, cmd->device->channel, 
+			  cmd->device->id, cmd->device->lun);
+		asd_print("Is not an active device.\n");
+		retval = SUCCESS;
+		goto exit;
+	}
+
+#ifdef ASD_DEBUG	
+	{
+		struct asd_target *t = NULL;
+#ifdef MULTIPATH_IO
+		t = dev->current_target;
+#else
+		t = dev->target;
+#endif
+		if (!t)
+			t = dev->target;
+
+		asd_hwi_dump_seq_state(asd, t->src_port->conn_mask);
+		asd_hwi_dump_ddb_site(asd, t->ddb_profile.conn_handle);
+	}
+#endif /* ASD_DEBUG */
+
+	/*
+	 * Check if the cmd is still in the device queue.
+	 */ 
+	list_for_each_entry(list_acmd, &dev->busyq, acmd_links) {
+		if (list_acmd == acmd) {
+			/* Found it. */
+			found = 1;
+			break;
+		}
+	}
+	if (found == 1) {
+		asd_print_path(asd, dev);
+		asd_print("Cmd %p found on device queue.\n", cmd);
+		list_del(&list_acmd->acmd_links);
+		asd_cmd_set_host_status(cmd, DID_ABORT);
+		cmd->scsi_done(cmd);
+		retval = SUCCESS;
+		goto exit;
+	}
+
+	/*
+	 * Check if the cmd has been submitted to the device.
+	 */
+	list_for_each_entry(scb_to_abort, &asd->platform_data->pending_os_scbs,
+			    owner_links) {
+		if (scb_to_abort->io_ctx == acmd) {
+			/* Found it. */
+			found = 1;
+			break;
+		}
+	}
+	if (found != 1) {
+		/*
+		 * Looks like we are trying to abort command that has
+		 * been completed.
+		 */
+		asd_print_path(asd, dev);
+		asd_print("Cmd %p not found.\n", cmd);
+		retval = SUCCESS;
+		goto exit;
+	}
+
+	/*
+	 * Set the level of error recovery for the error handler thread
+         * to perform.
+	 */
+	scb_to_abort->eh_state = SCB_EH_ABORT_REQ;
+	scb_to_abort->eh_post = asd_ehandler_done;
+	/*
+	 * Mark this SCB as timedout and add it to the timeout queue.
+	 */	 
+	scb_to_abort->flags |= SCB_TIMEDOUT;
+	list_add_tail(&scb_to_abort->timedout_links, &asd->timedout_scbs);
+	
+	asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+	asd->platform_data->flags |= ASD_SCB_UP_EH_SEM;
+
+	/* Release the host's lock prior putting the process to sleep. */
+	spin_unlock_irq(&asd->platform_data->spinlock);
+	
+	asd_sleep_sem(&asd->platform_data->eh_sem);
+
+	retval = (scb_to_abort->eh_status == SCB_EH_SUCCEED) ? SUCCESS : FAILED;
+
+	/* Acquire the host's lock. */
+	spin_lock_irq(&asd->platform_data->spinlock);
+	
+exit:
+	asd_sml_unlock(asd);
+	return (retval);
+}
+
+/******************************** Bus DMA *************************************/
+
+int
+asd_dma_tag_create(struct asd_softc *asd, uint32_t alignment, uint32_t maxsize,
+		   int flags, bus_dma_tag_t *ret_tag)
+{
+	bus_dma_tag_t dmat;
+
+	dmat = asd_alloc_mem(sizeof(*dmat), flags);
+	if (dmat == NULL)
+		return (-ENOMEM);
+
+	dmat->alignment = alignment;
+	dmat->maxsize = maxsize;
+	*ret_tag = dmat;
+	return (0);
+}
+
+void
+asd_dma_tag_destroy(struct asd_softc *asd, bus_dma_tag_t dmat)
+{
+	asd_free_mem(dmat);
+}
+
+int
+asd_dmamem_alloc(struct asd_softc *asd, bus_dma_tag_t dmat, void** vaddr,
+		 int flags, bus_dmamap_t *mapp, dma_addr_t *baddr)
+{
+	bus_dmamap_t map;
+
+	map = asd_alloc_mem(sizeof(*map), flags);
+	if (map == NULL)
+		return (-ENOMEM);
+
+	*vaddr = asd_alloc_coherent(asd, dmat->maxsize, &map->bus_addr);
+	if (*vaddr == NULL) {
+		asd_free_mem(map);
+		return (-ENOMEM);
+	}
+	*mapp = map;
+	*baddr = map->bus_addr;
+	return(0);
+}
+
+void
+asd_dmamem_free(struct asd_softc *asd, bus_dma_tag_t dmat, void *vaddr,
+		bus_dmamap_t map)
+{
+	asd_free_coherent(asd, dmat->maxsize, vaddr, map->bus_addr);
+}
+
+void
+asd_dmamap_destroy(struct asd_softc *asd, bus_dma_tag_t dmat, bus_dmamap_t map)
+{
+	asd_free_mem(map);
+}
+
+int
+asd_alloc_dma_mem(struct asd_softc *asd, unsigned length, void **vaddr,
+		  dma_addr_t *bus_addr, bus_dma_tag_t *buf_dmat,
+		  struct map_node *buf_map)
+{
+	if (asd_dma_tag_create(asd, 4, length, GFP_ATOMIC, buf_dmat) != 0)
+		return (-ENOMEM);
+
+	if (asd_dmamem_alloc(asd, *buf_dmat, (void **) &buf_map->vaddr,
+			     GFP_ATOMIC, &buf_map->dmamap,
+			     &buf_map->busaddr) != 0) {
+		asd_dma_tag_destroy(asd, *buf_dmat);
+		return (-ENOMEM);
+	}
+
+	*vaddr = (void *) buf_map->vaddr;
+	*bus_addr = buf_map->busaddr;
+	memset(*vaddr, 0, length);
+
+	return 0;
+}
+
+void
+asd_free_dma_mem(struct asd_softc *asd, bus_dma_tag_t buf_dmat,
+		 struct map_node *buf_map)
+{
+	asd_dmamem_free(asd, buf_dmat, buf_map->vaddr, buf_map->dmamap);
+	asd_dmamap_destroy(asd, buf_dmat, buf_map->dmamap);
+	asd_dma_tag_destroy(asd, buf_dmat);
+}
+
+/*************************** Platform Data Routines ***************************/
+
+struct asd_scb_platform_data *
+asd_alloc_scb_platform_data(struct asd_softc *asd)
+{
+	struct asd_scb_platform_data *pdata;
+	
+	pdata = (struct asd_scb_platform_data *) asd_alloc_mem(sizeof(*pdata),
+							       GFP_ATOMIC);
+	return (pdata);
+}
+
+void
+asd_free_scb_platform_data(struct asd_softc *asd,
+			   struct asd_scb_platform_data *pdata)
+{
+	asd_free_mem(pdata);
+}
+
+
+/**************************** Proc Filesystem support *************************/
+
+typedef struct proc_info_str {
+	char	*buf;
+	int	len;
+	off_t	off;
+	int	pos;
+} proc_info_str_t;
+
+static void	copy_mem_info(proc_info_str_t *info_str, char *data, int len);
+static int	copy_info(proc_info_str_t *info_str, char *fmt, ...);
+
+static void
+copy_mem_info(proc_info_str_t *info_str, char *data, int len)
+{
+	if (info_str->pos + len > info_str->off + info_str->len)
+		len = info_str->off + info_str->len - info_str->pos;
+
+	if (info_str->pos + len < info_str->off) {
+		info_str->pos += len;
+		return;
+	}
+
+	if (info_str->pos < info_str->off) {
+		off_t partial;
+
+		partial = info_str->off - info_str->pos;
+		data += partial;
+		info_str->pos += partial;
+		len  -= partial;
+	}
+
+	if (len > 0) {
+		memcpy(info_str->buf, data, len);
+		info_str->pos += len;
+		info_str->buf += len;
+	}
+}
+
+static int
+copy_info(proc_info_str_t *info_str, char *fmt, ...)
+{
+	va_list	args;
+	char 	buf[256];
+	int 	len;
+
+	va_start(args, fmt);
+	len = vsprintf(buf, fmt, args);
+	va_end(args);
+
+	copy_mem_info(info_str, buf, len);
+	return (len);
+}
+
+void
+asd_dump_indent(
+proc_info_str_t	*info_str,
+unsigned	indent
+)
+{
+	unsigned		i;
+
+	for (i = 0 ; i < indent ; i++) {
+		copy_info(info_str, "   ");
+	}
+}
+
+void
+asd_dump_conn_rate(
+proc_info_str_t	*info_str,
+unsigned	conn_rate
+)
+{
+	switch (conn_rate) {
+	case SAS_RATE_30GBPS:
+		copy_info(info_str, "3000 Mb/s");
+		break;
+	case SAS_RATE_15GBPS:
+		copy_info(info_str, "1500 MB/s");
+		break;
+	default:
+		copy_info(info_str, "\?\? MB/s");
+		break;
+	}
+}
+
+static void
+asd_dump_target_info(struct asd_softc *asd, proc_info_str_t *info_str,
+	struct asd_port *port, struct asd_target *targ, unsigned indent)
+{
+	unsigned		i;
+	struct Discover		*discover;
+	struct asd_target	*child_target;
+	struct hd_driveid	*hd_driveidp;
+
+	asd_dump_indent(info_str, indent);
+
+	copy_info(info_str, "  Connected to ");
+	switch (targ->transport_type) {
+	case ASD_TRANSPORT_SSP:
+		copy_info(info_str, "SAS End Device. ");	
+		copy_info(info_str, "SAS Address: %0llx\n", asd_be64toh(
+			  *((uint64_t *)targ->ddb_profile.sas_addr)));
+
+		asd_dump_indent(info_str, indent);
+		if (targ->scsi_cmdset.inquiry != NULL) {
+			copy_info(info_str,
+				"  Vendor: %8.8s Product: %16.16s "
+				"Revision: %4.4s\n",
+				&targ->scsi_cmdset.inquiry[8],
+				&targ->scsi_cmdset.inquiry[16],
+				&targ->scsi_cmdset.inquiry[32]);
+		}
+		break;
+
+	case ASD_TRANSPORT_STP:
+	case ASD_TRANSPORT_ATA:
+		hd_driveidp = &targ->ata_cmdset.adp_hd_driveid;
+		copy_info(info_str, "SATA End Device. ");
+		copy_info(info_str, "Mapped SAS Address: %0llx\n", asd_be64toh(
+			  *((uint64_t *)targ->ddb_profile.sas_addr)));
+		asd_dump_indent(info_str, indent);
+		copy_info(info_str,
+			"  Vendor: %8.8s Product: %16.16s "
+			"Revision: %4.4s\n",
+			hd_driveidp->model,
+			hd_driveidp->model + 8,
+			hd_driveidp->fw_rev);
+		break;
+
+	case ASD_TRANSPORT_SMP:
+		switch (targ->management_type)
+		{
+		case ASD_DEVICE_EDGE_EXPANDER:
+			copy_info(info_str, "Edge Expander Device. ");
+			copy_info(info_str, "SAS Address: %0llx\n", asd_be64toh(
+				  *((uint64_t *)targ->ddb_profile.sas_addr)));
+			break;
+
+		case ASD_DEVICE_FANOUT_EXPANDER:
+			copy_info(info_str, "Fanout Expander Device. ");
+			copy_info(info_str, "SAS Address: %0llx\n", asd_be64toh(
+				  *((uint64_t *)targ->ddb_profile.sas_addr)));
+			break;
+
+		default:
+			copy_info(info_str, "Unknown Device.");
+			break;
+		}
+
+		asd_dump_indent(info_str, indent);
+		copy_info(info_str,
+			"  Vendor: %8.8s Product: %16.16s Revision: %4.4s - ",
+			targ->smp_cmdset.manufacturer_info.VendorIdentification,
+			targ->smp_cmdset.manufacturer_info.
+				ProductIdentification,
+			targ->smp_cmdset.manufacturer_info.	
+				ProductRevisionLevel);
+		break;
+
+	default:
+		copy_info(info_str, "Unknown Device.");
+		break;
+	}
+
+	if (targ->management_type == ASD_DEVICE_END) {
+		return;
+	}
+
+	copy_info(info_str, "Total Phys: %d\n", targ->num_phys);
+
+	asd_dump_indent(info_str, indent);
+
+	copy_info(info_str, "  Routing: ");
+
+	discover = NULL;
+
+	for (i = 0 ; i < targ->num_phys ; i++) {
+
+		discover = &(targ->Phy[i].Result);
+
+		switch (discover->RoutingAttribute) {
+		case DIRECT:
+			copy_info(info_str, "%d:D", i);
+			break;
+		case SUBTRACTIVE:
+			copy_info(info_str, "%d:S", i);
+			break;
+		case TABLE:
+			copy_info(info_str, "%d:T", i);
+			break;
+		default:
+			copy_info(info_str, "%d:?", i);
+			break;
+		}
+
+		if (i != (targ->num_phys - 1)) {
+			copy_info(info_str, "|");
+		}
+	}
+
+	copy_info(info_str, "\n");
+
+	indent++;
+
+	list_for_each_entry(child_target, &targ->children, siblings) {
+
+		for (i = 0 ; i < targ->num_phys ; i++) {
+
+			discover = &(targ->Phy[i].Result);
+
+			if (SAS_ISEQUAL(child_target->ddb_profile.sas_addr,
+				discover->AttachedSASAddress)) {
+				break;
+			}
+		}
+
+		if (i == targ->num_phys) {
+			continue;
+		}
+
+		asd_dump_indent(info_str, indent);
+
+		copy_info(info_str, "+ Phy %d ", i);
+		copy_info(info_str, "link rate negotiated: ");
+
+		asd_dump_conn_rate(info_str,
+			discover->NegotiatedPhysicalLinkRate);
+
+		copy_info(info_str, " max: ");
+
+		asd_dump_conn_rate(info_str,
+			discover->HardwareMaximumPhysicalLinkRate);
+
+		copy_info(info_str, " min: ");
+
+		asd_dump_conn_rate(info_str,
+			discover->HardwareMinimumPhysicalLinkRate);
+
+		copy_info(info_str, "\n");
+
+		asd_dump_target_info(asd, info_str, port, child_target, 
+			indent);
+	}
+}
+	
+static void
+asd_dump_port_info(struct asd_softc *asd, proc_info_str_t *info_str, 
+		   int port_id)
+{
+	struct asd_port		*port;
+	struct asd_phy		*phy;
+
+	port = asd->port_list[port_id];
+	
+	copy_info(info_str, "Port %d Settings\n", port_id);
+	if (!list_empty(&port->phys_attached)) {
+		/* Dump out info for every phy connected to this port. */
+		list_for_each_entry(phy, &port->phys_attached, links) {
+			asd_dump_indent(info_str, 1);
+			copy_info(info_str, "+ Phy %d link rate "
+				  "negotiated: %d Mb/s "
+				  "max: %d Mb/s min %d Mb/s\n", 
+				  phy->id, (phy->conn_rate / 100000), 
+				  (phy->max_link_rate / 100000),
+				  (phy->min_link_rate / 100000));
+			asd_dump_indent(info_str, 1);
+			copy_info(info_str, "  Phy SAS Addrress: %0llx\n", 
+				  asd_be64toh(*((uint64_t *)
+					      phy->sas_addr)));
+		}
+
+		if (port->tree_root != NULL) {
+
+			asd_dump_target_info(asd, info_str, port, 
+				port->tree_root, 1);
+		}
+		else {
+			copy_info(info_str, "\n");
+		}
+	} else {
+		copy_info(info_str, "\n");
+	}
+	
+	copy_info(info_str, "\n");
+}
+
+/*
+ * asd_proc_info()
+ *
+ * Description:
+ *	Entry point for read and write operations to our driver node in the 
+ *	procfs filesystem.
+ */
+static int
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+asd_proc_info(char *proc_buffer, char **proc_start, off_t proc_offset,
+	     int proc_length, int proc_hostno, int proc_out)
+#else
+asd_proc_info(struct Scsi_Host *scsi_host, char *proc_buffer, char **proc_start,
+	     off_t proc_offset, int proc_length, int proc_out)
+#endif
+{
+	struct asd_softc  	*asd;
+	proc_info_str_t		 info_str;
+	int			 retval;
+	int			 len;
+	int			 i;
+	
+	retval = -ENOSYS;
+	len = 0;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+	list_for_each_entry(asd, &asd_hbas, link) {
+		if (asd->platform_data->scsi_host->host_no == proc_hostno)
+			break;
+	}
+#else
+	asd = asd_get_softc(*(struct asd_softc **) scsi_host->hostdata);
+#endif
+	if (asd == NULL)
+		goto exit;
+	
+	if (proc_out) {
+		/* 
+		 * No support for write yet.
+		 */
+		retval = len;
+	      	goto exit;
+     	}
+
+	*proc_start = proc_buffer;
+
+	info_str.buf = proc_buffer;
+	info_str.len = proc_length;
+	info_str.off = proc_offset;	
+	info_str.pos = 0;	
+
+	copy_info(&info_str, "\nAdaptec Linux SAS/SATA Family Driver\n");
+	copy_info(&info_str, "Rev: %s\n", asd_driver_version);
+	copy_info(&info_str, "Controller WWN: %0llx\n",
+		  asd_be64toh(*((uint64_t *) asd->hw_profile.wwn)));
+	copy_info(&info_str, "\n");
+	
+	for (i = 0; i < asd->hw_profile.max_ports; i++)
+		asd_dump_port_info(asd, &info_str, i);		
+		
+	copy_info(&info_str, "\n");
+
+	retval = info_str.pos > info_str.off ? info_str.pos - info_str.off : 0;
+exit:
+	return (retval);
+}
+
+/*************************** ASD Scsi Host Template ***************************/
+
+static Scsi_Host_Template asd_sht = {
+	.module			= THIS_MODULE,
+	.name			= ASD_DRIVER_NAME,
+	.proc_info		= asd_proc_info,
+	.proc_name		= ASD_DRIVER_NAME,
+	.info			= asd_info,
+	.queuecommand		= asd_queue,
+	.eh_abort_handler	= asd_abort,
+	.can_queue		= 2,
+	.this_id		= -1,
+	.max_sectors		= ASD_MAX_SECTORS,
+	.cmd_per_lun		= 2,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.bios_param		= asd_bios_param,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	.slave_alloc		= asd_slave_alloc,
+	.slave_configure	= asd_slave_configure,
+	.slave_destroy		= asd_slave_destroy,
+#else
+	.detect			= asd_detect,
+	.release		= asd_release,
+	.select_queue_depths	= asd_select_queue_depth,
+	.use_new_eh_code	= 1,
+#endif		
+};
+
+module_init(asd_init);
+module_exit(asd_exit);

