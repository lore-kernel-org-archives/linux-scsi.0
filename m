From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 02/20] qla2xxx: Export XGMAC statistics on supported ISPs.
Date: Wed,  3 Jun 2009 09:55:13 -0700
Message-ID: <1244048131-56590-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbZFCQzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:31 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   57 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    4 +++
 drivers/scsi/qla2xxx/qla_fw.h   |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 ++
 drivers/scsi/qla2xxx/qla_mbx.c  |   38 ++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    4 +++
 6 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 524ceb9..e8c1c9e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -692,6 +692,58 @@ static struct bin_attribute sysfs_edc_status_attr = {
 	.read = qla2x00_sysfs_read_edc_status,
 };
 
+static ssize_t
+qla2x00_sysfs_read_xgmac_stats(struct kobject *kobj,
+		       struct bin_attribute *bin_attr,
+		       char *buf, loff_t off, size_t count)
+{
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
+	int rval;
+	uint16_t actual_size;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count > XGMAC_DATA_SIZE)
+		return 0;
+
+	if (ha->xgmac_data)
+		goto do_read;
+
+	ha->xgmac_data = dma_alloc_coherent(&ha->pdev->dev, XGMAC_DATA_SIZE,
+	    &ha->xgmac_data_dma, GFP_KERNEL);
+	if (!ha->xgmac_data) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to allocate memory for XGMAC read-data.\n");
+		return 0;
+	}
+
+do_read:
+	actual_size = 0;
+	memset(ha->xgmac_data, 0, XGMAC_DATA_SIZE);
+
+	rval = qla2x00_get_xgmac_stats(vha, ha->xgmac_data_dma,
+	    XGMAC_DATA_SIZE, &actual_size);
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Unable to read XGMAC data (%x).\n", rval);
+		count = 0;
+	}
+
+	count = actual_size > count ? count: actual_size;
+	memcpy(buf, ha->xgmac_data, count);
+
+	return count;
+}
+
+static struct bin_attribute sysfs_xgmac_stats_attr = {
+	.attr = {
+		.name = "xgmac_stats",
+		.mode = S_IRUSR,
+	},
+	.size = 0,
+	.read = qla2x00_sysfs_read_xgmac_stats,
+};
+
 static struct sysfs_entry {
 	char *name;
 	struct bin_attribute *attr;
@@ -706,6 +758,7 @@ static struct sysfs_entry {
 	{ "reset", &sysfs_reset_attr, },
 	{ "edc", &sysfs_edc_attr, 2 },
 	{ "edc_status", &sysfs_edc_status_attr, 2 },
+	{ "xgmac_stats", &sysfs_xgmac_stats_attr, 3 },
 	{ NULL },
 };
 
@@ -721,6 +774,8 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
 			continue;
 		if (iter->is4GBp_only == 2 && !IS_QLA25XX(vha->hw))
 			continue;
+		if (iter->is4GBp_only == 3 && !IS_QLA81XX(vha->hw))
+			continue;
 
 		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
@@ -743,6 +798,8 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *vha)
 			continue;
 		if (iter->is4GBp_only == 2 && !IS_QLA25XX(ha))
 			continue;
+		if (iter->is4GBp_only == 3 && !IS_QLA81XX(ha))
+			continue;
 
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 721bae9..da941be 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2397,6 +2397,10 @@ struct qla_hw_data {
 	dma_addr_t	edc_data_dma;
 	uint16_t	edc_data_len;
 
+#define XGMAC_DATA_SIZE	PAGE_SIZE
+	void		*xgmac_data;
+	dma_addr_t	xgmac_data_dma;
+
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index f389f3d..80ab46c 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1405,6 +1405,7 @@ struct access_chip_rsp_84xx {
 #define MBC_IDC_ACK		0x101
 #define MBC_RESTART_MPI_FW	0x3d
 #define MBC_FLASH_ACCESS_CTRL	0x3e	/* Control flash access. */
+#define MBC_GET_XGMAC_STATS	0x7a
 
 /* Flash access control option field bit definitions */
 #define FAC_OPT_FORCE_SEMAPHORE		BIT_15
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f17d525..66ba399 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -293,6 +293,9 @@ qla81xx_fac_do_write_enable(scsi_qla_host_t *, int);
 extern int
 qla81xx_fac_erase_sector(scsi_qla_host_t *, uint32_t, uint32_t);
 
+extern int
+qla2x00_get_xgmac_stats(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t *);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7d0eeec..2497fe4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3462,3 +3462,41 @@ qla2x00_write_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
 
 	return rval;
 }
+
+int
+qla2x00_get_xgmac_stats(scsi_qla_host_t *vha, dma_addr_t stats_dma,
+    uint16_t size_in_bytes, uint16_t *actual_size)
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
+	mcp->mb[0] = MBC_GET_XGMAC_STATS;
+	mcp->mb[2] = MSW(stats_dma);
+	mcp->mb[3] = LSW(stats_dma);
+	mcp->mb[6] = MSW(MSD(stats_dma));
+	mcp->mb[7] = LSW(MSD(stats_dma));
+	mcp->mb[8] = size_in_bytes >> 2;
+	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
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
+
+		*actual_size = mcp->mb[2] << 2;
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f4f5355..642e976 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2434,6 +2434,10 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		vfree(ha->fw_dump);
 	}
 
+	if (ha->xgmac_data)
+		dma_free_coherent(&ha->pdev->dev, XGMAC_DATA_SIZE,
+		    ha->xgmac_data, ha->xgmac_data_dma);
+
 	if (ha->sns_cmd)
 		dma_free_coherent(&ha->pdev->dev, sizeof(struct sns_cmd_pkt),
 		ha->sns_cmd, ha->sns_cmd_dma);
-- 
1.6.3.1.244.gf9275

