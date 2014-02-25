From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 03/10] qla4xxx: Add support of 0xFF capture mask for minidump
Date: Mon, 24 Feb 2014 22:06:58 -0500
Message-ID: <1393297625-928-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:10045 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbaBYDnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:43:11 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h   |  4 ++++
 drivers/scsi/qla4xxx/ql4_init.c | 30 ++++++++++++++++++++++++++++--
 drivers/scsi/qla4xxx/ql4_os.c   |  2 +-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 209853c..699575e 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -1415,6 +1415,9 @@ struct ql_iscsi_stats {
 #define QLA83XX_DBG_OCM_WNDREG_ARRAY_LEN	16
 #define QLA83XX_SS_OCM_WNDREG_INDEX		3
 #define QLA83XX_SS_PCI_INDEX			0
+#define QLA8022_TEMPLATE_CAP_OFFSET		172
+#define QLA83XX_TEMPLATE_CAP_OFFSET		268
+#define QLA80XX_TEMPLATE_RESERVED_BITS		16
 
 struct qla4_8xxx_minidump_template_hdr {
 	uint32_t entry_type;
@@ -1434,6 +1437,7 @@ struct qla4_8xxx_minidump_template_hdr {
 	uint32_t saved_state_array[QLA8XXX_DBG_STATE_ARRAY_LEN];
 	uint32_t capture_size_array[QLA8XXX_DBG_CAP_SIZE_ARRAY_LEN];
 	uint32_t ocm_window_reg[QLA83XX_DBG_OCM_WNDREG_ARRAY_LEN];
+	uint32_t capabilities[QLA80XX_TEMPLATE_RESERVED_BITS];
 };
 
 #endif /*  _QLA4X_FW_H */
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 28fbece..7dda1a0 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -282,6 +282,25 @@ qla4xxx_wait_for_ip_config(struct scsi_qla_host *ha)
 	return ipv4_wait|ipv6_wait;
 }
 
+static int qla4_80xx_is_minidump_dma_capable(struct scsi_qla_host *ha,
+		struct qla4_8xxx_minidump_template_hdr *md_hdr)
+{
+	int offset = (is_qla8022(ha)) ? QLA8022_TEMPLATE_CAP_OFFSET :
+					QLA83XX_TEMPLATE_CAP_OFFSET;
+	int rval = 1;
+	uint32_t *cap_offset;
+
+	cap_offset = (uint32_t *)((char *)md_hdr + offset);
+
+	if (!(le32_to_cpu(*cap_offset) & BIT_0)) {
+		ql4_printk(KERN_INFO, ha, "PEX DMA Not supported %d\n",
+			   *cap_offset);
+		rval = 0;
+	}
+
+	return rval;
+}
+
 /**
  * qla4xxx_alloc_fw_dump - Allocate memory for minidump data.
  * @ha: pointer to host adapter structure.
@@ -294,6 +313,7 @@ void qla4xxx_alloc_fw_dump(struct scsi_qla_host *ha)
 	void *md_tmp;
 	dma_addr_t md_tmp_dma;
 	struct qla4_8xxx_minidump_template_hdr *md_hdr;
+	int dma_capable;
 
 	if (ha->fw_dump) {
 		ql4_printk(KERN_WARNING, ha,
@@ -326,13 +346,19 @@ void qla4xxx_alloc_fw_dump(struct scsi_qla_host *ha)
 
 	md_hdr = (struct qla4_8xxx_minidump_template_hdr *)md_tmp;
 
+	dma_capable = qla4_80xx_is_minidump_dma_capable(ha, md_hdr);
+
 	capture_debug_level = md_hdr->capture_debug_level;
 
 	/* Get capture mask based on module loadtime setting. */
-	if (ql4xmdcapmask >= 0x3 && ql4xmdcapmask <= 0x7F)
+	if ((ql4xmdcapmask >= 0x3 && ql4xmdcapmask <= 0x7F) ||
+	    (ql4xmdcapmask == 0xFF && dma_capable))  {
 		ha->fw_dump_capture_mask = ql4xmdcapmask;
-	else
+	} else {
+		if (ql4xmdcapmask == 0xFF)
+			ql4_printk(KERN_INFO, ha, "Falling back to default capture mask, as PEX DMA is not supported\n");
 		ha->fw_dump_capture_mask = capture_debug_level;
+	}
 
 	md_hdr->driver_capture_mask = ha->fw_dump_capture_mask;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index fb90c9d..bb16040 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -88,7 +88,7 @@ module_param(ql4xmdcapmask, int, S_IRUGO);
 MODULE_PARM_DESC(ql4xmdcapmask,
 		 " Set the Minidump driver capture mask level.\n"
 		 "\t\t  Default is 0 (firmware default capture mask)\n"
-		 "\t\t  Can be set to 0x3, 0x7, 0xF, 0x1F, 0x3F, 0x7F");
+		 "\t\t  Can be set to 0x3, 0x7, 0xF, 0x1F, 0x3F, 0x7F, 0xFF");
 
 int ql4xenablemd = 1;
 module_param(ql4xenablemd, int, S_IRUGO | S_IWUSR);
-- 
1.8.2.GIT

