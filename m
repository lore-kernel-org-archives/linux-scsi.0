From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [04/27]
Date: Thu, 17 Feb 2005 12:35:42 -0500
Message-ID: <4214D5EE.9050801@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:62608 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262322AbVBQRfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:35:47 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZkr30406
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:46 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHZjb20847
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:35:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is the SAS domain discovery code. Part 2/3.

+
+DISCOVER_RESULTS
+asd_issue_phy_control_post(struct state_machine_context * sm_contextp,
+			   struct asd_target * expander)
+{
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if ((discover_contextp->openStatus != OPEN_ACCEPT) ||
+	    (discover_contextp->SMPResponseFrame->FunctionResult !=
+	     SMP_FUNCTION_ACCEPTED)) {
+		/*
+		 * if we had a problem on this  link, then don't 
+		 * bother to  do anything else, production code,
+		 * should be more robust...
+		 */
+		asd_log(ASD_DBG_ERROR, "\n"
+			"phy control error, %02Xh at %0llx\n",
+			discover_contextp->SMPResponseFrame->FunctionResult,
+			*((uint64_t *) expander->ddb_profile.sas_addr));
+
+		return DISCOVER_FAILED;
+	}
+
+	return DISCOVER_OK;
+}
+
+/* -------------------------------------------------------------------------- */
+
+/*
+ * Standard inquiry command
+ */
+static uint8_t inquiry_cmd[] = {
+	INQUIRY, 0x00, 0x00, 0x00, 0x00, 0x00
+};
+
+/*
+ * Device ID
+ */
+static uint8_t inquiry_dev_id_cmd[] = {
+	INQUIRY, 0x01, 0x83, 0x00, 0x00, 0x00
+};
+
+/*
+ * Unit Serial Number
+ */
+static uint8_t inquiry_USN_cmd[] = {
+	INQUIRY, 0x01, 0x80, 0x00, 0x00, 0x00
+};
+
+#define MAX_INQUIRY_LEN(a)	(((a) > 255) ? 255 : (a))
+
+DISCOVER_RESULTS
+asd_issue_inquiry(struct state_machine_context *sm_contextp,
+		  struct asd_target *target,
+		  uint8_t * command, unsigned command_len)
+{
+	struct discover_context *discover_contextp;
+	unsigned xfer_len;
+	DISCOVER_RESULTS results;
+	uint8_t icmd[SCB_EMBEDDED_CDB_SIZE];
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	xfer_len = MAX_INQUIRY_LEN(discover_contextp->sas_info_len);
+
+	memcpy(icmd, command, command_len);
+
+	*((uint16_t *) & icmd[3]) = asd_htobe16(xfer_len);
+
+	results = asd_ssp_request(sm_contextp, target, icmd, command_len,
+				  discover_contextp->SASInfoBusAddr, xfer_len,
+				  DATA_DIR_INBOUND);
+
+	return results;
+}
+
+/* -------------------------------------------------------------------------- */
+
+uint8_t report_luns_cmd[] = {
+	REPORT_LUNS, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+};
+
+DISCOVER_RESULTS
+asd_issue_report_luns(struct state_machine_context * sm_contextp,
+		      struct asd_target * target)
+{
+	struct discover_context *discover_contextp;
+	DISCOVER_RESULTS results;
+	uint8_t rl_cmd[SCB_EMBEDDED_CDB_SIZE];
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	memcpy(rl_cmd, report_luns_cmd, sizeof(report_luns_cmd));
+
+	*((uint32_t *) & rl_cmd[6]) =
+	    asd_htobe32(discover_contextp->sas_info_len);
+
+	results = asd_ssp_request(sm_contextp, target,
+				  rl_cmd, sizeof(report_luns_cmd),
+				  discover_contextp->SASInfoBusAddr,
+				  discover_contextp->sas_info_len,
+				  DATA_DIR_INBOUND);
+
+	return results;
+}
+
+/* -------------------------------------------------------------------------- */
+
+#define CONTROL_MODE_PAGE_SIZE		0x08
+
+uint8_t mode_sense_port_control_cmd[] = {
+	MODE_SENSE, 0x00, 0x19, 0x00, 0x00, 0x00
+};
+
+DISCOVER_RESULTS
+asd_issue_get_port_control(struct state_machine_context * sm_contextp,
+			   struct asd_target * target)
+{
+	struct discover_context *discover_contextp;
+	DISCOVER_RESULTS results;
+	uint8_t pc_cmd[SCB_EMBEDDED_CDB_SIZE];
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	memcpy(pc_cmd, mode_sense_port_control_cmd,
+	       sizeof(mode_sense_port_control_cmd));
+
+	pc_cmd[4] = CONTROL_MODE_PAGE_SIZE;
+
+	results = asd_ssp_request(sm_contextp, target,
+				  pc_cmd, sizeof(mode_sense_port_control_cmd),
+				  discover_contextp->SASInfoBusAddr,
+				  CONTROL_MODE_PAGE_SIZE, DATA_DIR_INBOUND);
+
+	return results;
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_InitSMP_SM_Context {
+	struct list_head *discover_listp;
+	struct asd_target *currentTarget;
+};
+
+ASD_DISCOVERY_STATES
+asd_state_init_smp_start(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSMP_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		asd_log(ASD_DBG_INFO, "%s:%d - %llx %d\n",
+			__FUNCTION__, __LINE__,
+			*((uint64_t *) ctx->currentTarget->
+			  ddb_profile.sas_addr),
+			ctx->currentTarget->ddb_profile.conn_rate);
+
+		if (ctx->currentTarget->command_set_type == ASD_COMMAND_SET_SMP) {
+
+			return ASD_STATE_INIT_SMP_REPORT_MANUFACTURER_INFO;
+		}
+	}
+
+	return ASD_STATE_INIT_SMP_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_state_init_smp_report_manufacturer_info(struct state_machine_context *
+					    sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSMP_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_report_manufacturer_info(sm_contextp,
+						     ctx->currentTarget);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_smp_report_manufacturer_info_post(struct state_machine_context *
+						 sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSMP_SM_Context *ctx;
+	struct discover_context *discover_contextp;
+	DISCOVER_RESULTS results;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_report_manufacturer_info_post(sm_contextp,
+							  ctx->currentTarget);
+
+	if (results != DISCOVER_OK) {
+		printk("could not get manufactur_info from device\n");
+	}
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->command_set_type == ASD_COMMAND_SET_SMP) {
+
+			return ASD_STATE_INIT_SMP_REPORT_MANUFACTURER_INFO;
+		}
+	}
+
+	return ASD_STATE_INIT_SMP_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_InitSMP_SM_Initialize(struct state_machine_context * sm_contextp,
+			  void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_InitSMP_SM_Context *ctx;
+	struct asd_InitSMP_SM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_InitSMP_SM_Arguments *)init_args;
+
+	ctx->discover_listp = args->discover_listp;
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_InitSMP_SM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSMP_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_INIT_SMP_START:
+		new_state = asd_state_init_smp_start(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SMP_REPORT_MANUFACTURER_INFO:
+		new_state =
+		    asd_state_init_smp_report_manufacturer_info_post
+		    (sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_INIT_SMP_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+
+	case ASD_STATE_INIT_SMP_REPORT_MANUFACTURER_INFO:
+		results =
+		    asd_state_init_smp_report_manufacturer_info(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SMP_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_InitSMP_SM_Finish(struct state_machine_context *sm_contextp,
+		      DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_InitSMP_SM_Arguments *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(results);
+}
+
+void asd_InitSMP_SM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSMP_SM_Arguments *ctx;
+	ASD_DISCOVERY_STATES current_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+#if 0
+	switch (current_state) {
+	}
+#endif
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_InitSAS_SM_Context {
+	struct list_head *discover_listp;
+	struct asd_target *currentTarget;
+	unsigned phyIndex;
+};
+
+ASD_DISCOVERY_STATES
+asd_state_init_sas_start(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		asd_log(ASD_DBG_INFO, "%s:%d - %llx %d\n",
+			__FUNCTION__, __LINE__,
+			*((uint64_t *) ctx->currentTarget->
+			  ddb_profile.sas_addr),
+			ctx->currentTarget->ddb_profile.conn_rate);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_INQUIRY;
+		}
+	}
+
+	return ASD_STATE_INIT_SAS_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_state_init_sas_inquiry(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_inquiry(sm_contextp, ctx->currentTarget,
+				    inquiry_cmd, sizeof(inquiry_cmd));
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sas_inquiry_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	unsigned inquiry_response_len;
+	struct discover_context *discover_contextp;
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		printk("Inquiry failed\n");
+
+	} else {
+
+		inquiry_response_len =
+		    MAX_INQUIRY_LEN(discover_contextp->sas_info_len) -
+		    discover_contextp->resid_len;
+
+		ctx->currentTarget->scsi_cmdset.inquiry = (uint8_t *)
+		    asd_alloc_mem(inquiry_response_len, GFP_KERNEL);
+
+		if (ctx->currentTarget->scsi_cmdset.inquiry != NULL) {
+
+			memcpy(ctx->currentTarget->scsi_cmdset.inquiry,
+			       &discover_contextp->SASInfoFrame[0],
+			       inquiry_response_len);
+
+#if 0
+			printk("%8.8s | ",
+			       &ctx->currentTarget->scsi_cmdset.inquiry[8]);
+			printk("%16.16s | ",
+			       &ctx->currentTarget->scsi_cmdset.inquiry[16]);
+			printk("%4.4s\n",
+			       &ctx->currentTarget->scsi_cmdset.inquiry[32]);
+#endif
+		}
+	}
+
+	return ASD_STATE_INIT_SAS_GET_DEVICE_ID;
+}
+
+DISCOVER_RESULTS
+asd_state_init_get_device_id(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_inquiry(sm_contextp, ctx->currentTarget,
+				    inquiry_dev_id_cmd,
+				    sizeof(inquiry_dev_id_cmd));
+
+	return results;
+}
+
+#define ASSOCIATION_SCSI_LOGICAL_UNIT		0
+#define ASSOCIATION_SCSI_TARGET_PORT		1
+#define ASSOCIATION_SCSI_TARGET_DEVICE		2
+
+#define PIV_VALID				0x80
+#define VPD_SAS_PROTOCOL			6
+
+ASD_DISCOVERY_STATES
+asd_state_init_get_device_id_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	uint8_t *vpd_page_header;
+	uint8_t *vpd_pagep;
+	unsigned page_length;
+	unsigned identifier_type;
+	unsigned offset;
+	unsigned association;
+	unsigned code_set;
+	unsigned protocol;
+	unsigned length;
+	struct discover_context *discover_contextp;
+	unsigned inquiry_response_len;
+	unsigned piv_valid;
+#if 0
+	unsigned i;
+#endif
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		return ASD_STATE_INIT_SAS_GET_SERIAL_NUMBER;
+	}
+
+	vpd_page_header = &discover_contextp->SASInfoFrame[0];
+
+	inquiry_response_len =
+	    MAX_INQUIRY_LEN(discover_contextp->sas_info_len) -
+	    discover_contextp->resid_len;
+
+	page_length = MIN(asd_be16toh(*((uint16_t *) & vpd_page_header[2])) + 3,
+			  inquiry_response_len);
+
+#if 0
+	for (i = 0; i < page_length; i++) {
+		printk("%02x ", vpd_page_header[i]);
+
+		if (((i + 1) % 16) == 0) {
+			printk("\n");
+		}
+	}
+#endif
+
+	vpd_pagep = &vpd_page_header[4];
+
+	for (offset = vpd_pagep - vpd_page_header; offset < page_length;
+	     vpd_pagep = vpd_pagep + length,
+	     offset = vpd_pagep - vpd_page_header) {
+
+		length = vpd_pagep[3] + 3;
+
+		if ((offset + length) > page_length) {
+			break;
+		}
+
+		identifier_type = vpd_pagep[1] & 0xf;
+
+#if 0
+		switch (identifier_type & 0xf) {
+		case IDENTIFIER_TYPE_VENDOR_SPECIFIC:
+			printk("IDENTIFIER_TYPE_VENDOR_SPECIFIC\n");
+			break;
+		case IDENTIFIER_TYPE_T10:
+			printk("IDENTIFIER_TYPE_T10\n");
+			break;
+		case IDENTIFIER_TYPE_EIU_64:
+			printk("IDENTIFIER_TYPE_EIU_64\n");
+			break;
+		case IDENTIFIER_TYPE_NAA:
+			printk("IDENTIFIER_TYPE_NAA\n");
+			break;
+		case IDENTIFIER_TYPE_RELATIVE_TARGET_PORT:
+			printk("IDENTIFIER_TYPE_RELATIVE_TARGET_PORT\n");
+			break;
+		case IDENTIFIER_TYPE_TARGET_PORT_GROUP:
+			printk("IDENTIFIER_TYPE_TARGET_PORT_GROUP\n");
+			break;
+		case IDENTIFIER_TYPE_LOGICAL_UNIT_GROUP:
+			printk("IDENTIFIER_TYPE_LOGICAL_UNIT_GROUP\n");
+			break;
+		case IDENTIFIER_TYPE_MD5_LOGICAL_UNIT:
+			printk("IDENTIFIER_TYPE_MD5_LOGICAL_UNIT\n");
+			break;
+		case IDENTIFIER_TYPE_SCSI_NAME_STRING:
+			printk("IDENTIFIER_TYPE_SCSI_NAME_STRING\n");
+			break;
+		default:
+			printk("UNKNOWN\n");
+			break;
+		}
+#endif
+		if ((identifier_type & 0xf) != IDENTIFIER_TYPE_NAA) {
+
+			vpd_pagep = vpd_pagep + length;
+
+			continue;
+		}
+
+		protocol = (vpd_pagep[0] & 0xf0) >> 4;
+		piv_valid = vpd_pagep[1] & PIV_VALID;
+		code_set = vpd_pagep[0] & 0xf;
+		association = (vpd_pagep[1] & 0x30) >> 4;
+
+#if 0
+		printk("Association %d | ", association);
+		printk("Code Set %d | ", code_set);
+		printk("PIV Valid %d | ", piv_valid);
+		printk("Protocol %d\n", protocol);
+#endif
+
+		ctx->currentTarget->scsi_cmdset.ident_len = length - 3;
+
+		switch (association) {
+		case ASSOCIATION_SCSI_LOGICAL_UNIT:
+			// seagate
+			if (vpd_pagep[1] & PIV_VALID) {
+				continue;
+			}
+			break;
+
+		case ASSOCIATION_SCSI_TARGET_PORT:
+			// fujitsu
+			if (((piv_valid & PIV_VALID) != PIV_VALID) ||
+			    (protocol != VPD_SAS_PROTOCOL)) {
+				continue;
+			}
+			break;
+
+		case ASSOCIATION_SCSI_TARGET_DEVICE:
+			if (piv_valid & PIV_VALID) {
+				continue;
+			}
+		}
+
+		ctx->currentTarget->scsi_cmdset.ident = (uint8_t *)
+		    asd_alloc_mem(ctx->currentTarget->scsi_cmdset.ident_len,
+				  GFP_KERNEL);
+
+		if (ctx->currentTarget->scsi_cmdset.ident != NULL) {
+
+			memcpy(ctx->currentTarget->scsi_cmdset.ident,
+			       &vpd_pagep[4],
+			       ctx->currentTarget->scsi_cmdset.ident_len);
+		}
+	}
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_INQUIRY;
+		}
+	}
+
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		asd_log(ASD_DBG_INFO, "%s:%d - %llx %d\n",
+			__FUNCTION__, __LINE__,
+			*((uint64_t *) ctx->currentTarget->
+			  ddb_profile.sas_addr),
+			ctx->currentTarget->ddb_profile.conn_rate);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_ISSUE_REPORT_LUNS;
+		}
+	}
+
+	return ASD_STATE_INIT_SAS_FINISHED;
+}
+
+static const char *asd_vpd_warning = "Warning: This device does not support "
+"INQUIRY VPD Page 83h commmand which is required by the SAS spec. In addition, "
+"this device does not support the optional INQUIRY VPD Page 80h. Devices that "
+"do not support either of these commands may experience file corruption and "
+"data loss. Please upgrade your firmware.";
+
+DISCOVER_RESULTS
+asd_state_init_get_serial_number(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_inquiry(sm_contextp, ctx->currentTarget,
+				    inquiry_USN_cmd, sizeof(inquiry_USN_cmd));
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_get_serial_number_post(struct state_machine_context *
+				      sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	uint8_t *vpd_pagep;
+	unsigned page_length;
+	unsigned i;
+	unsigned serial_number_len;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		printk("%s\n", asd_vpd_warning);
+
+#ifdef NO_VPD_WORKAROUND
+		//TODO: free the ident field when the target is destroyed
+
+		ctx->currentTarget->scsi_cmdset.ident_len = sizeof(uint64_t);
+
+		ctx->currentTarget->scsi_cmdset.ident = (uint8_t *)
+		    asd_alloc_mem(sizeof(uint64_t), GFP_KERNEL);
+
+		if (ctx->currentTarget->scsi_cmdset.ident != NULL) {
+
+			*(uint64_t *) ctx->currentTarget->scsi_cmdset.ident =
+			    asd_be64toh(*((uint64_t *) ctx->currentTarget->
+					  ddb_profile.sas_addr)) & ~0xfL;
+
+			printk("Setting ident to %llx\n",
+			       *((uint64_t *) ctx->currentTarget->
+				 scsi_cmdset.ident));
+		}
+#endif
+	} else {
+		vpd_pagep = &discover_contextp->SASInfoFrame[0];
+
+		page_length = vpd_pagep[3];
+
+		for (i = 0; i < (page_length + 3); i++) {
+			printk("%02x ", vpd_pagep[i]);
+
+			if (((i + 1) % 16) == 0) {
+				printk("\n");
+			}
+		}
+
+		serial_number_len = discover_contextp->SASInfoFrame[3];
+
+		if (serial_number_len > discover_contextp->sas_info_len) {
+			serial_number_len = discover_contextp->sas_info_len;
+		}
+
+		ctx->currentTarget->scsi_cmdset.ident_len = serial_number_len;
+
+		ctx->currentTarget->scsi_cmdset.ident = (uint8_t *)
+		    asd_alloc_mem(ctx->currentTarget->scsi_cmdset.ident_len,
+				  GFP_KERNEL);
+
+		if (ctx->currentTarget->scsi_cmdset.ident != NULL) {
+			memcpy(ctx->currentTarget->scsi_cmdset.ident,
+			       &discover_contextp->SASInfoFrame[4],
+			       ctx->currentTarget->scsi_cmdset.ident_len);
+		}
+
+		printk("serial number is %s\n",
+		       ctx->currentTarget->scsi_cmdset.ident);
+	}
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_INQUIRY;
+		}
+	}
+
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		asd_log(ASD_DBG_INFO, "%s:%d - %llx %d\n",
+			__FUNCTION__, __LINE__,
+			*((uint64_t *) ctx->currentTarget->
+			  ddb_profile.sas_addr),
+			ctx->currentTarget->ddb_profile.conn_rate);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_ISSUE_REPORT_LUNS;
+		}
+	}
+
+	return ASD_STATE_INIT_SAS_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_state_init_sas_issue_report_luns(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_report_luns(sm_contextp, ctx->currentTarget);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sas_issue_report_lun_post(struct state_machine_context *
+					 sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	unsigned i;
+	unsigned num_luns;
+	uint64_t *ReportLunsFrame;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		ctx->currentTarget->scsi_cmdset.num_luns = 1;
+
+		ctx->currentTarget->scsi_cmdset.luns = (uint64_t *)
+		    asd_alloc_mem(sizeof(uint64_t), GFP_KERNEL);
+
+		memset(&ctx->currentTarget->scsi_cmdset.luns[0], 0,
+		       sizeof(uint64_t));
+
+		printk("Report LUNS failed\n");
+		/*
+		 * Report LUNS failed.
+		 */
+	} else {
+		ReportLunsFrame = (uint64_t *) discover_contextp->SASInfoFrame;
+
+		num_luns = asd_be32toh(ReportLunsFrame[0]) / sizeof(uint64_t);
+
+		if (num_luns > ASD_MAX_LUNS) {
+			num_luns = ASD_MAX_LUNS;
+		}
+		// printk("%s: found %d luns\n", __FUNCTION__, num_luns);
+
+		ctx->currentTarget->scsi_cmdset.num_luns = num_luns;
+
+		ctx->currentTarget->scsi_cmdset.luns = (uint64_t *)
+		    asd_alloc_mem(sizeof(uint64_t) * num_luns, GFP_KERNEL);
+
+		if (ctx->currentTarget->scsi_cmdset.luns != NULL) {
+			for (i = 0; i < num_luns; i++) {
+				/*
+				 * The SASInfoFrame includes the length
+				 * of the list as the first element.
+				 */
+				ctx->currentTarget->scsi_cmdset.luns[i] =
+				    asd_be64toh(ReportLunsFrame[i + 1]);
+			}
+		} else {
+			ctx->currentTarget->scsi_cmdset.num_luns = 0;
+		}
+	}
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_ISSUE_REPORT_LUNS;
+		}
+	}
+
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		asd_log(ASD_DBG_INFO, "%s:%d - %llx %d\n",
+			__FUNCTION__, __LINE__,
+			*((uint64_t *) ctx->currentTarget->
+			  ddb_profile.sas_addr),
+			ctx->currentTarget->ddb_profile.conn_rate);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_GET_PORT_CONTROL;
+		}
+	}
+
+	return ASD_STATE_INIT_SAS_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_state_init_sas_get_port_control(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_get_port_control(sm_contextp, ctx->currentTarget);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sas_get_port_control_post(struct state_machine_context *
+					 sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	uint8_t *port_control_page;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		//printk("Port Control failed\n");
+		/*
+		 * Report LUNS failed.
+		 */
+	} else {
+		port_control_page = (uint8_t *) discover_contextp->SASInfoFrame;
+
+#if 0
+		printk("page = 0x%x length = 0x%x protocol = 0x%x\n",
+		       port_control_page[0],
+		       port_control_page[1], port_control_page[2]);
+
+		printk("I_T Nexus Loss Time = %d\n",
+		       asd_be16toh(*((uint16_t *) & port_control_page[4])));
+#endif
+	}
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->command_set_type ==
+		    ASD_COMMAND_SET_SCSI) {
+
+			return ASD_STATE_INIT_SAS_GET_PORT_CONTROL;
+		}
+	}
+
+	return ASD_STATE_INIT_SAS_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_InitSAS_SM_Initialize(struct state_machine_context * sm_contextp,
+			  void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	struct asd_InitSAS_SM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_InitSAS_SM_Arguments *)init_args;
+
+	/*
+	 * go through the configure cycle progressively
+	 * ascending to each expander starting at "newExpander"
+	 */
+	ctx->discover_listp = args->discover_listp;
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_InitSAS_SM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_INIT_SAS_START:
+		new_state = asd_state_init_sas_start(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_INQUIRY:
+		new_state = asd_state_init_sas_inquiry_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_DEVICE_ID:
+		new_state = asd_state_init_get_device_id_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_SERIAL_NUMBER:
+		new_state = asd_state_init_get_serial_number_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_ISSUE_REPORT_LUNS:
+		new_state =
+		    asd_state_init_sas_issue_report_lun_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_PORT_CONTROL:
+		new_state =
+		    asd_state_init_sas_get_port_control_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_INIT_SAS_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+
+	case ASD_STATE_INIT_SAS_INQUIRY:
+		results = asd_state_init_sas_inquiry(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_DEVICE_ID:
+		results = asd_state_init_get_device_id(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_SERIAL_NUMBER:
+		results = asd_state_init_get_serial_number(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_ISSUE_REPORT_LUNS:
+		results = asd_state_init_sas_issue_report_luns(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_GET_PORT_CONTROL:
+		results = asd_state_init_sas_get_port_control(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SAS_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_InitSAS_SM_Finish(struct state_machine_context *sm_contextp,
+		      DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Arguments *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(results);
+}
+
+void asd_InitSAS_SM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSAS_SM_Arguments *ctx;
+	ASD_DISCOVERY_STATES current_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+#if 0
+	switch (current_state) {
+	}
+#endif
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_SATA_SpinHoldSM_Context {
+	struct discover_context *discover_contextp;
+	struct list_head *discover_listp;
+	struct asd_target *currentTarget;
+	unsigned phyIndex;
+};
+
+ASD_DISCOVERY_STATES
+asd_state_sata_spinhold_start(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		asd_log(ASD_DBG_INFO, "%s:%d - %llx %d\n",
+			__FUNCTION__, __LINE__,
+			*((uint64_t *) ctx->currentTarget->
+			  ddb_profile.sas_addr),
+			ctx->currentTarget->ddb_profile.conn_rate);
+
+		if ((ctx->currentTarget->transport_type ==
+		     ASD_TRANSPORT_STP) &&
+		    (ctx->currentTarget->ddb_profile.conn_rate ==
+		     SPINUP_HOLD_OOB)) {
+
+			return ASD_STATE_SATA_SPINHOLD_PHY_CONTROL;
+		}
+	}
+
+	return ASD_STATE_SATA_SPINHOLD_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_sata_spinhold_get_next_target(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if ((ctx->currentTarget->transport_type ==
+		     ASD_TRANSPORT_STP) &&
+		    (ctx->currentTarget->ddb_profile.conn_rate ==
+		     SPINUP_HOLD_OOB)) {
+
+			return DISCOVER_OK;
+		}
+	}
+
+	return DISCOVER_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_state_sata_spinhold_phy_control(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *parent;
+	unsigned i;
+	struct Discover *discover;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	parent = ctx->currentTarget->parent;
+
+	/*
+	 * Find the phy number of this device in the parent.
+	 */
+	for (i = 0; i < parent->num_phys; i++) {
+
+		discover = &(parent->Phy[i].Result);
+
+		if (SAS_ISEQUAL(ctx->currentTarget->ddb_profile.sas_addr,
+				discover->AttachedSASAddress)) {
+
+			break;
+		}
+	}
+
+	if (i == parent->num_phys) {
+
+		results = asd_sata_spinhold_get_next_target(sm_contextp);
+
+		return results;
+	}
+
+	results = asd_issue_phy_control(sm_contextp, parent, i, LINK_RESET);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_sata_spinhold_phy_control_post(struct state_machine_context *
+					 sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *parent;
+	struct Discover *discover;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_phy_control_post(sm_contextp,
+					     ctx->currentTarget->parent);
+
+	if (results != DISCOVER_OK) {
+
+		results = asd_sata_spinhold_get_next_target(sm_contextp);
+
+		if (results != DISCOVER_FINISHED) {
+			return ASD_STATE_SATA_SPINHOLD_PHY_CONTROL;
+		}
+
+		return ASD_STATE_SATA_SPINHOLD_FINISHED;
+	}
+
+	parent = ctx->currentTarget->parent;
+
+	/*
+	 * Find the phy number of the first matching device in the parent.
+	 */
+	for (ctx->phyIndex = 0; ctx->phyIndex < parent->num_phys;
+	     ctx->phyIndex++) {
+
+		discover = &(parent->Phy[ctx->phyIndex].Result);
+
+		if (SAS_ISEQUAL(ctx->currentTarget->ddb_profile.sas_addr,
+				discover->AttachedSASAddress)) {
+
+			return ASD_STATE_SATA_SPINHOLD_DISCOVER;
+		}
+	}
+
+	printk("Didn't find target!\n");
+
+	results = asd_sata_spinhold_get_next_target(sm_contextp);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_SATA_SPINHOLD_PHY_CONTROL;
+	}
+
+	return ASD_STATE_SATA_SPINHOLD_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_state_sata_spinhold_discover(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *parent;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	parent = ctx->currentTarget->parent;
+
+	results = asd_issue_discover_request(sm_contextp,
+					     parent, ctx->phyIndex);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_sata_spinhold_discover_post(struct state_machine_context *
+				      sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *parent;
+	struct Discover *discover;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	parent = ctx->currentTarget->parent;
+
+	results = asd_issue_discover_request_post(sm_contextp,
+						  parent, ctx->phyIndex);
+
+	if (results != DISCOVER_OK) {
+		printk("discover request failed\n");
+	}
+
+	parent = ctx->currentTarget->parent;
+
+	discover = &(parent->Phy[ctx->phyIndex].Result);
+
+	ctx->currentTarget->ddb_profile.conn_rate =
+	    discover->NegotiatedPhysicalLinkRate;
+
+	asd_hwi_setup_ddb_site(discover_contextp->asd, ctx->currentTarget);
+
+	ctx->phyIndex++;
+
+	/*
+	 * Find the phy number of this device in the parent.
+	 */
+	for (; ctx->phyIndex < parent->num_phys; ctx->phyIndex++) {
+
+		discover = &(parent->Phy[ctx->phyIndex].Result);
+
+		if (SAS_ISEQUAL(ctx->currentTarget->ddb_profile.sas_addr,
+				discover->AttachedSASAddress)) {
+
+			return ASD_STATE_SATA_SPINHOLD_DISCOVER;
+		}
+	}
+
+	results = asd_sata_spinhold_get_next_target(sm_contextp);
+
+	if (results != DISCOVER_FINISHED) {
+		return ASD_STATE_SATA_SPINHOLD_PHY_CONTROL;
+	}
+
+	return ASD_STATE_SATA_SPINHOLD_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_SATA_SpinHoldSM_Initialize(struct state_machine_context * sm_contextp,
+			       void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+	struct asd_SATA_SpinHoldSM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_SATA_SpinHoldSM_Arguments *)init_args;
+
+	/*
+	 * go through the configure cycle progressively
+	 * ascending to each expander starting at "newExpander"
+	 */
+	ctx->discover_listp = args->discover_listp;
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_SATA_SpinHoldSM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_SATA_SPINHOLD_START:
+		new_state = asd_state_sata_spinhold_start(sm_contextp);
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_PHY_CONTROL:
+		new_state =
+		    asd_state_sata_spinhold_phy_control_post(sm_contextp);
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_DISCOVER:
+		new_state = asd_state_sata_spinhold_discover_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_SATA_SPINHOLD_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_SATA_SPINHOLD_PHY_CONTROL:
+		results = asd_state_sata_spinhold_phy_control(sm_contextp);
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_DISCOVER:
+		results = asd_state_sata_spinhold_discover(sm_contextp);
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_SATA_SpinHoldSM_Finish(struct state_machine_context *sm_contextp,
+			   DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Arguments *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(results);
+}
+
+void asd_SATA_SpinHoldSM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_SATA_SpinHoldSM_Arguments *ctx;
+	ASD_DISCOVERY_STATES current_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_SATA_SPINHOLD_PHY_CONTROL:
+		/*
+		 * TODO: we need to abort the outstanding Phy Control request.
+		 */
+		break;
+
+	case ASD_STATE_SATA_SPINHOLD_DISCOVER:
+		/*
+		 * TODO: we need to abort the outstanding Discover request.
+		 */
+		break;
+	default:
+		break;
+	}
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_ConfigureATA_SM_Context {
+	struct asd_target *target;
+	uint8_t next_feature;
+	uint8_t sector_count;
+};
+
+ASD_DISCOVERY_STATES
+asd_state_configure_ata_start(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureATA_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	ctx->next_feature = asd_get_feature_to_enable(ctx->target,
+						      &ctx->sector_count);
+
+	if (ctx->next_feature == 0) {
+		return ASD_STATE_CONFIGURE_ATA_FINISHED;
+	}
+
+	if (ctx->target->transport_type != ASD_TRANSPORT_ATA) {
+		return ASD_STATE_CONFIGURE_ATA_FINISHED;
+	}
+
+	return ASD_STATE_CONFIGURE_ATA_FEATURES;
+}
+
+DISCOVER_RESULTS
+asd_state_configure_ata_features(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureATA_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_sata_configure_features(sm_contextp, ctx->target,
+					      ctx->next_feature,
+					      ctx->sector_count);
+
+	return results;
+}
+
+uint8_t
+asd_get_feature_to_enable(struct asd_target * target, uint8_t * sector_count)
+{
+	unsigned features_enabled;
+	unsigned features_state;
+	unsigned *dma_mode_level;
+
+	switch (target->command_set_type) {
+	case ASD_COMMAND_SET_ATA:
+		features_enabled = target->ata_cmdset.features_enabled;
+		features_state = target->ata_cmdset.features_state;
+		dma_mode_level = &target->ata_cmdset.dma_mode_level;
+		break;
+
+	case ASD_COMMAND_SET_ATAPI:
+		features_enabled = target->atapi_cmdset.features_enabled;
+		features_state = target->ata_cmdset.features_state;
+		dma_mode_level = &target->atapi_cmdset.dma_mode_level;
+		break;
+
+	default:
+		return 0;
+	}
+
+	*sector_count = 0;
+
+	if (features_enabled & WRITE_CACHE_FEATURE_ENABLED) {
+		if ((features_state & SATA_USES_WRITE_CACHE) == 0) {
+			return SETFEATURES_EN_WCACHE;
+		}
+	} else {
+		if (features_state & SATA_USES_WRITE_CACHE) {
+			return SETFEATURES_DIS_WCACHE;
+		}
+	}
+
+	if (features_enabled & READ_AHEAD_FEATURE_ENABLED) {
+		if ((features_state & SATA_USES_READ_AHEAD) == 0) {
+			return SETFEATURES_EN_RLA;
+		}
+	} else {
+		if (features_state & SATA_USES_READ_AHEAD) {
+			return SETFEATURES_DIS_RLA;
+		}
+	}
+
+	if (features_enabled & SATA_USES_UDMA) {
+		if (features_state & NEEDS_XFER_SETFEATURES) {
+			*sector_count = *dma_mode_level;
+
+			return SETFEATURES_XFER;
+		}
+	}
+
+	return 0;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_configure_ata_features_post(struct state_machine_context *
+				      sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureATA_SM_Context *ctx;
+	unsigned *features_state;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		printk("configure failed\n");
+
+		//TODO: we can't give up, but we need to notify the user
+
+	} else {
+		switch (ctx->target->command_set_type) {
+		case ASD_COMMAND_SET_ATA:
+			features_state =
+			    &ctx->target->ata_cmdset.features_state;
+			break;
+
+		case ASD_COMMAND_SET_ATAPI:
+			features_state =
+			    &ctx->target->ata_cmdset.features_state;
+			break;
+
+		default:
+			return ASD_STATE_CONFIGURE_ATA_FINISHED;
+		}
+
+		switch (ctx->next_feature) {
+		case SETFEATURES_EN_WCACHE:
+			*features_state |= SATA_USES_WRITE_CACHE;
+			break;
+
+		case SETFEATURES_EN_RLA:
+			*features_state |= SATA_USES_READ_AHEAD;
+			break;
+
+		case SETFEATURES_DIS_WCACHE:
+			*features_state &= ~SATA_USES_WRITE_CACHE;
+			break;
+
+		case SETFEATURES_DIS_RLA:
+			*features_state &= ~SATA_USES_READ_AHEAD;
+			break;
+
+		case SETFEATURES_XFER:
+			*features_state &= ~NEEDS_XFER_SETFEATURES;
+			break;
+		}
+	}
+
+	ctx->next_feature = asd_get_feature_to_enable(ctx->target,
+						      &ctx->sector_count);
+
+	if (ctx->next_feature != 0) {
+		return ASD_STATE_CONFIGURE_ATA_FEATURES;
+	}
+
+	return ASD_STATE_CONFIGURE_ATA_FINISHED;
+}
+
+/*
+ * The ConfigureATA state machine operates on a signle target so that it can
+ * be performed on an individual device to reconfigure that device after reset.
+ *
+ * This state machine does not need a discovery context (discover_contextp).
+ */
+DISCOVER_RESULTS
+asd_ConfigureATA_SM_Initialize(struct state_machine_context * sm_contextp,
+			       void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureATA_SM_Context *ctx;
+	struct asd_ConfigureATA_SM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_ConfigureATA_SM_Arguments *)init_args;
+
+	ctx->target = args->target;
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_ConfigureATA_SM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureATA_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_CONFIGURE_ATA_START:
+		new_state = asd_state_configure_ata_start(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIGURE_ATA_FEATURES:
+		new_state = asd_state_configure_ata_features_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_CONFIGURE_ATA_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_CONFIGURE_ATA_FEATURES:
+		results = asd_state_configure_ata_features(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIGURE_ATA_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_ConfigureATA_SM_Finish(struct state_machine_context *sm_contextp,
+			   DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureATA_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	RETURN_STACK(results);
+}
+
+void asd_ConfigureATA_SM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureATA_SM_Context *ctx;
+	ASD_DISCOVERY_STATES current_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_CONFIGURE_ATA_FEATURES:
+		break;
+
+	default:
+		break;
+	}
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_InitSATA_SM_Context {
+	struct discover_context *discover_contextp;
+	struct list_head *discover_listp;
+	struct asd_target *currentTarget;
+};
+
+ASD_DISCOVERY_STATES
+asd_state_init_sata_start(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	/*
+	 * Are there any devices that need a report phy?
+	 */
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		if (ctx->currentTarget->transport_type == ASD_TRANSPORT_STP) {
+
+			return ASD_STATE_INIT_SATA_REPORT_PHY;
+
+		} else if (ctx->currentTarget->transport_type ==
+			   ASD_TRANSPORT_ATA) {
+
+			asd_init_sata_direct_attached(sm_contextp,
+						      ctx->currentTarget);
+
+			continue;
+		}
+	}
+
+	/*
+	 * If not, are there any devices that need a SATA identify or configure
+	 * features?
+	 */
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		if (ctx->currentTarget->device_protocol_type ==
+		    ASD_DEVICE_PROTOCOL_ATA) {
+
+			return ASD_STATE_INIT_SATA_IDENTIFY;
+		}
+	}
+
+	return ASD_STATE_INIT_SATA_FINISHED;
+}
+
+DISCOVER_RESULTS
+asd_state_init_sata_report_phy(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_target *parent;
+	unsigned i;
+	struct Discover *discover;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	parent = ctx->currentTarget->parent;
+
+	for (i = 0; i < parent->num_phys; i++) {
+
+		discover = &(parent->Phy[i].Result);
+
+		if (SAS_ISEQUAL(ctx->currentTarget->ddb_profile.sas_addr,
+				discover->AttachedSASAddress)) {
+
+			break;
+		}
+	}
+
+	if (i == parent->num_phys) {
+
+		results = DISCOVER_FAILED;
+
+		return results;
+	}
+
+	results = asd_issue_report_phy_sata(sm_contextp, parent, i);
+
+	return results;
+}
+
+#define NUM_FIS_DWORDS \
+		(sizeof(struct adp_dev_to_host_fis) / sizeof(unsigned))
+
+ASD_DISCOVERY_STATES
+asd_init_sata_report_phy_next_target(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->transport_type == ASD_TRANSPORT_STP) {
+
+			return ASD_STATE_INIT_SATA_REPORT_PHY;
+
+		} else if (ctx->currentTarget->transport_type ==
+			   ASD_TRANSPORT_ATA) {
+
+			asd_init_sata_direct_attached(sm_contextp,
+						      ctx->currentTarget);
+		}
+	}
+
+	/*
+	 * If there are no more STP devices to phy control, check to see if
+	 * there are any devices that need IDENTIFY / PIDENTIFY.
+	 */
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		if (ctx->currentTarget->device_protocol_type ==
+		    ASD_DEVICE_PROTOCOL_ATA) {
+
+			return ASD_STATE_INIT_SATA_IDENTIFY;
+		}
+	}
+
+	return ASD_STATE_INIT_SATA_FINISHED;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sata_report_phy_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+	unsigned i;
+	struct adp_dev_to_host_fis *fis;
+	ASD_DISCOVERY_STATES new_state;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	results = asd_issue_report_phy_sata_post(sm_contextp,
+						 ctx->currentTarget->parent);
+
+	if (results != DISCOVER_OK) {
+
+		new_state = asd_init_sata_report_phy_next_target(sm_contextp);
+
+		return new_state;
+	}
+
+	fis = (struct adp_dev_to_host_fis *)&discover_contextp->
+	    SMPResponseFrame->Response.ReportPhySATA.FIS;
+
+	if (fis->error == FIS_DEVICE_TO_HOST) {
+
+		for (i = 0; i < NUM_FIS_DWORDS; i++) {
+
+			*((unsigned *)fis + i) =
+			    asd_htobe32(*((unsigned *)fis + i));
+		}
+	}
+
+	ctx->currentTarget->command_set_type = asd_sata_get_type(fis);
+
+	memcpy((void *)&ctx->currentTarget->
+	       device_protocol.ata_device_protocol.initial_fis[0],
+	       (void *)fis, sizeof(struct adp_dev_to_host_fis));
+
+	ctx->currentTarget->ddb_profile.sata_status = fis->status;
+
+	asd_hwi_update_sata(discover_contextp->asd, ctx->currentTarget);
+
+	new_state = asd_init_sata_report_phy_next_target(sm_contextp);
+
+	return new_state;
+}
+
+DISCOVER_RESULTS
+asd_state_init_sata_identify(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_sata_identify_request(sm_contextp, ctx->currentTarget);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_init_sata_identify_next_target(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->device_protocol_type ==
+		    ASD_DEVICE_PROTOCOL_ATA) {
+
+			return ASD_STATE_INIT_SATA_IDENTIFY;
+		}
+	}
+
+	/*
+	 * If there are no more ATA devices to identify, then check to see
+	 * if any device need to be configured.
+	 */
+	list_for_each_entry(ctx->currentTarget, ctx->discover_listp,
+			    all_domain_targets) {
+
+		if (ctx->currentTarget->device_protocol_type ==
+		    ASD_DEVICE_PROTOCOL_ATA) {
+
+			return ASD_STATE_INIT_SATA_CONFIGURE_FEATURES;
+		}
+	}
+
+	return ASD_STATE_INIT_SATA_FINISHED;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sata_identify_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	ASD_DISCOVERY_STATES new_state;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		printk("identify failed\n");
+
+		//TODO: we can't give up, but we need to notify the user
+	} else {
+		/*
+		 * Pre-compute the features that this drive supports so
+		 * that we don't have to hunt them down in the hd_driveid
+		 * structure.
+		 */
+		asd_sata_compute_support(discover_contextp->asd,
+					 ctx->currentTarget);
+	}
+
+	new_state = asd_init_sata_identify_next_target(sm_contextp);
+
+	return new_state;
+}
+
+DISCOVER_RESULTS
+asd_state_init_sata_configure_features(struct state_machine_context *
+				       sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+	struct asd_ConfigureATA_SM_Arguments args;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	args.target = ctx->currentTarget;
+
+	results = ASD_PUSH_STATE_MACHINE(sm_contextp,
+					 &asd_ConfigureATA_SM, (void *)&args);
+
+	return results;
+}
+
+ASD_DISCOVERY_STATES
+asd_init_sata_configure_features_next_target(struct state_machine_context *
+					     sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	while (ctx->currentTarget->all_domain_targets.next
+	       != ctx->discover_listp) {
+
+		ctx->currentTarget =
+		    list_entry(ctx->currentTarget->all_domain_targets.next,
+			       struct asd_target, all_domain_targets);
+
+		if (ctx->currentTarget->device_protocol_type ==
+		    ASD_DEVICE_PROTOCOL_ATA) {
+
+			return ASD_STATE_INIT_SATA_CONFIGURE_FEATURES;
+		}
+	}
+
+	return ASD_STATE_INIT_SATA_FINISHED;
+}
+
+ASD_DISCOVERY_STATES
+asd_state_init_sata_configure_features_post(struct state_machine_context *
+					    sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	ASD_DISCOVERY_STATES new_state;
+	struct discover_context *discover_contextp;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (discover_contextp->openStatus != OPEN_ACCEPT) {
+
+		printk("configure failed\n");
+
+		//TODO: we can't give up, but we need to notify the user
+	}
+
+	new_state = asd_init_sata_configure_features_next_target(sm_contextp);
+
+	return new_state;
+}
+
+DISCOVER_RESULTS
+asd_InitSATA_SM_Initialize(struct state_machine_context * sm_contextp,
+			   void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	struct asd_InitSATA_SM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_InitSATA_SM_Arguments *)init_args;
+
+	/*
+	 * go through the configure cycle progressively
+	 * ascending to each expander starting at "newExpander"
+	 */
+	ctx->discover_listp = args->discover_listp;
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_InitSATA_SM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_INIT_SATA_START:
+		new_state = asd_state_init_sata_start(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA_REPORT_PHY:
+		new_state = asd_state_init_sata_report_phy_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA_IDENTIFY:
+		new_state = asd_state_init_sata_identify_post(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA_CONFIGURE_FEATURES:
+		new_state =
+		    asd_state_init_sata_configure_features_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_INIT_SATA_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_INIT_SATA_REPORT_PHY:
+		results = asd_state_init_sata_report_phy(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA_IDENTIFY:
+		results = asd_state_init_sata_identify(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA_CONFIGURE_FEATURES:
+		results = asd_state_init_sata_configure_features(sm_contextp);
+		break;
+
+	case ASD_STATE_INIT_SATA_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}
+
+void
+asd_InitSATA_SM_Finish(struct state_machine_context *sm_contextp,
+		       DISCOVER_RESULTS results)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	struct discover_context *discover_contextp;
+	struct asd_phy *phy;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	discover_contextp = (struct discover_context *)
+	    sm_contextp->state_handle;
+
+	if (results == DISCOVER_FAILED) {
+		phy = list_entry(discover_contextp->port->phys_attached.next,
+				 struct asd_phy, links);
+
+		printk("Phy%d: %s - discovery error\n", phy->id, __FUNCTION__);
+	}
+
+	RETURN_STACK(results);
+}
+
+void asd_InitSATA_SM_Abort(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_InitSATA_SM_Context *ctx;
+	ASD_DISCOVERY_STATES current_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_INIT_SATA_REPORT_PHY:
+		/*
+		 * TODO: Abort Report Phy request.
+		 */
+		break;
+
+	case ASD_STATE_INIT_SATA_IDENTIFY:
+		/*
+		 * TODO: Abort Identify request.
+		 */
+		break;
+
+	default:
+		break;
+	}
+}
+
+/* -------------------------------------------------------------------------- */
+
+struct asd_ConfigureExpanderSM_Context {
+	struct discover_context *discover_contextp;
+	struct list_head *discover_listp;
+	struct asd_target *newExpander;
+	struct asd_target *currentExpander;
+	struct asd_target *configureExpander;
+	uint8_t upstreamSASAddress[SAS_ADDR_LEN];
+	uint8_t upstreamPhyIdentifier;
+	unsigned phyIndex;
+	unsigned routeIndex;
+	uint32_t slowest_link;
+};
+
+DISCOVER_RESULTS
+asd_state_config_expander_route(struct state_machine_context *sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureExpanderSM_Context *ctx;
+	uint8_t disableRouteEntry;
+	struct Discover *discover;
+	DISCOVER_RESULTS results;
+	uint8_t *attached_sas_addr;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	for (; 1; ctx->currentExpander = ctx->configureExpander) {
+
+		if (ctx->currentExpander->management_flags & DEVICE_SET_ROOT) {
+			/*
+			 * This is the edge of the device set, we are done.
+			 */
+			return DISCOVER_FINISHED;
+		}
+		/*
+		 * move upstream from here to find the expander table to 
+		 * configure with information from "attachedExpander"
+		 */
+		if (!asd_upstream_expander(ctx->currentExpander,
+					   ctx->upstreamSASAddress,
+					   &ctx->upstreamPhyIdentifier)) {
+
+			return DISCOVER_FINISHED;
+		}
+
+		if (SAS_ISZERO(ctx->upstreamSASAddress)) {
+			return DISCOVER_FINISHED;
+		}
+
+		/*
+		 * get the expander associated with the upstream address
+		 */
+		ctx->configureExpander = asd_find_target(ctx->discover_listp,
+							 ctx->
+							 upstreamSASAddress);
+
+		if (ctx->configureExpander == NULL) {
+			/*
+			 * If we don't have the upstream expander, something
+			 * is wrong.  This should never happen.
+			 */
+			return DISCOVER_FAILED;
+		}
+
+		/*
+		 * if we found an upstream expander, then program its route
+		 * table.
+		 */
+		for (ctx->phyIndex = 0; ctx->phyIndex <
+		     ctx->configureExpander->num_phys; ctx->phyIndex++) {
+
+			attached_sas_addr =
+			    ctx->configureExpander->
+			    Phy[ctx->phyIndex].Result.AttachedSASAddress;
+
+			if (SAS_ISEQUAL(attached_sas_addr,
+					ctx->currentExpander->ddb_profile.
+					sas_addr)) {
+
+				break;
+			}
+		}
+
+		if (ctx->phyIndex == ctx->configureExpander->num_phys) {
+
+			continue;
+		}
+
+		/*
+		 * assume the route entry is enabled
+		 */
+		disableRouteEntry = ENABLED;
+
+		discover = NULL;
+
+		for (ctx->routeIndex = 0;
+		     ctx->routeIndex < ctx->newExpander->num_phys;
+		     ctx->routeIndex++) {
+
+			discover = &(ctx->newExpander->
+				     Phy[ctx->routeIndex].Result);
+
+			/*
+			 * check to see if the address needs to be configured
+			 * in the route table, this decision is based on the
+			 * optimization flag
+			 */
+			if (asd_qualified_address(ctx->configureExpander,
+						  ctx->phyIndex, discover,
+						  &disableRouteEntry)) {
+
+				break;
+			}
+		}
+
+		if (ctx->routeIndex == ctx->newExpander->num_phys) {
+
+			continue;
+		}
+
+		results = asd_issue_route_config(sm_contextp,
+						 ctx->configureExpander,
+						 ctx->phyIndex,
+						 disableRouteEntry,
+						 discover->AttachedSASAddress);
+
+		return results;
+	}
+}
+
+ASD_DISCOVERY_STATES
+asd_state_config_expander_route_post(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureExpanderSM_Context *ctx;
+	struct Discover *discover;
+	DISCOVER_RESULTS results;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	results = asd_issue_route_config_post(sm_contextp,
+					      ctx->configureExpander,
+					      ctx->phyIndex);
+
+	if (results == DISCOVER_OK) {
+
+		discover = &(ctx->newExpander->Phy[ctx->routeIndex].Result);
+
+		ctx->routeIndex++;
+
+		/*
+		 * add the address to the internal copy of the
+		 * route table, if successfully configured
+		 */
+		SASCPY(ROUTE_ENTRY(ctx->configureExpander, ctx->phyIndex,
+				   ctx->configureExpander->
+				   route_indexes[ctx->phyIndex]),
+		       discover->AttachedSASAddress);
+
+		ctx->configureExpander->route_indexes[ctx->phyIndex]++;
+
+		return ASD_STATE_CONFIG_EXPANDER_ROUTE_LOOP;
+	}
+
+	return ASD_STATE_CONFIG_EXPANDER_FAILED;
+}
+
+DISCOVER_RESULTS
+asd_state_config_expander_route_loop(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureExpanderSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	uint8_t disableRouteEntry;
+	struct Discover *discover;
+	uint8_t *attached_sas_addr;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	while (1) {
+		/*
+		 * assume the route entry is enabled
+		 */
+		disableRouteEntry = ENABLED;
+
+		for (; ctx->routeIndex < ctx->newExpander->num_phys;
+		     ctx->routeIndex++) {
+
+			discover = &(ctx->newExpander->
+				     Phy[ctx->routeIndex].Result);
+
+			/*
+			 * check to see if the address needs to be configured
+			 * in the route table, this decision is based on the
+			 * optimization flag
+			 */
+			if (asd_qualified_address(ctx->configureExpander,
+						  ctx->phyIndex, discover,
+						  &disableRouteEntry)) {
+
+				results = asd_issue_route_config(sm_contextp,
+								 ctx->
+								 configureExpander,
+								 ctx->phyIndex,
+								 disableRouteEntry,
+								 discover->
+								 AttachedSASAddress);
+
+				return results;
+			}
+		}
+
+		ctx->phyIndex++;
+
+		/*
+		 * if we found an upstream expander, then program its route
+		 * table.
+		 */
+		for (; ctx->phyIndex <
+		     ctx->configureExpander->num_phys; ctx->phyIndex++) {
+
+			attached_sas_addr = ctx->configureExpander->
+			    Phy[ctx->phyIndex].Result.AttachedSASAddress;
+
+			if (SAS_ISEQUAL(attached_sas_addr,
+					ctx->currentExpander->ddb_profile.
+					sas_addr)) {
+
+				break;
+			}
+		}
+
+		if (ctx->phyIndex == ctx->configureExpander->num_phys) {
+
+			break;
+		}
+
+		ctx->routeIndex = 0;
+	}
+
+	ctx->phyIndex = 0;
+
+	ctx->currentExpander = ctx->configureExpander;
+
+	results = asd_state_config_expander_route(sm_contextp);
+
+	return results;
+}
+
+DISCOVER_RESULTS
+asd_ConfigureExpanderSM_Initialize(struct state_machine_context * sm_contextp,
+				   void *init_args)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureExpanderSM_Context *ctx;
+	struct asd_ConfigureExpanderSM_Arguments *args;
+
+	NEW_CONTEXT(ctx);
+
+	args = (struct asd_ConfigureExpanderSM_Arguments *)init_args;
+
+	/*
+	 * go through the configure cycle progressively
+	 * ascending to each expander starting at "newExpander"
+	 */
+	ctx->discover_listp = args->discover_listp;
+	ctx->newExpander = args->newExpander;
+	ctx->currentExpander = ctx->newExpander;
+	ctx->slowest_link = 0;
+	SAS_ZERO(ctx->upstreamSASAddress);
+
+	return DISCOVER_CONTINUE;
+}
+
+DISCOVER_RESULTS
+asd_ConfigureExpanderSM_StateMachine(struct state_machine_context * sm_contextp)
+{
+	struct state_information *state_infop;
+	struct asd_ConfigureExpanderSM_Context *ctx;
+	DISCOVER_RESULTS results;
+	ASD_DISCOVERY_STATES current_state;
+	ASD_DISCOVERY_STATES new_state;
+
+	GET_STATE_CONTEXT(sm_contextp, ctx);
+
+	current_state = GET_CURRENT_STATE();
+
+	switch (current_state) {
+	case ASD_STATE_CONFIG_EXPANDER_START:
+		new_state = ASD_STATE_CONFIG_EXPANDER_ROUTE;
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE:
+		new_state = asd_state_config_expander_route_post(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE_LOOP:
+		new_state = asd_state_config_expander_route_post(sm_contextp);
+		break;
+
+	default:
+		new_state = ASD_STATE_CONFIG_EXPANDER_FAILED;
+		break;
+	}
+
+	SM_new_state(sm_contextp, new_state);
+
+	switch (new_state) {
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE:
+		results = asd_state_config_expander_route(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_ROUTE_LOOP:
+		results = asd_state_config_expander_route_loop(sm_contextp);
+		break;
+
+	case ASD_STATE_CONFIG_EXPANDER_FINISHED:
+		results = DISCOVER_FINISHED;
+		break;
+
+	default:
+		results = DISCOVER_FAILED;
+		break;
+	}
+
+	return results;
+}




