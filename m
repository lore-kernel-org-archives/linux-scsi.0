From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/6] cleanup qla1280_nvram_config
Date: Sun, 6 Jun 2004 14:58:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606125825.GE31063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:29386 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263574AbUFFM6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:58:30 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org

qla1280_nvram_config is a huge mess.  Split it up into managable
subroutines and add suport for the ISP1040 to it.  Add missing call
to set the age limit also on 1280/1x160.


diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	2004-06-06 14:47:07 +02:00
+++ b/drivers/scsi/qla1280.c	2004-06-06 14:47:07 +02:00
@@ -2286,117 +2286,9 @@
 	return status;
 }
 
-/*
- * NVRAM configuration.
- *
- * Input:
- *      ha                = adapter block pointer.
- *      ha->request_ring  = request ring virtual address
- *
- * Output:
- *      host adapters parameters in host adapter block
- *
- * Returns:
- *      0 = success.
- */
-static int
-qla1280_nvram_config(struct scsi_qla_host *ha)
+static void
+qla1280_print_settings(struct nvram *nv)
 {
-	struct device_reg *reg = ha->iobase;
-	struct nvram *nv;
-	int status = 0;
-	int bus, target, lun;
-	uint16_t mb[MAILBOX_REGISTER_COUNT];
-	uint16_t mask;
-
-	ENTER("qla1280_nvram_config");
-
-	nv = &ha->nvram;
-	if (!ha->nvram_valid) {
-		dprintk(1, "Using defaults for NVRAM: \n");
-		memset(nv, 0, sizeof(struct nvram));
-
-		/* nv->cntr_flags_1.disable_loading_risc_code = 1; */
-		nv->firmware_feature.f.enable_fast_posting = 1;
-		nv->firmware_feature.f.disable_synchronous_backoff = 1;
-
-		nv->termination.f.scsi_bus_0_control = 3;
-		nv->termination.f.scsi_bus_1_control = 3;
-		nv->termination.f.auto_term_support = 1;
-
-		/*
-		 * Set default FIFO magic - What appropriate values
-		 * would be here is unknown. This is what I have found
-		 * testing with 12160s.
-		 * Now, I would love the magic decoder ring for this one,
-		 * the header file provided by QLogic seems to be bogus
-		 * or incomplete at best.
-		 */
-		nv->isp_config.c = 0x44;
-
-		if (IS_ISP1x160(ha))
-			nv->isp_parameter = 0x01;
-
-		for (bus = 0; bus < MAX_BUSES; bus++) {
-			nv->bus[bus].config_1.initiator_id = 7;
-			nv->bus[bus].bus_reset_delay = 5;
-			/* 8 = 5.0 clocks */
-			nv->bus[bus].config_2.async_data_setup_time = 8;
-			nv->bus[bus].config_2.req_ack_active_negation = 1;
-			nv->bus[bus].config_2.data_line_active_negation = 1;
-			nv->bus[bus].selection_timeout = 250;
-			nv->bus[bus].max_queue_depth = 256;
-
-			for (target = 0; target < MAX_TARGETS; target++) {
-				nv->bus[bus].target[target].parameter.f.
-					renegotiate_on_error = 1;
-				nv->bus[bus].target[target].parameter.f.
-					auto_request_sense = 1;
-				nv->bus[bus].target[target].parameter.f.
-					tag_queuing = 1;
-				nv->bus[bus].target[target].parameter.f.
-					enable_sync = 1;
-#if 1	/* Some SCSI Processors do not seem to like this */
-				nv->bus[bus].target[target].parameter.f.
-					enable_wide = 1;
-#endif
-				nv->bus[bus].target[target].parameter.f.
-					parity_checking = 1;
-				nv->bus[bus].target[target].parameter.f.
-					disconnect_allowed = 1;
-				nv->bus[bus].target[target].execution_throttle=
-					nv->bus[bus].max_queue_depth - 1;
-				if (IS_ISP1x160(ha)) {
-					nv->bus[bus].target[target].flags.
-						flags1x160.device_enable = 1;
-					nv->bus[bus].target[target].flags.
-						flags1x160.sync_offset = 0x0e;
-					nv->bus[bus].target[target].
-						sync_period = 9;
-					nv->bus[bus].target[target].
-						ppr_1x160.flags.enable_ppr = 1;
-					nv->bus[bus].target[target].ppr_1x160.
-						flags.ppr_options = 2;
-					nv->bus[bus].target[target].ppr_1x160.
-						flags.ppr_bus_width = 1;
-				} else {
-					nv->bus[bus].target[target].flags.
-						flags1x80.device_enable = 1;
-					nv->bus[bus].target[target].flags.
-						flags1x80.sync_offset = 0x8;
-					nv->bus[bus].target[target].
-						sync_period = 10;
-				}
-			}
-		}
-	} else {
-		/* Always force AUTO sense for LINUX SCSI */
-		for (bus = 0; bus < MAX_BUSES; bus++)
-			for (target = 0; target < MAX_TARGETS; target++) {
-				nv->bus[bus].target[target].parameter.f.
-					auto_request_sense = 1;
-			}
-	}
 	dprintk(1, "qla1280 : initiator scsi id bus[0]=%d\n",
 		nv->bus[0].config_1.initiator_id);
 	dprintk(1, "qla1280 : initiator scsi id bus[1]=%d\n",
@@ -2442,36 +2334,264 @@
 		nv->bus[0].max_queue_depth);
 	dprintk(1, "qla1280 : max queue depth[1]=%d\n",
 		nv->bus[1].max_queue_depth);
+}
+
+static void
+qla1280_set_target_defaults(struct scsi_qla_host *ha, int bus, int target)
+{
+	struct nvram *nv = &ha->nvram;
+
+	nv->bus[bus].target[target].parameter.f.renegotiate_on_error = 1;
+	nv->bus[bus].target[target].parameter.f.auto_request_sense = 1;
+	nv->bus[bus].target[target].parameter.f.tag_queuing = 1;
+	nv->bus[bus].target[target].parameter.f.enable_sync = 1;
+#if 1	/* Some SCSI Processors do not seem to like this */
+	nv->bus[bus].target[target].parameter.f.enable_wide = 1;
+#endif
+	if (!IS_ISP1040(ha))
+		nv->bus[bus].target[target].parameter.f.parity_checking = 1;
+
+	nv->bus[bus].target[target].parameter.f.disconnect_allowed = 1;
+	nv->bus[bus].target[target].execution_throttle =
+		nv->bus[bus].max_queue_depth - 1;
+
+	if (IS_ISP1x160(ha)) {
+		nv->bus[bus].target[target].flags.flags1x160.device_enable = 1;
+		nv->bus[bus].target[target].flags.flags1x160.sync_offset = 0x0e;
+		nv->bus[bus].target[target].sync_period = 9;
+		nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr = 1;
+		nv->bus[bus].target[target].ppr_1x160.flags.ppr_options = 2;
+		nv->bus[bus].target[target].ppr_1x160.flags.ppr_bus_width = 1;
+	} else {
+		nv->bus[bus].target[target].flags.flags1x80.device_enable = 1;
+		nv->bus[bus].target[target].flags.flags1x80.sync_offset = 12;
+		nv->bus[bus].target[target].sync_period = 10;
+	}
+}
+
+static void
+qla1280_set_defaults(struct scsi_qla_host *ha)
+{
+	struct nvram *nv = &ha->nvram;
+	int bus, target;
+
+	dprintk(1, "Using defaults for NVRAM: \n");
+	memset(nv, 0, sizeof(struct nvram));
+
+	/* nv->cntr_flags_1.disable_loading_risc_code = 1; */
+	nv->firmware_feature.f.enable_fast_posting = 1;
+	nv->firmware_feature.f.disable_synchronous_backoff = 1;
+	nv->termination.f.scsi_bus_0_control = 3;
+	nv->termination.f.scsi_bus_1_control = 3;
+	nv->termination.f.auto_term_support = 1;
+
+	/*
+	 * Set default FIFO magic - What appropriate values would be here
+	 * is unknown. This is what I have found testing with 12160s.
+	 *
+	 * Now, I would love the magic decoder ring for this one, the
+	 * header file provided by QLogic seems to be bogus or incomplete
+	 * at best.
+	 */
+	nv->isp_config.c = ISP_CFG1_BENAB|ISP_CFG1_F128;
+	if (IS_ISP1x160(ha))
+		nv->isp_parameter = 0x01; /* fast memory enable */
+
+	for (bus = 0; bus < MAX_BUSES; bus++) {
+		nv->bus[bus].config_1.initiator_id = 7;
+		nv->bus[bus].config_2.req_ack_active_negation = 1;
+		nv->bus[bus].config_2.data_line_active_negation = 1;
+		nv->bus[bus].selection_timeout = 250;
+		nv->bus[bus].max_queue_depth = 256;
+
+		if (IS_ISP1040(ha)) {
+			nv->bus[bus].bus_reset_delay = 3;
+			nv->bus[bus].config_2.async_data_setup_time = 6;
+			nv->bus[bus].retry_delay = 1;
+		} else {
+			nv->bus[bus].bus_reset_delay = 5;
+			nv->bus[bus].config_2.async_data_setup_time = 8;
+		}
+
+		for (target = 0; target < MAX_TARGETS; target++)
+			qla1280_set_target_defaults(ha, bus, target);
+	}
+}
+
+static int
+qla1280_config_target(struct scsi_qla_host *ha, int bus, int target)
+{
+	struct nvram *nv = &ha->nvram;
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
+	int status, lun;
+
+	/* Set Target Parameters. */
+	mb[0] = MBC_SET_TARGET_PARAMETERS;
+	mb[1] = (uint16_t) (bus ? target | BIT_7 : target);
+	mb[1] <<= 8;
+
+	/*
+	 * Do not enable wide, sync, and ppr for the initial
+	 * INQUIRY run. We enable this later if we determine
+	 * the target actually supports it.
+	 */
+	nv->bus[bus].target[target].parameter.f.
+		auto_request_sense = 1;
+	nv->bus[bus].target[target].parameter.f.
+		stop_queue_on_check = 0;
+
+	if (IS_ISP1x160(ha))
+		nv->bus[bus].target[target].ppr_1x160.
+			flags.enable_ppr = 0;
+
+	/*
+	 * No sync, wide, etc. while probing
+	 */
+	mb[2] = (nv->bus[bus].target[target].parameter.c << 8) &
+		~(TP_SYNC /*| TP_WIDE | TP_PPR*/);
+
+	if (IS_ISP1x160(ha))
+		mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8;
+	else
+		mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8;
+	mb[3] |= nv->bus[bus].target[target].sync_period;
+
+	status = qla1280_mailbox_command(ha, BIT_3 | BIT_2 | BIT_1 | BIT_0, &mb[0]);
+
+	/* Save Tag queuing enable flag. */
+	mb[0] = BIT_0 << target;
+	if (nv->bus[bus].target[target].parameter.f.tag_queuing)
+		ha->bus_settings[bus].qtag_enables |= mb[0];
+
+	/* Save Device enable flag. */
+	if (IS_ISP1x160(ha)) {
+		if (nv->bus[bus].target[target].flags.flags1x160.device_enable)
+			ha->bus_settings[bus].device_enables |= mb[0];
+		ha->bus_settings[bus].lun_disables |= 0;
+	} else {
+		if (nv->bus[bus].target[target].flags.flags1x80.device_enable)
+			ha->bus_settings[bus].device_enables |= mb[0];
+		/* Save LUN disable flag. */
+		if (nv->bus[bus].target[target].flags.flags1x80.lun_disable)
+			ha->bus_settings[bus].lun_disables |= mb[0];
+	}
+
+	/* Set Device Queue Parameters. */
+	for (lun = 0; lun < MAX_LUNS; lun++) {
+		mb[0] = MBC_SET_DEVICE_QUEUE;
+		mb[1] = (uint16_t)(bus ? target | BIT_7 : target);
+		mb[1] = mb[1] << 8 | lun;
+		mb[2] = nv->bus[bus].max_queue_depth;
+		mb[3] = nv->bus[bus].target[target].execution_throttle;
+		status |= qla1280_mailbox_command(ha, 0x0f, &mb[0]);
+	}
+
+	return status;
+}
+
+static int
+qla1280_config_bus(struct scsi_qla_host *ha, int bus)
+{
+	struct nvram *nv = &ha->nvram;
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
+	int target, status;
+
+	/* SCSI Reset Disable. */
+	ha->bus_settings[bus].disable_scsi_reset =
+		nv->bus[bus].config_1.scsi_reset_disable;
+
+	/* Initiator ID. */
+	ha->bus_settings[bus].id = nv->bus[bus].config_1.initiator_id;
+	mb[0] = MBC_SET_INITIATOR_ID;
+	mb[1] = bus ? ha->bus_settings[bus].id | BIT_7 :
+		ha->bus_settings[bus].id;
+	status = qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
+
+	/* Reset Delay. */
+	ha->bus_settings[bus].bus_reset_delay =
+		nv->bus[bus].bus_reset_delay;
+
+	/* Command queue depth per device. */
+	ha->bus_settings[bus].hiwat = nv->bus[bus].max_queue_depth - 1;
+
+	/* Set target parameters. */
+	for (target = 0; target < MAX_TARGETS; target++)
+		status |= qla1280_config_target(ha, bus, target);
+
+	return status;
+}
+
+static int
+qla1280_nvram_config(struct scsi_qla_host *ha)
+{
+	struct device_reg *reg = ha->iobase;
+	struct nvram *nv = &ha->nvram;
+	int bus, target, status = 0;
+	uint16_t mb[MAILBOX_REGISTER_COUNT];
+	uint16_t mask;
+
+	ENTER("qla1280_nvram_config");
+
+	if (ha->nvram_valid) {
+		/* Always force AUTO sense for LINUX SCSI */
+		for (bus = 0; bus < MAX_BUSES; bus++)
+			for (target = 0; target < MAX_TARGETS; target++) {
+				nv->bus[bus].target[target].parameter.f.
+					auto_request_sense = 1;
+			}
+	} else {
+		qla1280_set_defaults(ha);
+	}
+
+	qla1280_print_settings(nv);
 
 	/* Disable RISC load of firmware. */
 	ha->flags.disable_risc_code_load =
 		nv->cntr_flags_1.disable_loading_risc_code;
 
-	/* Set ISP hardware DMA burst */
-	mb[0] = nv->isp_config.c;
-	/* Enable DMA arbitration on dual channel controllers */
-	if (ha->ports > 1)
-		mb[0] |= BIT_13;
-	WRT_REG_WORD(&reg->cfg_1, mb[0]);
-
-#if 1	/* Is this safe? */
-	/* Set SCSI termination. */
-	WRT_REG_WORD(&reg->gpio_enable, (BIT_3 + BIT_2 + BIT_1 + BIT_0));
-	mb[0] = nv->termination.c & (BIT_3 + BIT_2 + BIT_1 + BIT_0);
-	WRT_REG_WORD(&reg->gpio_data, mb[0]);
-#endif
+	if (IS_ISP1040(ha)) {
+		uint16_t hwrev, cfg1, cdma_conf, ddma_conf;
+
+		hwrev = RD_REG_WORD(&reg->cfg_0) & ISP_CFG0_HWMSK;
+
+		cfg1 = RD_REG_WORD(&reg->cfg_1);
+		cdma_conf = RD_REG_WORD(&reg->cdma_cfg);
+		ddma_conf = RD_REG_WORD(&reg->ddma_cfg);
+
+		/* Busted fifo, says mjacob. */
+		if (hwrev == ISP_CFG0_1040A)
+			WRT_REG_WORD(&reg->cfg_1, cfg1 | ISP_CFG1_F64);
+		else
+			WRT_REG_WORD(&reg->cfg_1, cfg1 | ISP_CFG1_F64 | ISP_CFG1_BENAB);
+
+		WRT_REG_WORD(&reg->cdma_cfg, cdma_conf | CDMA_CONF_BENAB);
+		WRT_REG_WORD(&reg->ddma_cfg, cdma_conf | DDMA_CONF_BENAB);
+	} else {
+		/* Set ISP hardware DMA burst */
+		mb[0] = nv->isp_config.c;
+		/* Enable DMA arbitration on dual channel controllers */
+		if (ha->ports > 1)
+			mb[0] |= BIT_13;
+		WRT_REG_WORD(&reg->cfg_1, mb[0]);
+
+		/* Set SCSI termination. */
+		WRT_REG_WORD(&reg->gpio_enable, (BIT_3 + BIT_2 + BIT_1 + BIT_0));
+		mb[0] = nv->termination.c & (BIT_3 + BIT_2 + BIT_1 + BIT_0);
+		WRT_REG_WORD(&reg->gpio_data, mb[0]);
+	}
 
 	/* ISP parameter word. */
 	mb[0] = MBC_SET_SYSTEM_PARAMETER;
 	mb[1] = nv->isp_parameter;
 	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
 
-#if 0
-	/* clock rate - for qla1240 and older, only */
-	mb[0] = MBC_SET_CLOCK_RATE;
-	mb[1] = 0x50;
- 	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
-#endif
+	if (IS_ISP1x40(ha)) {
+		/* clock rate - for qla1240 and older, only */
+		mb[0] = MBC_SET_CLOCK_RATE;
+		mb[1] = 40;
+	 	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
+	}
+
 	/* Firmware feature word. */
 	mb[0] = MBC_SET_FIRMWARE_FEATURES;
 	mask = BIT_5 | BIT_1 | BIT_0;
@@ -2524,114 +2644,18 @@
 	mb[2] = 2;	/* Command DMA Channel Burst Enable */
 	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, &mb[0]);
 
+	mb[0] = MBC_SET_TAG_AGE_LIMIT;
+	mb[1] = 8;
+	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
+
 	/* Selection timeout. */
 	mb[0] = MBC_SET_SELECTION_TIMEOUT;
 	mb[1] = nv->bus[0].selection_timeout;
 	mb[2] = nv->bus[1].selection_timeout;
 	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, &mb[0]);
 
-	for (bus = 0; bus < ha->ports; bus++) {
-		/* SCSI Reset Disable. */
-		ha->bus_settings[bus].disable_scsi_reset =
-			nv->bus[bus].config_1.scsi_reset_disable;
-
-		/* Initiator ID. */
-		ha->bus_settings[bus].id = nv->bus[bus].config_1.initiator_id;
-		mb[0] = MBC_SET_INITIATOR_ID;
-		mb[1] = bus ? ha->bus_settings[bus].id | BIT_7 :
-			ha->bus_settings[bus].id;
-		status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
-
-		/* Reset Delay. */
-		ha->bus_settings[bus].bus_reset_delay =
-			nv->bus[bus].bus_reset_delay;
-
-		/* Command queue depth per device. */
-		ha->bus_settings[bus].hiwat = nv->bus[bus].max_queue_depth - 1;
-
-		/* Set target parameters. */
-		for (target = 0; target < MAX_TARGETS; target++) {
-			uint8_t mr = BIT_2 | BIT_1 | BIT_0;
-
-			/* Set Target Parameters. */
-			mb[0] = MBC_SET_TARGET_PARAMETERS;
-			mb[1] = (uint16_t) (bus ? target | BIT_7 : target);
-			mb[1] <<= 8;
-			/*
-			 * Do not enable wide, sync, and ppr for the initial
-			 * INQUIRY run. We enable this later if we determine
-			 * the target actually supports it.
-			 */
-			nv->bus[bus].target[target].parameter.f.
-				auto_request_sense = 1;
-			nv->bus[bus].target[target].parameter.f.
-				stop_queue_on_check = 0;
-
-			if (IS_ISP1x160(ha)) {
-				nv->bus[bus].target[target].ppr_1x160.
-					flags.enable_ppr = 0;
-			}
-
-			/*
-			 * No sync, wide, etc. while probing
-			 */
-			mb[2] = (nv->bus[bus].target[target].parameter.c << 8)&
-				~(TP_SYNC /*| TP_WIDE | TP_PPR*/);
-
-			if (IS_ISP1x160(ha))
-				mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8;
-			else
-				mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8;
-			mb[3] |= nv->bus[bus].target[target].sync_period;
-			mr |= BIT_3;
-
-			/*
-			 * We don't want to enable ppr etc. before we have 
-			 * determined that the target actually supports it
-			 */
-#if 0
-			if (IS_ISP1x160(ha)) {
-				mb[2] |= nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr << 5;
-
-				mb[6] =	nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8;
-				mb[6] |= nv->bus[bus].target[target].ppr_1x160.flags.ppr_bus_width;
-				mr |= BIT_6;
-			}
-#endif
-
-			status = qla1280_mailbox_command(ha, mr, &mb[0]);
-
-			/* Save Tag queuing enable flag. */
-			mb[0] = BIT_0 << target;
-			if (nv->bus[bus].target[target].parameter.f.tag_queuing)
-				ha->bus_settings[bus].qtag_enables |= mb[0];
-
-			/* Save Device enable flag. */
-			if (IS_ISP1x160(ha)) {
-				if (nv->bus[bus].target[target].flags.flags1x160.device_enable)
-					ha->bus_settings[bus].device_enables |= mb[0];
-				ha->bus_settings[bus].lun_disables |= 0;
-			} else {
-				if (nv->bus[bus].target[target].flags.flags1x80.device_enable)
-					ha->bus_settings[bus].device_enables |= mb[0];
-				/* Save LUN disable flag. */
-				if (nv->bus[bus].target[target].flags.flags1x80.lun_disable)
-				ha->bus_settings[bus].lun_disables |= mb[0];
-			}
-
-
-			/* Set Device Queue Parameters. */
-			for (lun = 0; lun < MAX_LUNS; lun++) {
-				mb[0] = MBC_SET_DEVICE_QUEUE;
-				mb[1] = (uint16_t)(bus ? target | BIT_7 : target);
-				mb[1] = mb[1] << 8 | lun;
-				mb[2] = nv->bus[bus].max_queue_depth;
-				mb[3] = nv->bus[bus].target[target].execution_throttle;
-				status |= qla1280_mailbox_command(ha, 0x0f,
-								  &mb[0]);
-			}
-		}
-	}
+	for (bus = 0; bus < ha->ports; bus++)
+		status |= qla1280_config_bus(ha, bus);
 
 	if (status)
 		dprintk(2, "qla1280_nvram_config: **** FAILED ****\n");
