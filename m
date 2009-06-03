From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/20] qla2xxx: Export TLV data on supported ISPs.
Date: Wed,  3 Jun 2009 09:55:14 -0700
Message-ID: <1244048131-56590-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbZFCQzd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:33 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Firmware currently provides PB and PGF TLVs.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   52 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    4 +++
 drivers/scsi/qla2xxx/qla_fw.h   |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 ++
 drivers/scsi/qla2xxx/qla_mbx.c  |   37 +++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    4 +++
 6 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e8c1c9e..9aa00f2 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -744,6 +744,57 @@ static struct bin_attribute sysfs_xgmac_stats_attr = {
 	.read = qla2x00_sysfs_read_xgmac_stats,
 };
 
+static ssize_t
+qla2x00_sysfs_read_dcbx_tlv(struct kobject *kobj,
+		       struct bin_attribute *bin_attr,
+		       char *buf, loff_t off, size_t count)
+{
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
+	int rval;
+	uint16_t actual_size;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count > DCBX_TLV_DATA_SIZE)
+		return 0;
+
+	if (ha->dcbx_tlv)
+		goto do_read;
+
+	ha->dcbx_tlv = dma_alloc_coherent(&ha->pdev->dev, DCBX_TLV_DATA_SIZE,
+	    &ha->dcbx_tlv_dma, GFP_KERNEL);
+	if (!ha->dcbx_tlv) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate memory for DCBX TLV read-data.\n");
+		return 0;
+	}
+
+do_read:
+	actual_size = 0;
+	memset(ha->dcbx_tlv, 0, DCBX_TLV_DATA_SIZE);
+
+	rval = qla2x00_get_dcbx_params(vha, ha->dcbx_tlv_dma,
+	    DCBX_TLV_DATA_SIZE);
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to read DCBX TLV data (%x).\n", rval);
+		count = 0;
+	}
+
+	memcpy(buf, ha->dcbx_tlv, count);
+
+	return count;
+}
+
+static struct bin_attribute sysfs_dcbx_tlv_attr = {
+	.attr = {
+		.name = "dcbx_tlv",
+		.mode = S_IRUSR,
+	},
+	.size = 0,
+	.read = qla2x00_sysfs_read_dcbx_tlv,
+};
+
 static struct sysfs_entry {
 	char *name;
 	struct bin_attribute *attr;
@@ -759,6 +810,7 @@ static struct sysfs_entry {
 	{ "edc", &sysfs_edc_attr, 2 },
 	{ "edc_status", &sysfs_edc_status_attr, 2 },
 	{ "xgmac_stats", &sysfs_xgmac_stats_attr, 3 },
+	{ "dcbx_tlv", &sysfs_dcbx_tlv_attr, 3 },
 	{ NULL },
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index da941be..bb6bfd7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2401,6 +2401,10 @@ struct qla_hw_data {
 	void		*xgmac_data;
 	dma_addr_t	xgmac_data_dma;
 
+#define DCBX_TLV_DATA_SIZE PAGE_SIZE
+	void		*dcbx_tlv;
+	dma_addr_t	dcbx_tlv_dma;
+
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 80ab46c..152d16c 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1406,6 +1406,7 @@ struct access_chip_rsp_84xx {
 #define MBC_RESTART_MPI_FW	0x3d
 #define MBC_FLASH_ACCESS_CTRL	0x3e	/* Control flash access. */
 #define MBC_GET_XGMAC_STATS	0x7a
+#define MBC_GET_DCBX_PARAMS	0x51
 
 /* Flash access control option field bit definitions */
 #define FAC_OPT_FORCE_SEMAPHORE		BIT_15
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 66ba399..fbf9972 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -296,6 +296,9 @@ qla81xx_fac_erase_sector(scsi_qla_host_t *, uint32_t, uint32_t);
 extern int
 qla2x00_get_xgmac_stats(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t *);
 
+extern int
+qla2x00_get_dcbx_params(scsi_qla_host_t *, dma_addr_t, uint16_t);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2497fe4..e0fee48 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3500,3 +3500,40 @@ qla2x00_get_xgmac_stats(scsi_qla_host_t *vha, dma_addr_t stats_dma,
 
 	return rval;
 }
+
+int
+qla2x00_get_dcbx_params(scsi_qla_host_t *vha, dma_addr_t tlv_dma,
+    uint16_t size)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_QLA81XX(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_GET_DCBX_PARAMS;
+	mcp->mb[1] = 0;
+	mcp->mb[2] = MSW(tlv_dma);
+	mcp->mb[3] = LSW(tlv_dma);
+	mcp->mb[6] = MSW(MSD(tlv_dma));
+	mcp->mb[7] = LSW(MSD(tlv_dma));
+	mcp->mb[8] = size;
+	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_2|MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=0x%x "
+		    "mb[1]=0x%x mb[2]=0x%x.\n", __func__, vha->host_no, rval,
+		    mcp->mb[0], mcp->mb[1], mcp->mb[2]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 642e976..7415ead 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2434,6 +2434,10 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		vfree(ha->fw_dump);
 	}
 
+	if (ha->dcbx_tlv)
+		dma_free_coherent(&ha->pdev->dev, DCBX_TLV_DATA_SIZE,
+		    ha->dcbx_tlv, ha->dcbx_tlv_dma);
+
 	if (ha->xgmac_data)
 		dma_free_coherent(&ha->pdev->dev, XGMAC_DATA_SIZE,
 		    ha->xgmac_data, ha->xgmac_data_dma);
-- 
1.6.3.1.244.gf9275

