From: Jeremy Higdon <jeremy@SGI.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 2 Dec 2003 01:36:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031202093631.GA173962@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060ED86@AVEXCH02.qlogic.org> <20031202020203.GA174948@sgi.com> <20031202100125.GA31682@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:17043 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S261744AbTLBJhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2003 04:37:52 -0500
Content-Disposition: inline
In-Reply-To: <20031202100125.GA31682@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@SGI.com, mdr@SGI.com

On Tue, Dec 02, 2003 at 02:01:25AM -0800, Andrew Vasquez wrote:
> 
> > Is it okay to read back from the request queue in register?
> > I'm planning to generate a new patch that includes the previous
> > changes, and I may as well generate something without the sn_mmiob.
> > 
> 
> I believe we'll need a readl() to flush the write.  Just curious, on
> SGI ia64 machines, how many bridges must a PCI write transaction cross
> before it reaches the target device?

It depends on what you call a bridge.  If you count chips traversed,
it could be as many as 6, I think.  However, the system in which I
had the problem is much smaller than that.

Here is my patch to the v8.00.00b6 driver.  It includes most of
Jes's earlier patch, but not Christoph's patch, which I have not
yet tried.  If you're going to supply a way to change NVRAM without
using BIOS (please!), then this patch can be a bit smaller.  Please
let me know what you think.

I added a read-after-write of the Request In register and commented
out setting of the enable_64bit_addressing flag in the nvram config
function.

I returned SN2 to using nvram variables, except for data rate and
frame size, since at least some QLA2310/2342 boards have the wrong
values.  As you pointed out, we need the nvram node and port name
for proper fabric operation.

jeremy

--- /usr/people/jeremy/26bk/qla2xxx/qla_def.h	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_def.h	Mon Dec  1 19:58:25 2003
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
diff -u /usr/people/jeremy/26bk/qla2xxx/qla_init.c drivers/scsi/qla2xxx/qla_init.c
--- /usr/people/jeremy/26bk/qla2xxx/qla_init.c	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_init.c	Tue Dec  2 00:44:28 2003
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
 
@@ -1184,6 +1200,7 @@
 		nv->add_firmware_options[0] = BIT_5;
 		nv->add_firmware_options[1] = BIT_5 | BIT_4;
 		nv->frame_payload_size  = __constant_cpu_to_le16(2048);
+		nv->special_options.data_rate = SO_DATA_RATE_AUTO;
 #elif defined(ISP2200)
 		nv->firmware_options[0] = BIT_2 | BIT_1;
 		nv->firmware_options[1] = BIT_7 | BIT_5;
@@ -1219,6 +1236,21 @@
 		rval = 1;
 	}
 
+#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
+	/*
+	 * The SN2 does not provide BIOS emulation which means you can't
+	 * change potentially bogus BIOS settings. Force the use of default
+	 * settings for link rate and frame size.  Hope that the rest of
+	 * the settings are valid.
+	 */
+	if (ia64_platform_is("sn2")) {
+		nv->frame_payload_size  = __constant_cpu_to_le16(2048);
+#if defined(ISP2300)
+		nv->special_options.data_rate = SO_DATA_RATE_AUTO;
+#endif
+	}
+#endif
+
 	/* Reset Initialization control block */
 	memset(icb, 0, sizeof(init_cb_t));
 
@@ -1310,7 +1342,11 @@
 	ha->flags.disable_luns = ((nv->host_p[0] & BIT_2) ? 1 : 0);
 	ha->flags.disable_risc_code_load = ((nv->host_p[0] & BIT_4) ? 1 : 0);
 	ha->flags.set_cache_line_size_1 = ((nv->host_p[0] & BIT_5) ? 1 : 0);
-	ha->flags.enable_64bit_addressing = ((nv->host_p[1] & BIT_0) ? 1 : 0);
+	/*
+	 * enable_64bit_addressing gets set in qla2x00_config_dma_addressing;
+	 * do not set it here.
+	 * ha->flags.enable_64bit_addressing = ((nv->host_p[1] & BIT_0) ? 1 : 0);
+	 */
 	ha->flags.enable_lip_reset = ((nv->host_p[1] & BIT_1) ? 1 : 0);
 	ha->flags.enable_lip_full_login = ((nv->host_p[1] & BIT_2) ? 1 : 0);
 	ha->flags.enable_target_reset = ((nv->host_p[1] & BIT_3) ? 1 : 0);
@@ -1319,8 +1355,6 @@
 	ha->operating_mode =
 	    (icb->add_firmware_options[0] & (BIT_6 | BIT_5 | BIT_4)) >> 4;
 
-	qla2x00_config_dma_addressing(ha);
-
 	ha->fw_seriallink_options[0] = nv->seriallink_options[0];
 	ha->fw_seriallink_options[1] = nv->seriallink_options[1];
 
diff -u /usr/people/jeremy/26bk/qla2xxx/qla_inline.h drivers/scsi/qla2xxx/qla_inline.h
--- /usr/people/jeremy/26bk/qla2xxx/qla_inline.h	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_inline.h	Mon Dec  1 19:58:25 2003
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
diff -u /usr/people/jeremy/26bk/qla2xxx/qla_iocb.c drivers/scsi/qla2xxx/qla_iocb.c
--- /usr/people/jeremy/26bk/qla2xxx/qla_iocb.c	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_iocb.c	Tue Dec  2 00:49:29 2003
@@ -506,6 +506,7 @@
 	/* Set chip new ring index. */
 	reg_flushed = CACHE_FLUSH(ISP_REQ_Q_IN(reg));
 	WRT_REG_WORD(ISP_REQ_Q_IN(reg), ha->req_ring_index);
+	RD_REG_WORD(ISP_REQ_Q_IN(reg));
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return (QLA_SUCCESS);
@@ -777,6 +778,7 @@
 
 	/* Set chip new ring index. */
 	WRT_REG_WORD(ISP_REQ_Q_IN(reg), ha->req_ring_index);
+	RD_REG_WORD(ISP_REQ_Q_IN(reg));
 
 	LEAVE(__func__);
 }
diff -u /usr/people/jeremy/26bk/qla2xxx/qla_os.c drivers/scsi/qla2xxx/qla_os.c
--- /usr/people/jeremy/26bk/qla2xxx/qla_os.c	Tue Nov  4 15:48:29 2003
+++ drivers/scsi/qla2xxx/qla_os.c	Mon Dec  1 19:58:25 2003
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
