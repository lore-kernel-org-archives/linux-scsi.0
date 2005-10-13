From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/12]  qla2xxx: Add hotplug firmware-load support for all ISP types.
Date: Thu, 13 Oct 2005 16:16:44 -0700 (PDT)
Message-ID: <20051013231644.27191.59756.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:39079 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932533AbVJMXQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:16:44 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Original implementation only supported ISP24xx types.  The
driver requests a specific file name based on ISP type:

	ISP		Filename
	----------	-------------
	21xx		ql2100_fw.bin
	22xx		ql2200_fw.bin
	2300, 2312	ql2300_fw.bin
	2322		ql2322_fw.bin
	6312, 6322	ql6312_fw.bin
	24xx		ql2400_fw.bin

so the user should insure that the appropriate .bin file is
hotplug accessible.  Upon request, the driver caches the
firmware image until the core qla2xxx driver is unloaded.

Also collapse essentially duplicate code in
qla2x00_load_ram_ext() into a qla2x00_load_ram().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/ql2322.c   |   12 +--
 drivers/scsi/qla2xxx/qla_def.h  |    7 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |    8 +-
 drivers/scsi/qla2xxx/qla_init.c |  176 +++++++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_mbx.c  |  103 ++---------------------
 drivers/scsi/qla2xxx/qla_os.c   |   77 +++++++++++++++++
 6 files changed, 233 insertions(+), 150 deletions(-)

applies-to: 62666c48a7115b6d16b8db7a511f89042b10cc8c
c0f04d85eb3657e1b08c3b5426e4cf56cd2e9e48
diff --git a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
index c88a22c..b7affb9 100644
--- a/drivers/scsi/qla2xxx/ql2322.c
+++ b/drivers/scsi/qla2xxx/ql2322.c
@@ -46,12 +46,10 @@ static struct qla_fw_info qla_fw_tbl[] =
 	{ FW_INFO_ADDR_NOMORE, },
 };
 
-static struct qla_board_info qla_board_tbl[] = {
-	{
-		.drv_name	= qla_driver_name,
-		.isp_name	= "ISP2322",
-		.fw_info	= qla_fw_tbl,
-	},
+static struct qla_board_info qla_board_tbl = {
+	.drv_name	= qla_driver_name,
+	.isp_name	= "ISP2322",
+	.fw_info	= qla_fw_tbl,
 };
 
 static struct pci_device_id qla2322_pci_tbl[] = {
@@ -60,7 +58,7 @@ static struct pci_device_id qla2322_pci_
 		.device		= PCI_DEVICE_ID_QLOGIC_ISP2322,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
-		.driver_data	= (unsigned long)&qla_board_tbl[0],
+		.driver_data	= (unsigned long)&qla_board_tbl,
 	},
 	{0, 0},
 };
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 73a066c..1dcb69e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -21,6 +21,7 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/interrupt.h>
+#include <linux/firmware.h>
 #include <asm/semaphore.h>
 
 #include <scsi/scsi.h>
@@ -2121,6 +2122,12 @@ struct qla_board_info {
 	int alternate_sht;
 };
 
+struct fw_blob {
+	char *name;
+	uint32_t segs[4];
+	const struct firmware *fw;
+};
+
 /* Return data from MBC_GET_ID_LIST call. */
 struct gid_list_info {
 	uint8_t	al_pa;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ec30ac1..1f61c38 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -33,6 +33,7 @@ extern int qla24xx_nvram_config(struct s
 extern void qla2x00_update_fw_options(struct scsi_qla_host *);
 extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
+extern int qla2x00_load_risc_hotplug(scsi_qla_host_t *, uint32_t *);
 extern int qla24xx_load_risc_flash(scsi_qla_host_t *, uint32_t *);
 extern int qla24xx_load_risc_hotplug(scsi_qla_host_t *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
@@ -77,6 +78,8 @@ extern void qla2x00_blink_led(scsi_qla_h
 
 extern int qla2x00_down_timeout(struct semaphore *, unsigned long);
 
+extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
@@ -95,10 +98,7 @@ int __qla2x00_marker(scsi_qla_host_t *, 
  * Global Function Prototypes in qla_mbx.c source file.
  */
 extern int
-qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t);
-
-extern int
-qla2x00_load_ram_ext(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
+qla2x00_load_ram(scsi_qla_host_t *, dma_addr_t, uint32_t, uint32_t);
 
 extern int
 qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7407780..a2db820 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8,7 +8,6 @@
 
 #include <linux/delay.h>
 #include <linux/vmalloc.h>
-#include <linux/firmware.h>
 #include <scsi/scsi_transport_fc.h>
 
 #include "qla_devtbl.h"
@@ -3508,13 +3507,8 @@ qla2x00_load_risc(scsi_qla_host_t *ha, u
 			for (i = 0; i < cnt; i++)
 				req_ring[i] = cpu_to_le16(risc_code[i]);
 
-			if (fw_iter->addressing == FW_INFO_ADDR_NORMAL) {
-				rval = qla2x00_load_ram(ha, ha->request_dma,
-				    risc_address, cnt);
-			} else {
-				rval = qla2x00_load_ram_ext(ha,
-				    ha->request_dma, risc_address, cnt);
-			}
+			rval = qla2x00_load_ram(ha, ha->request_dma,
+			    risc_address, cnt);
 			if (rval) {
 				DEBUG(printk("scsi(%ld): [ERROR] Failed to "
 				    "load segment %d of firmware\n",
@@ -3541,15 +3535,112 @@ qla2x00_load_risc(scsi_qla_host_t *ha, u
 }
 
 int
+qla2x00_load_risc_hotplug(scsi_qla_host_t *ha, uint32_t *srisc_addr)
+{
+	int	rval;
+	int	i, fragment;
+	uint16_t *wcode, *fwcode;
+	uint32_t risc_addr, risc_size, fwclen, wlen, *seg;
+	struct fw_blob *blob;
+
+	/* Load firmware blob. */
+	blob = qla2x00_request_firmware(ha);
+	if (!blob) {
+		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
+		return QLA_FUNCTION_FAILED;
+	}
+
+	rval = QLA_SUCCESS;
+
+	wcode = (uint16_t *)ha->request_ring;
+	*srisc_addr = 0;
+	fwcode = (uint16_t *)blob->fw->data;
+	fwclen = 0;
+
+	/* Validate firmware image by checking version. */
+	if (blob->fw->size < 8 * sizeof(uint16_t)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to verify integrity of firmware image (%Zd)!\n",
+		    blob->fw->size);
+		goto fail_fw_integrity;
+	}
+	for (i = 0; i < 4; i++)
+		wcode[i] = be16_to_cpu(fwcode[i + 4]);
+	if ((wcode[0] == 0xffff && wcode[1] == 0xffff && wcode[2] == 0xffff &&
+	    wcode[3] == 0xffff) || (wcode[0] == 0 && wcode[1] == 0 &&
+		wcode[2] == 0 && wcode[3] == 0)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to verify integrity of firmware image!\n");
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware data: %04x %04x %04x %04x!\n", wcode[0],
+		    wcode[1], wcode[2], wcode[3]);
+		goto fail_fw_integrity;
+	}
+
+	seg = blob->segs;
+	while (*seg && rval == QLA_SUCCESS) {
+		risc_addr = *seg;
+		*srisc_addr = *srisc_addr == 0 ? *seg : *srisc_addr;
+		risc_size = be16_to_cpu(fwcode[3]);
+
+		/* Validate firmware image size. */
+		fwclen += risc_size * sizeof(uint16_t);
+		if (blob->fw->size < fwclen) {
+			qla_printk(KERN_WARNING, ha,
+			    "Unable to verify integrity of firmware image "
+			    "(%Zd)!\n", blob->fw->size);
+			goto fail_fw_integrity;
+		}
+
+		fragment = 0;
+		while (risc_size > 0 && rval == QLA_SUCCESS) {
+			wlen = (uint16_t)(ha->fw_transfer_size >> 1);
+			if (wlen > risc_size)
+				wlen = risc_size;
+
+			DEBUG7(printk("scsi(%ld): Loading risc segment@ risc "
+			    "addr %x, number of words 0x%x.\n", ha->host_no,
+			    risc_addr, wlen));
+
+			for (i = 0; i < wlen; i++)
+				wcode[i] = swab16(fwcode[i]);
+
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    wlen);
+			if (rval) {
+				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
+				    "segment %d of firmware\n", ha->host_no,
+				    fragment));
+				qla_printk(KERN_WARNING, ha,
+				    "[ERROR] Failed to load segment %d of "
+				    "firmware\n", fragment);
+				break;
+			}
+
+			fwcode += wlen;
+			risc_addr += wlen;
+			risc_size -= wlen;
+			fragment++;
+		}
+
+		/* Next segment. */
+		seg++;
+	}
+
+	return rval;
+
+fail_fw_integrity:
+	return QLA_FUNCTION_FAILED;
+}
+
+int
 qla24xx_load_risc_flash(scsi_qla_host_t *ha, uint32_t *srisc_addr)
 {
 	int	rval;
-	int	segments, fragment;
+	int	i, segments, fragment;
 	uint32_t faddr;
 	uint32_t *dcode, dlen;
-	uint32_t risc_addr;
-	uint32_t risc_size;
-	uint32_t i;
+	uint32_t risc_addr, risc_size;
 
 	rval = QLA_SUCCESS;
 
@@ -3597,8 +3688,8 @@ qla24xx_load_risc_flash(scsi_qla_host_t 
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(dcode[i]);
 
-			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
-			    risc_addr, dlen);
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
 				    "segment %d of firmware\n", ha->host_no,
@@ -3631,14 +3722,13 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 	uint32_t risc_addr;
 	uint32_t risc_size;
 	uint32_t i;
-	const struct firmware *fw_entry;
+	struct fw_blob *blob;
 	uint32_t *fwcode, fwclen;
 
-	if (request_firmware(&fw_entry, ha->brd_info->fw_fname,
-	    &ha->pdev->dev)) {
-		qla_printk(KERN_ERR, ha,
-		    "Firmware image file not available: '%s'\n",
-		    ha->brd_info->fw_fname);
+	/* Load firmware blob. */
+	blob = qla2x00_request_firmware(ha);
+	if (!blob) {
+		qla_printk(KERN_ERR, ha, "Firmware image unavailable.\n");
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -3647,14 +3737,14 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 	segments = FA_RISC_CODE_SEGMENTS;
 	dcode = (uint32_t *)ha->request_ring;
 	*srisc_addr = 0;
-	fwcode = (uint32_t *)fw_entry->data;
+	fwcode = (uint32_t *)blob->fw->data;
 	fwclen = 0;
 
 	/* Validate firmware image by checking version. */
-	if (fw_entry->size < 8 * sizeof(uint32_t)) {
+	if (blob->fw->size < 8 * sizeof(uint32_t)) {
 		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of flash firmware image "
-		    "(%Zd)!\n", fw_entry->size);
+		    "Unable to verify integrity of firmware image (%Zd)!\n",
+		    blob->fw->size);
 		goto fail_fw_integrity;
 	}
 	for (i = 0; i < 4; i++)
@@ -3664,7 +3754,7 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 	    (dcode[0] == 0 && dcode[1] == 0 && dcode[2] == 0 &&
 		dcode[3] == 0)) {
 		qla_printk(KERN_WARNING, ha,
-		    "Unable to verify integrity of flash firmware image!\n");
+		    "Unable to verify integrity of firmware image!\n");
 		qla_printk(KERN_WARNING, ha,
 		    "Firmware data: %08x %08x %08x %08x!\n", dcode[0],
 		    dcode[1], dcode[2], dcode[3]);
@@ -3678,10 +3768,10 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 
 		/* Validate firmware image size. */
 		fwclen += risc_size * sizeof(uint32_t);
-		if (fw_entry->size < fwclen) {
+		if (blob->fw->size < fwclen) {
 			qla_printk(KERN_WARNING, ha,
-			    "Unable to verify integrity of flash firmware "
-			    "image (%Zd)!\n", fw_entry->size);
+			    "Unable to verify integrity of firmware image "
+			    "(%Zd)!\n", blob->fw->size);
 			goto fail_fw_integrity;
 		}
 
@@ -3698,8 +3788,8 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 			for (i = 0; i < dlen; i++)
 				dcode[i] = swab32(fwcode[i]);
 
-			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
-			    risc_addr, dlen);
+			rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr,
+			    dlen);
 			if (rval) {
 				DEBUG(printk("scsi(%ld):[ERROR] Failed to load "
 				    "segment %d of firmware\n", ha->host_no,
@@ -3720,12 +3810,9 @@ qla24xx_load_risc_hotplug(scsi_qla_host_
 		segments--;
 	}
 
-	release_firmware(fw_entry);
 	return rval;
 
 fail_fw_integrity:
-
-	release_firmware(fw_entry);
 	return QLA_FUNCTION_FAILED;
 
 }
@@ -3736,8 +3823,7 @@ qla24xx_load_risc(scsi_qla_host_t *ha, u
 	int	rval, num, i;
 	uint32_t cnt;
 	uint32_t *risc_code;
-	uint32_t risc_address;
-	uint32_t risc_code_size;
+	uint32_t risc_addr, risc_size;
 	uint32_t *req_ring;
 	struct qla_fw_info *fw_iter;
 
@@ -3748,26 +3834,26 @@ qla24xx_load_risc(scsi_qla_host_t *ha, u
 	*srisc_addr = *((uint32_t *)fw_iter->lfwstart);
 	while (fw_iter->addressing != FW_INFO_ADDR_NOMORE) {
 		risc_code = (uint32_t *)fw_iter->fwcode;
-		risc_code_size = *((uint32_t *)fw_iter->fwlen);
-		risc_address = *((uint32_t *)fw_iter->lfwstart);
+		risc_size = *((uint32_t *)fw_iter->fwlen);
+		risc_addr = *((uint32_t *)fw_iter->lfwstart);
 
 		num = 0;
 		rval = 0;
-		while (risc_code_size > 0 && !rval) {
+		while (risc_size > 0 && !rval) {
 			cnt = (uint32_t)(ha->fw_transfer_size >> 2);
-			if (cnt > risc_code_size)
-				cnt = risc_code_size;
+			if (cnt > risc_size)
+				cnt = risc_size;
 
 			DEBUG7(printk("scsi(%ld): Loading risc segment@ "
 			    "addr %p, number of bytes 0x%x, offset 0x%lx.\n",
-			    ha->host_no, risc_code, cnt, risc_address));
+			    ha->host_no, risc_code, cnt, risc_addr));
 
 			req_ring = (uint32_t *)ha->request_ring;
 			for (i = 0; i < cnt; i++)
 				req_ring[i] = cpu_to_le32(risc_code[i]);
 
-			rval = qla2x00_load_ram_ext(ha, ha->request_dma,
-			    risc_address, cnt);
+			rval = qla2x00_load_ram(ha, ha->request_dma,
+			    risc_addr, cnt);
 			if (rval) {
 				DEBUG(printk("scsi(%ld): [ERROR] Failed to "
 				    "load segment %d of firmware\n",
@@ -3781,8 +3867,8 @@ qla24xx_load_risc(scsi_qla_host_t *ha, u
 			}
 
 			risc_code += cnt;
-			risc_address += cnt;
-			risc_code_size -= cnt;
+			risc_addr += cnt;
+			risc_size -= cnt;
 			num++;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ad3cacb..6b6b3b8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -325,113 +325,30 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	return rval;
 }
 
-/*
- * qla2x00_load_ram
- *	Load adapter RAM using DMA.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
 int
-qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint16_t risc_addr,
-    uint16_t risc_code_size)
+qla2x00_load_ram(scsi_qla_host_t *ha, dma_addr_t req_dma, uint32_t risc_addr,
+    uint32_t risc_code_size)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t	req_len;
-	dma_addr_t	nml_dma;
-	uint32_t	nml_len;
-	uint32_t	normalized;
-
-	DEBUG11(printk("qla2x00_load_ram(%ld): entered.\n",
-	    ha->host_no);)
 
-	req_len = risc_code_size;
-	nml_dma = 0;
-	nml_len = 0;
-
-	normalized = qla2x00_normalize_dma_addr(&req_dma, &req_len, &nml_dma,
-	    &nml_len);
-
-	/* Load first segment */
-	mcp->mb[0] = MBC_LOAD_RISC_RAM;
-	mcp->mb[1] = risc_addr;
-	mcp->mb[2] = MSW(req_dma);
-	mcp->mb[3] = LSW(req_dma);
-	mcp->mb[4] = (uint16_t)req_len;
-	mcp->mb[6] = MSW(MSD(req_dma));
-	mcp->mb[7] = LSW(MSD(req_dma));
-	mcp->out_mb = MBX_7|MBX_6|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(ha, mcp);
-
-	/* Load second segment - if necessary */
-	if (normalized && (rval == QLA_SUCCESS)) {
-		mcp->mb[0] = MBC_LOAD_RISC_RAM;
-		mcp->mb[1] = risc_addr + (uint16_t)req_len;
-		mcp->mb[2] = MSW(nml_dma);
-		mcp->mb[3] = LSW(nml_dma);
-		mcp->mb[4] = (uint16_t)nml_len;
-		mcp->mb[6] = MSW(MSD(nml_dma));
-		mcp->mb[7] = LSW(MSD(nml_dma));
-		mcp->out_mb = MBX_7|MBX_6|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
-		mcp->in_mb = MBX_0;
-		mcp->tov = 30;
-		mcp->flags = 0;
-		rval = qla2x00_mailbox_command(ha, mcp);
-	}
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	if (rval == QLA_SUCCESS) {
-		/* Empty */
-		DEBUG11(printk("qla2x00_load_ram(%ld): done.\n", ha->host_no);)
+	if (MSW(risc_addr) || IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
+		mcp->mb[8] = MSW(risc_addr);
+		mcp->out_mb = MBX_8|MBX_0;
 	} else {
-		/* Empty */
-		DEBUG2_3_11(printk("qla2x00_load_ram(%ld): failed. rval=%x "
-		    "mb[0]=%x.\n", ha->host_no, rval, mcp->mb[0]);)
+		mcp->mb[0] = MBC_LOAD_RISC_RAM;
+		mcp->out_mb = MBX_0;
 	}
-	return rval;
-}
-
-/*
- * qla2x00_load_ram_ext
- *	Load adapter extended RAM using DMA.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Returns:
- *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
- */
-int
-qla2x00_load_ram_ext(scsi_qla_host_t *ha, dma_addr_t req_dma,
-    uint32_t risc_addr, uint32_t risc_code_size)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
-
-	mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
 	mcp->mb[1] = LSW(risc_addr);
 	mcp->mb[2] = MSW(req_dma);
 	mcp->mb[3] = LSW(req_dma);
 	mcp->mb[6] = MSW(MSD(req_dma));
 	mcp->mb[7] = LSW(MSD(req_dma));
-	mcp->mb[8] = MSW(risc_addr);
-	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->out_mb |= MBX_7|MBX_6|MBX_3|MBX_2|MBX_1;
 	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
 		mcp->mb[4] = MSW(risc_code_size);
 		mcp->mb[5] = LSW(risc_code_size);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 40b124d..2daba58 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1258,7 +1258,10 @@ int qla2x00_probe_one(struct pci_dev *pd
 	ha->isp_ops.reset_adapter	= qla2x00_reset_adapter;
 	ha->isp_ops.nvram_config	= qla2x00_nvram_config;
 	ha->isp_ops.update_fw_options	= qla2x00_update_fw_options;
-	ha->isp_ops.load_risc		= qla2x00_load_risc;
+	if (ql2xfwloadbin == 1 || ql2xfwloadbin == 2)
+		ha->isp_ops.load_risc = qla2x00_load_risc_hotplug;
+	else
+		ha->isp_ops.load_risc = qla2x00_load_risc;
 	ha->isp_ops.pci_info_str	= qla2x00_pci_info_str;
 	ha->isp_ops.fw_version_str	= qla2x00_fw_version_str;
 	ha->isp_ops.intr_handler	= qla2100_intr_handler;
@@ -2428,6 +2431,77 @@ qla2x00_down_timeout(struct semaphore *s
 	return -ETIMEDOUT;
 }
 
+/* Firmware interface routines. */
+
+#define FW_BLOBS	6
+#define FW_ISP21XX	0
+#define FW_ISP22XX	1
+#define FW_ISP2300	2
+#define FW_ISP2322	3
+#define FW_ISP63XX	4
+#define FW_ISP24XX	5
+
+static DECLARE_MUTEX(qla_fw_lock);
+
+static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
+	{ .name = "ql2100_fw.bin", .segs = { 0x1000, 0 }, },
+	{ .name = "ql2200_fw.bin", .segs = { 0x1000, 0 }, },
+	{ .name = "ql2300_fw.bin", .segs = { 0x800, 0 }, },
+	{ .name = "ql2322_fw.bin", .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
+	{ .name = "ql6312_fw.bin", .segs = { 0x800, 0 }, },
+	{ .name = "ql2400_fw.bin", },
+};
+
+struct fw_blob *
+qla2x00_request_firmware(scsi_qla_host_t *ha)
+{
+	struct fw_blob *blob;
+
+	blob = NULL;
+	if (IS_QLA2100(ha)) {
+		blob = &qla_fw_blobs[FW_ISP21XX];
+	} else if (IS_QLA2200(ha)) {
+		blob = &qla_fw_blobs[FW_ISP22XX];
+	} else if (IS_QLA2300(ha) || IS_QLA2312(ha)) {
+		blob = &qla_fw_blobs[FW_ISP2300];
+	} else if (IS_QLA2322(ha)) {
+		blob = &qla_fw_blobs[FW_ISP2322];
+	} else if (IS_QLA6312(ha) || IS_QLA6322(ha)) {
+		blob = &qla_fw_blobs[FW_ISP63XX];
+	} else if (IS_QLA24XX(ha)) {
+		blob = &qla_fw_blobs[FW_ISP24XX];
+	}
+
+	down(&qla_fw_lock);
+	if (blob->fw)
+		goto out;
+
+	if (request_firmware(&blob->fw, blob->name, &ha->pdev->dev)) {
+		DEBUG2(printk("scsi(%ld): Failed to load firmware image "
+		    "(%s).\n", ha->host_no, blob->name));
+		blob->fw = NULL;
+		blob = NULL;
+		goto out;
+	}
+
+out:
+	up(&qla_fw_lock);
+	return blob;
+}
+
+static void
+qla2x00_release_firmware(void)
+{
+	int idx;
+
+	down(&qla_fw_lock);
+	for (idx = 0; idx < FW_BLOBS; idx++)
+		if (qla_fw_blobs[idx].fw)
+			release_firmware(qla_fw_blobs[idx].fw);
+	up(&qla_fw_lock);
+}
+
+
 /**
  * qla2x00_module_init - Module initialization.
  **/
@@ -2463,6 +2537,7 @@ qla2x00_module_init(void)
 static void __exit
 qla2x00_module_exit(void)
 {
+	qla2x00_release_firmware();
 	kmem_cache_destroy(srb_cachep);
 	fc_release_transport(qla2xxx_transport_template);
 }
---
0.99.8.GIT

-- 
Andrew Vasquez
