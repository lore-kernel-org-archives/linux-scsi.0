From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] qla1280: qla1280: don't use bitfields for hardware access, parameters
Date: Mon, 4 Jul 2005 17:49:22 +0200
Message-ID: <20050704154922.GI30435@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59852 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261345AbVGDPta (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2005 11:49:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org, ths@linux-mips.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thiemo Seufer <ths@linux-mips.org>

Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c	2005-06-26 16:58:59.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.c	2005-06-26 16:59:06.000000000 +0200
@@ -1328,7 +1328,7 @@
 	uint8_t mr;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct nvram *nv;
-	int status;
+	int status, lun;
 
 	nv = &ha->nvram;
 
@@ -1336,24 +1336,38 @@
 
 	/* Set Target Parameters. */
 	mb[0] = MBC_SET_TARGET_PARAMETERS;
-	mb[1] = (uint16_t) (bus ? target | BIT_7 : target);
-	mb[1] <<= 8;
-
-	mb[2] = (nv->bus[bus].target[target].parameter.c << 8);
+	mb[1] = (uint16_t)((bus ? target | BIT_7 : target) << 8);
+	mb[2] = nv->bus[bus].target[target].parameter.renegotiate_on_error << 8;
+	mb[2] |= nv->bus[bus].target[target].parameter.stop_queue_on_check << 9;
+	mb[2] |= nv->bus[bus].target[target].parameter.auto_request_sense << 10;
+	mb[2] |= nv->bus[bus].target[target].parameter.tag_queuing << 11;
+	mb[2] |= nv->bus[bus].target[target].parameter.enable_sync << 12;
+	mb[2] |= nv->bus[bus].target[target].parameter.enable_wide << 13;
+	mb[2] |= nv->bus[bus].target[target].parameter.parity_checking << 14;
+	mb[2] |= nv->bus[bus].target[target].parameter.disconnect_allowed << 15;
 
 	if (IS_ISP1x160(ha)) {
 		mb[2] |= nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr << 5;
-		mb[3] =	(nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8) |
-			 nv->bus[bus].target[target].sync_period;
+		mb[3] =	(nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8);
 		mb[6] =	(nv->bus[bus].target[target].ppr_1x160.flags.ppr_options << 8) |
 			 nv->bus[bus].target[target].ppr_1x160.flags.ppr_bus_width;
 		mr |= BIT_6;
 	} else {
-		mb[3] =	(nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8) |
-			 nv->bus[bus].target[target].sync_period;
+		mb[3] =	(nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8);
 	}
+	mb[3] |= nv->bus[bus].target[target].sync_period;
+
+	status = qla1280_mailbox_command(ha, mr, mb);
 
-	status = qla1280_mailbox_command(ha, mr, &mb[0]);
+	/* Set Device Queue Parameters. */
+	for (lun = 0; lun < MAX_LUNS; lun++) {
+		mb[0] = MBC_SET_DEVICE_QUEUE;
+		mb[1] = (uint16_t)((bus ? target | BIT_7 : target) << 8);
+		mb[1] |= lun;
+		mb[2] = nv->bus[bus].max_queue_depth;
+		mb[3] = nv->bus[bus].target[target].execution_throttle;
+		status |= qla1280_mailbox_command(ha, 0x0f, mb);
+	}
 
 	if (status)
 		printk(KERN_WARNING "scsi(%ld:%i:%i): "
@@ -1400,19 +1414,19 @@
 	}
 
 #if LINUX_VERSION_CODE > 0x020500
-	nv->bus[bus].target[target].parameter.f.enable_sync = device->sdtr;
-	nv->bus[bus].target[target].parameter.f.enable_wide = device->wdtr;
+	nv->bus[bus].target[target].parameter.enable_sync = device->sdtr;
+	nv->bus[bus].target[target].parameter.enable_wide = device->wdtr;
 	nv->bus[bus].target[target].ppr_1x160.flags.enable_ppr = device->ppr;
 #endif
 
 	if (driver_setup.no_sync ||
 	    (driver_setup.sync_mask &&
 	     (~driver_setup.sync_mask & (1 << target))))
-		nv->bus[bus].target[target].parameter.f.enable_sync = 0;
+		nv->bus[bus].target[target].parameter.enable_sync = 0;
 	if (driver_setup.no_wide ||
 	    (driver_setup.wide_mask &&
 	     (~driver_setup.wide_mask & (1 << target))))
-		nv->bus[bus].target[target].parameter.f.enable_wide = 0;
+		nv->bus[bus].target[target].parameter.enable_wide = 0;
 	if (IS_ISP1x160(ha)) {
 		if (driver_setup.no_ppr ||
 		    (driver_setup.ppr_mask &&
@@ -1421,7 +1435,7 @@
 	}
 
 	spin_lock_irqsave(HOST_LOCK, flags);
-	if (nv->bus[bus].target[target].parameter.f.enable_sync)
+	if (nv->bus[bus].target[target].parameter.enable_sync)
 		status = qla1280_set_target_parameters(ha, bus, target);
 	qla1280_get_target_parameters(ha, device);
 	spin_unlock_irqrestore(HOST_LOCK, flags);
@@ -2151,17 +2165,17 @@
 {
 	struct nvram *nv = &ha->nvram;
 
-	nv->bus[bus].target[target].parameter.f.renegotiate_on_error = 1;
-	nv->bus[bus].target[target].parameter.f.auto_request_sense = 1;
-	nv->bus[bus].target[target].parameter.f.tag_queuing = 1;
-	nv->bus[bus].target[target].parameter.f.enable_sync = 1;
+	nv->bus[bus].target[target].parameter.renegotiate_on_error = 1;
+	nv->bus[bus].target[target].parameter.auto_request_sense = 1;
+	nv->bus[bus].target[target].parameter.tag_queuing = 1;
+	nv->bus[bus].target[target].parameter.enable_sync = 1;
 #if 1	/* Some SCSI Processors do not seem to like this */
-	nv->bus[bus].target[target].parameter.f.enable_wide = 1;
+	nv->bus[bus].target[target].parameter.enable_wide = 1;
 #endif
-	nv->bus[bus].target[target].parameter.f.parity_checking = 1;
-	nv->bus[bus].target[target].parameter.f.disconnect_allowed = 1;
 	nv->bus[bus].target[target].execution_throttle =
 		nv->bus[bus].max_queue_depth - 1;
+	nv->bus[bus].target[target].parameter.parity_checking = 1;
+	nv->bus[bus].target[target].parameter.disconnect_allowed = 1;
 
 	if (IS_ISP1x160(ha)) {
 		nv->bus[bus].target[target].flags.flags1x160.device_enable = 1;
@@ -2237,66 +2251,53 @@
 	struct nvram *nv = &ha->nvram;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int status, lun;
+	uint16_t flag;
 
 	/* Set Target Parameters. */
 	mb[0] = MBC_SET_TARGET_PARAMETERS;
-	mb[1] = (uint16_t) (bus ? target | BIT_7 : target);
-	mb[1] <<= 8;
-
-	/*
-	 * Do not enable wide, sync, and ppr for the initial
-	 * INQUIRY run. We enable this later if we determine
-	 * the target actually supports it.
-	 */
-	nv->bus[bus].target[target].parameter.f.
-		auto_request_sense = 1;
-	nv->bus[bus].target[target].parameter.f.
-		stop_queue_on_check = 0;
-
-	if (IS_ISP1x160(ha))
-		nv->bus[bus].target[target].ppr_1x160.
-			flags.enable_ppr = 0;
+	mb[1] = (uint16_t)((bus ? target | BIT_7 : target) << 8);
 
 	/*
-	 * No sync, wide, etc. while probing
+	 * Do not enable sync and ppr for the initial INQUIRY run. We
+	 * enable this later if we determine the target actually
+	 * supports it.
 	 */
-	mb[2] = (nv->bus[bus].target[target].parameter.c << 8) &
-		~(TP_SYNC /*| TP_WIDE | TP_PPR*/);
+	mb[2] = (TP_RENEGOTIATE | TP_AUTO_REQUEST_SENSE | TP_TAGGED_QUEUE
+		 | TP_WIDE | TP_PARITY | TP_DISCONNECT);
 
 	if (IS_ISP1x160(ha))
 		mb[3] =	nv->bus[bus].target[target].flags.flags1x160.sync_offset << 8;
 	else
 		mb[3] =	nv->bus[bus].target[target].flags.flags1x80.sync_offset << 8;
 	mb[3] |= nv->bus[bus].target[target].sync_period;
-
-	status = qla1280_mailbox_command(ha, BIT_3 | BIT_2 | BIT_1 | BIT_0, &mb[0]);
+	status = qla1280_mailbox_command(ha, 0x0f, mb);
 
 	/* Save Tag queuing enable flag. */
-	mb[0] = BIT_0 << target;
-	if (nv->bus[bus].target[target].parameter.f.tag_queuing)
-		ha->bus_settings[bus].qtag_enables |= mb[0];
+	flag = (BIT_0 << target) & mb[0];
+	if (nv->bus[bus].target[target].parameter.tag_queuing)
+		ha->bus_settings[bus].qtag_enables |= flag;
 
 	/* Save Device enable flag. */
 	if (IS_ISP1x160(ha)) {
 		if (nv->bus[bus].target[target].flags.flags1x160.device_enable)
-			ha->bus_settings[bus].device_enables |= mb[0];
+			ha->bus_settings[bus].device_enables |= flag;
 		ha->bus_settings[bus].lun_disables |= 0;
 	} else {
 		if (nv->bus[bus].target[target].flags.flags1x80.device_enable)
-			ha->bus_settings[bus].device_enables |= mb[0];
+			ha->bus_settings[bus].device_enables |= flag;
 		/* Save LUN disable flag. */
 		if (nv->bus[bus].target[target].flags.flags1x80.lun_disable)
-			ha->bus_settings[bus].lun_disables |= mb[0];
+			ha->bus_settings[bus].lun_disables |= flag;
 	}
 
 	/* Set Device Queue Parameters. */
 	for (lun = 0; lun < MAX_LUNS; lun++) {
 		mb[0] = MBC_SET_DEVICE_QUEUE;
-		mb[1] = (uint16_t)(bus ? target | BIT_7 : target);
-		mb[1] = mb[1] << 8 | lun;
+		mb[1] = (uint16_t)((bus ? target | BIT_7 : target) << 8);
+		mb[1] |= lun;
 		mb[2] = nv->bus[bus].max_queue_depth;
 		mb[3] = nv->bus[bus].target[target].execution_throttle;
-		status |= qla1280_mailbox_command(ha, 0x0f, &mb[0]);
+		status |= qla1280_mailbox_command(ha, 0x0f, mb);
 	}
 
 	return status;
@@ -2341,7 +2342,6 @@
 	struct nvram *nv = &ha->nvram;
 	int bus, target, status = 0;
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
-	uint16_t mask;
 
 	ENTER("qla1280_nvram_config");
 
@@ -2349,7 +2349,7 @@
 		/* Always force AUTO sense for LINUX SCSI */
 		for (bus = 0; bus < MAX_BUSES; bus++)
 			for (target = 0; target < MAX_TARGETS; target++) {
-				nv->bus[bus].target[target].parameter.f.
+				nv->bus[bus].target[target].parameter.
 					auto_request_sense = 1;
 			}
 	} else {
@@ -2416,16 +2416,17 @@
 
 	/* Firmware feature word. */
 	mb[0] = MBC_SET_FIRMWARE_FEATURES;
-	mask = BIT_5 | BIT_1 | BIT_0;
-	mb[1] = le16_to_cpu(nv->firmware_feature.w) & (mask);
+	mb[1] = nv->firmware_feature.f.enable_fast_posting;
+	mb[1] |= nv->firmware_feature.f.report_lvd_bus_transition << 1;
+	mb[1] |= nv->firmware_feature.f.disable_synchronous_backoff << 5;
 #if defined(CONFIG_IA64_GENERIC) || defined (CONFIG_IA64_SGI_SN2)
 	if (ia64_platform_is("sn2")) {
 		printk(KERN_INFO "scsi(%li): Enabling SN2 PCI DMA "
 		       "workaround\n", ha->host_no);
-		mb[1] |= BIT_9;
+		mb[1] |= nv->firmware_feature.f.unused_9 << 9; /* XXX */
 	}
 #endif
-	status |= qla1280_mailbox_command(ha, mask, &mb[0]);
+	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
 
 	/* Retry count and delay. */
 	mb[0] = MBC_SET_RETRY_COUNT;
@@ -2454,27 +2455,27 @@
 		mb[2] |= BIT_5;
 	if (nv->bus[1].config_2.data_line_active_negation)
 		mb[2] |= BIT_4;
-	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, &mb[0]);
+	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, mb);
 
 	mb[0] = MBC_SET_DATA_OVERRUN_RECOVERY;
 	mb[1] = 2;	/* Reset SCSI bus and return all outstanding IO */
-	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
+	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
 
 	/* thingy */
 	mb[0] = MBC_SET_PCI_CONTROL;
-	mb[1] = 2;	/* Data DMA Channel Burst Enable */
-	mb[2] = 2;	/* Command DMA Channel Burst Enable */
-	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, &mb[0]);
+	mb[1] = BIT_1;	/* Data DMA Channel Burst Enable */
+	mb[2] = BIT_1;	/* Command DMA Channel Burst Enable */
+	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, mb);
 
 	mb[0] = MBC_SET_TAG_AGE_LIMIT;
 	mb[1] = 8;
-	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, &mb[0]);
+	status |= qla1280_mailbox_command(ha, BIT_1 | BIT_0, mb);
 
 	/* Selection timeout. */
 	mb[0] = MBC_SET_SELECTION_TIMEOUT;
 	mb[1] = nv->bus[0].selection_timeout;
 	mb[2] = nv->bus[1].selection_timeout;
-	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, &mb[0]);
+	status |= qla1280_mailbox_command(ha, BIT_2 | BIT_1 | BIT_0, mb);
 
 	for (bus = 0; bus < ha->ports; bus++)
 		status |= qla1280_config_bus(ha, bus);
@@ -3915,21 +3916,21 @@
 	result = cmd->request_buffer;
 	n = &ha->nvram;
 
-	n->bus[bus].target[target].parameter.f.enable_wide = 0;
-	n->bus[bus].target[target].parameter.f.enable_sync = 0;
+	n->bus[bus].target[target].parameter.enable_wide = 0;
+	n->bus[bus].target[target].parameter.enable_sync = 0;
 	n->bus[bus].target[target].ppr_1x160.flags.enable_ppr = 0;
 
         if (result[7] & 0x60)
-		n->bus[bus].target[target].parameter.f.enable_wide = 1;
+		n->bus[bus].target[target].parameter.enable_wide = 1;
         if (result[7] & 0x10)
-		n->bus[bus].target[target].parameter.f.enable_sync = 1;
+		n->bus[bus].target[target].parameter.enable_sync = 1;
 	if ((result[2] >= 3) && (result[4] + 5 > 56) &&
 	    (result[56] & 0x4))
 		n->bus[bus].target[target].ppr_1x160.flags.enable_ppr = 1;
 
 	dprintk(2, "get_target_options(): wide %i, sync %i, ppr %i\n",
-		n->bus[bus].target[target].parameter.f.enable_wide,
-		n->bus[bus].target[target].parameter.f.enable_sync,
+		n->bus[bus].target[target].parameter.enable_wide,
+		n->bus[bus].target[target].parameter.enable_sync,
 		n->bus[bus].target[target].ppr_1x160.flags.enable_ppr);
 }
 #endif
Index: linux-2.6/drivers/scsi/qla1280.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.h	2005-06-26 16:58:59.000000000 +0200
+++ linux-2.6/drivers/scsi/qla1280.h	2005-06-26 16:59:06.000000000 +0200
@@ -451,18 +451,15 @@
 		uint16_t unused_38;	/* 38, 39 */
 
 		struct {
-			union {
-				uint8_t c;
-				struct {
-					uint8_t renegotiate_on_error:1;
-					uint8_t stop_queue_on_check:1;
-					uint8_t auto_request_sense:1;
-					uint8_t tag_queuing:1;
-					uint8_t enable_sync:1;
-					uint8_t enable_wide:1;
-					uint8_t parity_checking:1;
-					uint8_t disconnect_allowed:1;
-				} f;
+			struct {
+				uint8_t renegotiate_on_error:1;
+				uint8_t stop_queue_on_check:1;
+				uint8_t auto_request_sense:1;
+				uint8_t tag_queuing:1;
+				uint8_t enable_sync:1;
+				uint8_t enable_wide:1;
+				uint8_t parity_checking:1;
+				uint8_t disconnect_allowed:1;
 			} parameter;	/* 40 */
 
 			uint8_t execution_throttle;	/* 41 */
