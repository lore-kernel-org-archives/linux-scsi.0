From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [22/27]
Date: Thu, 17 Feb 2005 12:37:31 -0500
Message-ID: <4214D65B.2030008@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:39058 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262337AbVBQRhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:37:38 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbZr31543
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:35 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbYb21494
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Anything SATA related.  Part 2/2.

+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_control_mode_select(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+uint8_t			*bufptr
+)
+{
+	if (bufptr[1] != (CONTROL_MODE_PAGE_LEN - 2)) {
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	/*
+	 * T10/04-136r0 doesn't support this command, and Linux libata does
+	 * not support select, so we will do nothing.
+	 */
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_informational_exception_control_select(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+uint8_t			*bufptr
+)
+{
+	unsigned			*features_enabled;
+	unsigned			*features_state;
+	struct asd_target		*target;
+
+	if (bufptr[1] != (INFORMATIONAL_EXCEPTION_CONTROL_PAGE_LEN - 2)) {
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	target = dev->target;
+
+	switch (target->command_set_type) {
+	case ASD_COMMAND_SET_ATA:
+		features_enabled = &target->ata_cmdset.features_enabled;
+		features_state = &target->ata_cmdset.features_state;
+		break;
+
+	case ASD_COMMAND_SET_ATAPI:
+		features_enabled = &target->atapi_cmdset.features_enabled;
+		features_state = &target->ata_cmdset.features_state;
+		break;
+
+	default:
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	/*
+	 * Sense we only support polling and we are translating, there is
+	 * nothing more to do.
+	 */
+	if (bufptr[2] & SCSI_DEXCPT) {
+		*features_enabled &= ~SMART_FEATURE_ENABLED;
+		*features_state &= ~SMART_FEATURE_ENABLED;
+	} else {
+		*features_enabled |= SMART_FEATURE_ENABLED;
+		*features_state |= SMART_FEATURE_ENABLED;
+	}
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+/* -----------------------------------
+ * MODE_SENSE: (emulated)
+ * MODE_SENSE_10: (emulated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_mode_sense_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	unsigned			page_code;
+	unsigned			page_control;
+	unsigned			subpage_code;
+	unsigned			allocation_length;
+	unsigned			long_lba_accepted;
+	uint8_t				*buffer;
+	uint8_t				*bufptr;
+	unsigned			transfer_length;
+	unsigned			len;
+	struct hd_driveid		*hd_driveidp;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	if (cmd->cmnd[1] & DBD_BIT) {
+		/*
+		 * We don't support disabling block discriptors.
+		 */
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	page_control = cmd->cmnd[2] & PAGE_CONTROL_MASK;
+
+	if (page_control != 0) {
+		/*
+		 * We only support the current values.
+		 */
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	subpage_code = cmd->cmnd[3];
+
+	long_lba_accepted = 0;
+	transfer_length = 0;
+	allocation_length = 0;
+
+	/*
+	 * the first thing we need is a mode_parameter_header
+	 * this depends on whether we are using 6 byte or 10 byte CDBs
+	 */
+	switch (cmd->cmnd[0]) {
+	case MODE_SENSE:
+		transfer_length = MODE_PARAMETER_HEADER_LENGTH_6;
+		allocation_length = cmd->cmnd[4];
+		break;
+	case MODE_SENSE_10:
+		transfer_length = MODE_PARAMETER_HEADER_LENGTH_10;
+		long_lba_accepted = cmd->cmnd[1] & LLBA_MASK;
+		allocation_length = (cmd->cmnd[7] << 8) | cmd->cmnd[8];
+		break;
+	}
+
+	if (long_lba_accepted) {
+		transfer_length += BLOCK_DESCRIPTOR_LENGTH_8;
+	}
+	else {
+		transfer_length += BLOCK_DESCRIPTOR_LENGTH_16;
+	}
+
+	page_code = cmd->cmnd[2] & PAGE_CODE_MASK;
+
+	switch (page_code) {
+	case READ_WRITE_ERROR_RECOVERY_MODE_PAGE:
+		transfer_length += READ_WRITE_ERROR_RECOVERY_MODE_PAGE_LEN;
+		break;
+
+	case CACHING_MODE_PAGE:
+		transfer_length += CACHING_MODE_PAGE_LEN;
+		break;
+
+	case CONTROL_MODE_PAGE:
+		transfer_length += CONTROL_MODE_PAGE_LEN;
+		break;
+
+	case INFORMATIONAL_EXCEPTION_CONTROL_PAGE:
+		transfer_length += INFORMATIONAL_EXCEPTION_CONTROL_PAGE_LEN;
+		break;
+
+	case RETURN_ALL_PAGES:
+		transfer_length += 
+			READ_WRITE_ERROR_RECOVERY_MODE_PAGE_LEN + 
+			CACHING_MODE_PAGE_LEN + 
+			CONTROL_MODE_PAGE_LEN + 
+			INFORMATIONAL_EXCEPTION_CONTROL_PAGE_LEN;
+		break;
+	default:
+		/*
+		 * We don't support disabling block discriptors.
+		 */
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	len = MIN(transfer_length, cmd->request_bufflen);
+	len = MIN(len, allocation_length);
+
+	/*
+	 * We can't transfer more than the size of the buffer.
+	 */
+	cmd->request_bufflen = len;
+
+	/*
+	 * MODE_SENSE (6 byte) only supports 256 bytes of data length.  This
+	 * length doesn't include
+	 */
+	if (cmd->cmnd[0] == MODE_SENSE) {
+		/*
+		 * The length doesn't include the length field itself, so we
+		 * can have 256 bytes even though the length field only holds
+		 * 0-255.
+		 */
+		if (len > 256) {
+			len = 256;
+		}
+	}
+
+	/*
+	 * Allocate the whole length that we are going to fill in, fill the
+	 * buffer up, and then transfer back what was requested.
+	 */
+	buffer = (uint8_t *)asd_alloc_mem(transfer_length, GFP_KERNEL);
+
+	if (buffer == NULL) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			RESOURCE_FAILURE, MEMORY_OUT_OF_SPACE);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	memset(buffer, 0, transfer_length);
+
+	bufptr = buffer;
+
+	/*
+	 * SPC-3 says that the medium type should be 0.
+	 *
+	 * MODE_SENSE:    bufptr[1] == 0
+	 * MODE_SENSE_10: bufptr[2] == 0
+	 */
+	/*
+	 * 3.10.2 and 3.11.2 of T10/04-136r0 says that DPO is ignored and that
+	 * FUA is only supported for NCQ (Native Command Queuing) drives.  We
+	 * are not supporting NCQ in this release, so the answer to DPOFUA will
+	 * be 0 for now.
+	 *
+	 * MODE_SENSE:    bufptr[2] == 0
+	 * MODE_SENSE_10: bufptr[3] == 0
+	 */
+
+	/*
+	 * Now we can fill in the response.  Start with the mode parameter 
+	 * header.
+	 */
+	switch (cmd->cmnd[0]) {
+	case MODE_SENSE:
+		bufptr[0] = len - 1;
+		bufptr[3] = 8; // only one block descriptor
+		bufptr += MODE_PARAMETER_HEADER_LENGTH_6;
+		break;
+
+	case MODE_SENSE_10:
+		bufptr[0] = ((len - 2) >> 8) & 0xff;
+		bufptr[1] = (len - 2) & 0xff;
+		bufptr[6] = 0;
+		if (long_lba_accepted) {
+			bufptr[7] = 16; // only one block descriptor
+		} else {
+			bufptr[7] = 8; // only one block descriptor
+		}
+		bufptr += MODE_PARAMETER_HEADER_LENGTH_10;
+		break;
+	}
+
+	hd_driveidp = &dev->target->ata_cmdset.adp_hd_driveid;
+
+	if (long_lba_accepted) {
+		*((uint64_t *)&bufptr[0]) =
+			ATA2SCSI_8(*((uint64_t *)&hd_driveidp->lba_capacity_2));
+
+		bufptr[8] = 0;	// density code: T10/04-136r0 - 3.21.2.1.3
+
+		*((uint32_t *)&bufptr[12]) = ATA2SCSI_4(ATA_BLOCK_SIZE);
+
+		bufptr += BLOCK_DESCRIPTOR_LENGTH_16;
+	} else {
+		*((uint32_t *)&bufptr[0]) =
+			ATA2SCSI_4(*((uint64_t *)&hd_driveidp->lba_capacity_2));
+
+		bufptr[4] = 0;	// density code: T10/04-136r0 - 3.21.2.1.3
+
+		bufptr[5] = (ATA_BLOCK_SIZE >> 16) & 0xff;
+		bufptr[6] = (ATA_BLOCK_SIZE >> 8) & 0xff;
+		bufptr[7] = ATA_BLOCK_SIZE & 0xff;
+
+		bufptr += BLOCK_DESCRIPTOR_LENGTH_8;
+	}
+
+	switch (page_code) {
+	case READ_WRITE_ERROR_RECOVERY_MODE_PAGE:
+		bufptr = asd_sata_read_write_error_recovery_sense(asd,
+			dev, bufptr);
+		break;
+
+	case CACHING_MODE_PAGE:
+		bufptr = asd_sata_caching_sense(asd, dev, bufptr);
+		break;
+
+	case CONTROL_MODE_PAGE:
+		bufptr = asd_sata_control_sense(asd, dev, bufptr);
+		break;
+
+	case INFORMATIONAL_EXCEPTION_CONTROL_PAGE:
+		bufptr = asd_sata_informational_exception_control_sense(asd,
+			dev, bufptr);
+		break;
+
+	case RETURN_ALL_PAGES:
+		bufptr = asd_sata_read_write_error_recovery_sense(asd,
+			dev, bufptr);
+
+		bufptr = asd_sata_caching_sense(asd, dev, bufptr);
+
+		bufptr = asd_sata_control_sense(asd, dev, bufptr);
+
+		bufptr = asd_sata_informational_exception_control_sense(asd,
+			dev, bufptr);
+
+		break;
+	}
+
+	memcpy(cmd->request_buffer, buffer, len);
+
+	asd_free_mem(buffer);
+
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+uint8_t *
+asd_sata_read_write_error_recovery_sense(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+uint8_t			*bufptr
+)
+{
+	bufptr[0] = READ_WRITE_ERROR_RECOVERY_MODE_PAGE;	// PS == 0
+
+	bufptr[1] = READ_WRITE_ERROR_RECOVERY_MODE_PAGE_LEN - 2;
+	bufptr[2] = 0xc0;	// DCR == 0,  DTE == 0, PER == 0, ERR == 0
+				// RC == 0, TB == 0, ARRE == 1, AWRE == 1
+
+	bufptr[3] = 0x00;	// READ_RETRY_COUNT == 0
+	bufptr[8] = 0x00;	// WRITE_RETRY_COUNT == 0
+
+	bufptr[10] = 0x00;	// RECOVERY_TIME_LIMIT == 0
+	bufptr[11] = 0x00;
+
+	return bufptr + bufptr[1] + 2;
+}
+
+uint8_t *
+asd_sata_caching_sense(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+uint8_t			*bufptr
+)
+{
+	struct hd_driveid		*hd_driveidp;
+	unsigned			features_state;
+	struct asd_target		*target;
+
+	target = dev->target;
+
+	switch (target->command_set_type) {
+	case ASD_COMMAND_SET_ATA:
+		hd_driveidp = &target->ata_cmdset.adp_hd_driveid;
+		features_state = target->ata_cmdset.features_state;
+		break;
+
+	case ASD_COMMAND_SET_ATAPI:
+		hd_driveidp = &target->atapi_cmdset.adp_hd_driveid;
+		features_state = target->atapi_cmdset.features_state;
+		break;
+
+	default:
+		return bufptr + CACHING_MODE_PAGE_LEN;
+	}
+
+	bufptr[0] = CACHING_MODE_PAGE;	// PS == 0
+	bufptr[1] = CACHING_MODE_PAGE_LEN - 2;
+
+	bufptr[2] = 0;
+
+	if (features_state & WRITE_CACHE_FEATURE_ENABLED) {
+		/* 
+		 * RCD == 0, MF == 0, SIZE == 0, DISC == 0,
+		 * CAP == 0, ABPF == 0, IC == 0
+		 */
+		/*
+		 * After drive reset, we should re-issue IDENTIFY.
+		 */
+		bufptr[2] |= SCSI_WCE;
+	} else {
+		bufptr[2] &= ~SCSI_WCE;
+	}
+
+	bufptr[3] = 0;  // DEMAND_READ_RETENTION_PROPERTY == 0
+			// WRITE_RETENTION_PROPERTY == 0
+
+	bufptr[4] = 0;	// DISABLE_PRE_FETCH_TRANSFER_LENGTH == 0
+	bufptr[5] = 0;
+
+	bufptr[6] = 0;	// MINIMUM_PRE_FETCH == 0
+	bufptr[7] = 0;
+
+	bufptr[8] = 0;	// MAXIMUM_PRE_FETCH == 0
+	bufptr[9] = 0;
+
+	bufptr[10] = 0;	// MAXIMUM_PRE_FETCH_CEILING == 0
+	bufptr[11] = 0;
+
+	bufptr[12] = 0;
+
+	if ((features_state & READ_AHEAD_FEATURE_ENABLED) == 0) {
+		/*
+		 * NV_DIS == 0, FSW == 0, LBCSS == 0, FSW == 0
+		 */
+		/*
+		 * After drive reset, we should re-issue IDENTIFY.
+		 */
+		bufptr[12] |= SCSI_DRA;
+	} else {
+		bufptr[12] &= ~SCSI_DRA;
+	}
+
+	bufptr[13] = 0;	// NUMBER_OF_CACHE_SEGMENTS == 0
+
+	bufptr[14] = 0;	// CACHE_SEGMENT_SIZE == 0
+	bufptr[15] = 0;
+
+	bufptr[17] = 0;	// NON_CACHE_SEGMENT_SIZE == 0
+	bufptr[18] = 0;
+	bufptr[19] = 0;
+
+	return bufptr + bufptr[1] + 2;
+}
+
+uint8_t *
+asd_sata_control_sense(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+uint8_t			*bufptr
+)
+{
+	bufptr[0] = CONTROL_MODE_PAGE;
+	bufptr[1] = CONTROL_MODE_PAGE_LEN - 2;
+	bufptr[2] = 2;		// RLEC == 0, GLTSD == 0, D_SENSE == 0, TST == 0
+	bufptr[3] = 0;		// QERR == 0, QUEUE_ALGORITHM_MODIFIER == 0
+	bufptr[4] = 0;		// SWP == 0, UA_INTLCK_CTRL == 0, 
+				// RAC == 0, TAS== 0
+	bufptr[5] = 0;		// AUTOLOAD_MODE == 0, APTG_OWN == 0
+
+	bufptr[8] = 0xff;
+	bufptr[9] = 0xff;
+	bufptr[10] = 0;
+	bufptr[11] = 30;
+
+	return bufptr + bufptr[1] + 2;
+}
+
+uint8_t *
+asd_sata_informational_exception_control_sense(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+uint8_t			*bufptr
+)
+{
+	struct hd_driveid		*hd_driveidp;
+	unsigned			features_state;
+	struct asd_target		*target;
+
+	target = dev->target;
+
+	switch (target->command_set_type) {
+	case ASD_COMMAND_SET_ATA:
+		hd_driveidp = &target->ata_cmdset.adp_hd_driveid;
+		features_state = target->ata_cmdset.features_state;
+		break;
+
+	case ASD_COMMAND_SET_ATAPI:
+		hd_driveidp = &target->atapi_cmdset.adp_hd_driveid;
+		features_state = target->atapi_cmdset.features_state;
+		break;
+
+	default:
+		return bufptr + INFORMATIONAL_EXCEPTION_CONTROL_PAGE_LEN;
+	}
+
+	bufptr[0] = INFORMATIONAL_EXCEPTION_CONTROL_PAGE;	// PS == 0
+	bufptr[1] = INFORMATIONAL_EXCEPTION_CONTROL_PAGE_LEN - 2;
+
+	if ((features_state & SMART_FEATURE_ENABLED) == 0) {
+		/*
+		 * LOGERR == 0, TEST == 0, EWASC == 0, EBF == 0, PERF == 0
+		 */
+		bufptr[2] |= SCSI_DEXCPT;		// disabled
+	}
+
+	bufptr[3] = 0x06;	// MRIE - report on request
+
+	bufptr[4] = 0;	// INTERVAL_TIMER == 0
+	bufptr[5] = 0;
+	bufptr[6] = 0;
+	bufptr[7] = 0;
+
+	bufptr[8] = 0;	// REPORT_COUNT == 0
+	bufptr[9] = 0;
+	bufptr[10] = 0;
+	bufptr[11] = 0;
+
+	return bufptr + bufptr[1] + 2;
+}
+
+/* -----------------------------------
+ * READ_6: (translated)
+ * READ_10: (translated)
+ * READ_12: (translated)
+ */
+
+// RST - we need a tag somehow
+ASD_COMMAND_BUILD_STATUS
+asd_sata_read_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	uint32_t			lba;
+	unsigned			sectors;
+	unsigned			fis_command;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	switch (cmd->cmnd[0]) {
+	case READ_6:
+		lba = (cmd->cmnd[2] << 8) | cmd->cmnd[3];
+		sectors = cmd->cmnd[4];
+
+		break;
+
+	case READ_10:
+		if (cmd->cmnd[9] != 0) {
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+		}
+
+		lba = (cmd->cmnd[2] << 24) | (cmd->cmnd[3] << 16) |
+			(cmd->cmnd[4] << 8) | cmd->cmnd[5];
+		sectors = (cmd->cmnd[7] << 8) | cmd->cmnd[8];
+
+		break;
+
+	case READ_12:
+		if (cmd->cmnd[11] != 0) {
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+		}
+
+		lba = (cmd->cmnd[2] << 24) | (cmd->cmnd[3] << 16) |
+			(cmd->cmnd[4] << 8) | cmd->cmnd[5];
+		sectors = (cmd->cmnd[6] << 24) | (cmd->cmnd[7] << 16) |
+			(cmd->cmnd[8] << 8) | cmd->cmnd[9];
+
+		break;
+
+	default:
+		lba = 0;
+		sectors = 0;
+		break;
+	}
+
+	switch (cmd->cmnd[0]) {
+	case READ_10:
+	case READ_12:
+		if (cmd->cmnd[1] & 0x01) {
+			/*
+			 * Obsolete field that we will fail.
+			 */
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		if (sectors == 0) {
+			asd_cmd_set_host_status(cmd, DID_OK);
+
+			return ASD_COMMAND_BUILD_FINISHED;
+		}
+	}
+
+	fis_command = 0;
+
+	// RST - what about FUA??
+
+	switch (dev->target->ata_cmdset.features_state & 
+		(SATA_USES_DMA | SATA_USES_48BIT | SATA_USES_QUEUEING)) {
+	case 0:
+		fis_command = WIN_READ;
+		break;
+	case SATA_USES_DMA:
+		fis_command = WIN_READDMA;
+		break;
+	case SATA_USES_48BIT:
+		fis_command = WIN_READ_EXT;
+		break;
+	case SATA_USES_QUEUEING:
+		// Doesn't exist;
+		break;
+	case SATA_USES_DMA | SATA_USES_48BIT:
+		fis_command = WIN_READDMA_EXT;
+		break;
+	case SATA_USES_DMA | SATA_USES_QUEUEING:
+		// RST - sector and feature are swapped for this command
+		fis_command = WIN_READDMA_QUEUED;
+		break;
+	case SATA_USES_48BIT | SATA_USES_QUEUEING:
+		// Doesn't exist
+		break;
+	case SATA_USES_DMA | SATA_USES_48BIT | SATA_USES_QUEUEING:
+		// RST - sector and feature are swapped for this command
+		fis_command = WIN_READDMA_QUEUED_EXT;
+		break;
+	default:
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	asd_sata_setup_fis(ata_hscb, fis_command);
+
+	if (dev->target->ata_cmdset.features_state & SATA_USES_DMA) {
+		SET_DMA_MODE(ata_hscb);
+	} else {
+		SET_PIO_MODE(ata_hscb);
+	}
+
+	if (dev->target->ata_cmdset.features_state & SATA_USES_48BIT) {
+
+		asd_sata_setup_lba_ext(ata_hscb, lba, sectors);
+
+	} else {
+		if (lba >= RW_DMA_LBA_SIZE) {
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		if (sectors > RW_DMA_MAX_SECTORS) {
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		if (sectors == RW_DMA_MAX_SECTORS) {
+			sectors = 0;
+		}
+
+		asd_sata_setup_lba(ata_hscb, lba, sectors);
+	}
+
+	ata_hscb->ata_flags |= DATA_DIR_INBOUND;
+
+	asd_push_post_stack(asd, scb, (void *)cmd, asd_sata_read_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_read_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb		*ata_resp_edbp;
+	struct scsi_cmnd		*cmd;
+#if 0
+	unsigned			sectors;
+	uint32_t			lba;
+	struct asd_ata_task_hscb	*ata_hscb;
+	unsigned			remain;
+#endif
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+#if 0
+	ata_hscb = &scb->hscb->ata_task;
+#endif
+
+	switch (done_listp->opcode) {
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	case TASK_COMP_WO_ERR:
+		break;
+
+	default:
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_COMMAND_OPERATION, 0);
+
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	}
+
+#if 0
+	if (remain > 0) {
+
+		sectors = remain / RW_DMA_MAX_SECTORS ;
+
+		if (sectors >= RW_DMA_MAX_SECTORS) {
+			scb->transfer_length = RW_DMA_MAX_SECTORS *
+				ATA_BLOCK_SIZE;
+
+			sectors = 0;
+		} else {
+
+			scb->transfer_length = remain;
+		}
+
+
+		lba = (ASD_H2D_FIS(ata_hscb)->lba2  << 16) |
+			(ASD_H2D_FIS(ata_hscb)->lba1 << 8) |
+			(ASD_H2D_FIS(ata_hscb)->lba0);
+
+		lba = lba + sectors;
+
+		printk("%s:%d: finishing request lba 0x%x sectors 0x%x\n",
+			__FUNCTION__, __LINE__,
+			lba, sectors);
+
+		asd_sata_setup_lba(ata_hscb, lba, sectors);
+
+		asd_hwi_post_scb(asd, scb);
+
+		return;
+	}
+#endif
+
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+
+/* -----------------------------------
+ * WRITE_BUFFER: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_write_buffer_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	unsigned			buffer_offset;
+	unsigned			len;
+	unsigned			allocation_length;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	if ((dev->target->ata_cmdset.features_state & 
+		SATA_USES_WRITE_BUFFER) == 0) {
+
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	if ((cmd->cmnd[1] & BUFFER_MODE_MASK) != DATA_ONLY_MODE) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	/*
+	 * Only support Buffer ID of 0
+	 */
+	if (cmd->cmnd[2] != 0) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	buffer_offset = 
+		(cmd->cmnd[3] << 16) | (cmd->cmnd[4] << 8) | cmd->cmnd[5];
+
+	if (buffer_offset >= ATA_BUFFER_SIZE) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	allocation_length = 
+		(cmd->cmnd[6] << 16) | (cmd->cmnd[7] << 8) | cmd->cmnd[8];
+
+	len = MIN(ATA_BUFFER_SIZE - buffer_offset, cmd->request_bufflen);
+	len = MIN(len, allocation_length);
+
+	/*
+	 * We can't transfer more than the size of the buffer.
+	 */
+	cmd->request_bufflen = len;
+
+	asd_sata_setup_fis(ata_hscb, WIN_WRITE_BUFFER);
+
+	ata_hscb->ata_flags |= DATA_DIR_OUTBOUND;
+	SET_PIO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)cmd, asd_sata_write_buffer_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_write_buffer_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb	*ata_resp_edbp;
+	struct scsi_cmnd	*cmd;
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+	switch (done_listp->opcode) {
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	case TASK_COMP_WO_ERR:
+		asd_cmd_set_host_status(cmd, DID_OK);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	default:
+		break;
+	}
+
+	asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+
+/* -----------------------------------
+ * READ_BUFFER: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_read_buffer_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	uint8_t				*read_buffer_descriptor;
+	unsigned			buffer_offset;
+	unsigned			allocation_length;
+	unsigned			len;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	if ((dev->target->ata_cmdset.features_state & 
+		SATA_USES_READ_BUFFER) == 0) {
+
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	if (cmd->cmnd[2] != 0) {
+		/*
+		 * We are only supporting 1 buffer ID (== 0).
+		 */
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	allocation_length = 0;
+
+	if ((cmd->cmnd[1] & BUFFER_MODE_MASK) == DESCRIPTOR_MODE) {
+
+		if (cmd->request_bufflen < READ_BUFFER_DESCRIPTOR_LENGTH) {
+
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		read_buffer_descriptor = (uint8_t *)cmd->request_buffer;
+
+		memset(read_buffer_descriptor, 0, 
+			READ_BUFFER_DESCRIPTOR_LENGTH);
+
+		/*
+		 * ATA only supports ATA_BUFFER_SIZE byte buffer writes.
+		 */
+		read_buffer_descriptor[0] = 0;
+		read_buffer_descriptor[1] = (ATA_BUFFER_SIZE >> 16) & 0xff;
+		read_buffer_descriptor[2] = (ATA_BUFFER_SIZE >> 8) & 0xff;
+		read_buffer_descriptor[3] = ATA_BUFFER_SIZE & 0xff;
+
+		asd_cmd_set_host_status(cmd, DID_OK);
+
+		return ASD_COMMAND_BUILD_FINISHED;
+	}
+
+	if ((cmd->cmnd[1] & BUFFER_MODE_MASK) != DATA_ONLY_MODE) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	buffer_offset = 
+		(cmd->cmnd[3] << 16) | (cmd->cmnd[4] << 8) | cmd->cmnd[5];
+
+	if (buffer_offset >= ATA_BUFFER_SIZE) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	len = MIN(ATA_BUFFER_SIZE - buffer_offset, cmd->request_bufflen);
+	len = MIN(len, allocation_length);
+
+	/*
+	 * We can't transfer more than the size of the buffer.
+	 */
+	cmd->request_bufflen = len;
+
+	asd_sata_setup_fis(ata_hscb, WIN_READ_BUFFER);
+
+	ata_hscb->ata_flags |= DATA_DIR_INBOUND;
+	SET_PIO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)cmd, asd_sata_read_buffer_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_read_buffer_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb	*ata_resp_edbp;
+	struct scsi_cmnd	*cmd;
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+	switch (done_listp->opcode) {
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	case TASK_COMP_WO_ERR:
+		asd_cmd_set_host_status(cmd, DID_OK);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	default:
+		break;
+	}
+
+	asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+
+/* -----------------------------------
+ * READ_CAPACITY: (emulated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_read_capacity_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	struct hd_driveid		*hd_driveidp;
+	u_char				*read_capacity_data;
+	uint64_t			lba_capacity;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	hd_driveidp = &dev->target->ata_cmdset.adp_hd_driveid;
+
+	if (cmd->request_bufflen < READ_CAPACITY_DATA_LEN) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	read_capacity_data = (u_char *)cmd->request_buffer;
+
+	lba_capacity = *((uint64_t *)&hd_driveidp->lba_capacity_2);
+
+	/*
+	 * Ignore the Logical Block Address field and the PMI bit
+	 */
+	if (lba_capacity == 0) {
+		lba_capacity = *((uint32_t *)&hd_driveidp->lba_capacity);
+	}
+
+	*((uint32_t *)&read_capacity_data[0]) = ATA2SCSI_4(lba_capacity - 1);
+
+	*((uint32_t *)&read_capacity_data[4]) = ATA2SCSI_4(ATA_BLOCK_SIZE);
+
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+/* -----------------------------------
+ * REPORT_LUNS: (emulated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_report_luns_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	u_char		report_luns_data[REPORT_LUNS_SIZE];
+	unsigned	len;
+
+	memset(report_luns_data, 0, REPORT_LUNS_SIZE);
+
+	*((uint32_t *)&report_luns_data[0]) = asd_htobe32(8);
+
+	len = MIN(cmd->request_bufflen, REPORT_LUNS_SIZE);
+
+	memcpy(cmd->request_buffer, &report_luns_data[0], len);
+
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+/* -----------------------------------
+ * REQUEST_SENSE: (emulated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_request_sense_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+/* -----------------------------------
+ * REZERO_UNIT: (emulated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_rezero_unit_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+/* -----------------------------------
+ * SEEK_6: (emulated)
+ * SEEK_10: (emulated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_seek_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	switch (cmd->cmnd[0]) {
+	case SEEK_6:
+	case SEEK_10:
+		break;
+	}
+
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	return ASD_COMMAND_BUILD_FINISHED;
+}
+
+/* -----------------------------------
+ * SEND_DIAGNOSTIC: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_send_diagnostic_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	/*
+	 * "Execute Device Diagnostic"
+	 */
+	asd_sata_setup_fis(ata_hscb, WIN_DIAGNOSE);
+
+	ata_hscb->ata_flags |= DATA_DIR_NO_XFER;
+	SET_NO_IO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)cmd,
+		asd_sata_send_diagnostic_post);
+
+	if ((cmd->cmnd[1] & SELFTEST) == 0) {
+
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_COMMAND_OPERATION, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	if ((cmd->cmnd[1] & SELFTEST_CODE_MASK) != 0) {
+
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_COMMAND_OPERATION, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_send_diagnostic_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb	*ata_resp_edbp;
+	struct scsi_cmnd	*cmd;
+	COMMAND_SET_TYPE	command_set_type;
+	struct asd_device	*dev;
+	unsigned		error;
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+	dev = scb->platform_data->dev;
+
+	switch (done_listp->opcode) {
+	case CSMI_TASK_COMP_WO_ERR:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		break;
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+	default:
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_COMMAND_OPERATION, 0);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+	}
+
+	command_set_type = asd_sata_get_type(ASD_D2H_FIS(ata_resp_edbp));
+
+	if (command_set_type != dev->target->command_set_type) {
+		/*
+		 * Signatures don't match.
+		 */
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_COMMAND_OPERATION, 0);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+	}
+
+	asd_pop_post_stack(asd, scb, done_listp);
+
+	error = ASD_D2H_FIS(ata_resp_edbp)->error;
+	
+	if (error == 0x01) {
+		/*
+		 * device 0 passed
+		 */
+		asd_cmd_set_host_status(cmd, DID_OK);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+	}
+
+	if ((error == 0x00) || (error > 0x02)) {
+		/*
+		 * The device failed internal tests.
+		 */
+		asd_sata_set_check_condition(cmd, HARDWARE_ERROR,
+			LOGICAL_UNIT_FAILURE, FAILED_SELF_TEST);
+
+		asd_pop_post_stack(asd, scb, done_listp);
+
+		return;
+	}
+
+	asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+
+/* -----------------------------------
+ * START_STOP: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_start_stop_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	if (cmd->cmnd[4] & START_STOP_LOEJ) {
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	if (cmd->cmnd[4] & START_STOP_START) {
+		asd_sata_setup_fis(ata_hscb, WIN_IDLEIMMEDIATE);
+	} else {
+		/*
+		 * "Standby Immediate"
+		 */
+		asd_sata_setup_fis(ata_hscb, WIN_STANDBYNOW1);
+	}
+
+	ata_hscb->ata_flags |= DATA_DIR_NO_XFER;
+	SET_NO_IO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)cmd, asd_sata_start_stop_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_start_stop_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb	*ata_resp_edbp;
+	struct scsi_cmnd	*cmd;
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+	switch (done_listp->opcode) {
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	case TASK_COMP_WO_ERR:
+		asd_cmd_set_host_status(cmd, DID_OK);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	default:
+		break;
+	}
+
+	asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+
+/* -----------------------------------
+ * SYNCHRONIZE_CACHE: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_synchronize_cache_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	asd_sata_setup_fis(ata_hscb, WIN_FLUSH_CACHE);
+
+	ata_hscb->ata_flags |= DATA_DIR_NO_XFER;
+	SET_NO_IO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)cmd,
+		asd_sata_synchronize_cache_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_synchronize_cache_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb	*ata_resp_edbp;
+	struct scsi_cmnd	*cmd;
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+	switch (done_listp->opcode) {
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	case TASK_COMP_WO_ERR:
+		asd_cmd_set_host_status(cmd, DID_OK);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	default:
+		break;
+	}
+
+	asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_COMMAND_OPERATION, 0);
+
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+
+/* -----------------------------------
+ * TEST_UNIT_READY: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_test_unit_ready_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	struct hd_driveid		*hd_driveidp;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	hd_driveidp = &dev->target->ata_cmdset.adp_hd_driveid;
+
+	if ((hd_driveidp->command_set_1 & POWER_MANAGEMENT_SUPPORTED) == 0) {
+
+		asd_cmd_set_host_status(cmd, DID_OK);
+
+		return ASD_COMMAND_BUILD_FINISHED;
+	}
+
+	asd_sata_setup_fis(ata_hscb, WIN_CHECKPOWERMODE1);
+
+	/*
+	 * The CSMI task bit is a misnomer.  It really means to return an
+	 * ATA Response Empty Buffer done list entry even though there was no
+	 * error.  Normally this buffer gets returned from a ATA TASK COMPLETE
+	 * WITH RESPONSE done list entry.
+	 */
+	ata_hscb->ata_flags |= (DATA_DIR_NO_XFER | CSMI_TASK);
+	SET_NO_IO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)cmd,
+		asd_sata_test_unit_ready_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+
+void
+asd_sata_test_unit_ready_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb		*ata_resp_edbp;
+	struct scsi_cmnd		*cmd;
+	struct asd_ata_task_hscb	*ata_hscb;
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+	switch (done_listp->opcode) {
+	case CSMI_TASK_COMP_WO_ERR:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		break;
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+	default:
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_COMMAND_OPERATION, 0);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+	}
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	switch (ASD_H2D_FIS(ata_hscb)->sector_count) {
+#if 0
+	// RST - this doesn't seem to work
+	case ATA_STANDBY_MODE:
+		asd_sata_set_check_condition(cmd, NOT_READY,
+			LOGICAL_UNIT_NOT_READY, NOTIFY_REQUIRED);
+		break;
+#endif
+
+	default:
+	case ATA_IDLE_MODE:
+	case ATA_ACTIVE:
+		asd_cmd_set_host_status(cmd, DID_OK);
+		break;
+	}
+
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+
+#ifdef T10_04_136
+/* -----------------------------------
+ * VERIFY: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_verify_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	if (target->ata_cmdset.features_state & SATA_USES_48BIT) {
+		asd_sata_setup_fis(ata_hscb, WIN_VERIFY_EXT);
+	} else {
+		asd_sata_setup_fis(ata_hscb, WIN_VERIFY);
+	}
+
+	ata_hscb->ata_flags |= DATA_DIR_NO_XFER;
+	SET_NO_IO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)acmd,
+		asd_sata_verify_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_verify_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	// RST - fill this in
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+#endif
+
+
+/* -----------------------------------
+ * WRITE_6: (translated)
+ * WRITE_10: (translated)
+ * WRITE_12: (translated)
+ */
+
+// RST - we need a tag somehow
+ASD_COMMAND_BUILD_STATUS
+asd_sata_write_build(
+struct asd_softc	*asd,
+struct asd_device	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	uint32_t			lba;
+	unsigned			sectors;
+	unsigned			fis_command;
+	unsigned			fua_bit;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	switch (cmd->cmnd[0]) {
+	case WRITE_6:
+		lba = (cmd->cmnd[2] << 8) | cmd->cmnd[3];
+		sectors = cmd->cmnd[4];
+
+		break;
+
+	case WRITE_10:
+		lba = (cmd->cmnd[2] << 24) | (cmd->cmnd[3] << 16) |
+			(cmd->cmnd[4] << 8) | cmd->cmnd[5];
+		sectors = (cmd->cmnd[7] << 8) | cmd->cmnd[8];
+
+		break;
+
+	case WRITE_12:
+		lba = (cmd->cmnd[2] << 24) | (cmd->cmnd[3] << 16) |
+			(cmd->cmnd[4] << 8) | cmd->cmnd[5];
+		sectors = (cmd->cmnd[6] << 24) | (cmd->cmnd[7] << 16) |
+			(cmd->cmnd[8] << 8) | cmd->cmnd[9];
+
+		break;
+	default:
+		lba = 0;
+		sectors = 0;
+	}
+
+	fua_bit = 0;
+
+	switch (cmd->cmnd[0]) {
+	case WRITE_10:
+	case WRITE_12:
+		if (cmd->cmnd[1] & 0x01) {
+			/*
+			 * Obsolete field that we will fail.
+			 */
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		if (sectors == 0) {
+			asd_cmd_set_host_status(cmd, DID_OK);
+
+			return ASD_COMMAND_BUILD_FINISHED;
+		}
+
+		if ((dev->target->ata_cmdset.features_state & 
+			SATA_USES_WRITE_FUA) != 0) {
+
+			fua_bit = cmd->cmnd[1] & SCSI_WRITE_FUA_BIT;
+		}
+		break;
+	}
+
+	fis_command = 0;
+
+	switch (dev->target->ata_cmdset.features_state & 
+		(SATA_USES_DMA | SATA_USES_48BIT | SATA_USES_QUEUEING)) {
+	case 0:
+		fis_command = WIN_WRITE;
+		break;
+	case SATA_USES_DMA:
+		fis_command = WIN_WRITEDMA;
+		break;
+	case SATA_USES_48BIT:
+		fis_command = WIN_WRITE_EXT;
+		break;
+	case SATA_USES_QUEUEING:
+		// Doesn't exist;
+		break;
+	case SATA_USES_DMA | SATA_USES_48BIT:
+		if (fua_bit) {
+			fis_command = WIN_WRITE_DMA_FUA_EXT;
+		} else {
+			fis_command = WIN_WRITEDMA_EXT;
+		}
+		break;
+	case SATA_USES_DMA | SATA_USES_QUEUEING:
+		fis_command = WIN_WRITEDMA_QUEUED;
+		break;
+	case SATA_USES_48BIT | SATA_USES_QUEUEING:
+		// Doesn't exist
+		break;
+	case SATA_USES_DMA | SATA_USES_48BIT | SATA_USES_QUEUEING:
+		if (fua_bit) {
+			fis_command = WIN_WRITE_DMA_QUEUED_FUA_EXT;
+		} else {
+			fis_command = WIN_WRITEDMA_QUEUED_EXT;
+		}
+		break;
+	default:
+		fis_command = 0;
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+			INVALID_FIELD_IN_CDB, 0);
+		return ASD_COMMAND_BUILD_FAILED;
+	}
+
+	asd_sata_setup_fis(ata_hscb, fis_command);
+
+	if (dev->target->ata_cmdset.features_state & SATA_USES_DMA) {
+		SET_DMA_MODE(ata_hscb);
+	} else {
+		SET_PIO_MODE(ata_hscb);
+	}
+
+	if (dev->target->ata_cmdset.features_state & SATA_USES_48BIT) {
+
+		asd_sata_setup_lba_ext(ata_hscb, lba, sectors);
+
+	} else {
+		if (lba >= RW_DMA_LBA_SIZE) {
+
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		if (sectors > RW_DMA_MAX_SECTORS) {
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		if (sectors == RW_DMA_MAX_SECTORS) {
+			sectors = 0;
+		}
+
+		asd_sata_setup_lba(ata_hscb, lba, sectors);
+	}
+
+	ata_hscb->ata_flags |= DATA_DIR_OUTBOUND;
+
+	asd_push_post_stack(asd, scb, (void *)cmd,
+		asd_sata_write_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_write_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	struct ata_resp_edb		*ata_resp_edbp;
+	struct scsi_cmnd		*cmd;
+#if 0
+	uint32_t			lba;
+	struct asd_ata_task_hscb	*ata_hscb;
+	unsigned			sectors;
+#endif
+
+	cmd = (struct scsi_cmnd *)scb->io_ctx;
+
+#if 0
+	ata_hscb = &scb->hscb->ata_task;
+#endif
+
+	switch (done_listp->opcode) {
+	case ATA_TASK_COMP_W_RESP:
+		ata_resp_edbp = asd_sata_get_edb(asd, done_listp);
+		asd_sata_check_registers(ata_resp_edbp, scb, cmd);
+		asd_pop_post_stack(asd, scb, done_listp);
+		return;
+
+	case TASK_COMP_WO_ERR:
+		break;
+
+	default:
+		asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_COMMAND_OPERATION, 0);
+
+		asd_pop_post_stack(asd, scb, done_listp);
+
+		return;
+	}
+
+#if 0
+	if (scb->sectors_remaining != 0) {
+
+		sectors = scb->sectors_remaining;
+
+		if (sectors >= RW_DMA_MAX_SECTORS) {
+			scb->sectors_remaining = 
+				scb->sectors_remaining - RW_DMA_MAX_SECTORS;
+
+			sectors = 0;
+		} else {
+
+			scb->sectors_remaining = 0;
+		}
+
+		lba = (ASD_H2D_FIS(ata_hscb)->lba2  << 16) |
+			(ASD_H2D_FIS(ata_hscb)->lba1 << 8) |
+			(ASD_H2D_FIS(ata_hscb)->lba0);
+
+		lba = lba + sectors;
+
+		printk("%s:%d: finishing request lba 0x%x sectors 0x%x "
+			"remaining 0x%x\n",
+			__FUNCTION__, __LINE__,
+			lba, sectors, scb->sectors_remaining);
+
+		asd_sata_setup_lba(ata_hscb, lba, sectors);
+
+		ret = asd_setup_data(asd, scb, cmd);
+
+		asd_hwi_post_scb(asd, scb);
+
+
+		return;
+	}
+#endif
+
+	asd_cmd_set_host_status(cmd, DID_OK);
+
+	asd_pop_post_stack(asd, scb, done_listp);
+
+	return;
+}
+
+#ifdef T10_04_136
+/* -----------------------------------
+ * WRITE_VERIFY: (translated)
+ */
+
+ASD_COMMAND_BUILD_STATUS
+asd_sata_write_verify_build(
+struct asd_softc	*asd,
+struct asd_device 	*dev,
+struct scb		*scb,
+struct scsi_cmnd	*cmd
+)
+{
+	struct asd_ata_task_hscb	*ata_hscb;
+	uint32_t			lba;
+	unsigned			sectors;
+
+	ata_hscb = &scb->hscb->ata_task;
+
+	lba = (cmd->cmnd[2] << 24) | (cmd->cmnd[3] << 16) |
+		(cmd->cmnd[4] << 8) | cmd->cmnd[5];
+
+	sectors = (cmd->cmnd[7] << 8) | cmd->cmnd[8];
+
+	// RST - this should be a WRITE with FUA followed by a read verify.
+	// ... we will want to set affiliation bits in the ata_hscb
+
+	if (target->ata_cmdset.features_state & SATA_USES_48BIT) {
+		/*
+		 * Read Verify Sectors
+		 */
+		asd_sata_setup_fis(ata_hscb, WIN_VERIFY_EXT);
+	} else {
+		if (sectors > RW_DMA_MAX_SECTORS) {
+			asd_sata_set_check_condition(cmd, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+
+			return ASD_COMMAND_BUILD_FAILED;
+		}
+
+		if (sectors == RW_DMA_MAX_SECTORS) {
+			sectors = 0;
+		}
+
+		asd_sata_setup_fis(ata_hscb, WIN_VERIFY);
+	}
+
+	ata_hscb->ata_flags |= DATA_DIR_NO_XFER;
+	SET_NO_IO_MODE(ata_hscb);
+
+	asd_push_post_stack(asd, scb, (void *)acmd,
+		asd_sata_write_verify_post);
+
+	return ASD_COMMAND_BUILD_OK;
+}
+
+void
+asd_sata_write_verify_post(
+struct asd_softc	*asd,
+struct scb		*scb,
+struct asd_done_list	*done_listp
+)
+{
+	asd_pop_post_stack(asd, scb, done_listp);
+}
+#endif
+
+#if 0
+void
+asd_print_hex(
+unsigned char	*s,
+unsigned	len
+)
+{
+	unsigned	i;
+	unsigned	count;
+
+	while (len != 0) {
+		count = (len > 16) ? 16 : len;
+
+		for (i = 0 ; i < count ; i++) {
+			printk("%02x ", *(s + i));
+		}
+
+		for ( ; i < 16 ; i++) {
+			printk("   ");
+		}
+
+		for (i = 0 ; i < count ; i++) {
+			if (((*(s + i) >= 'a') && (*(s + i) <= 'z')) ||
+			    ((*(s + i) >= 'A') && (*(s + i) <= 'Z')) ||
+			    ((*(s + i) >= '0') && (*(s + i) <= '9'))) {
+				printk("%c", *(s + i));
+			} else {
+				printk(".");
+			}
+		}
+
+		printk("\n");
+
+		len = len - count;
+
+		s = s + count;
+	}
+}
+#endif

