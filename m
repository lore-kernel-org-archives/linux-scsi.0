From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [15/27]
Date: Thu, 17 Feb 2005 12:36:53 -0500
Message-ID: <4214D635.5030102@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:8850 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262330AbVBQRhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:37:05 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHavr31216
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:57 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHaub21278
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

OSM code.  Part 2/3.

+
+ASD_COMMAND_BUILD_STATUS
+asd_setup_data(struct asd_softc *asd, struct scb *scb, Scsi_Cmnd *cmd)
+{
+	struct asd_ssp_task_hscb *ssp_hscb;
+	struct sg_element 	 *sg;
+	int			  dir;
+	int			  error;
+
+	/*
+	 * All SSP, STP, and SATA SCBs have their direction
+	 * flags and SG/elements in the same place, so using
+	 * any of their definitions here is safe.
+	 */
+	ssp_hscb = &scb->hscb->ssp_task;
+	scb->sg_count = 0;
+	error = 0;
+
+	if (cmd->use_sg != 0) {
+		struct	scatterlist *cur_seg;
+		u_int	nseg;
+
+		cur_seg = (struct scatterlist *)cmd->request_buffer;
+		dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+		nseg = asd_map_sg(asd, cur_seg, cmd->use_sg, dir);
+		scb->sg_count = nseg;
+		if (nseg > ASD_NSEG) {
+			asd_unmap_sg(asd, cur_seg, nseg, dir);
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+		for (sg = scb->sg_list; nseg > 0; nseg--, cur_seg++, sg++) {
+			dma_addr_t addr;
+			uint32_t len;
+
+			addr = sg_dma_address(cur_seg);
+			len = sg_dma_len(cur_seg);
+			error = asd_sg_setup(sg, addr, len, /*last*/nseg == 1);
+			if (error != 0)
+				break;
+		}
+		if (error != 0) {
+			asd_unmap_sg(asd, cur_seg, scb->sg_count, dir);
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+	} else if (cmd->request_bufflen != 0) {
+		dma_addr_t addr;
+
+		sg = scb->sg_list;
+		dir = scsi_to_pci_dma_dir(cmd->sc_data_direction);
+		addr = asd_map_single(asd,
+				      cmd->request_buffer,
+				      cmd->request_bufflen, dir);
+		scb->platform_data->buf_busaddr = addr;
+		error = asd_sg_setup(sg, addr, cmd->request_bufflen, /*last*/1);
+		if (error != 0) {
+			asd_unmap_single(asd, addr, cmd->request_bufflen, dir);
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+		scb->sg_count = 1;
+	} else {
+		scb->sg_count = 0;
+		dir = PCI_DMA_NONE;
+	}
+
+	if (scb->sg_count != 0) {
+		size_t sg_copy_size;
+
+		sg_copy_size = scb->sg_count * sizeof(*sg);
+		if (scb->sg_count > 3)
+			sg_copy_size = 2 * sizeof(*sg);
+		memcpy(ssp_hscb->sg_elements, scb->sg_list, sg_copy_size);
+		if (scb->sg_count > 3) {
+			/*
+			 * Setup SG sub-list.
+			 */
+			sg = &ssp_hscb->sg_elements[1];
+			sg->next_sg_offset = 2 * sizeof(*sg);
+			sg->flags |= SG_EOS;
+			sg++;
+			sg->bus_address = asd_htole64(scb->sg_list_busaddr);
+			memset(&sg->length, 0,
+			       sizeof(*sg)-offsetof(struct sg_element, length));
+		}
+	}
+
+	switch (dir) {
+	case PCI_DMA_BIDIRECTIONAL:
+		ssp_hscb->data_dir_flags |= DATA_DIR_UNSPECIFIED;
+		break;
+	case PCI_DMA_TODEVICE:
+		ssp_hscb->data_dir_flags |= DATA_DIR_OUTBOUND;
+		break;
+	case PCI_DMA_FROMDEVICE:
+		ssp_hscb->data_dir_flags |= DATA_DIR_INBOUND;
+		break;
+	case PCI_DMA_NONE:
+		ssp_hscb->data_dir_flags |= DATA_DIR_NO_XFER;
+		break;
+	}
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+static ASD_COMMAND_BUILD_STATUS
+asd_build_sas_scb(struct asd_softc *asd, struct scb *scb, union asd_cmd *acmd)
+{
+	struct asd_ssp_task_hscb	*ssp_hscb;
+	struct asd_target 		*targ;
+	Scsi_Cmnd 			*cmd;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) 
+	int				 msg_bytes;
+	uint8_t 			 tag_msgs[2];
+#endif
+
+	asd_push_post_stack(asd, scb, acmd, asd_scb_done);
+
+	cmd = &acmd_scsi_cmd(acmd);
+#ifdef MULTIPATH_IO
+	targ = scb->platform_data->dev->current_target;
+
+	scb->platform_data->dev->current_target = list_entry(
+		scb->platform_data->dev->current_target->multipath.next,
+		struct asd_target, multipath);
+#else
+	targ = scb->platform_data->dev->target;
+#endif
+	ssp_hscb = &scb->hscb->ssp_task;
+
+	ssp_hscb->header.opcode = SCB_INITIATE_SSP_TASK;
+
+	/*
+	 * Build the SAS frame header.
+	 */
+	asd_build_sas_header(targ, ssp_hscb);
+
+	ssp_hscb->protocol_conn_rate |= PROTOCOL_TYPE_SSP;
+	ssp_hscb->xfer_len = asd_htole32(cmd->request_bufflen);
+
+	/*
+	 * Hnadle for multi-lun devices. 
+	 */
+	memcpy(ssp_hscb->lun, scb->platform_data->dev->saslun, SAS_LUN_LEN);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0) 
+	msg_bytes = scsi_populate_tag_msg(cmd, tag_msgs);
+	if (msg_bytes && tag_msgs[0] != MSG_SIMPLE_TAG)
+		ssp_hscb->task_attr |= tag_msgs[0] & 0x3;
+#endif
+	memcpy(ssp_hscb->cdb, cmd->cmnd, cmd->cmd_len);
+	memset(&ssp_hscb->cdb[cmd->cmd_len], 0,
+	       SCB_EMBEDDED_CDB_SIZE - cmd->cmd_len);
+
+	return (asd_setup_data(asd, scb, cmd));
+}
+
+/*
+ * This routine is called from a tasklet, so we must re-acquire
+ * our lock prior when accessing data-structures that need protection.
+ */
+static void
+asd_runq_tasklet(unsigned long data) {
+	struct asd_softc	*asd;
+	struct asd_device 	*dev;
+	u_long			 flags;
+
+	asd = (struct asd_softc *) data;
+	asd_lock(asd, &flags);
+	while ((dev = asd_next_device_to_run(asd)) != NULL) {
+		list_del(&dev->links);
+		dev->flags &= ~ASD_DEV_ON_RUN_LIST;
+		asd_check_device_queue(asd, dev);
+		/* Yeild to our interrupt handler */
+		asd_unlock(asd, &flags);
+		asd_lock(asd, &flags);
+	}
+	asd_unlock(asd, &flags);
+}
+
+static void
+asd_unblock_tasklet(unsigned long data)
+{
+	struct asd_softc *asd;
+
+	asd = (struct asd_softc *) data;
+	scsi_unblock_requests(asd->platform_data->scsi_host);
+}
+
+/*
+ * Function:
+ * 	asd_discovery_thread()
+ *
+ * Description:
+ *	Thread to handle device discovery, topology changes and async. event
+ *	from attached device(s).
+ */	   	  
+static int
+asd_discovery_thread(void *data)
+{
+	struct asd_softc	*asd;
+	u_long			 flags;
+	u_char			 id;
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
+	sprintf(current->comm, "asd_disc_%d", asd->profile.unit);
+#else
+	daemonize("asd_disc_%d", asd->profile.unit);
+	current->flags |= PF_FREEZE;	
+#endif
+	unlock_kernel();
+	
+	while (1) {
+		int 	pending;
+
+		/*
+		 * Use down_interruptible() rather than down() to
+		 * avoid inclusion in the load average.
+		 */
+		down_interruptible(&asd->platform_data->discovery_sem);
+
+		/* Check to see if we've been signaled to exit. */
+		asd_lock(asd, &flags);
+		if ((asd->platform_data->flags & ASD_DISCOVERY_SHUTDOWN) != 0) {
+			asd_unlock(asd, &flags);
+			break;
+		}
+		asd_unlock(asd, &flags);
+
+		/*
+		 * For now, only handle ID ADDR RCVD event.
+		 */
+		pending = 0;
+		for (id = 0; id < asd->hw_profile.max_phys; id++)
+			pending += asd_check_phy_events(asd, id);
+
+		for (id = 0; id < asd->hw_profile.max_ports; id++)
+			pending += asd_check_port_events(asd, id);
+
+		if ((pending == 0) && 
+		    (asd->platform_data->flags & ASD_DISCOVERY_INIT) != 0) {
+			asd_lock(asd, &flags);
+			asd->platform_data->flags &= ~ASD_DISCOVERY_INIT;
+			asd_unlock(asd, &flags);
+			asd_release_hostq(asd);
+		}
+	}
+
+	up(&asd->platform_data->discovery_ending_sem);
+
+	return (0);
+}
+
+/*
+ * Function:
+ * 	asd_kill_discovery_thread()
+ * 
+ * Description:
+ * 	Kill the discovery thread.
+ */
+static void
+asd_kill_discovery_thread(struct asd_softc *asd)
+{
+	u_long	flags;
+
+	asd_lock(asd, &flags);
+
+	if (asd->platform_data->discovery_pid != 0) {
+		asd->platform_data->flags |= ASD_DISCOVERY_SHUTDOWN;
+		asd_unlock(asd, &flags);
+
+		up(&asd->platform_data->discovery_sem);
+
+		/*
+		 * Wait for the discovery thread to exit before continuing
+		 * with the unloading processes.
+		 */
+		down_interruptible(&asd->platform_data->discovery_ending_sem);
+
+		asd->platform_data->discovery_pid = 0;
+	} else {
+		asd_unlock(asd, &flags);
+	}
+}
+
+#ifdef ASD_EH_SIMULATION
+/*
+ * Function:
+ * 	asd_kill_eh_simul_thread()
+ * 
+ * Description:
+ * 	Kill the EH Simulation thread.
+ */ 	   	  
+static void
+asd_kill_eh_simul_thread(struct asd_softc  *asd)
+{
+	u_long	flags;
+
+	asd_lock(asd, &flags);
+
+	if (asd->platform_data->eh_simul_pid != 0) {
+		asd->platform_data->flags |= ASD_EH_SIMUL_SHUTDOWN;
+		asd_unlock(asd, &flags);
+		up(&asd->platform_data->eh_simul_sem);
+		down_interruptible(&asd->platform_data->ehandler_ending_sem);
+		asd->platform_data->eh_simul_pid = 0;
+	} else {
+		asd_unlock(asd, &flags);
+	}
+}
+#endif /* ASD_EH_SIMULATION */
+
+/*
+ * Function:
+ *	asd_check_phy_events()
+ *	
+ * Description:
+ *	Check if any phy events that needs to be handled.
+ */
+static int
+asd_check_phy_events(struct asd_softc *asd, u_int phy_id)
+{
+	struct	asd_phy	*phy;
+	u_long		 flags;
+
+	phy = asd->phy_list[phy_id];
+
+	asd_lock(asd, &flags);
+
+	if ((phy->state != ASD_PHY_WAITING_FOR_ID_ADDR) &&
+	    (list_empty(&phy->pending_scbs))) {
+		asd_unlock(asd, &flags);
+		return 0;
+	}
+
+	if ((phy->state == ASD_PHY_WAITING_FOR_ID_ADDR) &&
+	    ((phy->attr & ASD_SATA_SPINUP_HOLD) != 0) &&
+	    (list_empty(&phy->pending_scbs))) {
+
+		asd_hwi_release_sata_spinup_hold(asd, phy);
+
+		return 1;
+	}
+
+	/* Handle ID Address Frame that has been received. */
+	if ((phy->events & ASD_ID_ADDR_RCVD) != 0) {
+		asd_process_id_addr_evt(asd, phy);
+		phy->events &= ~ASD_ID_ADDR_RCVD;
+		phy->state = ASD_PHY_CONNECTED;
+	}
+
+	asd_unlock(asd, &flags);
+
+	return 1;
+}
+
+/*
+ * Function:
+ *	asd_check_port_events()
+ *
+ * Description:
+ *	Check if any port events that need to be handled.
+ */
+static int
+asd_check_port_events(struct asd_softc *asd, u_int port_id)
+{
+	struct asd_port	*port;
+
+	port = asd->port_list[port_id];
+
+	if ((port->events & ASD_DISCOVERY_PROCESS) != 0) {
+		if ((port->events & ASD_DISCOVERY_EVENT) != 0) {
+			port->events &= ~ASD_DISCOVERY_EVENT;
+
+			asd_run_state_machine(&port->dc.sm_context);
+		}
+
+		if ((port->events & ASD_DISCOVERY_PROCESS) != 0) {
+			return 1;
+		}
+	}
+
+	if (((port->events & ASD_DISCOVERY_REQ) != 0) || 
+		((port->events & ASD_DISCOVERY_RETRY) != 0)) {
+		if (asd_initiate_port_discovery(asd, port) == 0) {
+			port->events |= ASD_DISCOVERY_PROCESS;
+			/* 
+			 * Only clear the event if it is handled successfully. 
+			 */
+			if ((port->events & ASD_VALIDATION_REQ) != 0) {
+				/*
+				 * Validate any targets if needed.
+				 */
+				if (!list_empty(&port->targets_to_validate))
+					asd_configure_port_targets(asd, port);
+
+				port->events &= ~ASD_VALIDATION_REQ;
+			}
+
+			port->events &= ~(ASD_DISCOVERY_REQ | 
+				ASD_DISCOVERY_RETRY | ASD_VALIDATION_REQ);
+
+			asd_do_discovery(asd, port);
+		}
+	}
+
+	if ((port->events & ASD_LOSS_OF_SIGNAL) != 0) {
+		asd_handle_loss_of_signal(asd, port);
+		port->events &= ~ASD_LOSS_OF_SIGNAL;
+	}
+
+	if ((port->events & ASD_VALIDATION_REQ) != 0) {
+		/*
+		 * Validate any targets if needed.
+		 */
+		if (!list_empty(&port->targets_to_validate))
+			asd_configure_port_targets(asd, port);
+
+		port->events &= ~ASD_VALIDATION_REQ;
+	}
+
+	return (0);
+}
+
+/*
+ * Function:
+ *	asd_configure_port_targets
+ *
+ * Description:
+ *	Configure any new targets that have been added.
+ *	Clean up targets that have been removed.
+ */
+static void
+asd_configure_port_targets(struct asd_softc *asd, struct asd_port *port)
+{
+	struct asd_target	*targ;
+	struct asd_target	*tmp_targ;
+	struct list_head	 validate_list;
+	u_long			 flags;
+
+	INIT_LIST_HEAD(&validate_list);
+
+	/*
+	 * TODO:
+	 * Access to the validate_list itself is protected, but we still need
+	 * to make sure that the individual target's validate_links are
+	 * protected.
+	 */
+	asd_list_lock(&flags);
+
+	list_move_all(&validate_list, &port->targets_to_validate);
+
+	asd_list_unlock(&flags);
+
+	/* 
+	 * We might be calling a routine that destroys the target, so use 
+	 * the safe version of list traversal.
+	 */
+	list_for_each_entry_safe(targ, tmp_targ, &validate_list,
+				 validate_links) {
+
+		list_del(&targ->validate_links);
+
+		if (targ->flags & ASD_TARG_HOT_ADDED) {
+			targ->flags &= ~ASD_TARG_HOT_ADDED;
+
+			/*
+			 * We only need to configure the target if it is
+			 * a SAS or SATA END-DEVICE.
+		      	 */	 
+			if (targ->management_type == ASD_DEVICE_END) {
+				asd_configure_target(asd, targ);
+			} else {
+				targ->flags |= ASD_TARG_ONLINE;
+			}
+
+		} else if (targ->flags & ASD_TARG_HOT_REMOVED) {
+			if (targ->flags & ASD_TARG_MAPPED) {
+				/*
+				 * Tell the OS that the device is gone.
+				 */
+				asd_destroy_target(asd, targ);
+			} else {
+				/*
+				 * This target is not exported to the OS,
+				 * so we aren't going to report this device as
+				 * missing.
+				 */
+				asd_free_target(asd, targ);
+			}
+		} else {
+			asd_log(ASD_DBG_ERROR, "Invalid Target Flags.\n");
+		}
+	}
+}
+
+/*
+ * Function:
+ *	asd_configure_target()
+ *
+ * Description:
+ *	Configure target that was HOT-ADDED. 
+ */ 
+static void
+asd_configure_target(struct asd_softc *asd, struct asd_target *targ)
+{
+	u_int	ch;
+	u_int	id;
+	u_int	lun;
+	
+	ch = targ->src_port->id;
+	id = targ->target;
+	/* TODO : Currently the lun is set 0. This needs to be fixed. */
+	lun = 0;
+
+	/* Report the new target found to the user or OS. */
+	asd_print("New device attached at ");
+	asd_print("Host: scsi%d Channel: %d Id: %d Lun: %d\n",
+		  asd->platform_data->scsi_host->host_no, ch, id, lun);
+	
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,0)
+	/*
+	 * For 2.6 kernel, notify the scsi layer that a new had been
+	 * device added.
+	 */
+	scsi_add_device(asd->platform_data->scsi_host, ch, id, lun);
+#endif
+	targ->flags |= (ASD_TARG_ONLINE | ASD_TARG_MAPPED);
+}
+
+/*
+ * Function:
+ *	asd_destroy_target()
+ *
+ * Description:
+ *	Destroy target that was HOT-REMOVED.
+ */ 
+static void
+asd_destroy_target(struct asd_softc *asd, struct asd_target *targ)
+{
+	u_long		flags;
+	unsigned	num_luns;
+	unsigned	i;
+
+	/*
+	 * For an end-device, we need to free the device and report 
+	 * the change to the user or scsi layer.
+	 */
+	if (targ->management_type != ASD_DEVICE_END) {
+		asd_lock(asd, &flags);
+		/* Free the DDB site used by this target. */
+		asd_free_ddb(asd, targ->ddb_profile.conn_handle);
+		/*
+		 * For non end-device, nothing much need to be done.
+		 * All we need to do is free up the target.
+		 */
+		asd_free_target(asd, targ);
+		asd_unlock(asd, &flags);
+		return;
+	}
+
+	switch (targ->command_set_type) {
+	case ASD_COMMAND_SET_SCSI:
+		num_luns = targ->scsi_cmdset.num_luns;
+		break;
+
+	case ASD_COMMAND_SET_ATA:
+	case ASD_COMMAND_SET_ATAPI:
+		num_luns = 1;
+		break;
+
+	default:
+		return;
+	}
+
+	for (i = 0 ; i < num_luns ; i++)
+		asd_init_dev_itnl_exp(asd, targ, i);
+}
+
+static void
+asd_init_dev_itnl_exp(struct asd_softc *asd, struct asd_target *targ,
+		      u_int lun)
+{
+	struct asd_device *dev;
+	u_long		   itnl_timeout;
+	u_long		   flags;
+
+	asd_lock(asd, &flags);
+
+	dev = targ->devices[lun];
+	if (dev == NULL)
+		panic("Dev is corrupted.\n");
+
+	itnl_timeout = ((targ->ddb_profile.itnl_const/1000) + 2) * HZ;
+
+	asd_setup_dev_timer(dev, itnl_timeout, asd_dev_intl_times_out);
+
+	asd_unlock(asd, &flags);
+}
+
+void
+asd_dev_intl_times_out(u_long arg)
+{
+	struct asd_softc 	*asd;
+	struct asd_device	*dev;
+	u_long			 flags;
+
+	dev = (struct asd_device *) arg;
+	asd = dev->target->softc;
+
+	asd_lock(asd, &flags);
+	dev->flags &= ~ASD_DEV_TIMER_ACTIVE;
+
+	/*
+	 * It seems that aftet ITNL timer expired, there are still 
+	 * outstanding IO(s) pending with the firmware.
+	 */
+	if (dev->active > 0) {
+		/*
+		 * Request the firmware to abort all IO(s) pending on
+		 * its queue.
+		 */
+		asd_log(ASD_DBG_ERROR, "ITNL expired, DEV is still ACTIVE.\n");
+
+		dev->flags |= ASD_DEV_DESTROY_WAS_ACTIVE;
+		asd_clear_device_io(asd, dev);
+	} else {
+		/*
+		 * No more active IO(s). Schedule a deferred process to
+		 * destroy the device.
+		 */
+		asd_setup_dev_dpc_task(dev, asd_destroy_device);
+	}
+
+	asd_unlock(asd, &flags);
+}
+
+static void
+asd_clear_device_io(struct asd_softc *asd, struct asd_device *dev)
+{
+	struct scb	*scb;
+	
+	/*
+	 * Send a request to the firmware to abort all IOs pending on its
+	 * queue that are intended for the target.
+	 */	 
+	if ((scb = asd_hwi_get_scb(asd, 1)) == NULL) {
+		asd_log(ASD_DBG_ERROR, "Failed to get free SCB "
+			"for CLEARING firmware queue.\n");
+		return;
+ 	}
+
+	scb->platform_data->dev = dev;
+	scb->platform_data->targ = dev->target;
+
+	asd_hwi_build_clear_nexus(scb, CLR_NXS_I_T_L,
+				 (NOT_IN_Q | SEND_Q | EXEC_Q),
+				  ASD_TARG_HOT_REMOVED);
+				
+	scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+	asd_push_post_stack(asd, scb, (void *) dev, asd_clear_device_io_done);
+	asd_hwi_post_scb(asd, scb);
+}
+
+static void
+asd_clear_device_io_done(struct asd_softc *asd, struct scb *scb,
+			 struct asd_done_list *dl)
+{
+	asd_log(ASD_DBG_ERROR, "DL Opcode = 0x%x.\n", dl->opcode);
+
+	asd_hwi_free_scb(asd, scb);
+}
+
+void
+asd_destroy_device(void *arg)
+{
+	struct asd_softc	*asd;
+	struct asd_device	*dev;
+	struct scsi_cmnd	*cmd;
+	union asd_cmd		*acmd;
+	u_long	 		 flags;
+
+	dev = (struct asd_device *) arg;
+	asd = dev->target->softc;
+
+	asd_lock(asd, &flags);
+	
+	dev->flags &= ~ASD_DEV_DPC_ACTIVE;
+	/*
+	 * Prior to free up the device, make sure no IOs are
+	 * pending on the device queue.
+	 * Return all pending IOs to the scsi layer.
+	 */
+	while (!list_empty(&dev->busyq)) {
+		acmd = list_entry(dev->busyq.next, 
+				  union asd_cmd, acmd_links);
+		list_del(&acmd->acmd_links);
+		cmd = &acmd_scsi_cmd(acmd);
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+		asd_cmd_set_host_status(cmd, DID_NO_CONNECT);
+#else
+		asd_cmd_set_offline_status(cmd);
+#endif
+		cmd->scsi_done(cmd);
+	}
+
+	/* 
+	 * If the device has been exposed to the scsi layer, 
+	 * we need to notify the scsi layer that the device has
+	 * been removed and free up the the device.
+	 */
+	asd_print("%s: device %d:%d:%d:%d has been removed.\n",
+		  ASD_DRIVER_NAME, asd->platform_data->scsi_host->host_no,
+		  dev->ch, dev->target->target, dev->lun);
+
+	if ((dev->flags & ASD_DEV_UNCONFIGURED) != 0) {
+		/*
+		 * The device has not been exposed to the scsi 
+		 * layer yet, all we need to do is free up the device.
+		 */
+		asd_free_device(asd, dev);
+		asd_unlock(asd, &flags);
+		return;
+	}
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,6)
+	if ((dev->flags & ASD_DEV_DESTROY_WAS_ACTIVE) == 0)
+		scsi_device_set_state(dev->scsi_device, SDEV_OFFLINE);
+#endif	
+	/*
+	 * For 2.6 kernel, notify the scsi layer that
+	 * a device had been removed. Ends up in asd_slave_destroy().
+	 */
+	asd_unlock(asd, &flags);
+
+	scsi_remove_device(dev->scsi_device);
+#else
+
+	if ((dev->flags & ASD_DEV_DESTROY_WAS_ACTIVE) == 0)
+		dev->scsi_device->online = 0;
+
+	if (dev->target->refcount == 1) {
+		/*
+		 * Last device attached on this target.
+		 * Free the target's DDB site.
+		 */
+		asd_free_ddb(asd, dev->target->ddb_profile.conn_handle);
+	}
+		
+	/* 
+	 * The device is no longer active.
+	 * It is safe to free up the device.
+	 */
+	asd_free_device(asd, dev);
+
+	asd_unlock(asd, &flags);
+#endif
+}
+
+static void
+asd_handle_loss_of_signal(struct asd_softc *asd, struct asd_port *port)
+{
+	struct asd_target	*targ;
+	struct asd_target	*multipath_target;
+	struct asd_phy		*phy;
+	struct asd_phy		*tmp_phy;
+	u_long			 flags;
+	int			 num_phy_online;
+
+	phy = NULL;
+	num_phy_online = 0;
+
+	asd_lock(asd, &flags);
+
+	/*
+	 * We have lost signal from the port to the attached device.
+       	 * If the port is a narrow port, we need to have all the attached
+	 * targets validated.
+	 * If the port is a wide port, we need to check if there is other 
+	 * link is still connected to the attached device. 
+	 */	 
+	if (port->num_phys > 1) {
+		/* 
+		 * Wide port. We can still functional if other links still
+		 * up and attached to the end device;
+		 */
+		list_for_each_entry_safe(phy, tmp_phy,
+					 &port->phys_attached, links) {
+
+			if (phy->state == ASD_PHY_CONNECTED) {
+				num_phy_online++;
+				continue;
+			}
+			/* 
+			 * We need to disassociate the phy that no longer
+			 * belongs to this wide port.
+			 */
+			if ((phy->state == ASD_PHY_ONLINE)  || 
+			    (phy->state == ASD_PHY_OFFLINE)) {
+				list_del_init(&phy->links);
+				phy->src_port = NULL;
+				port->num_phys--;
+				port->conn_mask &= ~(1 << phy->id);
+			}
+		}
+	}
+
+	if (num_phy_online == 0) {
+		/* 
+		 * Links are down from the port to the attached device. 
+		 * All targets attached to the port need to be validated.
+		 */
+		while (!list_empty(&port->targets)) {
+			targ = list_entry(port->targets.next,
+					  struct asd_target,
+					  all_domain_targets);
+
+			/*
+			 * If this is a multipath target, then move the device
+			 * mapping before removing the device.
+			 */
+			if (!list_empty(&targ->multipath)) {
+
+				multipath_target = list_entry(
+					targ->multipath.next,
+					struct asd_target, multipath);
+
+				asd_remap_device(asd, targ, multipath_target);
+
+				/*
+				 * This device wasn't in the target list
+				 * because it was a multipath.  Add it to the
+				 * list.
+				 */
+				list_add_tail(
+					&multipath_target->all_domain_targets,
+					&multipath_target->src_port->targets);
+
+				targ->flags &= ~ASD_TARG_MAPPED;
+			}
+
+			list_del_init(&targ->all_domain_targets);
+			list_del_init(&targ->children);
+			list_del_init(&targ->siblings);
+			list_del_init(&targ->multipath);
+			targ->flags |= ASD_TARG_HOT_REMOVED;
+			list_add_tail(&targ->validate_links,
+				      &port->targets_to_validate);
+		}
+		INIT_LIST_HEAD(&port->targets);
+		port->events |= ASD_VALIDATION_REQ;
+		/*
+		 * We need to disassociate all the attached phys from this
+		 * port.
+		 */
+		while (!list_empty(&port->phys_attached)) {
+			phy = list_entry(port->phys_attached.next,
+					 struct asd_phy, links);
+			list_del_init(&phy->links);
+			phy->src_port = NULL;
+			port->num_phys--;
+			port->conn_mask = 0;
+			port->state = ASD_PORT_UNUSED;
+		}
+	}
+
+	asd_unlock(asd, &flags);
+}
+
+/* 
+ * parse thro' list of all devices discovered and retireve target by 
+ * sas address.
+ */
+struct asd_target * 
+asd_get_sas_target_from_sasaddr(struct asd_softc *asd, struct asd_port *port, 
+				uint8_t *sasaddr)
+{
+	struct asd_target 	*target;
+	u_long			 flags;
+	
+	if ((asd == NULL) || (port == NULL) || (sasaddr == NULL)) {
+		return NULL;
+	}
+
+	asd_lock(asd, &flags);
+	list_for_each_entry(target, &port->targets, all_domain_targets) {
+		if (memcmp(target->ddb_profile.sas_addr, 
+			   sasaddr, 
+			   SAS_ADDR_LEN) == 0) {
+			asd_unlock(asd, &flags);
+			return target;
+		}
+	}	
+	asd_unlock(asd, &flags);
+
+	return NULL;
+}
+
+/* parse thro' devices exported to os and retrieve target by SAS address */
+struct asd_target * 
+asd_get_os_target_from_sasaddr(struct asd_softc *asd, struct asd_domain *dm,
+			       uint8_t *sasaddr)
+{
+	struct asd_target 	*target;
+	int 			 i;
+	u_long 			 flags;
+	
+	if ((asd == NULL) || (dm == NULL))
+		return NULL;
+	
+	asd_lock(asd, &flags);
+	for (i = 0; i < ASD_MAX_TARGETS; i++) {
+		if ((target = dm->targets[i]) != NULL) {
+			if (memcmp(target->ddb_profile.sas_addr, 
+			   	   sasaddr, 
+			   	   SAS_ADDR_LEN) == 0) {
+				asd_unlock(asd, &flags);
+				return target;
+			}
+		}
+	}
+	asd_unlock(asd, &flags);
+	return NULL;
+}
+
+/* parse thro' devices exported to os and retrieve target by port 
+ * This routine will have to be discarded soon.
+ * */
+struct asd_target * 
+asd_get_os_target_from_port(struct asd_softc *asd, struct asd_port *port, 
+			    struct asd_domain *dm)
+{
+	int i;
+	u_long flags;
+	
+	if ((asd == NULL) || (dm == NULL) || (port == NULL))
+		return NULL;
+	
+	asd_lock(asd, &flags);
+	for (i = 0; i < ASD_MAX_TARGETS; i++) {
+		if ((dm->targets[i] != NULL) 
+		   && (dm->targets[i]->src_port == port)) {
+			asd_unlock(asd, &flags);
+			return dm->targets[i];
+		}
+	}
+	asd_unlock(asd, &flags);
+
+	return NULL;
+}
+
+struct asd_device *
+asd_get_device_from_lun(struct asd_softc *asd, struct asd_target *targ, 
+			uint8_t *saslun)
+{
+	int 	k;
+	u_long 	flags;
+	
+	if ((asd == NULL) || (targ == NULL)) 
+		return NULL;
+
+	if ((targ->transport_type == ASD_TRANSPORT_STP) || 
+	    (targ->transport_type == ASD_TRANSPORT_ATA)) {
+		return targ->devices[0];
+	}
+
+	if (saslun == NULL)
+		return NULL;
+
+	asd_list_lock(&flags);
+	for (k = 0; k < ASD_MAX_LUNS; k++) {
+		if (targ->devices[k]) {
+			if (memcmp(&targ->devices[k]->saslun, 
+			    saslun, 8) == 0) {
+				asd_list_unlock(&flags);
+				return targ->devices[k];
+			}
+		}
+	}
+	asd_list_unlock(&flags);
+
+	return NULL;
+}
+
+int 
+asd_get_os_platform_map_from_sasaddr(struct asd_softc *asd, 
+				     struct asd_port *port, 
+				     uint8_t *sasaddr, uint8_t *saslun, 
+				     uint8_t *host, uint8_t *bus, 
+				     uint8_t *target, uint8_t *lun)
+{
+	Scsi_Device 		*scsi_device;
+	struct asd_domain	*dm;
+	struct asd_target	*targ;
+	struct asd_device	*dev;
+	struct Scsi_Host 	*scsi_host;
+	
+	dm = asd->platform_data->domains[port->id];
+	if (dm == NULL)
+		return 0;
+	
+	if ((targ = 
+		asd_get_os_target_from_sasaddr(asd, dm, sasaddr)) == NULL)
+		return -ENODEV;
+
+	if ((dev = asd_get_device_from_lun(asd, targ, saslun)) == NULL)	
+		return -ENODEV;
+
+	scsi_device = dev->scsi_device;
+	scsi_host = asd->platform_data->scsi_host;
+
+	*host = scsi_host->host_no;
+	*target = scsi_device->id;
+	*bus = scsi_device->channel;
+	*lun = scsi_device->lun;
+
+	return 0;
+}
+
+struct asd_port *
+asd_get_sas_addr_from_platform_map(struct asd_softc *asd, 
+				   uint8_t host, uint8_t bus, uint8_t target, 
+				   uint8_t lun, uint8_t *sasaddr,
+				   uint8_t *saslun)
+{
+	struct asd_domain	*dm;
+	struct asd_target	*targ;
+	struct asd_device	*dev;
+	struct Scsi_Host 	*scsi_host;
+	struct asd_port		*port;
+	u_long 			 flags;
+
+	asd_lock(asd, &flags);
+
+	port = NULL;
+	scsi_host = asd->platform_data->scsi_host;
+	if ((scsi_host == NULL) || 
+	   ((host != 0xFF) && (host != scsi_host->host_no)))
+		goto exit;
+
+	if ((bus >= asd->platform_data->num_domains) ||
+	    ((dm = asd->platform_data->domains[bus]) == NULL))
+		goto exit;
+
+	if ((target >= ASD_MAX_TARGETS) ||
+	    ((targ = dm->targets[target]) == NULL))
+		goto exit;
+
+	if (lun >= ASD_MAX_LUNS)
+		goto exit;
+
+	if ((dev = targ->devices[lun]) == NULL)
+		goto exit;
+
+	/* Get LUN address. */
+	memcpy(saslun, dev->saslun, SAS_LUN_LEN);
+	/* Get SAS address. */
+	memcpy(sasaddr, targ->ddb_profile.sas_addr, SAS_ADDR_LEN);
+
+	port = targ->src_port;
+
+exit:	
+	asd_unlock(asd, &flags);
+	return (port);
+}
+
+struct scb *
+asd_find_pending_scb_by_qtag(struct asd_softc *asd, uint32_t qtag)
+{
+	struct scb 		*list_scb;
+	struct scb 		*scb;
+	struct scsi_cmnd 	*cmd;
+	union asd_cmd 		*acmd;
+	u_long 			flags;
+	
+	list_scb = NULL;
+	scb = NULL;
+	cmd = NULL;
+	acmd = NULL;
+
+	asd_list_lock(&flags);
+	list_for_each_entry(list_scb, &asd->platform_data->pending_os_scbs,
+			    owner_links) {
+		acmd = list_scb->io_ctx;
+		cmd = &acmd_scsi_cmd(acmd);
+		if (cmd->tag == qtag) {
+			scb = list_scb;
+			break;
+		}
+	}
+	asd_list_unlock(&flags);
+	return scb;
+}
+
+/*
+ * Function:
+ * 	asd_process_id_addr_evt()
+ *
+ * Description:
+ * 	Process Identify Address frame received by the phy. 
+ * 	If the phy has no src port, associate the phy with a port.
+ *	Otherwise, validate if the phy still belongs to the same src port.
+ *	Trigger discovery as needed.
+ */
+static void
+asd_process_id_addr_evt(struct asd_softc *asd, struct asd_phy *phy)
+{
+	struct asd_port	*port;
+	struct asd_phy	*list_phy;
+	int		 wide_port;
+	int		 prev_attached_phy;
+	int		 port_no;
+
+	ASD_LOCK_ASSERT(asd);
+
+	port = NULL;
+	prev_attached_phy = 0;
+	wide_port = 0;
+	/*
+	 * Check existing ports whether the current phy attached to the
+         * port has the same ID ADDR as this new phy.
+	 * If so, this phy shall be associated to the port and aggregate
+	 * as a wide port if it a different phy.
+	 * Else, if it is the same phy then it must be after enable-phy.
+	 */
+	for (port_no = 0; port_no < asd->hw_profile.max_ports; port_no++) {
+		port = asd->port_list[port_no];
+
+		if ((port->state & ASD_PORT_ONLINE) == 0) {
+			continue;
+		}
+
+		if (port->link_type != ASD_LINK_SAS) {
+			/*
+			 * For SATA link, check if the phy is the same as
+		         * the one currently attached to the port.
+			 */
+			list_phy = list_entry(port->phys_attached.next,
+					      struct asd_phy, links);
+			if (list_phy->id == phy->id)
+				prev_attached_phy = 1;
+
+			continue;
+		}
+
+		list_for_each_entry(list_phy, &port->phys_attached, links) {
+			/*
+			 * Check the id_addr that we just got in.
+			 */
+			if (memcmp(PHY_GET_ID_SAS_ADDR(list_phy),
+	       			   PHY_GET_ID_SAS_ADDR(phy), 
+				   SAS_ADDR_LEN) != 0) {
+
+				continue;
+			}
+			/*
+			 * Check the sas address that assigned by the BIOS
+			 */
+			if (memcmp(list_phy->sas_addr, phy->sas_addr, 
+				   SAS_ADDR_LEN) != 0) {
+				continue;
+			}
+			/*
+			 * Check if this is the same phy that was previously
+			 * attached to this port.
+			 * The new phy can only become a wide port if it isn't
+			 * previously attached to this port.
+		         */	 
+			if (list_phy->id == phy->id)
+				prev_attached_phy = 1;
+			else
+				wide_port = 1;
+			
+			break;
+		}
+
+		if ((wide_port == 1) || (prev_attached_phy == 1))
+			break;
+	}
+
+	if ((wide_port == 0) && (prev_attached_phy == 0)) {
+		/*
+	 	 * The phy is not associated with any port. 
+	 	 * Create a new port for this phy.
+	 	 */
+		for (port_no = 0; port_no < asd->hw_profile.max_ports; 
+		     port_no++) {
+			port = asd->port_list[port_no];
+
+			if ((port->state == ASD_PORT_UNUSED) && 
+			    (port->num_phys == 0))
+				break;
+		}
+		memcpy(port->sas_addr, phy->sas_addr, SAS_ADDR_LEN);
+		/* 
+		 * Generate SAS hashed address to be used as the port 
+		 * SAS address. 
+		 */
+		asd_hwi_hash(port->sas_addr, port->hashed_sas_addr);
+
+		/* 
+		 * During enable phy, we have determined whether we have a 
+		 * direct attached SATA device.
+		 */  
+		if (phy->attr & ASD_SATA_MODE) {
+			/*
+			 * TODO: More things to do for SATA II device which 
+			 *	 supports tag queueing. Need to setup sister
+			 *	 ddb, other additional SATA information. Need
+			 *	 to add SATA specific fields in target DDB
+			 *	 profile.
+			 */
+			port->link_type = ASD_LINK_SATA;
+			port->management_type = ASD_DEVICE_END;
+
+		} else if (phy->bytes_dmaed_rcvd.id_addr_rcvd.addr_frame_type & 
+			SAS_END_DEVICE) {
+			/*
+			 * Direct Attached SAS device.
+			 */
+			port->link_type = ASD_LINK_SAS;
+			port->management_type = ASD_DEVICE_END;
+
+		} else if (phy->bytes_dmaed_rcvd.id_addr_rcvd.addr_frame_type & 
+			SAS_EDGE_EXP_DEVICE) {
+			/*
+			 * Edge Expander device.
+			 */
+			port->link_type = ASD_LINK_SAS;
+			port->management_type = ASD_DEVICE_EDGE_EXPANDER;
+		} else {
+			/*
+			 * Fanout Expander device
+			 */
+			if (phy->bytes_dmaed_rcvd.id_addr_rcvd.addr_frame_type & 
+				SAS_FANOUT_EXP_DEVICE) {
+
+				port->link_type = ASD_LINK_SAS;
+				port->management_type =
+					ASD_DEVICE_FANOUT_EXPANDER;
+			}
+		}
+
+		port->state = ASD_PORT_ONLINE;
+	}
+
+	phy->src_port = port;
+
+	if (prev_attached_phy == 0) {
+		list_add_tail(&phy->links, &port->phys_attached);
+		port->num_phys++;
+	}
+	asd_setup_port_data(asd, port, phy);
+
+	/*
+	 * Check to see if the port already has discovery running on it.
+	 */
+	if (((port->events & ASD_DISCOVERY_REQ) == 0) &&
+		((port->events & ASD_DISCOVERY_PROCESS) == 0)) {
+		/*
+		 * The port does not have a discovery running on it.
+		 */
+		port->events |= ASD_DISCOVERY_REQ;
+
+		port->conn_mask |= (1 << phy->id);
+
+		asd->num_discovery++;
+
+	} else {
+		/*
+		 * We should only get here if this is a wide port.  We will not
+		 * mark this phy in the connection mask yet, the discovery
+		 * thread will do that when it is finished.
+		 */
+		ASSERT(wide_port == 1);
+	}
+}
+
+/*
+ * Function:
+ *	asd_setup_port_data()
+ *
+ * Description:
+ *	Setup port settings based on the phy info.
+ */
+static void 
+asd_setup_port_data(struct asd_softc *asd, struct asd_port *port,
+		    struct asd_phy *phy)
+{
+	u_int	lowest_rate;
+
+	/* 
+	 * If this port was previously disabled, change the port state to 
+	 * ONLINE.   
+	 */
+	if (port->state != ASD_PORT_ONLINE)
+		port->state = ASD_PORT_ONLINE;
+
+	port->attr = phy->attr;	
+
+	/* 
+	 * Get the negotiated connection rate.
+	 *
+	 * Notice the two different definitions of connection rate.
+	 * SAS_RATE_XXX is used on the OPEN ADDRESS FRAME.
+	 * For wide port configuration, we need to use lowest link rate of 
+	 * all attached phys as the port connection rate.
+	 */
+	lowest_rate = phy->conn_rate;
+	if (port->num_phys > 1) {
+		struct asd_phy	*list_phy;
+
+		/* Wide port configuration. */
+		list_for_each_entry(list_phy, &port->phys_attached, links) {
+			if (phy->conn_rate < lowest_rate)
+				lowest_rate = phy->conn_rate;
+		}
+	}
+
+	port->conn_rate = ((lowest_rate == SAS_30GBPS_RATE) ? SAS_RATE_30GBPS :
+							      SAS_RATE_15GBPS);
+}
+
+/*
+ * Function:
+ * 	asd_initiate_port_discovery()
+ * 
+ * Description:
+ *	Check any events such as phy events, id_addr frame or dynamic 
+ *	configuration changes that required discovery.
+ */	   	  
+static int
+asd_initiate_port_discovery(struct asd_softc *asd, struct asd_port *port)
+{
+	struct asd_phy		*phy;
+	struct asd_target 	*targ;
+	struct asd_target	*multipath_target;
+	uint64_t		 sas_addr;
+	u_long			 flags;
+
+	// TODO: fix locking - lists should be locked
+
+	if (list_empty(&port->phys_attached)) {
+		asd_log(ASD_DBG_ERROR, "Corrupted port, no phy(s) attached "
+			"to it.\n");
+		return (-1);
+	}
+
+	phy = list_entry(port->phys_attached.next, struct asd_phy, links);
+
+	if ((port->link_type == ASD_LINK_SATA) &&
+	    (port->management_type = ASD_DEVICE_END)) {
+		/*
+	 	 * For direct-attached SATA end-device, generate the SAS addr
+        	 * internally.
+	 	*/
+		sas_addr = asd_htobe64(asd_be64toh(*((uint64_t *)
+				       asd->hw_profile.wwn)) + 0x10 + phy->id);
+	} else {
+		sas_addr = (*(uint64_t *) PHY_GET_ID_SAS_ADDR(phy));
+	}
+
+	/*
+	 * Look up this target to see if it already exists.
+	 */
+	targ = asd_find_target(&port->targets, (uint8_t *) &sas_addr);
+	if (targ != NULL) {
+		list_del_init(&targ->all_domain_targets);
+		list_del_init(&targ->children);
+		list_del_init(&targ->siblings);
+
+		while (!list_empty(&targ->multipath)) {
+			multipath_target = list_entry(targ->multipath.next,
+					  struct asd_target, multipath);
+
+			list_del_init(&multipath_target->multipath);
+
+			list_add_tail(&multipath_target->multipath,
+				&port->targets);
+		}
+
+		list_add_tail(&targ->all_domain_targets, &port->targets);
+	} else {
+		targ = asd_alloc_target(asd, port);
+	}
+
+	if (targ == NULL) {
+		/* 
+		 * TODO: Return for now.
+		 *  	 Probably, we should return and put
+		 *  	 the discovery thread back to sleep
+		 *  	 and restart at some point later on. 
+		 */
+		asd_log(ASD_DBG_ERROR, "Failed to allocate a target !!\n");
+		return (-1);
+	}
+
+	asd_lock(asd, &flags);
+
+	if (asd_setup_target_data(asd, phy, targ) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to setup target data !!\n");
+		return (-1);
+	}
+
+     	memcpy(port->attached_sas_addr, targ->ddb_profile.sas_addr,
+	       SAS_ADDR_LEN);
+
+	switch (port->link_type)
+	{
+	case ASD_LINK_SAS:
+		targ->management_type = port->management_type;
+
+		switch (port->management_type)
+		{
+		case ASD_DEVICE_END:
+			/*
+			 * It can't be an STP type because it is directly
+			 * attached to the initiator.
+			 */
+			targ->command_set_type = ASD_COMMAND_SET_SCSI;
+			targ->device_protocol_type = ASD_DEVICE_PROTOCOL_SCSI;
+			targ->transport_type = ASD_TRANSPORT_SSP;
+			break;
+
+		case ASD_DEVICE_EDGE_EXPANDER:
+			targ->command_set_type = ASD_COMMAND_SET_SMP;
+			targ->device_protocol_type = ASD_DEVICE_PROTOCOL_SMP;
+			targ->transport_type = ASD_TRANSPORT_SMP;
+			break;
+
+		case ASD_DEVICE_FANOUT_EXPANDER:
+			targ->command_set_type = ASD_COMMAND_SET_SMP;
+			targ->device_protocol_type = ASD_DEVICE_PROTOCOL_SMP;
+			targ->transport_type = ASD_TRANSPORT_SMP;
+			break;
+
+		case ASD_DEVICE_NONE:
+		case ASD_DEVICE_UNKNOWN:
+			targ->command_set_type = ASD_COMMAND_SET_UNKNOWN;
+			targ->device_protocol_type = 
+				ASD_DEVICE_PROTOCOL_UNKNOWN;
+			targ->transport_type = ASD_TRANSPORT_UNKNOWN;
+			break;
+		}
+		break;
+
+	case ASD_LINK_SATA:
+		targ->command_set_type = ASD_COMMAND_SET_UNKNOWN;
+		targ->device_protocol_type = ASD_DEVICE_PROTOCOL_ATA;
+		targ->transport_type = ASD_TRANSPORT_ATA;
+		targ->management_type = ASD_DEVICE_END;
+		break;
+
+	default:
+		targ->command_set_type = ASD_COMMAND_SET_UNKNOWN;
+		targ->device_protocol_type = ASD_DEVICE_PROTOCOL_UNKNOWN;
+		targ->transport_type = ASD_TRANSPORT_UNKNOWN;
+		targ->management_type = ASD_DEVICE_NONE;
+		break;
+	}
+
+	port->tree_root = targ;
+
+	asd_unlock(asd, &flags);
+
+	return (0);
+}	
+
+/*
+ * Function:
+ * 	asd_setup_target_data()
+ * 
+ * Description:
+ *	Setup target info based on the Identify Address frame received.
+ * 	Also, setup a hardware ddb site for this target.
+ */
+static int
+asd_setup_target_data(struct asd_softc *asd, struct asd_phy *phy,
+		      struct asd_target *targ)
+{
+	uint64_t	sas_addr;
+
+	ASD_LOCK_ASSERT(asd);
+
+	/* Set the sister ddb to invalid for now. */
+	targ->ddb_profile.sister_ddb = ASD_INVALID_DDB_INDEX;
+
+	targ->ddb_profile.conn_rate = phy->src_port->conn_rate;
+
+	/* Set a default ITNL timer, applicable for SAS device only. */
+	targ->ddb_profile.itnl_const = ITNL_TIMEOUT_CONST;
+		
+	/* Setup target protocol. */
+	if (phy->bytes_dmaed_rcvd.id_addr_rcvd.tgt_port_type & SSP_TGT_PORT) {
+
+		targ->transport_type = ASD_TRANSPORT_SSP;
+		targ->command_set_type = ASD_COMMAND_SET_SCSI;
+
+	} else if (phy->bytes_dmaed_rcvd.id_addr_rcvd.tgt_port_type & 
+		SMP_TGT_PORT) {
+
+		targ->transport_type = ASD_TRANSPORT_SMP;
+		targ->command_set_type = ASD_COMMAND_SET_SMP;
+
+	} else if (phy->bytes_dmaed_rcvd.id_addr_rcvd.tgt_port_type & 
+		STP_TGT_PORT) {
+		/* 
+		 * We don't know the command set yet (could be ATAPI or ATA)
+		 * We won't know until IDENTIFY / PIDENTIFY.
+		 */
+		targ->transport_type = ASD_TRANSPORT_STP;
+	} else {
+		/* 
+		 * We don't know the command set yet (could be ATAPI or ATA)
+		 * We won't know until IDENTIFY / PIDENTIFY.
+		 */
+		targ->transport_type = ASD_TRANSPORT_ATA;
+	}
+
+	if (targ->transport_type == ASD_TRANSPORT_ATA) {
+
+		sas_addr =  asd_htobe64(asd_be64toh(*((uint64_t *)
+			asd->hw_profile.wwn)) + 0x10 + phy->id);
+
+		/*
+		 * Setup the SAS Address for this target based on the
+		 * generated SAS Address.
+		 */
+		memcpy(targ->ddb_profile.sas_addr, &sas_addr, SAS_ADDR_LEN);
+	} else {
+		/*
+		 * Setup the SAS Address for this target based on the Identify
+		 * Frame received for this phy.
+		 */
+		memcpy(targ->ddb_profile.sas_addr, PHY_GET_ID_SAS_ADDR(phy),
+		       SAS_ADDR_LEN);
+	}
+
+	asd_hwi_hash(targ->ddb_profile.sas_addr, 
+		     targ->ddb_profile.hashed_sas_addr);
+		
+	/* 
+	 * Based on the target port type, enable the OPEN bit so that 
+	 * OPEN address will be issued when opening an connection.
+	 */
+	if ((phy->bytes_dmaed_rcvd.id_addr_rcvd.tgt_port_type & SSP_TGT_PORT) &&
+		(phy->bytes_dmaed_rcvd.id_addr_rcvd.tgt_port_type & 
+			SMP_TGT_PORT) &&
+		(phy->bytes_dmaed_rcvd.id_addr_rcvd.tgt_port_type & 
+			STP_TGT_PORT)) {
+
+		targ->ddb_profile.open_affl = OPEN_AFFILIATION;
+
+		/*
+		 * TODO: More to be done for STP in the case affiliation is
+		 *	 supported.
+	 	 */	    
+	} else {
+		/* 
+		 * For direct attached SATA device and SATA Port Multi, 
+		 * OPEN Address frame and afflitiation policy are not 
+		 * supported.
+		 */   
+		targ->ddb_profile.open_affl = 0;
+	}
+
+	/* Setup a hardware DDB site for this target. */
+	if (asd_hwi_setup_ddb_site(asd, targ) != 0) {
+		/* 
+		 * Failed to setup ddb site due to no free site.
+		 * TODO: More handling needed here once ddb site recycling 
+		 *	 algorithm is implemented.
+		 *	 For now, just return failure.	 
+		 */
+		return (-1);
+	}
+      		
+	return (0);
+}
+
+/*
+ * Function:
+ * 	asd_map_target()
+ *
+ * Description:
+ *	Mapped the target to the domain.
+ */
+int
+asd_map_target(struct asd_softc *asd, struct asd_target *targ)
+{
+	struct asd_domain	*dm;
+	struct asd_port		*port;
+	u_int			 i;
+	unsigned		 channel;
+
+	port = targ->src_port;
+
+	/*
+	 * Map the target to the domain.
+	 */
+	if (targ->flags & ASD_TARG_MAP_BOOT) {
+		targ->flags &= ~ASD_TARG_MAP_BOOT;
+		channel = 0;
+	} else {
+		channel = port->id;
+	}
+
+	dm = asd->platform_data->domains[channel];
+
+	if (dm == NULL) {
+		dm = asd_alloc_domain(asd, channel);
+		if (dm == NULL) {
+			return (-1);
+		}
+	}
+		
+	for (i = 0; i < ASD_MAX_TARGETS; i++) {
+		if (dm->targets[i] == NULL) {
+			dm->targets[i] = targ;
+			targ->target = i;
+			targ->domain = dm;
+			break;
+		}
+	}
+
+	if (i == ASD_MAX_TARGETS) {
+		return (-1);
+	}
+
+	/* Increment domain ref count for new target mapped. */
+	asd_domain_addref(dm);
+
+	return (0);
+}
+
+
+/***************************** PCI Entry Points *******************************/
+/* 
+ * Function:
+ *	asd_pci_dev_probe()
+ *
+ * Description:
+ *	This routine will be called when OS finds a controller that matches
+ *	and entry in our supported PCI ID table.  It will perform hardware
+ *	initialization and bring our device to the online state. 
+ */
+static int
+asd_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct asd_softc		*asd;
+	struct asd_pci_driver_data	*drv_data;
+	asd_dev_t			 dev;
+	unsigned long			 flags;
+	int				 error;
+
+	asd_print("Probing Adaptec AIC-94xx Controller(s)...\n");
+	
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+	if (asd_init_stat.asd_init_state != 1) {
+		asd_print("%s: Ignoring PCI device found after initialization. "
+			  "\n", ASD_DRIVER_NAME);
+		return (-ENODEV);
+	}
+#endif
+
+	/* Sanity checking to make sure the same device is not probed twice. */
+	asd_list_lock(&flags);
+	list_for_each_entry(asd, &asd_hbas, link) {
+		struct pci_dev *probed_pdev;
+
+		probed_pdev = asd_pci_dev(asd);
+		if ((probed_pdev->bus->number == pdev->bus->number) && 
+		    (probed_pdev->devfn == pdev->devfn)) {
+			/* A Duplicate PCI Device found. Ignore it. */
+			asd_print("%s: Ignoring duplicate PCI device.\n", 
+			  	  ASD_DRIVER_NAME);
+			asd_list_unlock(&flags);
+			return (-ENODEV);
+		}
+	}
+	asd_list_unlock(&flags);
+
+	drv_data = (struct asd_pci_driver_data *) (id->driver_data);
+	if (drv_data == NULL) {
+		asd_log(ASD_DBG_ERROR, "PCI Driver Data not found.\n");
+		return (-ENODEV);
+	}
+
+	if (pdev->class == (PCI_CLASS_STORAGE_RAID << 8)
+	    && !attach_HostRAID)
+		return -ENODEV;
+
+	if (pci_enable_device(pdev) != 0)
+		return (-ENODEV);	
+	
+	pci_set_master(pdev);
+		
+	dev = asd_pdev_to_dev(pdev);
+	/* Allocate a softc structure for the current PCI Device found. */
+	asd = asd_alloc_softc(dev);
+	if (asd == NULL)
+		return (-ENOMEM);
+	
+	asd->pci_entry = id;
+	/*
+	 * Perform profile setup for the specific controller.
+	 * Always success.
+	 */
+	error = drv_data->setup(asd);
+	
+	asd->platform_data->domains = asd_alloc_mem(
+					    (asd->hw_profile.max_ports *
+					    sizeof(struct asd_domain)),
+					    GFP_ATOMIC);
+
+	if (asd->platform_data->domains == NULL) {
+		asd_free_softc(asd);
+		return (-ENOMEM);
+	}
+	memset(asd->platform_data->domains, 0x0, (asd->hw_profile.max_ports *
+						  sizeof(struct asd_domain)));
+
+	/*
+	 * Setup PCI consistent dma transfer mask to 32-bit and below 
+	 * 4GB boundary.
+	 */
+	if (asd_set_consistent_dma_mask(asd, 0xFFFFFFFF) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to set PCI consistent "
+			"dma mask.\n");
+		asd_free_softc(asd);
+		return (-ENODEV);
+	}	
+	
+	/*
+	 * Setup the dma transfer mask to 64-bit only the following conditions
+	 * are met:
+	 *    (a) the system is running on 64-bit or 'PAE' mode.
+	 *    (b) the controller can do DMA transfer above 4GB boundary.
+	 *    (c) dma address can be above 4GB boundary.
+	 * Otherwise set the dma transfer mask to 32-bit.
+	 */
+	 if ((asd->profile.dma64_addr == 1)	&& 
+	     (ASD_DMA_64BIT_SUPPORT == 1)) {
+		uint64_t    mask;
+		
+		mask = 0xFFFFFFFFFFFFFFFFULL;
+	 	if (asd_set_dma_mask(asd, mask) != 0) {
+			/* 
+			 * Failed to set dma mask to 64-bit, throttle down
+			 * to 32-bit instead.
+			 */
+			 mask = 0xFFFFFFFFULL;
+			 if (asd_set_dma_mask(asd, mask) != 0) {
+			 	/* If this also failed, we need to exit. */
+				asd_log(ASD_DBG_ERROR, "Failed to set DMA "
+					"mask. \n");
+				asd_free_softc(asd);
+				return (-ENODEV);
+			}	 
+	 	}
+		asd->profile.dma_mask = (dma_addr_t) mask;		
+	 } else {
+	 	if (asd_set_dma_mask(asd, 0xFFFFFFFF) != 0) {
+			asd_log(ASD_DBG_ERROR, "Failed to set DMA "
+					"mask. \n");
+			asd_free_softc(asd);
+			return (-ENODEV);
+		}
+		asd->profile.dma_mask = 0xFFFFFFFF;
+	}
+
+	/* 
+	 * TBD: Review locking. This is a single threaded operation and 
+	 * 2.6.x kernel on a SMP machine complains about a potential 
+	 * deadlock due to irqs being disabled. 
+	 */
+	/*asd_lock(asd, &flags);*/
+	/* Initialize the controller. */
+	if (asd_init_hw(asd) != 0) {
+		//asd_unlock(asd, &flags);
+		asd_log(ASD_DBG_ERROR, "Failed to initialize the HW.\n");
+		asd_free_softc(asd);
+		return (-ENODEV);
+	} 	
+	pci_set_drvdata(pdev, asd);
+	/*asd_unlock(asd, &flags);*/
+	
+	asd_list_lock(&flags);
+	list_add_tail(&asd->link, &asd_hbas);
+	asd_list_unlock(&flags);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	/* The controller is hot-plugged, register it with the SCSI midlayer. */
+	if (asd_init_stat.asd_init_state == 0) {
+		error = asd_register_host(asd);
+		if (error != 0) {
+			asd_log(ASD_DBG_ERROR, "Failed to register host.\n");
+			asd_list_lock(&flags);
+			list_del(&asd->link);
+			asd_list_unlock(&flags);
+			asd_free_softc(asd);
+		}
+	}
+#endif
+	if (!error)
+		/* Enable the Host interrupt. */
+		asd_intr_enable(asd, 1);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
+	/* 
+	 * For the controller that is hot-plugged, we need to request the 
+	 * midlayer to perform bus scan.
+	 */
+	if (asd_init_stat.asd_init_state == 0) {
+		error = asd_initiate_bus_scan(asd);
+		if (error != 0) {
+			asd_log(ASD_DBG_ERROR, "Failed in performing "
+				"bus scan.\n");
+			asd_list_lock(&flags);
+			list_del(&asd->link);
+			asd_list_unlock(&flags);
+			asd_free_softc(asd);
+		}
+	}	
+#endif
+
+	return (error);
+}

