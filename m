From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: 10 Nov 2003 09:00:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq0u15cnx1x.fsf@wildopensource.com>
References: <B179AE41C1147041AA1121F44614F0B060ED62@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:14287 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S263609AbTKJOAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2003 09:00:38 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED62@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>, jeremy@sgi.com, jbarnes@sgi.com

>>>>> "Andrew" == Andrew Vasquez <andrew.vasquez@qlogic.com> writes:

Andrew> All, A new version of the 8.x series driver for Linux 2.6.x
Andrew> kernels has been uploaded to SourceForge:

Andrew> Changes from previous release (8.00.00b5) include:

Andrew> 	o Intelligent RSCN handling.  o Slab cache allocations
Andrew> for driver SRBs.  o Support larger numbers of targets.  o
Andrew> Initial rework of debug logging facilities.

Hi Andrew,

More changes that really needs to go into the driver:
 - Call qla2x00_config_dma_addressing() before performing any
   consistent allocations. This is required since the dma mask
   settings will affect the memory pci_alloc_consistent() will return.
 - Call pci_set_consistent_dma_mask() to allow for 64 bit consistent
   allocations, required on some platforms such as the SN2.
 - Wait 20 usecs (not sure how long is really necessary, but this
   seems safe) after setting CSR_ISP_SOFT_RESET in the ctrl_status
   register as the card doesn't respond to PCI reads while in reset
   state. This causes a machine check on some architectures.
 - Flush PCI writes before calling udelay() to ensure the write is not
   sitting idle in-flight for a while before hitting the hardware.
 - Use auto-negotiate link speed when using default parameters rather
   than NVRAM settings. Disable NVRAM reading on SN2 since it's
   not possible to execute the HBA's BIOS on an SN2. I suggest doing
   something similar for all architectures that do not provide x86
   BIOS emulation.
 - Include linux/vmalloc.h in qla_os.c since it uses vmalloc()

And a quick recommendation: there's a lot of global variables in the
driver which are explicitly being initialized to zero/NULL. Please
don't do that as it forces them into the DATA segment rather than the
BSS segment. Just declaring them 'static int foo;' is sufficient.

Cheers,
Jes


diff -urN -X /usr/people/jes/exclude-linux drivers/scsi/qla2xxx-orig/qla_def.h drivers/scsi/qla2xxx/qla_def.h
--- drivers/scsi/qla2xxx-orig/qla_def.h	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_def.h	Wed Nov  5 06:44:49 2003
@@ -727,6 +727,47 @@
 #define PD_STATE_WAIT_PORT_LOGOUT_ACK		11
 
 
+struct qla2x00_special_options
+{
+#if defined(__BIG_ENDIAN)
+	uint8_t	data_rate			:2;
+	uint8_t	enable_50_ohm_termination	:1;
+	uint8_t	unused_12			:1;
+
+	uint8_t	unused_11			:1;
+	uint8_t	unused_10			:1;
+	uint8_t	unused_9			:1;
+	uint8_t	unused_8			:1;
+
+	uint8_t	disable_auto_plogi_local_loop	:1;
+	uint8_t	enable_ooo_frame_handling	:1;
+	uint8_t	fcp_rsp_payload			:2;
+
+	uint8_t	unused_3			:1;
+	uint8_t	unused_2			:1;
+	uint8_t	soft_id_only			:1;
+	uint8_t	enable_read_xfr_rdy		:1;
+#else
+	uint8_t	enable_read_xfr_rdy		:1;
+	uint8_t	soft_id_only			:1;
+	uint8_t	unused_2			:1;
+	uint8_t	unused_3			:1;
+
+	uint8_t	fcp_rsp_payload			:2;
+	uint8_t	enable_ooo_frame_handling	:1;
+	uint8_t	disable_auto_plogi_local_loop	:1;
+
+	uint8_t	unused_8			:1;
+	uint8_t	unused_9			:1;
+	uint8_t	unused_10			:1;
+	uint8_t	unused_11			:1;
+
+	uint8_t	unused_12			:1;
+	uint8_t	enable_50_ohm_termination	:1;
+	uint8_t	data_rate			:2;
+#endif
+};
+
 /*
  * ISP Initialization Control Block.
  */
@@ -954,7 +995,7 @@
 	 * MSB BIT 6 = Data Rate (2300 only)
 	 * MSB BIT 7 = Data Rate (2300 only)
 	 */
-	uint8_t	 special_options[2];
+	struct qla2x00_special_options special_options;
 
 	/* Reserved for expanded RISC parameter block */
 	uint8_t reserved_2[24];
diff -urN -X /usr/people/jes/exclude-linux drivers/scsi/qla2xxx-orig/qla_init.c drivers/scsi/qla2xxx/qla_init.c
--- drivers/scsi/qla2xxx-orig/qla_init.c	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_init.c	Thu Nov  6 03:23:48 2003
@@ -162,7 +162,7 @@
 		isp_init = 0;
 
 		/* If firmware needs to be loaded */
-		if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
+		if ((rval = qla2x00_isp_firmware(ha)) != QLA_SUCCESS) {
 			if ((rval = qla2x00_chip_diag(ha)) == QLA_SUCCESS) {
 				rval = qla2x00_setup_chip(ha);
 			}
@@ -470,6 +470,12 @@
 	    ha->pdev->device == QLA2322_DEVICE_ID) {
 		udelay(10);
 	} else {
+		/*
+		 * It is necessary to for a delay here since the card 
+		 * doesn't respond to PCI reads during a reset. On some
+		 * architectures this will result in an MCA.
+		 */
+		udelay(20);
 		for (cnt = 30000; cnt; cnt--) {
 			if ((RD_REG_WORD(&reg->ctrl_status) &
 			    CSR_ISP_SOFT_RESET) == 0)
@@ -485,6 +491,10 @@
 
 	/* Release RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+	/*
+	 * Flush the write so the udelay count below will be reliable
+	 */
+	RD_REG_WORD(&reg->hccr);
 
 	if (ha->pdev->device == QLA2312_DEVICE_ID ||
 	    ha->pdev->device == QLA2322_DEVICE_ID) {
@@ -546,6 +556,11 @@
 
 	/* Reset ISP chip. */
 	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	/*
+	 * We need to have a delay here since the card will not respond
+	 * while in reset causing an MCA on some architectures.
+	 */
+	udelay(20);
 	data = qla2x00_debounce_register(&reg->ctrl_status);
 	for (cnt = 6000000 ; cnt && (data & CSR_ISP_SOFT_RESET); cnt--) {
 		udelay(5);
@@ -821,6 +836,7 @@
 	WRT_REG_WORD(ISP_REQ_Q_OUT(reg), 0);
 	WRT_REG_WORD(ISP_RSP_Q_IN(reg), 0);
 	WRT_REG_WORD(ISP_RSP_Q_OUT(reg), 0);
+	RD_REG_WORD(ISP_RSP_Q_OUT(reg));
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1162,6 +1178,16 @@
 	DEBUG5(qla2x00_dump_buffer((uint8_t *)ha->request_ring,
 	    sizeof(nvram_t)));
 
+#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
+	/*
+	 * The SN2 does not provide BIOS emulation which means you can't
+	 * change potentially bogus BIOS settings. Force the use of
+	 * default settings.
+	 */
+	if (ia64_platform_is("sn2"))
+		chksum = 1;
+#endif
+
 	/* Bad NVRAM data, set defaults parameters. */
 	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' ||
 	    nv->id[2] != 'P' || nv->id[3] != ' ' || nv->nvram_version < 1) {
@@ -1184,6 +1210,7 @@
 		nv->add_firmware_options[0] = BIT_5;
 		nv->add_firmware_options[1] = BIT_5 | BIT_4;
 		nv->frame_payload_size  = __constant_cpu_to_le16(2048);
+		nv->special_options.data_rate = SO_DATA_RATE_AUTO;
 #elif defined(ISP2200)
 		nv->firmware_options[0] = BIT_2 | BIT_1;
 		nv->firmware_options[1] = BIT_7 | BIT_5;
@@ -1319,8 +1346,6 @@
 	ha->operating_mode =
 	    (icb->add_firmware_options[0] & (BIT_6 | BIT_5 | BIT_4)) >> 4;
 
-	qla2x00_config_dma_addressing(ha);
-
 	ha->fw_seriallink_options[0] = nv->seriallink_options[0];
 	ha->fw_seriallink_options[1] = nv->seriallink_options[1];
 
diff -urN -X /usr/people/jes/exclude-linux drivers/scsi/qla2xxx-orig/qla_inline.h drivers/scsi/qla2xxx/qla_inline.h
--- drivers/scsi/qla2xxx-orig/qla_inline.h	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_inline.h	Wed Nov  5 02:50:51 2003
@@ -73,6 +73,12 @@
 			ha->calc_request_entries = qla2x00_calc_iocbs_64;
 			ha->build_scsi_iocbs = qla2x00_build_scsi_iocbs_64;
 			ha->host->sg_tablesize = SG_SEGMENTS_64;
+			if (pci_set_consistent_dma_mask(ha->pdev, 0xffffffffffffffffULL)) {
+				printk(KERN_DEBUG "scsi(%ld): Failed to set 64 bit PCI"
+						" consistent mask; using 32 bit.\n",
+						ha->host_no);
+				pci_set_consistent_dma_mask(ha->pdev, 0xffffffffULL);
+			}
 		} else {
 			printk(KERN_DEBUG
 			    "scsi(%ld): Failed to set 64 bit PCI DMA mask, "
diff -urN -X /usr/people/jes/exclude-linux drivers/scsi/qla2xxx-orig/qla_os.c drivers/scsi/qla2xxx/qla_os.c
--- drivers/scsi/qla2xxx-orig/qla_os.c	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_os.c	Thu Nov  6 03:23:52 2003
@@ -20,6 +20,7 @@
 #include "qla_os.h"
 
 #include "qla_def.h"
+#include <linux/vmalloc.h>
 
 /*
  * Driver version
@@ -2492,6 +2493,7 @@
 	    "scsi(%ld): Scatter/Gather Entries (0x%x).\n",
 	    ha->host_no, ha->host->sg_tablesize));
 
+	qla2x00_config_dma_addressing(ha);
 	if (qla2x00_mem_alloc(ha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "[ERROR] Failed to allocate memory for adapter\n");
