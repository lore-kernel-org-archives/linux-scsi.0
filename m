From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [09/27]
Date: Thu, 17 Feb 2005 12:36:19 -0500
Message-ID: <4214D613.2000006@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:38289 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262323AbVBQRgX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:36:23 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHaMr30837
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:22 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHaMb21055
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:36:22 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hardware interface. Part 3/3.

+
+static void
+asd_hwi_reset_device_done(struct asd_softc *asd, struct scb *scb,
+			  struct asd_done_list *dl)
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
+	{	
+		if (((scb->eh_state & SCB_EH_INITIATED) != 0) ||
+		    ((scb->eh_state & SCB_EH_PHY_REPORT_REQ) != 0)) {
+			struct asd_port	*port;
+		
+			port = SCB_GET_SRC_PORT(scb);
+			if (port->management_type == ASD_DEVICE_END) {
+				/*
+		 	 	 * For direct-attached SSP target, we need to
+				 * check if it is attached on a wide port. 
+				 * If so, we need to issue a HARD RESET on 
+				 * one of the phys and LINK RESET on the 
+				 * remaining phys.
+			 	 * For direct-attached SATA/SATAPI target,
+				 * LINK RESET can be done for all the phys
+				 * belong to the port.
+				 * Get which phy(s) that need to be reset.
+		 	 	 */
+				port->reset_mask = port->conn_mask;
+			}
+			scb->eh_state = SCB_EH_DEV_RESET_REQ;
+		} else {
+			scb->eh_state = SCB_EH_DONE;
+		}
+		scb->eh_status = SCB_EH_SUCCEED;
+		break;
+	}
+
+	case TMF_F_W_TC_NOT_FOUND:
+	case TMF_F_W_TAG_NOT_FOUND:
+	case TMF_F_W_CONN_HNDL_NOT_FOUND:
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
+		asd_log(ASD_DBG_ERROR, "Unhandled DL opcode.\n");
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+	}
+
+	asd_hwi_reset_device(asd, (struct scb *) scb->io_ctx, scb);
+}
+
+/*
+ * Function:
+ *	asd_hwi_reset_end_device()
+ *	
+ * Description:
+ *	For direct-attached SATA/SATAPI target, device reset is achieved by 
+ *	issuing a Link Reset sequence (OOB).
+ *	For direct-attached SSP target, device reset is achieved by issuing
+ *	a Hard Reset.
+ */
+static void
+asd_hwi_reset_end_device(struct asd_softc *asd, struct scb *scb)
+{
+	struct asd_target	*targ;
+	struct asd_port		*port;
+	struct asd_phy		*phy;
+	int			 found;
+
+	targ = scb->platform_data->targ;
+	port = SCB_GET_SRC_PORT(scb);
+	found = 0;
+	/*
+	 * Find the associated phy that need to be reset.
+	 */
+	list_for_each_entry(phy, &port->phys_attached, links) {
+		if ((port->reset_mask & (1 << phy->id)) != 0) {
+			found = 1;
+			break;
+		}
+	}
+	if (found != 1) {
+		/* This shouldn't happen. */
+		asd_log(ASD_DBG_ERROR,"No PHY to reset, PR Mask: 0x%x "
+			"PC Mask: 0x%x.\n", port->reset_mask, port->conn_mask);
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		asd_hwi_reset_device(asd,
+				    (struct scb *) scb->post_stack[0].io_ctx,
+				     scb);
+		return;
+	}
+
+	if (targ->transport_type == ASD_TRANSPORT_SSP) {
+		/* 
+	 	 * For SSP wide port target, we need to perform a
+	 	 * HARD RESET only on one of the phys and LINK RESET
+		 * on the remaining phys.
+	 	 */
+		asd_hwi_build_control_phy(scb, phy,
+					 ((port->reset_mask == port->conn_mask)
+					  ? EXECUTE_HARD_RESET : ENABLE_PHY));
+	} else {
+		/* 
+	 	 * For SATA direct-attached end device, 
+	 	 * device port reset is done by re-Enabling the phy
+	 	 * and hence initiating OOB sequence.
+	 	 */
+		asd_hwi_build_control_phy(scb, phy, ENABLE_PHY); 	
+	}
+		
+	port->reset_mask &= ~(1 << phy->id);
+	scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+	asd_setup_scb_timer(scb, (8 * HZ), asd_scb_eh_timeout);
+	asd_push_post_stack(asd, scb, (void *) phy,
+			    asd_hwi_reset_end_device_done);
+	asd_hwi_post_scb(asd, scb);
+}
+
+static void
+asd_hwi_reset_end_device_done(struct asd_softc *asd, struct scb *scb, 
+			      struct asd_done_list *dl)
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
+	if (scb->eh_status == SCB_EH_SUCCEED) {
+		if (scb->eh_state != SCB_EH_PHY_NO_OP_REQ) {
+			/* Check if any remaining phys need to be reset. */
+			scb->eh_state =
+				((SCB_GET_SRC_PORT(scb)->reset_mask == 0) ?
+				  SCB_EH_CLR_NXS_REQ : SCB_EH_DEV_RESET_REQ);
+		}
+	} else {
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+	}
+		
+	asd_hwi_reset_device(asd, (struct scb *) scb->post_stack[0].io_ctx,
+			     scb);
+}
+
+static void
+asd_hwi_report_phy_err_log(struct asd_softc *asd, struct scb *scb)
+{
+	struct asd_port		*port;
+	struct asd_target	*exp_targ;
+	struct asd_target	*targ;
+	struct Discover		*disc;
+	int			 phy_id;
+
+	targ = scb->platform_data->targ;
+	/* Expander that the target is attached to. */
+	exp_targ = targ->parent;
+	port = SCB_GET_SRC_PORT(scb);
+
+	if (exp_targ == NULL) {
+		/* This shouldn't happen. */
+		asd_log(ASD_DBG_ERROR, "Parent Expander shouldn't be NULL.\n");
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		asd_hwi_reset_device(asd,
+				    (struct scb *) scb->post_stack[0].io_ctx,
+				     scb);
+		return;
+	}
+	/*
+	 * Find the expander phy id that the target is attached to. 
+	 */
+	for (phy_id = 0; phy_id < exp_targ->num_phys; phy_id++) {
+		disc = &(exp_targ->Phy[phy_id].Result);
+
+		if (SAS_ISEQUAL(targ->ddb_profile.sas_addr,
+				disc->AttachedSASAddress))
+			break;
+	}
+
+	if (phy_id == exp_targ->num_phys) {
+		/* This shouldn't happen. */
+		asd_log(ASD_DBG_ERROR, "Corrupted target, inv. phy id.\n");
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		asd_hwi_reset_device(asd,
+				    (struct scb *) scb->post_stack[0].io_ctx,
+				     scb);
+		return;
+	}
+
+	/* Build a REPORT PHY ERROR LOG SMP request. */
+	asd_hwi_build_smp_phy_req(port, REPORT_PHY_ERROR_LOG, phy_id, 0);
+
+	/* Build a SMP TASK. */
+	asd_hwi_build_smp_task(scb, exp_targ,
+			       port->dc.SMPRequestBusAddr,
+			       sizeof(struct SMPRequestPhyInput),
+			       port->dc.SMPResponseBusAddr,
+			       sizeof(struct SMPResponseReportPhyErrorLog));
+
+	scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+	asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+	asd_push_post_stack(asd, scb, (void *) port,
+			    asd_hwi_reset_exp_device_done);
+	asd_hwi_post_scb(asd, scb);
+}
+
+/*
+ * Function:
+ *	asd_hwi_reset_exp_device()
+ *	
+ * Description:
+ * 	For device that is attached behind an expander device, device reset
+ *	is achieved by issuing SMP PHY CONTROL with a phy operation of:
+ *	- HARD RESET for SSP and STP device port.
+ *	- LINK RESET for SATA/SATAPI device port.
+ */
+static void
+asd_hwi_reset_exp_device(struct asd_softc *asd, struct scb *scb)
+{
+	struct asd_target	*exp_targ;
+	struct asd_target	*targ;
+	struct asd_port		*port;
+	struct Discover		*disc;
+	int			 phy_id;
+
+	port = SCB_GET_SRC_PORT(scb);
+	targ = scb->platform_data->targ;
+	/* Expander that the target is attached to. */
+	exp_targ = targ->parent;
+	if (exp_targ == NULL) {
+		/* This shouldn't happen. */
+		asd_log(ASD_DBG_ERROR, "Parent Expander shouldn't be NULL.\n");
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		asd_hwi_reset_device(asd,
+				    (struct scb *) scb->post_stack[0].io_ctx,
+				     scb);
+		return;
+	}
+
+	/*
+	 * Find the expander phy id that the target is attached to. 
+	 */
+	for (phy_id = 0; phy_id < exp_targ->num_phys; phy_id++) {
+		disc = &(exp_targ->Phy[phy_id].Result);
+
+		if (SAS_ISEQUAL(targ->ddb_profile.sas_addr,
+				disc->AttachedSASAddress))
+			break;
+	}
+
+	if (phy_id == exp_targ->num_phys) {
+		/* This shouldn't happen. */
+		asd_log(ASD_DBG_ERROR, "Corrupted target, inv. phy id.\n");
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		asd_hwi_reset_device(asd,
+				    (struct scb *) scb->post_stack[0].io_ctx,
+				     scb);
+		return;
+	}
+
+	/* 
+	 * For SSP/STP target port, CONTROL PHY-HARD RESET will be issued.
+	 * For SATA/SATAPI target port, CONTROL PHY-LINK RESET will be issued.
+	 */
+	asd_hwi_build_smp_phy_req(
+		port, PHY_CONTROL, phy_id,
+		((targ->transport_type == ASD_TRANSPORT_ATA) ? LINK_RESET :
+		 					       HARD_RESET));
+
+	/* Build a SMP REQUEST. */
+	asd_hwi_build_smp_task(scb, exp_targ,
+			       port->dc.SMPRequestBusAddr,
+			       sizeof(struct SMPRequestPhyControl),
+			       port->dc.SMPResponseBusAddr,
+			       sizeof(struct SMPResponsePhyControl));
+
+	scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+	asd_setup_scb_timer(scb, (8 * HZ), asd_scb_eh_timeout);
+	asd_push_post_stack(asd, scb, (void *) port,
+			    asd_hwi_reset_exp_device_done);
+	asd_hwi_post_scb(asd, scb);
+}
+
+static void
+asd_hwi_reset_exp_device_done(struct asd_softc *asd, struct scb *scb, 
+			      struct asd_done_list *dl)
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
+	{	
+		struct asd_port	*port;
+
+		port = (struct asd_port *) scb->io_ctx;
+		/* Check the SMP Response function result. */
+		if (port->dc.SMPResponseFrame->FunctionResult ==
+			SMP_FUNCTION_ACCEPTED) {
+			if (scb->eh_state == SCB_EH_PHY_REPORT_REQ) {
+				asd_hwi_dump_phy_err_log(port, scb);
+				scb->eh_state = SCB_EH_DONE;
+			} else {
+				scb->eh_state = SCB_EH_CLR_NXS_REQ;
+			}
+			scb->eh_status = SCB_EH_SUCCEED;
+		} else {
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+		}
+		break;
+	}
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
+	case TASK_F_W_SMPRSP_TO:
+	case TASK_F_W_SMP_XMTRCV_ERR:
+	default:
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+		break;
+	}
+
+	asd_hwi_reset_device(asd, (struct scb *) scb->post_stack[0].io_ctx,
+			     scb);
+}
+
+static void
+asd_hwi_dump_phy_err_log(struct asd_port *port, struct scb *scb)
+{
+	struct SMPResponseReportPhyErrorLog 	*report_phy_log;
+	struct asd_target			*targ;
+	struct asd_device			*dev;
+
+	report_phy_log = (struct SMPResponseReportPhyErrorLog *)
+				&(port->dc.SMPResponseFrame->Response);
+	targ = scb->platform_data->targ;
+	dev = scb->platform_data->dev;
+
+	asd_print("REPORT PHY ERROR LOG\n");
+	asd_print("---------------------\n");
+	asd_print("Phy #%d of Expander 0x%llx.\n",
+		  report_phy_log->PhyIdentifier, asd_be64toh(
+		  *((uint64_t *) targ->parent->ddb_profile.sas_addr)));
+	asd_print("Attached device:\n"); 
+	asd_print("Scsi %d Ch %d Tgt %d Lun %d, SAS Addr: 0x%llx.\n",
+		  targ->softc->platform_data->scsi_host->host_no,
+		  dev->ch, dev->id, dev->lun, asd_be64toh(
+		  *((uint64_t *) targ->ddb_profile.sas_addr)));
+	asd_print("\nPHY ERROR COUNTS\n");
+	asd_print("----------------\n");
+	asd_print("Invalid Dword Count: %d.\n",
+		  report_phy_log->InvalidDuint16_tCount);
+	asd_print("Disparity Error Count: %d.\n",
+		  report_phy_log->DisparityErrorCount);
+	asd_print("Loss of Dword Synchronization Count: %d.\n",
+		  report_phy_log->LossOfDuint16_tSynchronizationCount);
+	asd_print("Phy Reset Problem Count: %d.\n",
+		  report_phy_log->PhyResetProblemCount);
+}
+
+/*
+ * Function:
+ *	asd_hwi_reset_port()
+ *	
+ * Description:
+ *	Issue a HARD/LINK RESET to the failing port.
+ */
+static void
+asd_hwi_reset_port(struct asd_softc *asd, struct scb *scb_to_reset,
+		   struct scb *scb)
+{
+	ASD_LOCK_ASSERT(asd);
+
+	asd_log(ASD_DBG_ERROR, "Curr State: 0x%x Status: 0x%x.\n",
+		scb->eh_state, scb->eh_status);
+
+	switch (scb->eh_state) {
+	case SCB_EH_INITIATED:
+	{
+		struct asd_port		*port;
+		struct asd_target	*targ;
+		
+		port = SCB_GET_SRC_PORT(scb_to_reset);
+		if (port == NULL) {
+			asd_log(ASD_DBG_ERROR," Invalid port to reset.\n");
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_state = SCB_EH_FAILED;
+			asd_hwi_reset_port(asd, scb_to_reset, scb);
+			break;
+		}
+		/* 
+		 * Freeze all the targets' queue attached to the port that
+		 * we are about to reset.
+		 */
+		list_for_each_entry(targ, &port->targets, all_domain_targets) {
+			targ->qfrozen++;
+		}
+
+		/* 
+		 * Saving final post routine and the scb_to_reset in
+		 * the first post stack slot. We need to access the
+		 * scb_to_reset during the device reset process.
+		 */
+		asd_push_post_stack(asd, scb, (void *) scb_to_reset,
+				    asd_hwi_reset_port_done);
+		
+		/* Bitmask of the phys to perform reset. */
+		port->reset_mask = port->conn_mask;
+		scb->platform_data->targ = scb_to_reset->platform_data->targ;
+		scb->platform_data->dev = scb_to_reset->platform_data->dev;
+		scb->eh_state = SCB_EH_CLR_NXS_REQ;
+		asd_hwi_reset_port(asd, scb_to_reset, scb);
+		break;
+	}
+	
+	case SCB_EH_CLR_NXS_REQ:
+		asd_hwi_build_clear_nexus(scb, CLR_NXS_I_OR_T,
+				  	  /*parm*/0, /*ctx*/0);
+		asd_push_post_stack(asd, scb, (void *) scb_to_reset,
+				    asd_hwi_reset_port_done);
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_hwi_post_scb(asd, scb);
+		break;
+
+	case SCB_EH_PORT_RESET_REQ:
+	{
+		struct asd_port	*port;
+		struct asd_phy	*phy;
+		int		 found;
+
+		found = 0;
+		port = SCB_GET_SRC_PORT(scb_to_reset);
+		list_for_each_entry(phy, &port->phys_attached, links) {
+			if ((port->reset_mask & (1 << phy->id)) != 0) {
+				found = 1;
+				break;
+			}
+		}
+		if (found != 1) {
+			/* This shouldn't happen. */
+			asd_log(ASD_DBG_ERROR,"No PHY to reset, PR Mask: 0x%x "
+				"PC Mask: 0x%x.\n",
+				port->reset_mask, port->conn_mask);
+			scb->eh_state = SCB_EH_DONE;
+			scb->eh_status = SCB_EH_FAILED;
+			asd_hwi_reset_port(asd, scb_to_reset, scb);
+			break;
+		}
+		/* 
+	 	 * For SSP initiator wide port, we need to perform a
+		 * HARD RESET only on one of the phys and LINK RESET on
+		 * the remaining phys.
+	 	 */
+		asd_hwi_build_control_phy(scb, phy,
+					 ((port->reset_mask == port->conn_mask)
+					  ? EXECUTE_HARD_RESET : ENABLE_PHY));
+
+		port->reset_mask &= ~(1 << phy->id);
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (8 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, (void *) phy,
+				    asd_hwi_reset_port_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
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
+		 */
+		asd_hwi_build_control_phy(scb, phy, PHY_NO_OP);
+		scb->flags |= (SCB_INTERNAL | SCB_ACTIVE | SCB_RECOVERY);
+		asd_setup_scb_timer(scb, (4 * HZ), asd_scb_eh_timeout);
+		asd_push_post_stack(asd, scb, scb->io_ctx,
+				    asd_hwi_reset_port_done);
+		asd_hwi_post_scb(asd, scb);
+		break;
+	}
+
+	case SCB_EH_DONE:
+	{
+		struct asd_port		*port;
+		struct asd_target	*targ;
+
+		port = SCB_GET_SRC_PORT(scb_to_reset);
+		
+		/* Unfreeze all the targets. */
+		list_for_each_entry(targ, &port->targets, all_domain_targets) {
+			targ->qfrozen--;
+		}
+		scb_to_reset->eh_state = scb->eh_state;
+		scb_to_reset->eh_status = scb->eh_status;
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+	}
+
+	default:
+		asd_log(ASD_DBG_ERROR, "Invalid State.\n");
+		scb_to_reset->eh_state = SCB_EH_DONE;
+		scb_to_reset->eh_status = SCB_EH_FAILED;
+		asd_hwi_free_scb(asd, scb);
+		asd_wakeup_sem(&asd->platform_data->ehandler_sem);
+		break;
+	}
+}
+
+static void
+asd_hwi_reset_port_done(struct asd_softc *asd, struct scb *scb, 
+			struct asd_done_list *dl)
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
+	/* CLR NXS completion. */
+	if (dl->opcode == TASK_COMP_WO_ERR) {
+		scb->eh_state = SCB_EH_PORT_RESET_REQ;
+	} else if (scb->eh_status == SCB_EH_SUCCEED) {
+		if (scb->eh_state != SCB_EH_PHY_NO_OP_REQ) {
+			/* Check if any remaining phys need to be reset. */
+			scb->eh_state =
+				((SCB_GET_SRC_PORT(scb)->reset_mask == 0) ?
+				  SCB_EH_DONE : SCB_EH_PORT_RESET_REQ);
+		}
+	} else {
+		scb->eh_state = SCB_EH_DONE;
+		scb->eh_status = SCB_EH_FAILED;
+	}
+		
+	asd_hwi_reset_port(asd,
+			  (struct scb *) scb->post_stack[0].io_ctx,
+			   scb);
+}
+
+/*************************** NVRAM access utilities ***************************/
+
+#if NVRAM_SUPPORT
+
+
+/*
+ * Function:
+ *	asd_hwi_poll_nvram()
+ *
+ * Description:
+ *	This routine will poll for the NVRAM to be ready to accept new
+ *	command.
+ */
+static int
+asd_hwi_poll_nvram(struct asd_softc *asd)
+{
+	uint8_t	nv_data;
+	uint8_t	toggle_data;
+	int loop_cnt;
+
+	loop_cnt = 5000;
+
+	while (loop_cnt) {
+		nv_data = asd_hwi_swb_read_byte(asd, 
+						asd->hw_profile.nv_flash_bar);
+
+		toggle_data = (nv_data ^ asd_hwi_swb_read_byte(asd,
+						asd->hw_profile.nv_flash_bar));
+
+		if (toggle_data == 0) {
+			return (0);
+		} else {
+	  		if (((toggle_data == 0x04) && ((loop_cnt - 1) == 0)) ||
+			   ((toggle_data & 0x40) && (toggle_data & 0x20))) {
+				return (-1);
+			}
+		}
+	
+		loop_cnt--;
+		asd_delay(ASD_DELAY_COUNT);
+	}
+	return (-1);
+}
+
+static int
+asd_hwi_chk_write_status(struct asd_softc *asd, uint32_t sector_addr, 
+			uint8_t erase_flag) 
+{
+	uint32_t read_addr;
+	uint32_t loop_cnt;
+	uint8_t	nv_data1, nv_data2;
+	uint8_t	toggle_bit1/*, toggle_bit2*/;
+
+	/* 
+	 * Read from DQ2 requires sector address 
+	 * while it's dont care for DQ6 
+	 */
+	/* read_addr = asd->hw_profile.nv_flash_bar + sector_addr;*/
+	read_addr = asd->hw_profile.nv_flash_bar;
+	loop_cnt = 50000;
+
+	while (loop_cnt) {
+		nv_data1 = asd_hwi_swb_read_byte(asd, read_addr); 
+		nv_data2 = asd_hwi_swb_read_byte(asd, read_addr); 
+
+		toggle_bit1 = ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6)
+				 ^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
+		/* toggle_bit2 = ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ2) 
+				^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ2));*/
+
+		if (toggle_bit1 == 0) {
+			return (0);
+		} else {
+			if (nv_data2 & FLASH_STATUS_BIT_MASK_DQ5) {
+				nv_data1 = asd_hwi_swb_read_byte(asd, 
+								read_addr); 
+				nv_data2 = asd_hwi_swb_read_byte(asd,
+								read_addr); 
+				toggle_bit1 = 
+				((nv_data1 & FLASH_STATUS_BIT_MASK_DQ6) 
+				^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ6));
+				/*
+				toggle_bit2 = 
+				   ((nv_data1 & FLASH_STATUS_BIT_MASK_DQ2) 
+				   ^ (nv_data2 & FLASH_STATUS_BIT_MASK_DQ2));
+				*/
+				if (toggle_bit1 == 0) {
+					return 0;
+				}
+			}
+		}
+		loop_cnt--;
+	
+		/* 
+		 * ERASE is a sector-by-sector operation and requires
+		 * more time to finish while WRITE is byte-byte-byte
+		 * operation and takes lesser time to finish. 
+		 *
+		 * For some strange reason a reduced ERASE delay gives different
+		 * behaviour across different spirit boards. Hence we set
+		 * a optimum balance of 50mus for ERASE which works well
+		 * across all boards.
+		 */ 
+		if (erase_flag) {
+			asd_delay(FLASH_STATUS_ERASE_DELAY_COUNT);
+		} else {
+			asd_delay(FLASH_STATUS_WRITE_DELAY_COUNT);
+		}
+	}
+	return (-1);
+}
+/*
+ * Function:
+ *	asd_hwi_reset_nvram()
+ *
+ * Description:
+ *	Reset the NVRAM section.
+ */
+static int
+asd_hwi_reset_nvram(struct asd_softc *asd)
+{
+	/* Poll till NVRAM is ready for new command. */
+	if (asd_hwi_poll_nvram(asd) != 0)
+		return (-1);
+
+	asd_hwi_swb_write_byte(asd, asd->hw_profile.nv_flash_bar, NVRAM_RESET);
+
+	/* Poll if the command is successfully written. */
+	if (asd_hwi_poll_nvram(asd) != 0)
+		return (-1);	
+
+	return (0);
+}
+
+/*
+ * Function:
+ * 	asd_hwi_search_nv_cookie()
+ *
+ * Description:
+ *	Search the cookie in NVRAM.
+ *	If found, return the address offset of the cookie.
+ */
+int
+asd_hwi_search_nv_cookie(struct asd_softc *asd, uint32_t *addr,
+			struct asd_flash_dir_layout *pflash_dir_buf)
+{
+	struct asd_flash_dir_layout flash_dir;
+	uint8_t		 cookie_to_find[32]="*** ADAPTEC FLASH DIRECTORY *** ";
+	void		*dest_buf;
+	uint32_t	 nv_addr;
+	int		 cookie_found;
+	u_int		 bytes_read;
+
+	memset(&flash_dir, 0x0, sizeof(flash_dir));
+	dest_buf = &flash_dir;
+	cookie_found = 0;
+	nv_addr = 0;
+	while (nv_addr < NVRAM_MAX_BASE_ADR) {
+		if (asd_hwi_read_nv_segment(asd, NVRAM_NO_SEGMENT_ID,
+					    dest_buf, nv_addr,
+					    sizeof(flash_dir), 
+					    &bytes_read)
+					    != 0)
+			return (-1);
+
+		if (memcmp(flash_dir.cookie,
+			   &cookie_to_find[0],
+			   NVRAM_COOKIE_SIZE) == 0) {
+			cookie_found = 1;
+			if (pflash_dir_buf != NULL) {
+				memcpy(pflash_dir_buf, &flash_dir, 
+					sizeof(flash_dir));
+			}
+			break;
+		}
+
+		nv_addr += NVRAM_NEXT_ENTRY_OFFSET;
+	}
+	if (cookie_found == 0) {
+		return (-1);
+	}
+	
+	*addr = nv_addr;
+	asd->hw_profile.nv_cookie_addr = nv_addr;
+	asd->hw_profile.nv_cookie_found = 1;
+
+	return (0);
+}
+
+/*
+ * Function:
+ * 	asd_hwi_search_nv_segment()
+ *
+ * Description:
+ *	Search the requested NVRAM segment.
+ *	If exists, the segment offset, attributes, pad_size and image_size
+ *	will be returned.
+ */
+int
+asd_hwi_search_nv_segment(struct asd_softc *asd, u_int segment_id,
+			  uint32_t *offset, uint32_t *pad_size,
+			  uint32_t *image_size, uint32_t *attr)
+{
+	struct asd_flash_dir_layout 	flash_dir;
+	struct asd_fd_entry_layout 	fd_entry;
+	uint32_t			nv_addr;
+	int				segment_found;
+	u_int				bytes_read;
+	u_int				i;
+
+	/*
+	 * Check if we have NVRAM base addr for the FLASH directory layout.
+	 */
+	if (asd->hw_profile.nv_cookie_found != 1) {
+		if (asd_hwi_search_nv_cookie(asd, &nv_addr,
+					&flash_dir) != 0) {
+			asd_log(ASD_DBG_ERROR, "Failed to search NVRAM "
+				"cookie.\n");
+			return (-1);
+		}
+	} else {
+	    nv_addr = asd->hw_profile.nv_cookie_addr;
+	}
+		    
+	nv_addr += NVRAM_FIRST_DIR_ENTRY;
+	memset(&fd_entry, 0x0, sizeof(struct asd_fd_entry_layout));
+	segment_found = 0;
+
+	for (i = 0; i < NVRAM_MAX_ENTRIES; i++) {
+		if (asd_hwi_read_nv_segment(asd, NVRAM_NO_SEGMENT_ID,
+					&fd_entry, nv_addr,
+					sizeof(struct asd_fd_entry_layout),
+					&bytes_read) != 0) {
+			return (-1);
+		}
+
+		if ((fd_entry.attr & FD_ENTRYTYPE_CODE) == segment_id) {
+			segment_found = 1;
+			break;
+		}
+
+		nv_addr += sizeof(struct asd_fd_entry_layout);
+	}
+
+	if (segment_found == 0) {
+		return (-1);
+	}
+
+	*offset = fd_entry.offset;
+	*pad_size = fd_entry.pad_size;
+	*attr = ((fd_entry.attr & FD_SEGMENT_ATTR) ? 1 : 0);
+
+	if ((segment_id != NVRAM_CTRL_A_SETTING) &&
+		(segment_id != NVRAM_MANUF_TYPE)) {
+		*image_size = fd_entry.image_size;
+	} else {
+		*image_size = NVRAM_INVALID_SIZE;
+	}
+
+	return (0);
+}
+
+/*
+ * Function:
+ *	asd_hwi_read_nv_segment()
+ *
+ * Description:
+ *	Retrieves data from an NVRAM segment.
+ */
+int
+asd_hwi_read_nv_segment(struct asd_softc *asd, uint32_t segment_id, void *dest,
+			uint32_t src_offset, uint32_t bytes_to_read,
+			uint32_t *bytes_read)
+{
+    	uint8_t		*dest_buf;
+    	uint32_t	 nv_offset;
+	uint32_t	 pad_size, image_size, attr;
+	uint32_t	 i;
+
+	/* Reset the NVRAM. */
+	if (asd_hwi_reset_nvram(asd) != 0)
+		return (-1);
+
+	nv_offset = 0;
+	if (segment_id != NVRAM_NO_SEGMENT_ID) {
+		if (asd_hwi_search_nv_segment(asd, segment_id, &nv_offset,
+					      &pad_size, &image_size,
+					      &attr) != 0) {
+			return (-1);
+		}
+	}
+	nv_offset = asd->hw_profile.nv_flash_bar + nv_offset + src_offset;
+
+	dest_buf = (uint8_t *) dest;
+	*bytes_read = 0;
+
+	if (asd_hwi_reset_nvram(asd) != 0)
+		return (-1);
+
+	for (i = 0; i < bytes_to_read; i++) {
+		*(dest_buf + i) = asd_hwi_swb_read_byte(asd, (nv_offset + i));
+		if (asd_hwi_poll_nvram(asd) != 0) {
+			return (-1);
+		}
+	}
+	*bytes_read = i;
+
+	return (0); 
+}
+
+/*
+ * Function:
+ *	asd_hwi_write_nv_segment()
+ *
+ * Description:
+ *	Writes data to an NVRAM segment.
+ */
+int
+asd_hwi_write_nv_segment(struct asd_softc *asd, void *src, uint32_t segment_id, 
+			uint32_t dest_offset, uint32_t bytes_to_write)
+{
+    	uint8_t	*src_buf;
+	uint32_t nv_offset, nv_flash_bar, i;
+	uint32_t pad_size, image_size, attr;
+
+	nv_flash_bar = asd->hw_profile.nv_flash_bar;
+	src_buf = NULL;
+	nv_offset = 0;
+	attr = 0;
+	pad_size = 0;
+	image_size = 0;
+
+	if (asd_hwi_reset_nvram(asd) != 0) {
+		return (-1);
+	}
+	if (segment_id != NVRAM_NO_SEGMENT_ID) {
+		if (asd_hwi_search_nv_segment(asd, segment_id, &nv_offset, 
+				&pad_size, &image_size, &attr) != 0) {
+			return (-1);
+		}
+		if ((bytes_to_write > pad_size) || (dest_offset != 0)) {
+			return (-1);
+		}
+	}
+
+	nv_offset += dest_offset;
+	if (segment_id == NVRAM_NO_SEGMENT_ID 
+	   || attr == NVRAM_SEGMENT_ATTR_ERASEWRITE) {
+		if (asd_hwi_erase_nv_sector(asd, nv_offset) != 0) {
+			printk("<1>adp94xx: Erase failed at offset:0x%x\n",
+				nv_offset);
+			return (-1);
+		}
+	}
+
+	if (asd_hwi_reset_nvram(asd) != 0) {
+		return (-1);
+	}
+	src_buf = (uint8_t *)src;
+	for (i = 0; i < bytes_to_write; i++) {
+		/* Setup program command sequence */
+		switch (asd->hw_profile.flash_dev_id) {
+		case FLASH_DEV_ID_AM29LV800D:
+		{
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0xAAA), 0xAA);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x555), 0x55);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0xAAA), 0xA0);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + nv_offset + i),
+					(*(src_buf + i)));
+			break;
+		}
+		case FLASH_DEV_ID_AM29LV008B:
+		{
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x555), 0xAA);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x2AA), 0x55);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x555), 0xA0);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + nv_offset + i),
+					(*(src_buf + i)));
+			break;
+		}
+		default:
+			break;
+		}
+		if (asd_hwi_chk_write_status(asd, (nv_offset + i), 
+			0 /* WRITE operation */) != 0) {
+			printk("<1>adp94xx: Write failed at offset:0x%x\n",
+				nv_flash_bar + nv_offset + i);
+			return -1;
+		}
+	}
+
+#if 0
+	/* Add padding to the image. */
+	for (i = bytes_to_write; i < pad_size; i++) {
+		switch (asd->hw_profile.flash_dev_id) {
+		case FLASH_DEV_ID_AM29LV800D:
+		{
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0xAAA), 0xAA);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x555), 0x55);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x555), 0xA0);
+			break;
+		}
+		case FLASH_DEV_ID_AM29LV008B:
+		{
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x555), 0xAA);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x2AA), 0x55);
+			asd_hwi_swb_write_byte(asd, 
+					(nv_flash_bar + 0x555), 0xA0);
+			break;
+		}
+		default:
+			break;
+		}
+		asd_hwi_swb_write_byte(asd, 
+				      (nv_flash_bar + nv_offset + i),
+				       0);
+		if (asd_hwi_poll_nvram(asd) != 0)
+			return (-1);
+	}
+#endif
+
+#if 0
+	/* Why is this required for program command sequence ?? */
+	/* Unlock bypass reset. */
+	asd_hwi_swb_write_byte(asd, nv_flash_bar, 0x90);
+	asd_hwi_swb_write_byte(asd, nv_flash_bar, 0x00);
+#endif
+	if (asd_hwi_reset_nvram(asd) != 0) {
+		return (-1);
+	}
+	return (0);
+}
+
+/*
+ * Function:
+ *	asd_hwi_erase_nv_sector()
+ *
+ * Description:
+ *	Erase the requested NVRAM sector.
+ */
+static int
+asd_hwi_erase_nv_sector(struct asd_softc *asd, uint32_t sector_addr) 
+{
+	uint32_t nv_flash_bar;
+	
+	nv_flash_bar = asd->hw_profile.nv_flash_bar; 
+	if (asd_hwi_poll_nvram(asd) != 0) {
+		return (-1);
+	}
+	/*
+	 * Erasing an NVRAM sector needs to be done in six consecutive
+	 * write cyles.
+	 */
+	switch (asd->hw_profile.flash_dev_id) {
+	case FLASH_DEV_ID_AM29LV800D:
+	{
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0xAAA), 0xAA);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0x55);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0xAAA), 0x80);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0xAAA), 0xAA);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0x55);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + sector_addr), 0x30);
+		break;
+	}
+	case FLASH_DEV_ID_AM29LV008B:
+	{
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0xAA);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x2AA), 0x55);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0x80);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0xAA);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x2AA), 0x55);
+		asd_hwi_swb_write_byte(asd, (nv_flash_bar + sector_addr), 0x30);
+		break;
+	}
+	default:
+		break;
+	}
+
+	if (asd_hwi_chk_write_status(asd, sector_addr, 
+				1 /* ERASE operation */) != 0) {
+		return (-1);
+	}
+	return (0);
+}
+
+/*
+ * Function:
+ * 	asd_hwi_verify_nv_checksum()
+ *	
+ * Description:
+ *	Verify if the checksum for particular NV segment is correct.
+ */		 	  
+static int
+asd_hwi_verify_nv_checksum(struct asd_softc *asd, u_int segment_id,
+			   uint8_t *segment_ptr, u_int bytes_to_read)
+{
+	uint32_t		offset;
+	u_int			pad_size;
+	u_int			image_size;
+	u_int			attr;
+	u_int			bytes_read;
+	int			checksum_bytes;
+	uint16_t		sum;
+	uint16_t		*seg_ptr;
+	u_short			i;
+	
+	if (asd_hwi_search_nv_segment(asd, segment_id, &offset, &pad_size,
+				      &image_size, &attr) != 0) {
+		asd_log(ASD_DBG_ERROR, "Requested segment not found in "
+			"the NVRAM.\n");
+		return (-1);
+	}
+
+	memset(segment_ptr, 0x0, bytes_to_read);
+	if (asd_hwi_read_nv_segment(asd, NVRAM_NO_SEGMENT_ID, segment_ptr,
+				    offset, bytes_to_read, &bytes_read) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to read NVRAM segment %d.\n",
+			NVRAM_NO_SEGMENT_ID);
+		return (-1);
+	}
+
+	if (asd_hwi_reset_nvram(asd) != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed to reset NVRAM.\n");
+		return (-1);
+	}
+
+	seg_ptr = (uint16_t *) segment_ptr;
+	/*
+	 * checksum_bytes is equivalent to the size of the layout.
+         * The size of layout is available at the offset of 8.
+	 */	 
+	checksum_bytes = (*(seg_ptr + 4) / 2);
+	offset += asd->hw_profile.nv_flash_bar;
+	sum = 0;
+	
+	for (i = 0; i < checksum_bytes; i++)
+		sum += asd_hwi_swb_read_word(asd, (offset + (i*2)));
+
+	if (sum != 0) {
+		asd_log(ASD_DBG_ERROR, "Checksum verification failed.\n");
+		return (-1);
+	}
+
+	return (0);
+}
+
+/*
+ * Function:
+ * 	asd_hwi_get_nv_config() 
+ *
+ * Description:
+ *	Retrieves NVRAM configuration for the controller.
+ */	   
+static int
+asd_hwi_get_nv_config(struct asd_softc  *asd)
+{
+	struct asd_manuf_base_seg_layout manuf_layout;
+	struct asd_pci_layout	pci_layout;
+	uint32_t		offset;
+	u_int			bytes_read;
+
+	if (asd_hwi_check_flash(asd) < 0) 
+		return -1;
+
+	asd->hw_profile.nv_exist = 0;
+	/* Verify if the controller NVRAM has CTRL_A_SETTING type. */
+	if (asd_hwi_verify_nv_checksum(asd, NVRAM_CTRL_A_SETTING,
+				       (uint8_t *) &pci_layout,
+				       sizeof(struct asd_pci_layout)) != 0) {
+		/* 
+		 * CTRL_A type verification failed, verify if the controller  
+		 * has NVRAM CTRL_A_DEFAULT type.
+		 */  
+		if (asd_hwi_verify_nv_checksum(asd, NVRAM_CTRL_A_DEFAULT,
+					       (uint8_t *) &pci_layout, 
+					       sizeof(struct asd_pci_layout))
+					       != 0)
+			return (-1);
+
+		asd->hw_profile.nv_segment_type = NVRAM_CTRL_A_DEFAULT;
+	} else {
+		asd->hw_profile.nv_segment_type = NVRAM_CTRL_A_SETTING;
+		asd->hw_profile.nv_exist = 1;
+	}
+
+	offset = 0;
+	memset(&manuf_layout, 0x0, sizeof (struct asd_manuf_base_seg_layout));
+
+	/* Retrieves Controller Manufacturing NVRAM setting. */
+	if (asd_hwi_read_nv_segment(asd, NVRAM_MANUF_TYPE, &manuf_layout,
+			    offset, sizeof(struct asd_manuf_base_seg_layout),
+			    &bytes_read) != 0) {
+		return (-1);
+	}
+
+	memcpy(asd->hw_profile.wwn, manuf_layout.base_sas_addr, 
+	       ASD_MAX_WWN_LEN);
+
+	return (0);
+}	
+
+/*
+ * Function:
+ * 	asd_hwi_search_nv_id()
+ *
+ * Description:
+ * 	Search for the requested NV setting ID. If successful copy contents
+ * 	to the destination buffer and set appropriate value in offset.
+ */
+static int
+asd_hwi_search_nv_id(struct asd_softc  *asd, u_int setting_id, void *dest,
+		     u_int  *src_offset, u_int bytes_to_read)
+{
+	struct asd_settings_layout *psettings;
+	uint32_t offset;
+	int bytes_read;
+
+	offset = 0;
+	bytes_read = 0;
+	psettings = (struct asd_settings_layout *)dest;
+	while (1) {
+		
+        	if (asd_hwi_read_nv_segment(asd, 
+				    asd->hw_profile.nv_segment_type, 
+				    psettings,
+				    offset, 
+				    bytes_to_read,
+				    &bytes_read) != 0) {
+			return (-1);
+		}
+
+		if (psettings->id == setting_id) {
+            		break;
+        	} else {
+			
+            		if (psettings->next_ptr == 0)
+				return -1;
+			offset = (uint32_t)offset + psettings->next_ptr;
+		}
+	}
+	*src_offset = offset;
+	return (0);
+}
+
+static int
+asd_hwi_get_nv_phy_settings(struct asd_softc *asd)
+{
+	struct asd_phy_settings_layout phy_settings;
+	struct asd_phy_settings_entry_layout *phy_entry;
+	uint32_t		offset;
+	uint32_t		bytes_to_read;
+	struct asd_phy		*phy;
+	u_int			bytes_read;
+	u_int		 	phy_id;
+	u_char		 	settings_found;
+
+	if (asd->hw_profile.nv_exist != 1)
+		return -1;
+	/*
+	 * NVRAM setting exists, retrieve Phys user settings, such 
+	 * as SAS address, connection rate, and attributes.
+	 */  
+	
+	offset = 0;
+	settings_found = 0;
+	if (asd_hwi_search_nv_id(asd, NVRAM_PHY_SETTINGS_ID, 
+			&phy_settings, &offset, sizeof(phy_settings))) {
+		return -1;
+	}
+
+	bytes_to_read = phy_settings.num_phys * sizeof(*phy_entry);
+	if ((phy_entry = asd_alloc_mem(bytes_to_read, GFP_ATOMIC)) 
+	   == NULL) {
+		return (-1);
+	}
+
+	if (asd_hwi_read_nv_segment(asd, 
+		    asd->hw_profile.nv_segment_type, 
+		    phy_entry,
+		    offset + sizeof(phy_settings),
+		    bytes_to_read,
+		    &bytes_read) != 0) {
+		asd_free_mem(phy_entry);
+		return (-1);
+	} else {
+		settings_found = 1;
+	}
+
+	if (settings_found == 1) {
+		asd->hw_profile.max_phys = phy_settings.num_phys;
+		for (phy_id = 0; 
+		     phy_id < asd->hw_profile.max_phys; 
+		     phy_id++) {
+			
+			if ((phy = asd->phy_list[phy_id]) == NULL)
+				continue;
+			
+			memcpy(phy->sas_addr, 
+			       phy_entry[phy_id].sas_addr,
+			       SAS_ADDR_LEN);
+			/* 
+			 * if an invalid link rate is specified,
+			 * the existing default value is used. 
+			 */
+			asd_hwi_map_lrate_from_sas(
+				(phy_entry[phy_id].link_rate 
+				 & PHY_MIN_LINK_RATE_MASK),
+				&phy->min_link_rate);
+
+			asd_hwi_map_lrate_from_sas(
+				((phy_entry[phy_id].link_rate
+				 & PHY_MAX_LINK_RATE_MASK) >> 4),
+				&phy->max_link_rate);
+			/* TBD: crc */
+		}
+	}
+	
+	asd_free_mem(phy_entry);
+	return 0;
+}
+
+static void
+asd_hwi_get_nv_phy_params(struct asd_softc *asd)
+{
+	struct asd_manuf_base_seg_layout   manuf_layout;	
+	struct asd_manuf_phy_param_layout  phy_param;
+	struct asd_phy_desc_format	  *pphy_desc;
+	struct asd_phy			  *phy;
+	uint32_t 	 		   offset;
+	uint32_t	 		   bytes_to_read;
+	uint32_t 	 		   bytes_read;
+	u_int 		 		   phy_id;
+	
+	/* Set the phy parms to the default value. */
+	for (phy_id = 0; phy_id < asd->hw_profile.max_phys; phy_id++) {
+		if ((phy = asd->phy_list[phy_id]) == NULL)
+			continue;
+
+		phy->phy_state = PHY_STATE_DEFAULT;
+		phy->phy_ctl0 = PHY_CTL0_DEFAULT;
+		phy->phy_ctl1 = PHY_CTL1_DEFAULT;
+		phy->phy_ctl2 = PHY_CTL2_DEFAULT;
+		phy->phy_ctl3 = PHY_CTL3_DEFAULT;
+	}
+
+	if (asd_hwi_verify_nv_checksum(asd, NVRAM_MANUF_TYPE,
+				       (uint8_t *) &manuf_layout,
+				       sizeof(struct asd_manuf_base_seg_layout))
+				       != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed verifying checksum for "
+			"NVRAM MANUFACTURING LAYOUT.\n");
+		goto exit;
+	}
+
+	offset = 0;
+	memset(&phy_param, 0x0, sizeof(phy_param));
+
+	if (asd_hwi_get_nv_manuf_seg(asd, &phy_param,
+				     sizeof(phy_param), &offset,
+				     NVRAM_MNF_PHY_PARAM_SIGN) != 0)
+		goto exit;
+
+	if (phy_param.num_phy_desc > asd->hw_profile.max_phys)
+		phy_param.num_phy_desc = asd->hw_profile.max_phys;
+	
+	bytes_to_read = phy_param.num_phy_desc * phy_param.phy_desc_size;
+	if ((pphy_desc = asd_alloc_mem(bytes_to_read, GFP_ATOMIC)) == NULL)
+		goto exit;
+
+	offset += sizeof(phy_param);
+	if (asd_hwi_read_nv_segment(asd, NVRAM_MANUF_TYPE, pphy_desc, offset,
+				    bytes_to_read, &bytes_read) != 0) {
+		asd_free_mem(pphy_desc);
+		goto exit;
+	}
+
+	for (phy_id = 0; phy_id < asd->hw_profile.max_phys; phy_id++) {
+		if ((phy = asd->phy_list[phy_id]) == NULL)
+			continue;
+
+		phy->phy_state = (pphy_desc[phy_id].state & PHY_STATE_MASK);
+		phy->phy_ctl0 &= ~PHY_CTL0_MASK;
+		phy->phy_ctl0 |= (pphy_desc[phy_id].ctl0 & PHY_CTL0_MASK);
+		phy->phy_ctl1 = pphy_desc[phy_id].ctl1;
+		phy->phy_ctl2 = pphy_desc[phy_id].ctl2;
+		phy->phy_ctl3 = pphy_desc[phy_id].ctl3;
+	}
+
+	asd_free_mem(pphy_desc);
+exit:	
+	return;
+}
+
+/*
+ * Function:
+ *	asd_hwi_get_nv_conn_info
+ *
+ * Description:
+ * 	This routine reads the Connector Map information from Flash (NVRAM)
+ * 	and allocates memory and populates the parameters 'pconn' 
+ * 	and 'pnoded' with the read information. 
+ *
+ * 	At the end of this routine if everything goes fine the data structure 
+ * 	layout pointed to by 'pconn' and 'pnoded' will be:
+ *
+ * 	'pconn' ->
+ * 	|-----------|--------------|--------------|--------
+ * 	| Connector | Connector    | Connector    | ...
+ * 	| Map 	    | Descriptor 0 | Descriptor 1 | 
+ * 	|-----------|--------------|--------------|--------
+ * 	
+ * 	'pnoded' ->
+ * 	|--------|--------|--------|---  --|-------|--------|--------|----
+ * 	| Node   | Phy    | Phy    |...    | Node  | Phy    | Phy    | ...
+ * 	| Desc 0 | Desc 0 | Desc 1 |       | Desc 1| Desc 0 | Desc 1 |
+ * 	|--------|--------|--------|---  --|-------|--------|--------|----
+ *
+ * 	'pconn_size' will hold the size of data pointed to by 'pconn' 
+ * 	'pnoded_size' will hold the size of data pointed to by 'pnoded'. 
+ * 	
+ */
+int
+asd_hwi_get_nv_conn_info(struct asd_softc *asd,
+			 uint8_t **pconn,
+			 uint32_t *pconn_size,
+			 uint8_t **pnoded,
+			 uint32_t *pnoded_size)
+{
+	struct asd_manuf_base_seg_layout   manuf_layout;	
+	struct asd_conn_map_format conn_map;
+	struct asd_node_desc_format node_desc;
+	//struct asd_conn_desc_format *pconn_desc;
+	uint8_t *pconn_buf; 
+	uint8_t *pnode_buf; 
+	uint32_t offset, cur_offset;
+	uint32_t bytes_to_read, bytes_read;
+	uint32_t bytes_count, tot_count;
+	uint32_t node_num;
+	
+	if (pconn == NULL || pnoded == NULL || pconn_size == NULL 
+	   || pnoded_size == NULL) {
+		return -1;
+	}
+
+	if (asd_hwi_verify_nv_checksum(asd, NVRAM_MANUF_TYPE,
+				       (uint8_t *) &manuf_layout,
+				       sizeof(manuf_layout))
+				       != 0) {
+		asd_log(ASD_DBG_ERROR, "Failed verifying checksum for "
+			"NVRAM MANUFACTURING LAYOUT.\n");
+		return -1;
+	}
+
+	/* 
+	 * Determine the memory size to be allocated by reading
+	 * the connector_map first
+	 */
+	offset = 0;
+	memset(&conn_map, 0x0, sizeof(conn_map));
+	if (asd_hwi_get_nv_manuf_seg(asd, &conn_map, 
+				sizeof(conn_map), &offset,
+				NVRAM_MNF_CONN_MAP) != 0){
+		return (-1);
+	}
+	
+	bytes_to_read = sizeof(conn_map) 
+			+ conn_map.num_conn_desc * conn_map.conn_desc_size;
+	
+	/* 
+	 * Now read connector_map and associated connector_decriptor entries
+	 */
+	*pconn_size = bytes_to_read;
+	if ((pconn_buf = asd_alloc_mem(bytes_to_read, GFP_ATOMIC)) 
+	   == NULL) {
+		return (-1);
+	}
+	memset(pconn_buf, 0, bytes_to_read);
+	if (asd_hwi_read_nv_segment(asd, NVRAM_MANUF_TYPE,
+				pconn_buf, offset,
+				bytes_to_read,
+				&bytes_read) != 0) {
+		asd_free_mem(pconn_buf);
+		return (-1);
+	}
+
+	/* bypass all read connector_map & connector_descriptor entries */
+	offset += (bytes_read + 1);
+	
+	/* no field in connector map yet */
+	bytes_to_read = sizeof(node_desc); 
+
+	/* 
+	 * Determine memory to be allocated for reading node descriptors
+	 * and their associated phy descriptor entries
+	 */
+	bytes_count = 0;
+	tot_count = 0;
+	cur_offset = offset;
+	for (node_num = 0; node_num < conn_map.num_node_desc; node_num++) {
+		if (asd_hwi_read_nv_segment(asd, NVRAM_MANUF_TYPE,
+					&node_desc, cur_offset,
+					bytes_to_read,
+					&bytes_read) != 0) {
+			asd_free_mem(pconn_buf);
+			return (-1);
+		}
+		bytes_count = (sizeof(node_desc) 
+				+ (node_desc.num_phy_desc 
+				   * node_desc.phy_desc_size));
+		cur_offset += bytes_count;
+		tot_count += bytes_count;
+	}
+	bytes_to_read = tot_count;
+	
+	/* 
+	 * Now read node descriptors and their 
+	 * associated phy descriptor entries
+	 */
+	if ((pnode_buf = asd_alloc_mem(bytes_to_read, GFP_ATOMIC)) 
+	   == NULL) {
+		asd_free_mem(pconn_buf);
+		return (-1);
+	}
+	if (asd_hwi_read_nv_segment(asd, NVRAM_MANUF_TYPE,
+				pnode_buf, offset,
+				bytes_to_read,
+				&bytes_read) != 0) {
+		asd_free_mem(pconn_buf);
+		asd_free_mem(pnode_buf);
+		return (-1);
+	}
+
+	/* Caller has to free the resources */
+	*pconn = pconn_buf;
+	*pnoded = pnode_buf;
+	*pnoded_size = tot_count;
+
+	return 0;
+}
+
+static int
+asd_hwi_get_nv_manuf_seg(struct asd_softc *asd, void *dest, 
+			 uint32_t bytes_to_read, uint32_t *src_offset,
+			 uint16_t signature) 
+{
+	struct asd_manuf_base_seg_layout manuf_layout;
+	uint32_t 			 offset;
+	uint32_t 			 bytes_read;
+	int				 segments_size;
+	int				 segment_off;
+	int 				 err;
+	
+	memset(&manuf_layout, 0x0, sizeof(manuf_layout));
+	err = -1;
+	offset = 0;
+
+	/* Retrieve Manufacturing Base segment */
+	if (asd_hwi_read_nv_segment(asd, NVRAM_MANUF_TYPE, &manuf_layout,
+				    offset, sizeof(manuf_layout), 
+				    &bytes_read) != 0) {
+		return err;
+	}
+
+	/* Retrieve Manufacturing segment specified by signature */
+	offset = manuf_layout.seg_sign.next_seg_ptr;
+	segments_size = manuf_layout.sector_size - sizeof(manuf_layout); 
+	segment_off = offset;
+
+	while (1) {
+		if (asd_hwi_read_nv_segment(asd, NVRAM_MANUF_TYPE,
+					    dest, offset, bytes_to_read,
+					    &bytes_read) != 0) {
+			return (-1);
+		}
+
+		if (((struct asd_manuf_seg_sign *) dest)->signature ==
+			signature) {
+			*src_offset = offset;
+			err = 0;
+			break;
+		}
+		
+		/*
+		 * If next_seg_ptr is 0 then it indicates the last segment.
+		 */
+		if (((struct asd_manuf_seg_sign *) dest)->next_seg_ptr == 0)
+			break;
+
+		offset = ((struct asd_manuf_seg_sign *) dest)->next_seg_ptr;
+	}
+
+	return err;
+}
+
+static int
+asd_hwi_map_lrate_from_sas(u_int sas_link_rate, 
+		u_int *asd_link_rate)
+{
+	switch (sas_link_rate) {
+	case SAS_RATE_30GBPS:
+		*asd_link_rate = SAS_30GBPS_RATE; 
+		break;
+	case SAS_RATE_15GBPS:
+		*asd_link_rate = SAS_15GBPS_RATE;
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+static int
+asd_hwi_set_speed_mask(u_int asd_link_rate, 
+				  uint8_t *asd_speed_mask)
+{
+	switch (asd_link_rate) {
+	case SAS_60GBPS_RATE:
+		*asd_speed_mask &= ~SAS_SPEED_60_DIS; 
+		break;
+	case SAS_15GBPS_RATE:
+		*asd_speed_mask &= ~SAS_SPEED_15_DIS; 
+		break;
+	case SAS_30GBPS_RATE:
+	default:
+		*asd_speed_mask &= ~SAS_SPEED_30_DIS; 
+		break;
+	}
+
+	return 0;
+}
+
+static int
+asd_hwi_get_ocm_info(struct asd_softc  *asd)
+{
+	struct asd_ocm_entry_format ocm_de;
+	struct asd_bios_chim_format *pbios_chim;
+	uint32_t offset, bytes_read, bytes_to_read;
+
+	if (asd_hwi_get_ocm_entry(asd, OCM_DE_BIOS_CHIM, 
+				  &ocm_de, &offset) != 0) {
+		return -1;
+	}
+
+	bytes_to_read = OCM_DE_OFFSET_SIZE_CONV(ocm_de.size);
+	if ((pbios_chim = asd_alloc_mem(bytes_to_read, GFP_ATOMIC)) 
+	   == NULL) {
+		return (-1);
+	}
+	if (asd_hwi_read_ocm_seg(asd, pbios_chim, 
+		OCM_DE_OFFSET_SIZE_CONV(ocm_de.offset), 
+		bytes_to_read, 
+		&bytes_read) != 0) {
+		asd_free_mem(pbios_chim);
+		return -1;
+	}
+	if (pbios_chim->signature == OCM_BC_BIOS_SIGN) {
+		if (pbios_chim->bios_present 
+		   & OCM_BC_BIOS_PRSNT_MASK) {
+			asd->hw_profile.bios_maj_ver = 
+					pbios_chim->bios_maj_ver;
+			asd->hw_profile.bios_min_ver = 
+					pbios_chim->bios_min_ver;
+			asd->hw_profile.bios_bld_num = 
+					pbios_chim->bios_bld_num;
+		}
+	}
+
+	asd->unit_elements = asd_alloc_mem(pbios_chim->num_elements * 
+		sizeof(struct asd_unit_element_format), GFP_ATOMIC);
+
+	if (asd->unit_elements == NULL) {
+		asd_free_mem(pbios_chim);
+		return 0;
+	}
+
+	asd->num_unit_elements = pbios_chim->num_elements;
+
+	memcpy(asd->unit_elements, &pbios_chim->unit_elm[0],
+		pbios_chim->num_elements * 
+			sizeof(struct asd_unit_element_format));
+
+	asd_free_mem(pbios_chim);
+
+	return 0;
+}
+
+static int
+asd_hwi_get_ocm_entry(struct asd_softc  *asd, 
+				 uint32_t entry_type, 
+				 struct asd_ocm_entry_format *pocm_de, 
+				 uint32_t *src_offset)
+{
+	struct asd_ocm_dir_format ocm_dir;
+	uint32_t offset, entry_no;
+	u_int bytes_read;
+	int err;
+
+	memset(&ocm_dir, 0x0, sizeof (ocm_dir));
+	memset(pocm_de, 0x0, sizeof (*pocm_de));
+	offset = 0;
+	err = -1;
+	
+	if (asd_hwi_read_ocm_seg(asd, &ocm_dir, offset, 
+		sizeof(ocm_dir), &bytes_read)) {
+		return -1;
+	}
+
+	if ((ocm_dir.signature != OCM_DIR_SIGN) 
+	   /*|| ((ocm_dir.num_entries & OCM_NUM_ENTRIES_MASK) == 0)*/) {
+		return -1;
+	}
+
+	offset = sizeof(ocm_dir);
+	for (entry_no = 0; 
+	     entry_no < (ocm_dir.num_entries & OCM_NUM_ENTRIES_MASK); 
+	     entry_no++, offset += sizeof(*pocm_de)) {
+		if (asd_hwi_read_ocm_seg(asd, pocm_de, offset, 
+			sizeof(*pocm_de), &bytes_read)) {
+			return -1;
+		}
+		if (pocm_de->type == entry_type) {
+			err = 0;
+			break;
+		}
+	}
+	*src_offset = offset;
+	return err;
+}
+
+static int
+asd_hwi_read_ocm_seg(struct asd_softc *asd, void *dest,
+			uint32_t src_offset, u_int bytes_to_read,
+			u_int *bytes_read)
+{
+    	uint8_t		*dest_buf;
+    	uint32_t	 nv_offset;
+	uint32_t	 i;
+	
+	nv_offset = 0;
+	nv_offset = OCM_BASE_ADDR + nv_offset + src_offset;
+	
+	dest_buf = (uint8_t *) dest;
+	*bytes_read = 0;
+	
+	for (i = 0; i < bytes_to_read; i++) {
+		*(dest_buf+i) = asd_hwi_swb_read_byte(asd, (nv_offset + i));
+	}
+	*bytes_read = i - 1;
+
+	return (0); 
+}
+
+static int asd_hwi_check_flash(struct asd_softc *asd) 
+{
+	uint32_t nv_flash_bar;
+	uint32_t exsi_base_addr;
+	uint32_t reg_contents;
+	uint8_t manuf_id;
+	uint8_t dev_id_boot_blk;
+	uint8_t sec_prot;
+
+	/* get Flash memory base address */
+	asd->hw_profile.nv_flash_bar = 
+				asd_pcic_read_dword(asd, PCIC_FLASH_MBAR);
+	nv_flash_bar = asd->hw_profile.nv_flash_bar; 
+
+	/* check presence of flash */	
+	exsi_base_addr = EXSI_REG_BASE_ADR + EXSICNFGR;
+	reg_contents = asd_hwi_swb_read_dword(asd, exsi_base_addr);
+	if (!(reg_contents & FLASHEX)) {
+		asd->hw_profile.flash_present = FALSE;
+		return -1;
+	}
+	asd->hw_profile.flash_present = TRUE;
+	
+	/* Determine flash info */
+	if (asd_hwi_reset_nvram(asd) != 0)
+		return (-1);
+
+	asd->hw_profile.flash_manuf_id = FLASH_MANUF_ID_UNKNOWN;
+	asd->hw_profile.flash_dev_id = FLASH_DEV_ID_UNKNOWN;
+
+	/* Issue Unlock sequence for AM29LV800D */
+ 	asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0xAAA), 0xAA);
+ 	asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0x55);
+
+	/* Issue the erase command */
+	asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0xAAA), 0x90);
+
+	manuf_id = asd_hwi_swb_read_byte(asd, nv_flash_bar);
+	dev_id_boot_blk = asd_hwi_swb_read_byte(asd, nv_flash_bar + 1);
+	sec_prot = asd_hwi_swb_read_byte(asd, nv_flash_bar + 2);
+
+	if (asd_hwi_reset_nvram(asd) != 0)
+		return (-1);
+
+	if ((manuf_id == (uint8_t)FLASH_MANUF_ID_AMD 
+	   && sec_prot == (uint8_t)FLASH_DEV_ID_AM29LV800D)){
+		/* TBD: check the data order */
+		asd->hw_profile.flash_manuf_id = manuf_id;
+		asd->hw_profile.flash_dev_id = sec_prot;
+		//asd->hw_profile.flash_wr_prot = ;
+		return 0; 
+	}
+	
+	if (asd_hwi_reset_nvram(asd) != 0)
+		return (-1);
+
+	/* Issue Unlock sequence for AM29LV008BT */
+	asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0xAA);
+	asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x2AA), 0x55);
+
+	asd_hwi_swb_write_byte(asd, (nv_flash_bar + 0x555), 0x90);
+
+	manuf_id = asd_hwi_swb_read_byte(asd, nv_flash_bar);
+	dev_id_boot_blk = asd_hwi_swb_read_byte(asd, nv_flash_bar + 1);
+	sec_prot = asd_hwi_swb_read_byte(asd, nv_flash_bar + 2);
+	
+	if (asd_hwi_reset_nvram(asd) != 0)
+		return (-1);
+	
+	if ((manuf_id == (uint8_t)FLASH_MANUF_ID_AMD 
+	    && dev_id_boot_blk == (uint8_t)FLASH_DEV_ID_AM29LV008B)){
+		asd->hw_profile.flash_manuf_id = manuf_id;
+		asd->hw_profile.flash_dev_id = dev_id_boot_blk;
+		asd->hw_profile.flash_wr_prot = sec_prot;
+		return 0;
+	}
+
+ 	return -1;
+}
+#endif /* NVRAM_SUPPORT */
+
+int
+asd_hwi_control_activity_leds(struct asd_softc *asd, uint8_t phy_id, 
+			      uint32_t asd_phy_ctl_func)
+{
+	uint32_t	exsi_base_addr;
+	uint32_t	reg_contents;
+	uint32_t	reg_data;
+	
+	if (asd->hw_profile.rev_id != AIC9410_DEV_REV_B0) 
+		return -EINVAL;
+
+	if (phy_id >= ASD_MAX_XDEVLED_BITS)
+		return -EINVAL;
+
+	reg_data = 0;
+
+	/* set the bit map corresponding to phy_id */
+	reg_data = (1 << phy_id);
+
+	/* Enable/Disable activity LED for the PHY */
+	exsi_base_addr = EXSI_REG_BASE_ADR + GPIOOER;
+	reg_contents = asd_hwi_swb_read_dword(asd, exsi_base_addr);
+
+	if (asd_phy_ctl_func == DISABLE_PHY) {
+		reg_contents &= ~reg_data;
+	} else {
+		if (asd_phy_ctl_func == ENABLE_PHY
+		   || asd_phy_ctl_func == ENABLE_PHY_NO_SAS_OOB
+		   || asd_phy_ctl_func == ENABLE_PHY_NO_SATA_OOB ) {
+			reg_contents |= reg_data;
+		}
+	}
+	asd_hwi_swb_write_dword(asd, exsi_base_addr, reg_contents);
+	
+	/* Set activity source to external/internal */
+	exsi_base_addr = EXSI_REG_BASE_ADR + GPIOCNFGR;
+	reg_contents = asd_hwi_swb_read_dword(asd, exsi_base_addr);
+
+	if (asd_phy_ctl_func == DISABLE_PHY) {
+		reg_contents &= ~reg_data;
+	} else {
+		if (asd_phy_ctl_func == ENABLE_PHY
+		   || asd_phy_ctl_func == ENABLE_PHY_NO_SAS_OOB
+		   || asd_phy_ctl_func == ENABLE_PHY_NO_SATA_OOB ) {
+			reg_contents |= reg_data;
+		}
+	}
+	asd_hwi_swb_write_dword(asd, exsi_base_addr, reg_contents);
+
+	return 0;
+}
+



