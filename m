From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [08/27]
Date: Thu, 17 Feb 2005 12:36:14 -0500
Message-ID: <4214D60E.9040501@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:32913 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262319AbVBQRgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:36:19 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHaIr30788
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:18 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHaHb21031
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hardware interface. Part 2/3.

+
+/*
+ * Function:
+ * 	asd_hwi_process_prim_event()
+ * 
+ * Description:
+ *	Process any recevied primitives that are not handled by the 
+ *	firmware (eg. BROADCAST, HARD_RESET, etc.)
+ */
+static void
+asd_hwi_process_prim_event(struct asd_softc *asd, struct asd_phy *phy,
+			   u_int reg_addr, u_int reg_content)
+{
+	uint32_t	reg_val;
+
+	reg_val = 0;
+	if (reg_addr == LmPRMSTAT0BYTE1) {
+		/* 
+		 * First byte of Primitive Status register is intended for
+		 * BROADCAST primitives.
+		 */
+		reg_val = (reg_content << 8) & 0xFF00;
+		switch (reg_val) {
+		case LmBROADCH:
+		case LmBROADRVCH0:
+		case LmBROADRVCH1:
+			asd_log(ASD_DBG_RUNTIME, "BROADCAST PRIMITIVE "
+				"received.\n");
+			/* 
+			 * Set the event that discovery is needed and
+			 * wakeup discovery thread.  
+			 */ 
+			if(phy->src_port->events & ASD_DISCOVERY_PROCESS)
+				phy->src_port->events |= ASD_DISCOVERY_RETRY;
+			else
+				phy->src_port->events = ASD_DISCOVERY_REQ;
+			asd_wakeup_sem(&asd->platform_data->discovery_sem);
+			phy->brdcst_rcvd_cnt++;
+			break;
+
+		default:
+			asd_log(ASD_DBG_ERROR, "Unsupported BROADCAST "
+				"primitive.\n");
+			break;
+		}
+	} else if (reg_addr == LmPRMSTAT1BYTE0) {
+		reg_val = reg_content & 0xFF;
+		if (reg_val == LmHARDRST) {
+			asd_log(ASD_DBG_RUNTIME, "HARD_RESET primitive "
+				"received.\n");
+		}
+	} else if (reg_addr == LmPRMSTAT0BYTE3) {
+		reg_val = (reg_content << 24) & 0xFF000000;
+		if (reg_val == LmUNKNOWNP) {
+			asd_log(ASD_DBG_RUNTIME, "Undefined BREAK primitive "
+				"received.\n");
+		}
+	} else {
+		asd_log(ASD_DBG_ERROR, "Unsupported PRIMITIVE STATUS REG.\n");
+	}
+}
+
+/*
+ * Function:
+ * 	asd_hwi_process_phy_event()
+ * 
+ * Description:
+ *	Process received async. phy events.
+ */
+static void
+asd_hwi_process_phy_event(struct asd_softc *asd, struct asd_phy *phy, 
+			  u_int oob_status, u_int oob_mode)
+{
+	switch (oob_status) {
+	case DEVICE_REMOVED:
+		/*
+		 * We received a phy event that notified us that the 
+		 * signal is lost with the direct attached device to 
+		 * this phy. The device has been hot removed.
+		 */	 
+		asd_log(ASD_DBG_RUNTIME, 
+			"PHY_EVENT (%d) - DEVICE HOT REMOVED.\n", phy->id);
+		phy->state = ASD_PHY_ONLINE;
+		phy->attr = (ASD_SSP_INITIATOR | ASD_SMP_INITIATOR | 
+			     ASD_STP_INITIATOR);
+
+		if (phy->src_port != NULL)
+			phy->src_port->events |= ASD_LOSS_OF_SIGNAL;
+
+		asd_wakeup_sem(&asd->platform_data->discovery_sem);
+		break;
+
+	case DEVICE_ADDED_W_CNT:
+	case DEVICE_ADDED_WO_CNT:
+		asd_log(ASD_DBG_RUNTIME,
+			"PHY_EVENT (%d) - DEVICE HOT ADDED.\n", phy->id);
+
+		/* There is a device attached. */
+		if (oob_status & CURRENT_DEVICE_PRESENT) {
+			phy->attr |= ASD_DEVICE_PRESENT;
+
+			if (oob_status & CURRENT_SPINUP_HOLD)
+				phy->attr |= ASD_SATA_SPINUP_HOLD;
+
+			phy->state = ASD_PHY_WAITING_FOR_ID_ADDR;
+		}
+
+		/* Get the negotiated connection rate. */
+		if (oob_mode & PHY_SPEED_30) {
+			phy->conn_rate = SAS_30GBPS_RATE;
+		} else if (oob_mode & PHY_SPEED_15) {
+			phy->conn_rate = SAS_15GBPS_RATE;
+		}
+			
+		/* Get the transport mode. */
+		if (oob_mode & SAS_MODE) {
+			phy->attr |= ASD_SAS_MODE;
+		} else if (oob_mode & SATA_MODE) {
+			phy->attr |= ASD_SATA_MODE;
+		}
+
+		break;
+	
+	case CURRENT_OOB1_ERROR:
+	case CURRENT_OOB2_ERROR:
+		asd_print("PHY_EVENT (%d) - OOB ERROR.\n", phy->id);
+		break;
+	
+	default:
+		asd_log(ASD_DBG_ERROR,
+			"PHY_EVENT (%d) - UNKNOWN EVENT 0x%x.\n", phy->id,
+			oob_status);
+		break;
+	}
+}
+
+#ifdef ASD_TEST
+static void
+asd_hwi_dump_phy_id_addr(struct asd_phy  *phy)
+{
+	u_char	i;
+
+	asd_print("ID ADDRESS FRAME RECEIVED.\n");
+	asd_print("Addr Frame Type = 0x%x.\n", 
+			phy->bytes_dmaed_rcvd.id_addr_rcvd.addr_frame_type);
+	asd_print("Init Port Type = 0x%x.\n", 
+			phy->bytes_dmaed_rcvd.id_addr_rcvd.init_port_type);
+	asd_print("Tgt Port Type = 0x%x.\n", 
+			phy->bytes_dmaed_rcvd.id_addr_rcvd.tgt_port_type);
+	asd_print("Phy ID = 0x%x.\n", 
+			phy->bytes_dmaed_rcvd.id_addr_rcvd.phy_id);
+	for (i = 0; i < 8; i++)
+		asd_print("TGT Sas Addr[%d] = 0x%x.\n",
+			i, phy->bytes_dmaed_rcvd.id_addr_rcvd.sas_addr[i]);
+}
+#endif 
+
+/*
+ * Function:
+ * 	asd_hwi_handle_link_rst_err()
+ * 
+ * Description:
+ *	Handle Link Reset Error event as a result of timedout while
+ *	waiting for Identity Frame Address or Initial Device-to-Host
+ *	Register FIS from direct-attached device.
+ */
+static void
+asd_hwi_handle_link_rst_err(struct asd_softc *asd, struct asd_phy *phy)
+{
+	struct scb	*scb;
+
+	/*
+	 * We are skipping OOB register initialization as it was done
+	 * the first time we enable the phy.
+	 * Should we redo this initialization again??
+	 */
+
+	/*
+	 * We want to retry the link reset sequence up to a certain
+	 * amount of time to retry establishing connection with the device.
+	 */
+	if (phy->link_rst_cnt > MAX_LINK_RESET_RETRY) {
+		/* 
+		 * We have tried link reset a few times, the device still
+	 	 * failed to return the ID Frame Addr or Device-to-Host
+		 * Register FIS.
+		 * End the discovery process for this phy.
+		 */
+		phy->state = ASD_PHY_ONLINE;
+		phy->attr = (ASD_SSP_INITIATOR | ASD_SMP_INITIATOR | 
+			     ASD_STP_INITIATOR);
+		asd_wakeup_sem(&asd->platform_data->discovery_sem);
+	}
+
+	if ((scb = asd_hwi_get_scb(asd, 0)) == NULL) {
+		asd_log(ASD_DBG_ERROR, "Out of SCB resources.\n");
+
+		return;
+	}
+
+	scb->io_ctx = (void *) phy;
+	scb->flags |= SCB_INTERNAL;
+
+	asd_hwi_build_control_phy(scb, phy, ENABLE_PHY);
+
+	list_add_tail(&scb->owner_links, &phy->pending_scbs);
+	phy->link_rst_cnt++;
+	asd_hwi_post_scb(asd, scb);
+}
+
+/*
+ * Function:
+ * 	asd_hwi_process_req_task()
+ * 
+ * Description:
+ *	Process the requested task recevied from the sequencer.
+ */
+static void
+asd_hwi_process_req_task(struct asd_softc *asd, uint8_t req_type,
+			 uint16_t index)
+{
+	struct scb	*scb;
+	int		 found;
+
+	if ((req_type != REQ_TASK_ABORT) && (req_type != REQ_DEVICE_RESET)) {
+		asd_log(ASD_DBG_ERROR, "Unsupported REQ TASK 0x%x.\n",
+			req_type);
+		return;
+	}
+
+	found = 0;
+	list_for_each_entry(scb, &asd->platform_data->pending_os_scbs,
+			    owner_links) {
+		if (SCB_GET_INDEX(scb) == index) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found == 0) {
+		asd_log(ASD_DBG_ERROR, "REQ TASK with invalid TC.\n");
+		return;
+	}
+
+	if (req_type == REQ_TASK_ABORT)
+		scb->eh_state = SCB_EH_ABORT_REQ;
+	else
+		scb->eh_state = SCB_EH_DEV_RESET_REQ;
+
+	scb->flags |= SCB_TIMEDOUT;
+	scb->eh_post = asd_hwi_req_task_done;
+	list_add_tail(&scb->timedout_links, &asd->timedout_scbs);
+	asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+}
+
+static void
+asd_hwi_req_task_done(struct asd_softc *asd, struct scb *scb)
+{
+	asd_log(ASD_DBG_ERROR, "Req Task completed.\n");
+}
+
+/*************** Helper Functions to build a specific SCB type. ***************/
+
+/*
+ * Function:
+ * 	asd_hwi_build_id_frame()
+ *
+ * Description:
+ *	Build an Identify Frame address.
+ */
+static void
+asd_hwi_build_id_frame(struct asd_phy *phy)
+{
+	struct sas_id_addr	*id_addr;
+	u_char			 i;
+
+	id_addr = (struct sas_id_addr *) phy->id_addr_map.vaddr;
+	memset(id_addr, 0x0, sizeof(*id_addr));
+
+	/* Set the device type to end-device. */
+	id_addr->addr_frame_type |= SAS_END_DEVICE;	
+
+	for (i = 0; i < SAS_ADDR_LEN; i++) 
+		id_addr->sas_addr[i] = phy->sas_addr[i]; 
+	
+	/* Set the Initiator Port attributes. */
+	id_addr->init_port_type = (SSP_INIT_PORT | STP_INIT_PORT | 
+				   SMP_INIT_PORT);
+	id_addr->phy_id = phy->id;
+}
+
+/* 
+ * Function:
+ *	asd_hwi_build_control_phy()
+ *
+ * Description:
+ *      Build a CONTROL PHY SCB.
+ *	CONTROL PHY SCB is used to control the operation of a phy, such as
+ *	enable or disable phy, execute hard reset, release spinup hold and
+ *	control ATA device.
+ */
+void
+asd_hwi_build_control_phy(struct scb *scb, struct asd_phy *phy, 
+			  uint8_t sub_func)
+{
+	struct asd_control_phy_hscb 	*cntrlphy_hscb;
+	uint8_t 			 phy_id;
+	uint8_t				 speed_mask;
+
+	speed_mask = 0;
+	phy_id = phy->id;
+	cntrlphy_hscb = &scb->hscb->control_phy;
+
+	cntrlphy_hscb->header.opcode = SCB_CONTROL_PHY;
+	cntrlphy_hscb->phy_id = phy_id;
+	cntrlphy_hscb->sub_func = sub_func;
+
+	if ((cntrlphy_hscb->sub_func == ENABLE_PHY) || 
+	    (cntrlphy_hscb->sub_func == EXECUTE_HARD_RESET) ||
+	    (cntrlphy_hscb->sub_func == PHY_NO_OP)) {
+		cntrlphy_hscb->func_mask = FUNCTION_MASK_DEFAULT;
+
+		/* 
+		 * Hot Plug timer needs to be disabled while performing
+		 * Hard Reset.
+		 */
+		if (cntrlphy_hscb->sub_func == EXECUTE_HARD_RESET)
+			cntrlphy_hscb->func_mask |= HOT_PLUG_DIS;
+
+		/* mask all speeds */
+		speed_mask = (SAS_SPEED_60_DIS | SAS_SPEED_30_DIS |
+			      SAS_SPEED_15_DIS | SATA_SPEED_30_DIS |
+			      SATA_SPEED_15_DIS);
+
+		/* enable required speed */	
+		asd_hwi_set_speed_mask(phy->max_link_rate, &speed_mask); 
+		asd_hwi_set_speed_mask(phy->min_link_rate, &speed_mask); 
+
+#if SAS_COMSTOCK_SUPPORT
+		/* COMSTOCK only support 1.5 Gbits/s data transfer. */
+		speed_mask &= ~SATA_SPEED_15_DIS;
+		cntrlphy_hscb->speed_mask = speed_mask | (SATA_SPEED_30_DIS | 
+					    SAS_SPEED_60_DIS |
+					    SAS_SPEED_30_DIS);	 
+#else
+		cntrlphy_hscb->speed_mask = speed_mask;
+#endif
+		/* Set to Hot plug time delay to 100 ms. */
+		cntrlphy_hscb->hot_plug_delay = HOTPLUG_DEFAULT_DELAY;
+		cntrlphy_hscb->port_type = (SSP_INITIATOR_PORT | 
+					    STP_INITIATOR_PORT |
+					    SMP_INITIATOR_PORT);
+	} else {
+		cntrlphy_hscb->func_mask = 0;
+		cntrlphy_hscb->speed_mask = 0;
+		cntrlphy_hscb->hot_plug_delay = 0;
+		cntrlphy_hscb->port_type = 0;
+	}
+
+	cntrlphy_hscb->ovrd_devpres_timer = 0;
+	cntrlphy_hscb->devpres_timer_to_const_ovrd = 0;
+	cntrlphy_hscb->link_reset_retries = 0;
+	memset(&cntrlphy_hscb->res1[0], 0x0, 
+		sizeof(struct asd_control_phy_hscb) - 
+		offsetof(struct asd_control_phy_hscb, res1));
+	cntrlphy_hscb->conn_handle = 0xFFFF;
+}
+
+/* 
+ * Function:
+ *	asd_hwi_build_abort_task()
+ *
+ * Description:
+ *      Build an ABORT TASK SCB.
+ *	ABORT TASK scb is used to abort an SCB previously sent to the 
+ *	firmware.
+ */
+void
+asd_hwi_build_abort_task(struct scb *scb, struct scb *scb_to_abort)
+{
+	struct asd_abort_task_hscb	*abort_hscb;
+	struct asd_target		*targ;
+
+	targ = scb_to_abort->platform_data->targ;
+	abort_hscb = &scb->hscb->abort_task;
+	abort_hscb->header.opcode = SCB_ABORT_TASK;
+
+	memset(&abort_hscb->protocol_conn_rate, 0x0,
+	       offsetof(struct asd_abort_task_hscb, res3) -
+	       offsetof(struct asd_abort_task_hscb, protocol_conn_rate));
+	/* 
+	 * The conn_rate is only valid when aborting an SCB with SSP protocol.
+	 */
+	if (targ->transport_type == ASD_TRANSPORT_SSP)
+		abort_hscb->protocol_conn_rate = targ->ddb_profile.conn_rate;
+
+	if ((SCB_GET_OPCODE(scb_to_abort) == SCB_INITIATE_SSP_TASK) ||
+	    (SCB_GET_OPCODE(scb_to_abort) == SCB_INITIATE_LONG_SSP_TASK)) 
+		abort_hscb->protocol_conn_rate |= PROTOCOL_TYPE_SSP;
+	else if ((SCB_GET_OPCODE(scb_to_abort) == SCB_INITIATE_ATA_TASK) ||
+		 (SCB_GET_OPCODE(scb_to_abort) == SCB_INITIATE_ATAPI_TASK))
+		abort_hscb->protocol_conn_rate |= PROTOCOL_TYPE_STP;
+	else
+		abort_hscb->protocol_conn_rate |= PROTOCOL_TYPE_SMP;
+	/*
+	 * Build SSP Frame Header and SSP Task IU, these fields only valid
+         * when aborting an SCB with SSP protocol.
+	 */
+	if (targ->transport_type == ASD_TRANSPORT_SSP) {
+		/* SSP Frame Header. */
+		abort_hscb->sas_header.frame_type = TASK_FRAME;
+		memcpy(abort_hscb->sas_header.hashed_dest_sasaddr,
+		       targ->ddb_profile.hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+		memcpy(abort_hscb->sas_header.hashed_src_sasaddr,
+		       targ->src_port->hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+		abort_hscb->sas_header.target_port_xfer_tag = 0xFFFF;
+		abort_hscb->sas_header.data_offset = 0;
+
+		/* SSP Task IU. */
+		if (scb_to_abort->platform_data->dev != NULL) {
+			/*
+			 * We could be aborting task for SMP target or
+		         * target during discovery and there is no device
+			 * associated with that target.
+			 */	 
+			memcpy(abort_hscb->task_iu.lun,
+			       scb_to_abort->platform_data->dev->saslun,
+			       SAS_LUN_LEN);
+		}
+
+		abort_hscb->task_iu.tmf = ABORT_TASK_TMF;
+		/*
+		 * Setting tag_to_manage to 0xFFFF will indicate the sequencer
+	         * to use conn_handle, lun, and tc_to_abort to determine the
+		 * I_T_L_Q nexus of the task to be aborted.
+		 */	 
+		abort_hscb->task_iu.tag_to_manage = 0xFFFF;
+	}
+
+	abort_hscb->sister_scb = 0xFFFF;
+	abort_hscb->conn_handle = targ->ddb_profile.conn_handle;
+
+	/* 
+	 * For Aborting SSP Task, we need to suspend the data transmission
+	 * of the task to be aborted.
+	 */
+	if (SCB_GET_OPCODE(scb_to_abort) == SCB_INITIATE_SSP_TASK) {
+		abort_hscb->suspend_data = SUSPEND_DATA;
+		scb->eh_state |= SCB_EH_SUSPEND_SENDQ;
+	}
+
+	abort_hscb->retry_cnt = TASK_RETRY_CNT;
+
+	/* Set the TC to be aborted. */
+	abort_hscb->tc_to_abort = asd_htole16(SCB_GET_INDEX(scb_to_abort));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_build_query_task()
+ *
+ * Description:
+ *      Build an QUERY TASK SCB.
+ *	QUERY TASK scb is used to issue an SSP Task IU for a Query Task
+ *	Task Management Function.
+ */
+void
+asd_hwi_build_query_task(struct scb *scb, struct scb *scb_to_query)
+{
+	struct asd_query_ssp_task_hscb	*query_hscb;
+	struct asd_target		*targ;
+
+	targ = scb_to_query->platform_data->targ;
+	query_hscb = &scb->hscb->query_ssp_task;
+	query_hscb->header.opcode = SCB_QUERY_SSP_TASK;
+
+	memset(&query_hscb->protocol_conn_rate, 0x0,
+	       offsetof(struct asd_query_ssp_task_hscb, res3) -
+	       offsetof(struct asd_query_ssp_task_hscb, protocol_conn_rate));
+		
+	query_hscb->protocol_conn_rate = (targ->ddb_profile.conn_rate |
+					  PROTOCOL_TYPE_SSP);
+	/* SSP Frame Header. */
+	query_hscb->sas_header.frame_type = TASK_FRAME;
+	memcpy(query_hscb->sas_header.hashed_dest_sasaddr,
+	       targ->ddb_profile.hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+	memcpy(query_hscb->sas_header.hashed_src_sasaddr,
+	       targ->src_port->hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+	query_hscb->sas_header.target_port_xfer_tag = 0xFFFF;
+	query_hscb->sas_header.data_offset = 0;
+
+	/* SSP Task IU. */
+	query_hscb->task_iu.tmf = QUERY_TASK_TMF;
+	/*
+	 * Setting tag_to_manage to 0xFFFF will indicate the sequencer
+         * to use conn_handle, lun, and tc_to_query to determine the
+	 * I_T_L_Q nexus of the task to be queried.
+	 */	 
+	query_hscb->task_iu.tag_to_manage = 0xFFFF;
+
+	query_hscb->sister_scb = 0xFFFF;
+	query_hscb->conn_handle = targ->ddb_profile.conn_handle;
+	query_hscb->retry_cnt = TASK_RETRY_CNT;
+	/* Set the TC to be queried. */
+	query_hscb->tc_to_query = asd_htole16(SCB_GET_INDEX(scb_to_query));
+}
+
+/* 
+ * Function:
+ *	asd_hwi_build_clear_nexus()
+ *
+ * Description:
+ *      Build a CLEAR NEXUS SCB.
+ *	CLEAR NEXUS SCB is used to request the firmware that a set of pending
+ *	transactions pending for a specified nexus be return to the driver
+ *	and free the associated SCBs to the free list.
+ */
+void
+asd_hwi_build_clear_nexus(struct scb *scb, u_int nexus_ind, u_int parm,
+			  u_int context)
+{
+	struct asd_clear_nexus_hscb	*clr_nxs_hscb;
+	struct asd_target		*targ;
+
+#define RESUME_SENDQ_REQ					\
+do {								\
+	if (context == SCB_EH_RESUME_SENDQ) 			\
+		clr_nxs_hscb->queue_ind = (uint8_t) RESUME_TX;	\
+} while (0)
+	
+	clr_nxs_hscb = &scb->hscb->clear_nexus;
+	clr_nxs_hscb->header.opcode = SCB_CLEAR_NEXUS;
+	targ = scb->platform_data->targ;
+	
+	memset(&clr_nxs_hscb->nexus_ind, 0x0, 
+	       offsetof(struct asd_clear_nexus_hscb, res8) - 
+	       offsetof(struct asd_clear_nexus_hscb, nexus_ind));
+	
+	clr_nxs_hscb->nexus_ind = nexus_ind;
+	switch (nexus_ind) {
+	case CLR_NXS_I_OR_T:
+		/* Clear Nexus intended for I or T. */
+		clr_nxs_hscb->conn_mask_to_clr = targ->src_port->conn_mask;
+		break;
+
+	case CLR_NXS_I_T_L:
+		/* Clear Nexus intended for I_T_L. */
+		if (scb->platform_data->dev != NULL) {
+			memcpy(clr_nxs_hscb->lun_to_clr,
+			       scb->platform_data->dev->saslun,
+			       SAS_LUN_LEN);
+		}
+		/* Fallthrough */
+	case CLR_NXS_IT_OR_TI:
+		/* Clear Nexus intended for I_T or T_I. */
+		clr_nxs_hscb->conn_handle_to_clr = 
+					targ->ddb_profile.conn_handle;
+		clr_nxs_hscb->queue_ind = (uint8_t) parm;
+		break;
+		
+	case CLR_NXS_I_T_L_Q_TAG:
+		/* Clear Nexus intended for I_T_L_Q (by tag). */
+		clr_nxs_hscb->tag_to_clr = (uint16_t) parm;
+		clr_nxs_hscb->conn_handle_to_clr = 
+					targ->ddb_profile.conn_handle;
+		if (scb->platform_data->dev != NULL) {
+			memcpy(clr_nxs_hscb->lun_to_clr,
+			       scb->platform_data->dev->saslun,
+			       SAS_LUN_LEN);
+		}
+		RESUME_SENDQ_REQ;
+		break;
+
+	case CLR_NXS_I_T_L_Q_TC:
+		/* Clear Nexus intended for I_T_L_Q (by TC). */
+		clr_nxs_hscb->tc_to_clr = (uint16_t) parm;
+		clr_nxs_hscb->conn_handle_to_clr = 
+					targ->ddb_profile.conn_handle;
+		if (scb->platform_data->dev != NULL) {
+			memcpy(clr_nxs_hscb->lun_to_clr,
+			       scb->platform_data->dev->saslun,
+			       SAS_LUN_LEN);
+		}
+		RESUME_SENDQ_REQ;
+		break;
+		
+	case CLR_NXS_I_T_L_Q_STAG:
+		/* Clear Nexus intended for I_T_L_Q (by SATA tag). */
+		clr_nxs_hscb->conn_handle_to_clr = 
+					targ->ddb_profile.conn_handle;
+		/* 
+		 * Bits 4-0 of the tag_to_clr contain the SATA tag to be
+		 * cleared. Bits 15-5 shall be set to zero.
+		 */
+		clr_nxs_hscb->tag_to_clr = ((uint16_t) parm && 0x001F);
+		RESUME_SENDQ_REQ;
+		break;
+
+	case CLR_NXS_ADAPTER:
+		/* Clear Nexus for Adapter. */
+	default:
+		/* Unsupported Clear Nexus function. */
+		break;	
+	}
+
+	clr_nxs_hscb->nexus_ctx = (uint16_t) context;
+}
+
+/* 
+ * Function:
+ *	asd_hwi_build_ssp_tmf()
+ *
+ * Description:
+ *      Build a SSP TMF SCB.
+ *	SSP TMF SCB is used to issue an SSP Task information unit for a
+ *	LOGICAL UNIT RESET, ABORT TASK SET, CLEAR TASK SET, or CLEAR ACA
+ *	task management function.
+ */
+void
+asd_hwi_build_ssp_tmf(struct scb *scb, struct asd_target *targ, 
+		      uint8_t *lun, u_int tmf_opcode)
+{
+	struct asd_ssp_tmf_hscb	*tmf_hscb;
+
+	tmf_hscb = &scb->hscb->ssp_tmf;
+	tmf_hscb->header.opcode = SCB_INITIATE_SSP_TMF;
+
+	memset(&tmf_hscb->protocol_conn_rate, 0x0,
+	       offsetof(struct asd_ssp_tmf_hscb, res3) -
+	       offsetof(struct asd_ssp_tmf_hscb, protocol_conn_rate));
+
+	tmf_hscb->protocol_conn_rate = (targ->ddb_profile.conn_rate | 
+					PROTOCOL_TYPE_SSP);
+	/* SSP Frame Header. */
+	tmf_hscb->sas_header.frame_type = TASK_FRAME;
+	memcpy(tmf_hscb->sas_header.hashed_dest_sasaddr,
+	       targ->ddb_profile.hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+	memcpy(tmf_hscb->sas_header.hashed_src_sasaddr,
+	       targ->src_port->hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+	tmf_hscb->sas_header.target_port_xfer_tag = 0xFFFF;
+	tmf_hscb->sas_header.data_offset = 0;
+	
+	/* SSP Task IU. */
+	memcpy(tmf_hscb->task_iu.lun, lun, SAS_LUN_LEN);
+	tmf_hscb->task_iu.tmf = tmf_opcode;
+
+	tmf_hscb->sister_scb = 0xFFFF;
+	tmf_hscb->conn_handle = targ->ddb_profile.conn_handle;
+	
+	/* Suspend data transmission to the target. */
+	scb->eh_state |= SCB_EH_SUSPEND_SENDQ;
+	tmf_hscb->suspend_data = SUSPEND_DATA;
+	tmf_hscb->retry_cnt = TASK_RETRY_CNT;
+}
+ 
+/*
+ * Function:
+ * 	asd_hwi_build_smp_phy_req()
+ *
+ * Description:
+ *	Build a SMP PHY related request.
+ */ 
+static void
+asd_hwi_build_smp_phy_req(struct asd_port *port, int req_type,
+			  int phy_id, int ctx)
+{
+	struct SMPRequest	*smp_req;
+
+	smp_req = port->dc.SMPRequestFrame;
+	memset(smp_req, 0, sizeof(*smp_req));
+
+	smp_req->SMPFrameType = SMP_REQUEST_FRAME;
+
+	switch (req_type) {
+	case PHY_CONTROL:
+		smp_req->Function = PHY_CONTROL;
+		smp_req->Request.PhyControl.PhyIdentifier = phy_id;
+		smp_req->Request.PhyControl.PhyOperation = ctx;
+		break;
+
+	case REPORT_PHY_ERROR_LOG:
+		smp_req->Function = REPORT_PHY_ERROR_LOG;
+		smp_req->Request.ReportPhyErrorLog.PhyIdentifier = phy_id;
+		break;
+
+	default:
+		panic("Unknown SMP PHY request type.\n"); 
+		break;
+	}
+
+	/*
+	 * DC: Currently, we are not changing the programmed min/max 
+         *     physical link rate for LINK RESET or HARD RESET.
+	 *     We might need to change the link rate if CMSI application
+	 *     required..
+	 */
+}
+
+/*
+ * Function:
+ *	asd_hwi_build_smp_task()
+ *
+ * Description:
+ *	Build a SMP TASK SCB.
+ *	SMP TASK SCB is used to send an SMP TASK to an expander.
+ */ 
+void
+asd_hwi_build_smp_task(struct scb *scb, struct asd_target *targ,
+		       uint64_t req_bus_addr, u_int req_len, 
+		       uint64_t resp_bus_addr, u_int resp_len)
+{
+	struct asd_smp_task_hscb	*smp_hscb;
+
+	smp_hscb = &scb->hscb->smp_task;
+	smp_hscb->header.opcode = SCB_INITIATE_SMP_TASK;
+
+	memset(&smp_hscb->protocol_conn_rate, 0x0,
+	       offsetof(struct asd_smp_task_hscb, res5) -
+	       offsetof(struct asd_ssp_tmf_hscb, protocol_conn_rate));
+
+	smp_hscb->protocol_conn_rate = (targ->ddb_profile.conn_rate |
+					PROTOCOL_TYPE_SMP);
+	smp_hscb->smp_req_busaddr = req_bus_addr;
+	smp_hscb->smp_req_size = req_len;
+	smp_hscb->smp_req_ds = 0;
+	smp_hscb->sister_scb = 0xffff;
+	smp_hscb->conn_handle = targ->ddb_profile.conn_handle;
+	smp_hscb->smp_resp_busaddr = resp_bus_addr;
+	smp_hscb->smp_resp_size = resp_len;
+	smp_hscb->smp_resp_ds = 0;
+}
+
+/*
+ * Function:
+ *	asd_hwi_build_ssp_task()
+ *
+ * Description:
+ *	Build a SSP TASK SCB.
+ *	SSP TASK SCB is used to send an SSP TASK to an expander.
+ */ 
+void
+asd_hwi_build_ssp_task(struct scb *scb, struct asd_target *targ,
+		       uint8_t *saslun, uint8_t *cdb, uint32_t cdb_len,
+		       uint8_t addl_cdb_len, uint32_t data_len)
+{
+	struct asd_ssp_task_hscb *ssp_hscb;
+
+	ssp_hscb = &scb->hscb->ssp_task;
+	ssp_hscb->header.opcode = SCB_INITIATE_SSP_TASK;
+	ssp_hscb->protocol_conn_rate = targ->ddb_profile.conn_rate 
+					| PROTOCOL_TYPE_SSP;
+	ssp_hscb->xfer_len = asd_htole32(data_len);
+	ssp_hscb->sas_header.frame_type = OPEN_ADDR_FRAME;
+	
+	memcpy(ssp_hscb->sas_header.hashed_dest_sasaddr,
+	       targ->ddb_profile.hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+
+	ssp_hscb->sas_header.res = 0;
+
+	memcpy(ssp_hscb->sas_header.hashed_src_sasaddr,
+	       targ->src_port->hashed_sas_addr, HASHED_SAS_ADDR_LEN);
+
+	memset(ssp_hscb->sas_header.res1, 0,
+	       offsetof(struct asd_sas_header, target_port_xfer_tag) - 
+	       offsetof(struct asd_sas_header, res1));
+
+	ssp_hscb->sas_header.target_port_xfer_tag = 0xFFFF;
+	ssp_hscb->sas_header.data_offset = 0;
+
+	/* SSP Command IU */
+	memset(ssp_hscb->lun, 0,
+	       offsetof(struct asd_ssp_task_hscb, cdb) -
+	       offsetof(struct asd_ssp_task_hscb, lun));
+	memcpy(ssp_hscb->lun, saslun, 8);
+	memcpy(ssp_hscb->cdb, cdb, cdb_len);
+	
+	memset(&ssp_hscb->cdb[cdb_len], 0,
+	      SCB_EMBEDDED_CDB_SIZE - cdb_len);
+
+	ssp_hscb->addl_cdb_len = addl_cdb_len;
+	ssp_hscb->sister_scb = 0xFFFF;
+	ssp_hscb->conn_handle = targ->ddb_profile.conn_handle;
+	ssp_hscb->retry_cnt = TASK_RETRY_CNT;
+
+	memset(&ssp_hscb->LAST_SSP_HSCB_FIELD, 0,
+	       offsetof(struct asd_ssp_task_hscb, sg_elements) - 
+	       offsetof(struct asd_ssp_task_hscb, LAST_SSP_HSCB_FIELD));
+
+	return;
+}
+
+/*
+ * Function:
+ *	asd_hwi_build_stp_task()
+ *
+ * Description:
+ *	Build a STP TASK SCB.
+ *	STP TASK SCB is used to send an ATA TASK to an expander.
+ */ 
+void 
+asd_hwi_build_stp_task(struct scb *scb, struct asd_target *targ,
+		       uint32_t data_len)
+{
+	struct asd_ata_task_hscb *ata_hscb;
+
+	ata_hscb = &scb->hscb->ata_task;
+	ata_hscb->header.opcode = SCB_INITIATE_ATA_TASK;
+	ata_hscb->protocol_conn_rate =
+		PROTOCOL_TYPE_SATA | targ->ddb_profile.conn_rate;
+	ata_hscb->xfer_len = asd_htole32(data_len);
+	ata_hscb->data_offset = 0;
+	ata_hscb->sister_scb = 0xffff;
+	ata_hscb->conn_handle = targ->ddb_profile.conn_handle;
+	ata_hscb->retry_cnt = TASK_RETRY_CNT;
+	ata_hscb->affiliation_policy = 0;
+
+	ata_hscb->ata_flags = 0;
+#ifdef TAGGED_QUEUING
+	// RST - add support for SATA II queueing
+	ata_hscb->ata_flags |= LEGACY_QUEUING;
+#else
+	ata_hscb->ata_flags |= UNTAGGED;
+#endif
+	return;
+}
+
+/*
+ * Function:
+ * 	asd_hwi_hash()
+ *
+ * Desctiption:
+ * 	Convert a 64-bit SAS address into a 24-bit Hash address.
+ * 	This is based on the hash implementation from the SAS 1.1 draft.
+ */
+void
+asd_hwi_hash(uint8_t *sas_addr, uint8_t *hashed_addr)
+{
+	const uint32_t 	distance_9_poly = 0x01DB2777;
+	uint32_t 	upperbits;
+	uint32_t 	lowerbits;
+	uint32_t 	msb;
+	uint32_t 	moving_one;
+	uint32_t 	leading_bit;
+	uint32_t 	regg;
+	int	 	i;
+
+	upperbits = scsi_4btoul(sas_addr);
+	lowerbits = scsi_4btoul(sas_addr + 4);
+	msb = 0x01000000;
+	regg = 0;
+	moving_one = 0x80000000;
+	for (i = 31; i >= 0; i--) {
+		leading_bit = 0;
+		if (moving_one & upperbits)
+			leading_bit = msb;
+		regg <<= 1;
+		regg ^= leading_bit;
+		if (regg & msb)
+			regg ^= distance_9_poly;
+		moving_one >>= 1;
+	}
+	moving_one = 0x80000000;
+	for (i = 31; i >= 0; i--) {
+		leading_bit = 0;
+		if (moving_one & lowerbits)
+			leading_bit = msb;
+		regg <<= 1;
+		regg ^= leading_bit;
+		if (regg & msb)
+			regg ^= distance_9_poly;
+
+		moving_one >>= 1;
+	}
+	scsi_ulto3b(regg, hashed_addr);
+}
+
+/*************************** Error Handling routines **************************/
+
+void
+asd_recover_cmds(struct asd_softc *asd)
+{
+	struct scb	*scb;
+	struct scb	*free_scb;
+	struct scb	*safe_scb;
+	u_long		 flags;
+
+	if (list_empty(&asd->timedout_scbs)) {
+		asd_log(ASD_DBG_ERROR, "Timed-out scbs already completed.\n");
+		goto exit;
+	}
+	
+	list_for_each_entry_safe(scb, safe_scb, &asd->timedout_scbs,
+				 timedout_links) {
+		asd_lock(asd, &flags);
+
+		/* 
+		 * Error recovery is in progress for this scb.
+		 * Proceed to next one.
+		 */
+		if ((scb->eh_state & SCB_EH_IN_PROGRESS) != 0) {
+			asd_unlock(asd, &flags);
+			continue;
+		}
+		/*
+		 * Error recovery is completed for this scb.
+	         */
+		if (scb->eh_state == SCB_EH_DONE) {
+			asd_unlock(asd, &flags);
+			goto done;
+		}
+		/*
+		 * Only allowed one Error Recovery ongoing for a particular
+		 * target.
+		 */
+		if ((scb->platform_data->targ->flags &
+					ASD_TARG_IN_RECOVERY) != 0) {
+			asd_unlock(asd, &flags);
+			continue;
+		}
+		/* 
+		 * Acquire a free SCB from reserved pool to be used
+		 * for error recovery purpose.
+		 */
+		if ((free_scb = asd_hwi_get_scb(asd, 1)) == NULL) {
+			asd_log(ASD_DBG_ERROR, "Failed to get free SCB "
+				"for error recovery.\n");
+			asd_unlock(asd, &flags);
+			continue;
+		}
+
+		/* Mark this target to be in recovery mode. */
+		scb->platform_data->targ->flags |= ASD_TARG_IN_RECOVERY;
+
+		/* Freeze the target's queue. */
+		asd_freeze_targetq(asd, scb->platform_data->targ);
+
+		/* Initialiaze the state. */
+		scb->eh_state |= SCB_EH_IN_PROGRESS;
+		free_scb->eh_state = SCB_EH_INITIATED;
+		free_scb->eh_status = SCB_EH_SUCCEED;
+		
+		switch (scb->eh_state & SCB_EH_LEVEL_MASK) {
+		case SCB_EH_ABORT_REQ:
+			asd_log(ASD_DBG_ERROR, "ABORT ER REQ.\n");
+			asd_hwi_abort_scb(asd, scb, free_scb);
+			break;
+
+		case SCB_EH_LU_RESET_REQ:
+			asd_log(ASD_DBG_ERROR, "LU RESET ER REQ.\n");
+			asd_hwi_reset_lu(asd, scb, free_scb);
+			break;
+		
+		case SCB_EH_DEV_RESET_REQ:
+			asd_log(ASD_DBG_ERROR, "DEV RESET ER REQ.\n");
+			asd_hwi_reset_device(asd, scb, free_scb);
+			break;
+			
+		case SCB_EH_PORT_RESET_REQ:
+			asd_log(ASD_DBG_ERROR, "PORT RESET ER REQ.\n");
+			asd_hwi_reset_port(asd, scb, free_scb);
+			break;
+			
+		default:
+			asd_log(ASD_DBG_ERROR, "Unknown Error Recovery "
+				"Level.\n");
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			break;
+		}
+		asd_unlock(asd, &flags);
+
+done:
+		if (scb->eh_state == SCB_EH_DONE) {
+			/*
+			 * Error recovery is done for this scb,
+		         * Clean up and free the scb.
+			 */	 
+			asd_lock(asd, &flags);
+
+			list_del(&scb->timedout_links);
+			scb->flags &= ~SCB_TIMEDOUT;
+			scb->platform_data->targ->flags &= 
+						~ASD_TARG_IN_RECOVERY;
+			/* Unfreeze the target's queue. */
+			asd_unfreeze_targetq(asd, scb->platform_data->targ);
+			scb->eh_post(asd, scb);
+
+			if (scb->eh_status != SCB_EH_FAILED) {
+				struct asd_device *dev;
+				/* 
+				 * Schedule a timer to run the device
+				 * queue if the device is not frozen and
+				 * not in the process of being removed.
+				 */
+				dev = scb->platform_data->dev;
+				if ((dev != NULL) && (dev->qfrozen == 0) &&
+				    (dev->flags & ASD_DEV_TIMER_ACTIVE) == 0 &&
+				    (dev->target->flags &
+				     ASD_TARG_HOT_REMOVED) == 0) {
+
+					asd_setup_dev_timer(
+						dev, HZ,
+						asd_timed_run_dev_queue);
+				}
+				/*
+			 	 * Only free the scb if the error recovery is
+			 	 * successful.
+			 	 */
+				asd_hwi_free_scb(asd, scb);
+			}
+			asd_unlock(asd, &flags);
+		}
+	}
+
+exit:
+	return;
+}
+
+static void
+asd_scb_eh_timeout(u_long arg)
+{
+	struct asd_softc 	*asd;
+	struct scb		*scb;
+	struct scb		*err_scb;
+	u_long		 	 flags;
+	
+	scb = (struct scb *) arg;
+	err_scb = (struct scb *) scb->post_stack[0].io_ctx;
+	asd = scb->softc;
+	asd_lock(asd, &flags);
+
+	scb->eh_state = SCB_EH_TIMEDOUT;
+	err_scb->eh_state &= ~SCB_EH_IN_PROGRESS;
+	/* 
+	 * Error recovery SCB timed out.
+	 * If this error recovery requested by the OS, we need to mark the
+	 * error recovery failed and make an attempt to perform the next
+	 * level error recovery if possible.
+	 */ 
+	switch (err_scb->eh_state) {
+	case SCB_EH_ABORT_REQ:
+		err_scb->eh_state = SCB_EH_LU_RESET_REQ;
+		break;
+		
+	case SCB_EH_LU_RESET_REQ:
+		err_scb->eh_state = SCB_EH_DEV_RESET_REQ;
+		break;
+
+	case SCB_EH_DEV_RESET_REQ:
+		err_scb->eh_state = SCB_EH_PORT_RESET_REQ;
+		break;
+
+	case SCB_EH_PORT_RESET_REQ:
+	default:
+		/* 
+		 * Currently, our biggest hammer now is PORT RESET.
+		 * We might perform ADAPTER RESET later on.
+		 */ 
+		err_scb->eh_state = SCB_EH_DONE;
+		break;
+	}
+
+	err_scb->eh_status = SCB_EH_FAILED;
+	err_scb->platform_data->targ->flags &= ~ASD_TARG_IN_RECOVERY;
+	asd_unlock(asd, &flags);
+	asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+}
+
+int
+asd_hwi_check_cmd_pending(struct asd_softc *asd, struct scb *scb, 
+		       	  struct asd_done_list *dl)
+{
+	struct scb *abort_scb;
+
+	while (!list_empty(&asd->timedout_scbs)) {
+		abort_scb = list_entry(asd->timedout_scbs.next, 
+				       struct scb, timedout_links);
+		if (((struct asd_abort_task_hscb *)
+		      &scb->hscb->abort_task)->tc_to_abort == 
+		      asd_htole16(SCB_GET_INDEX(abort_scb))) {
+			return (1);
+		}
+	}
+
+	return (0);
+}
+
+/*
+ * Function: 
+ *	asd_hwi_abort_scb()
+ *
+ * Description:
+ *	This routine will issue an ABORT_TASK to abort the requested scb.
+ *	ONLY SCB with protocol SSP, SMP and STP can be issued ABORT_TASK TMF.
+ */
+static void
+asd_hwi_abort_scb(struct asd_softc *asd, struct scb *scb_to_abort,
+		  struct scb *scb)
+{
+	ASD_LOCK_ASSERT(asd);
+
+	asd_log(ASD_DBG_ERROR, "Curr State: 0x%x Status: 0x%x.\n",
+		scb->eh_state, scb->eh_status);
+
+	/*
+	 * DC: We probably need to search the scb_to_abort in the 
+	 *     target/device queue as initial step for internal requested
+	 *     command.
+	 */ 
+	switch (scb->eh_state) {
+	case SCB_EH_INITIATED:
+	{
+		/* 
+		 * Validate the opcode of scb to be aborted. 
+		 * Only scb with specific opcode can be aborted.
+		 */
+		if ((SCB_GET_OPCODE(scb_to_abort) != SCB_INITIATE_SSP_TASK) &&
+	    	    (SCB_GET_OPCODE(scb_to_abort) != SCB_INITIATE_SMP_TASK) &&
+	    	    (SCB_GET_OPCODE(scb_to_abort) != 
+		     				SCB_INITIATE_LONG_SSP_TASK) &&
+	    	    (SCB_GET_OPCODE(scb_to_abort) != SCB_INITIATE_ATA_TASK) &&
+	    	    (SCB_GET_OPCODE(scb_to_abort) != SCB_INITIATE_ATAPI_TASK)) {
+			asd_log(ASD_DBG_ERROR, "Requested to abort unsupported "
+				"SCB request.\n");
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			/* 
+			 * Recursively call this function again upon changing
+		 	 * the state.
+			 */
+			asd_hwi_abort_scb(asd, scb_to_abort, scb);
+			break;
+		}
+
+		scb->platform_data->targ = scb_to_abort->platform_data->targ;
+		scb->platform_data->dev = scb_to_abort->platform_data->dev;
+		scb->eh_state = SCB_EH_ABORT_REQ;
+		asd_hwi_abort_scb(asd, (struct scb *) scb_to_abort, scb);
+		break;
+	}
+
+	case SCB_EH_ABORT_REQ:
+		/* Build the ABORT_TASK SCB. */
+		asd_hwi_build_abort_task(scb, scb_to_abort);
+
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, (void *) scb_to_abort,
+				    asd_hwi_abort_scb_done);
+		/* Post the ABORT_TASK SCB. */
+		asd_hwi_post_scb(asd, scb);
+		break;
+
+	case SCB_EH_CLR_NXS_REQ:
+		/* 
+		 * The Clear Nexus SCB has been prepared in the abort
+		 * post routine. All we need is to post it to the firmware.
+		 */
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, (void *) scb_to_abort,
+				    asd_hwi_abort_scb_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
+	
+	case SCB_EH_RESUME_SENDQ:
+		/*
+		 * We are here because the ABORT TMF failed.
+	         * We need to resume the data transmission of the task
+		 * that was going to be aborted.
+		 */	 
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_hwi_build_clear_nexus(scb, CLR_NXS_I_T_L_Q_TC,
+					  SCB_GET_INDEX(scb_to_abort),
+					  SCB_EH_RESUME_SENDQ);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, (void *) scb_to_abort,
+				    asd_hwi_abort_scb_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
+
+	case SCB_EH_DONE:
+		scb_to_abort->eh_state = scb->eh_state;
+		scb_to_abort->eh_status = scb->eh_status;
+
+		if ((scb_to_abort->eh_state == SCB_EH_DONE) && 
+		    (scb_to_abort->eh_status == SCB_EH_FAILED)) {
+			/*
+		 	 * Failed to perform abort error recovery for the
+		 	 * failed command, we shall procced with the next 
+			 * level of error recovery (Logical Unit Reset).
+			 * We need to change the scb eh_state to 
+			 * SCB_EH_LU_RESET_REQ. 
+		 	 */
+			scb_to_abort->eh_state = SCB_EH_LU_RESET_REQ;
+			scb_to_abort->platform_data->targ->flags &= 
+							~ASD_TARG_IN_RECOVERY;
+		}
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+
+	default:
+		asd_log(ASD_DBG_ERROR, "Invalid EH State 0x%x.\n",
+			scb->eh_state);
+
+		scb_to_abort->eh_state = SCB_EH_DONE;
+		scb_to_abort->eh_status = SCB_EH_FAILED;
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+	}
+}
+
+static void
+asd_hwi_abort_scb_done(struct asd_softc *asd, struct scb *scb, 
+		       struct asd_done_list *dl)
+{
+	asd_log(ASD_DBG_ERROR, "DL Opcode = 0x%x.\n", dl->opcode);
+
+	/*
+       	 * There is a possibility that this post routine is called after
+	 * the SCB timedout. So, only delete the timer if the SCB hasn't
+	 * timedout.
+	 */
+	if (scb->eh_state != SCB_EH_TIMEDOUT)
+		del_timer_sync(&scb->platform_data->timeout);
+
+	/*
+	 * This post routine is shared by ABORT_TASK and CLEAR_NEXUS
+         * issued by this abort handler code.
+ 	 * Hence, the DL opcodes also apply to both SCB task.
+	 */	 
+	switch (dl->opcode) {
+	case TASK_COMP_WO_ERR:
+	case TMF_F_W_TAG_NOT_FOUND:
+	case TMF_F_W_CONN_HNDL_NOT_FOUND:
+	case TMF_F_W_TAG_ALREADY_DONE:
+	case TMF_F_W_TAG_ALREADY_FREE:
+	case TMF_F_W_TC_NOT_FOUND:
+		/*
+		 * For SMP or STP target, firmware will only try to abort
+		 * the task if it is still in its execution queue.
+		 * If the task to be aborted couldn't be found, mostly like it
+		 * has been issued to the target.
+		 * We should try next level error recovery.
+		 */
+		if (scb->platform_data->targ->device_protocol_type
+					!= ASD_DEVICE_PROTOCOL_SCSI) {
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			break;
+		}
+		/* Fall thru */
+	case TASK_ABORTED_BY_ITNL_EXP:
+		/* Indicate that Abort succeeded. */
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_SUCCEED;
+		break;
+
+	case TASK_F_W_NAK_RCVD:
+		/* 
+		 * Indicate that Abort failed.
+		 * If this is a failure in issuing ABORT TMF, we need to 
+		 * resume the data transmission of the task that was
+		 * going to be aborted.
+		 */
+		if ((scb->eh_state & SCB_EH_SUSPEND_SENDQ) != 0)
+			scb->eh_state = SCB_EH_RESUME_SENDQ;
+		else
+			scb->eh_state = SCB_EH_DONE;
+		
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+
+	case SSP_TASK_COMP_W_RESP:
+	{
+		union edb 		*edb;
+		struct scb 		*escb;
+		struct ssp_resp_edb  	*redb;
+		struct ssp_resp_iu	*riu;
+		u_int			 edb_index;
+		
+		edb = asd_hwi_get_edb_from_dl(asd, scb, dl, &escb, &edb_index);
+		if (edb == NULL) {
+			asd_log(ASD_DBG_ERROR, "Invalid EDB recv for SSP "
+				"comp w/response.\n");
+			scb->eh_state = SCB_EH_RESUME_SENDQ;
+			scb->eh_status = SCB_EH_SUCCEED;
+			break;
+		}
+
+		/*
+		 * Search if the aborted command still pending on the firmware
+	         * queue. If so, we need to send CLEAR_NEXUS to have the 
+		 * command freed and returned to us.
+		 */	 
+		if (!asd_hwi_check_cmd_pending(asd, scb, dl)) {
+			asd_log(ASD_DBG_RUNTIME, "Aborted cmd has been "
+				"completed.\n");
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_SUCCEED;
+			asd_hwi_free_edb(asd, escb, edb_index);
+			break;
+		}
+
+		redb = &edb->ssp_resp;
+		riu = &redb->resp_frame.riu;
+		if (SSP_RIU_DATAPRES(riu) == SSP_RIU_DATAPRES_RESP) {
+			uint8_t	resp_code;
+
+			resp_code = ((struct resp_data_iu *)
+						&riu->data[0])->resp_code;
+
+			/* Handle the SSP TMF response code. */
+			asd_hwi_map_tmf_resp(scb, resp_code);
+			
+			if (scb->eh_state == SCB_EH_CLR_NXS_REQ) {
+				asd_log(ASD_DBG_ERROR,
+					"Tag to Clear=0x%x.\n",
+					asd_be16toh(redb->tag_to_clear));
+				/* 
+				 * Upon receving TMF_COMPLETE, we need to send
+				 * CLEAR_NEXUS SCB for tag_to_clear.
+				 */
+				asd_hwi_build_clear_nexus(scb, 
+							  CLR_NXS_I_T_L_Q_TAG,
+							  redb->tag_to_clear,
+							  /*ctx*/0);
+			}
+		} else {
+			/* 
+			 * Response Data not available. Protocol error.
+			 * Indicate that Abort failed. 
+			 */
+			scb->eh_state = SCB_EH_RESUME_SENDQ;
+			scb->eh_status = SCB_EH_FAILED;
+		}
+		
+		asd_hwi_free_edb(asd, escb, edb_index);
+		break;
+	}
+
+	case TASK_F_W_OPEN_REJECT:
+		scb->eh_state = SCB_EH_RESUME_SENDQ;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+
+	case RESUME_COMPLETE:
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+
+	case TASK_CLEARED:
+		/* 
+	 	 * Previous error recovery SCB that timed-out and
+	 	 * was aborted.
+	 	 * All we need to do here is just free the scb.
+	 	 */ 
+		asd_hwi_free_scb(asd, scb);
+		return;
+
+	default:
+		asd_log(ASD_DBG_ERROR, "DL opcode not handled.\n");
+		scb->eh_state = SCB_EH_RESUME_SENDQ;
+		scb->eh_status = SCB_EH_FAILED;
+		break;		
+	}
+
+	asd_hwi_abort_scb(asd, (struct scb *) scb->io_ctx, scb);
+}
+
+/*
+ * Function:
+ *	asd_hwi_reset_lu()
+ *	
+ * Description:
+ *	Issue a Logical Unit Reset to the end device.
+ *	LU Reset can only be done for SSP end device.
+ */
+static void
+asd_hwi_reset_lu(struct asd_softc *asd, struct scb *scb_to_reset,
+		 struct scb *scb)
+{
+	ASD_LOCK_ASSERT(asd);
+
+	asd_log(ASD_DBG_ERROR, "Curr State: 0x%x Status: 0x%x.\n",
+		scb->eh_state, scb->eh_status);
+
+	switch (scb->eh_state) {
+	case SCB_EH_INITIATED:
+	{
+		struct asd_target	*targ;
+		struct asd_device	*dev;
+		
+		targ = scb_to_reset->platform_data->targ;
+		dev = scb_to_reset->platform_data->dev;
+		if ((targ == NULL) || (dev == NULL)) {
+			/* This shouldn't happen. */
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			asd_hwi_reset_lu(asd, scb_to_reset, scb);
+			break;
+		}
+
+		/*
+   		 * Only SSP end device can be issued a LU reset.
+		 */
+		if (targ->device_protocol_type != ASD_DEVICE_PROTOCOL_SCSI) {
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			asd_hwi_reset_lu(asd, (struct scb *) scb_to_reset, scb);
+			break;
+		}
+
+		scb->platform_data->targ = targ;
+		scb->platform_data->dev = dev;
+		scb->eh_state = SCB_EH_LU_RESET_REQ;
+		asd_hwi_reset_lu(asd, (struct scb *) scb_to_reset, scb);	
+		break;
+	}
+
+	case SCB_EH_LU_RESET_REQ:
+		/* Build LUR Task Management Function. */
+		asd_hwi_build_ssp_tmf(scb, scb->platform_data->targ,
+				      scb->platform_data->dev->saslun,	
+				      LOGICAL_UNIT_RESET_TMF);
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, (void *) scb_to_reset,
+				    asd_hwi_reset_lu_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
+
+	case SCB_EH_CLR_NXS_REQ:
+		asd_hwi_build_clear_nexus(scb, CLR_NXS_I_T_L,
+					  (RESUME_TX | NOT_IN_Q | SEND_Q),
+					  /*ctx*/0);
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, (void *) scb_to_reset,
+				    asd_hwi_reset_lu_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
+
+	case SCB_EH_RESUME_SENDQ:
+		/*
+		 * If we failed to perform LU Reset, we need to resume
+		 * the firmware send queue for the I_T_L.
+		 */
+		asd_hwi_build_clear_nexus(scb, CLR_NXS_I_T_L,
+					  RESUME_TX, /*ctx*/0);
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, (void *) scb_to_reset,
+				    asd_hwi_reset_lu_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
+
+	case SCB_EH_DONE:
+	{
+		scb_to_reset->eh_state = scb->eh_state;
+		scb_to_reset->eh_status = scb->eh_status;
+
+		if ((scb_to_reset->eh_state == SCB_EH_DONE) &&
+		    (scb_to_reset->eh_status == SCB_EH_FAILED)) {
+			/*
+		 	 * Failed to perform LU Reset or LU Reset is not
+		 	 * supported then we shall procced with 
+			 * the next level of error recovery (Device Port Reset).
+			 * We need to change the scb eh_state to 
+			 * SCB_EH_DEV_RESET_REQ.
+		 	 */
+			scb_to_reset->eh_state = SCB_EH_DEV_RESET_REQ;
+			scb_to_reset->platform_data->targ->flags &= 
+							~ASD_TARG_IN_RECOVERY;
+		}
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+	}
+
+	default:
+		asd_log(ASD_DBG_ERROR, "Invalid EH State 0x%x.\n",
+			scb->eh_state);
+		scb_to_reset->eh_state = SCB_EH_DONE;
+		scb_to_reset->eh_status = SCB_EH_FAILED;
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+	}
+}
+
+static void
+asd_hwi_reset_lu_done(struct asd_softc *asd, struct scb *scb,
+		     struct asd_done_list *dl)
+{
+	asd_log(ASD_DBG_ERROR, "DL Opcode = 0x%x.\n", dl->opcode);
+
+	/*
+       	 * There is a possibility that this post routine is called after
+	 * the SCB timedout. So, only delete the timer if the SCB hasn't
+	 * timedout.
+	 */
+	if (scb->eh_state != SCB_EH_TIMEDOUT)
+		del_timer_sync(&scb->platform_data->timeout);
+
+	switch (dl->opcode) {
+	case TASK_COMP_WO_ERR:
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_SUCCEED;
+		break;
+
+	case TMF_F_W_TC_NOT_FOUND:
+	case TMF_F_W_TAG_NOT_FOUND:
+	case TMF_F_W_CONN_HNDL_NOT_FOUND:
+	case TASK_F_W_NAK_RCVD:
+		if ((scb->eh_state & SCB_EH_SUSPEND_SENDQ) != 0)
+			scb->eh_state = SCB_EH_RESUME_SENDQ;
+		else
+			scb->eh_state = SCB_EH_DONE;
+		
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+
+	case SSP_TASK_COMP_W_RESP:
+	{	
+		union edb 		*edb;
+		struct scb 		*escb;
+		struct ssp_resp_edb  	*redb;
+		struct ssp_resp_iu	*riu;
+		u_int			 edb_index;
+
+		edb = asd_hwi_get_edb_from_dl(asd, scb, dl, &escb, &edb_index);
+		if (edb == NULL) {
+			asd_log(ASD_DBG_ERROR, "Invalid EDB recv for SSP "
+				"comp w/response.\n");
+			scb->eh_state = SCB_EH_RESUME_SENDQ;
+			scb->eh_status = SCB_EH_FAILED;
+			break;
+		}
+		
+		redb = &edb->ssp_resp;
+		riu = &redb->resp_frame.riu;
+		if (SSP_RIU_DATAPRES(riu) == SSP_RIU_DATAPRES_RESP) {
+			uint8_t	resp_code;
+
+			resp_code = ((struct resp_data_iu *)
+						&riu->data[0])->resp_code;
+
+			/* Handle the SSP TMF response code. */
+			asd_hwi_map_tmf_resp(scb, resp_code);
+		} else {
+			/* 
+			 * Response Data not available. Protocol error.
+			 * Indicate that LUR failed.
+			 */
+			scb->eh_state = SCB_EH_RESUME_SENDQ;
+			scb->eh_status = SCB_EH_FAILED;
+		}
+
+		asd_hwi_free_edb(asd, escb, edb_index);
+		break;
+	}
+
+	case TASK_F_W_OPEN_REJECT:
+		scb->eh_state = SCB_EH_RESUME_SENDQ;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+
+	case RESUME_COMPLETE:
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+
+	case TASK_CLEARED:
+		/* 
+		 * Previous error recovery SCB that timed-out and
+		 * was aborted.
+		 * All we need to do here is just free the scb.
+		 */ 
+		asd_hwi_free_scb(asd, scb);
+		return;
+	
+	default:
+		asd_log(ASD_DBG_ERROR, "DL Opcode not handled.\n");
+		scb->eh_state = SCB_EH_RESUME_SENDQ;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+	}
+
+	asd_hwi_reset_lu(asd, (struct scb *) scb->io_ctx, scb);
+}
+
+void
+asd_hwi_map_tmf_resp(struct scb *scb, u_int resp_code)
+{
+	/* 
+	 * Handle TMF Response upon completion of issuing 
+	 * Task Management Function to the target..
+	 * Based on the response code, we will move to certain
+	 * error recovery state.
+	 */
+	switch (resp_code) {
+	case TMF_COMPLETE:
+		scb->eh_state = SCB_EH_CLR_NXS_REQ;
+		scb->eh_status = SCB_EH_SUCCEED;
+		break;
+
+	case INVALID_FRAME:
+	case TMF_FAILED:
+	case TMF_SUCCEEDED:
+	case TMF_NOT_SUPPORTED:
+	case INVALID_LUN:
+	default:
+		/* We treat all this as a failure case. */
+		scb->eh_state = SCB_EH_RESUME_SENDQ;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+	}
+}
+
+/*
+ * Function:
+ *	asd_hwi_reset_device()
+ *	
+ * Description:
+ *	Issue a device reset to the failing device.
+ */
+static void
+asd_hwi_reset_device(struct asd_softc *asd, struct scb *scb_to_reset,
+		     struct scb *scb)
+{
+	ASD_LOCK_ASSERT(asd);
+
+	asd_log(ASD_DBG_ERROR, "Curr State: 0x%x Status: 0x%x.\n",
+		scb->eh_state, scb->eh_status);
+
+	switch (scb->eh_state) {
+	case SCB_EH_INITIATED:
+	{
+		struct asd_target	*targ;
+		struct asd_device	*dev;
+
+		targ = scb_to_reset->platform_data->targ;
+		dev = scb_to_reset->platform_data->dev;
+		if ((targ == NULL) || (dev == NULL)) {
+			/* This shouldn't happen. */
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			asd_hwi_reset_device(asd, scb_to_reset, scb);
+			break;
+		}
+
+		/*
+	 	 * DC: Currently we are not handling error recovery for
+		 *     expander.
+		 *     Logic for that will be added later on.
+         	 */ 
+		if ((targ->device_protocol_type != ASD_DEVICE_PROTOCOL_SCSI) &&
+		    (targ->device_protocol_type != ASD_DEVICE_PROTOCOL_ATA)) {
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			asd_hwi_reset_device(asd, scb_to_reset, scb);
+			break;
+		}
+		
+		scb->platform_data->targ = targ;
+		scb->platform_data->dev = dev;
+
+		/* 
+		 * Saving final post routine and the scb_to_reset in
+		 * the first post stack slot. We need to access the
+		 * scb_to_reset during the device reset process.
+		 */
+		asd_push_post_stack(asd, scb, (void *) scb_to_reset,
+				    asd_hwi_reset_device_done);
+		
+		if (SCB_GET_SRC_PORT(scb_to_reset)->management_type == 
+							ASD_DEVICE_END) {
+			/* We or'ed it to remember its previous state. */
+			scb->eh_state |= SCB_EH_CLR_NXS_REQ;
+		} else {
+			/*
+			 * For device attached behind expander,
+		         * prior to device reset, we will try to
+			 * obtain the error report log of the phy
+			 * that the device is connected to.
+			 */
+			scb->eh_state = SCB_EH_PHY_REPORT_REQ;
+		}
+		asd_hwi_reset_device(asd, scb_to_reset, scb);	
+		break;
+	}
+
+	case SCB_EH_DEV_RESET_REQ:
+	{
+		struct asd_target	*targ;
+		struct asd_port		*port;
+
+		targ = scb->platform_data->targ;
+		port = SCB_GET_SRC_PORT(scb);
+		/*
+	 	 * Perform a specific device reset for device that is 
+		 * direct-attached or expander-attached.
+	 	 */
+		if (port->management_type == ASD_DEVICE_END) {
+			/* Device is directly attached to the initiator. */
+			asd_hwi_reset_end_device(asd, scb);
+		} else {
+			/* Device is attached behind expander. */
+			asd_hwi_reset_exp_device(asd, scb);
+		}
+	    	break;
+	}
+
+	case SCB_EH_PHY_NO_OP_REQ:
+	{
+		struct asd_phy	*phy;
+
+		phy = (struct asd_phy *) scb->io_ctx;
+		/*
+		 * Upon completion of HARD RESET, we need to initialize
+		 * OOB registers to enable hot-plug timer.
+		 * PHY NO OP currently only applied for direct-attached
+		 * device.
+		 */
+		asd_hwi_build_control_phy(scb, phy, PHY_NO_OP);
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, scb->io_ctx,
+				    asd_hwi_reset_end_device_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
+	}
+
+	case SCB_EH_PHY_REPORT_REQ:
+		/*
+		 * Obtain the report error log of the phy that the failing
+		 * device is connected to.
+		 * Ideally, we want to traverse the route and obtain the
+		 * error report log of each phy that has pathway to the
+		 * device.
+		 */
+		asd_hwi_report_phy_err_log(asd, scb);
+		break;
+
+	case SCB_EH_CLR_NXS_REQ:
+	case (SCB_EH_CLR_NXS_REQ|SCB_EH_INITIATED):
+	case (SCB_EH_CLR_NXS_REQ|SCB_EH_PHY_REPORT_REQ):
+		/*
+	 	 * Prior to performing Link Reset or Hard Reset to the 
+		 * target, we need to clear the firmware's execution queue
+		 * and suspend the data transimission to the target.
+	 	 */
+		if (((scb->eh_state & SCB_EH_INITIATED) != 0) ||
+		    ((scb->eh_state & SCB_EH_PHY_REPORT_REQ) != 0)) {
+			asd_hwi_build_clear_nexus(scb, CLR_NXS_IT_OR_TI,
+					  	 (SUSPEND_TX | EXEC_Q),
+						  /*ctx*/0);
+			asd_push_post_stack(asd, scb, (void *) scb_to_reset,
+					    asd_hwi_reset_device_done);
+		} else {
+			/* 
+			 * Upon completion of Device Reset, we need to issue
+			 * CLEAR NEXUS to the firmware to free up the SCB
+		         * resume data transmission.
+			 * Also, we will be using the first post stack
+			 * we save at the beginning.
+			 */
+			asd_hwi_build_clear_nexus(scb, CLR_NXS_IT_OR_TI,
+						 (RESUME_TX|SEND_Q|NOT_IN_Q),
+					  	  /*ctx*/0);
+		}
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_hwi_post_scb(asd, scb);
+		break;
+	
+	case SCB_EH_DONE:
+		scb_to_reset->eh_state = scb->eh_state;
+		scb_to_reset->eh_status = scb->eh_status;
+
+		if ((scb_to_reset->eh_state == SCB_EH_DONE) &&
+		    (scb_to_reset->eh_status == SCB_EH_FAILED)) {
+			/*
+		 	 * Failed to perform DEVICE RESET,
+			 * we shall procced with the next level of 
+			 * error recovery (Port Reset).
+			 * We need to change the scb eh_state to 
+			 * SCB_EH_PORT_RESET_REQ.
+		 	 */
+			scb_to_reset->eh_state = SCB_EH_PORT_RESET_REQ;
+			scb_to_reset->platform_data->targ->flags &= 
+							~ASD_TARG_IN_RECOVERY;
+		}
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+
+	default:
+		asd_log(ASD_DBG_ERROR, "Invalid EH State 0x%x.\n",
+			scb->eh_state);
+
+		scb_to_reset->eh_state = SCB_EH_DONE;
+		scb_to_reset->eh_status = SCB_EH_FAILED;
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+	}
+}


