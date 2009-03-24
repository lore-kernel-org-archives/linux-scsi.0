From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 18/26] qla2xxx: Add EDC-update support.
Date: Tue, 24 Mar 2009 09:08:12 -0700
Message-ID: <1237910900-30817-19-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762171AbZCXQIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:38 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Interface allows for the update of onboard EDC firmware
present on mezzanine ISP25xx type cards.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  144 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    5 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |    8 ++
 drivers/scsi/qla2xxx/qla_mbx.c  |   78 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    3 +
 5 files changed, 238 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ed22ee0..a59edb5 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -548,6 +548,144 @@ static struct bin_attribute sysfs_reset_attr = {
 	.write = qla2x00_sysfs_write_reset,
 };
 
+static ssize_t
+qla2x00_sysfs_write_edc(struct kobject *kobj,
+			struct bin_attribute *bin_attr,
+			char *buf, loff_t off, size_t count)
+{
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t dev, adr, opt, len;
+	int rval;
+
+	ha->edc_data_len = 0;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count < 8)
+		return 0;
+
+	if (!ha->edc_data) {
+		ha->edc_data = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		    &ha->edc_data_dma);
+		if (!ha->edc_data) {
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "Unable to allocate memory for EDC write.\n"));
+			return 0;
+		}
+	}
+
+	dev = le16_to_cpup((void *)&buf[0]);
+	adr = le16_to_cpup((void *)&buf[2]);
+	opt = le16_to_cpup((void *)&buf[4]);
+	len = le16_to_cpup((void *)&buf[6]);
+
+	if (!(opt & BIT_0))
+		if (len == 0 || len > DMA_POOL_SIZE || len > count - 8)
+			return -EINVAL;
+
+	memcpy(ha->edc_data, &buf[8], len);
+
+	rval = qla2x00_write_edc(vha, dev, adr, ha->edc_data_dma,
+	    ha->edc_data, len, opt);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "Unable to write EDC (%x) %02x:%02x:%04x:%02x:%02x.\n",
+		    rval, dev, adr, opt, len, *buf));
+		return 0;
+	}
+
+	return count;
+}
+
+static struct bin_attribute sysfs_edc_attr = {
+	.attr = {
+		.name = "edc",
+		.mode = S_IWUSR,
+	},
+	.size = 0,
+	.write = qla2x00_sysfs_write_edc,
+};
+
+static ssize_t
+qla2x00_sysfs_write_edc_status(struct kobject *kobj,
+			struct bin_attribute *bin_attr,
+			char *buf, loff_t off, size_t count)
+{
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t dev, adr, opt, len;
+	int rval;
+
+	ha->edc_data_len = 0;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count < 8)
+		return 0;
+
+	if (!ha->edc_data) {
+		ha->edc_data = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
+		    &ha->edc_data_dma);
+		if (!ha->edc_data) {
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "Unable to allocate memory for EDC status.\n"));
+			return 0;
+		}
+	}
+
+	dev = le16_to_cpup((void *)&buf[0]);
+	adr = le16_to_cpup((void *)&buf[2]);
+	opt = le16_to_cpup((void *)&buf[4]);
+	len = le16_to_cpup((void *)&buf[6]);
+
+	if (!(opt & BIT_0))
+		if (len == 0 || len > DMA_POOL_SIZE)
+			return -EINVAL;
+
+	memset(ha->edc_data, 0, len);
+	rval = qla2x00_read_edc(vha, dev, adr, ha->edc_data_dma,
+	    ha->edc_data, len, opt);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_INFO, ha,
+		    "Unable to write EDC status (%x) %02x:%02x:%04x:%02x.\n",
+		    rval, dev, adr, opt, len));
+		return 0;
+	}
+
+	ha->edc_data_len = len;
+
+	return count;
+}
+
+static ssize_t
+qla2x00_sysfs_read_edc_status(struct kobject *kobj,
+			   struct bin_attribute *bin_attr,
+			   char *buf, loff_t off, size_t count)
+{
+	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
+	    struct device, kobj)));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!capable(CAP_SYS_ADMIN) || off != 0 || count == 0)
+		return 0;
+
+	if (!ha->edc_data || ha->edc_data_len == 0 || ha->edc_data_len > count)
+		return -EINVAL;
+
+	memcpy(buf, ha->edc_data, ha->edc_data_len);
+
+	return ha->edc_data_len;
+}
+
+static struct bin_attribute sysfs_edc_status_attr = {
+	.attr = {
+		.name = "edc_status",
+		.mode = S_IRUSR | S_IWUSR,
+	},
+	.size = 0,
+	.write = qla2x00_sysfs_write_edc_status,
+	.read = qla2x00_sysfs_read_edc_status,
+};
+
 static struct sysfs_entry {
 	char *name;
 	struct bin_attribute *attr;
@@ -560,6 +698,8 @@ static struct sysfs_entry {
 	{ "vpd", &sysfs_vpd_attr, 1 },
 	{ "sfp", &sysfs_sfp_attr, 1 },
 	{ "reset", &sysfs_reset_attr, },
+	{ "edc", &sysfs_edc_attr, 2 },
+	{ "edc_status", &sysfs_edc_status_attr, 2 },
 	{ NULL },
 };
 
@@ -573,6 +713,8 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
 	for (iter = bin_file_entries; iter->name; iter++) {
 		if (iter->is4GBp_only && !IS_FWI2_CAPABLE(vha->hw))
 			continue;
+		if (iter->is4GBp_only == 2 && !IS_QLA25XX(vha->hw))
+			continue;
 
 		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
@@ -593,6 +735,8 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *vha)
 	for (iter = bin_file_entries; iter->name; iter++) {
 		if (iter->is4GBp_only && !IS_FWI2_CAPABLE(ha))
 			continue;
+		if (iter->is4GBp_only == 2 && !IS_QLA25XX(ha))
+			continue;
 
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 757e31d..5a55a20 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -607,6 +607,7 @@ typedef struct {
 #define MBC_GET_TIMEOUT_PARAMS		0x22	/* Get FW timeouts. */
 #define MBC_TRACE_CONTROL		0x27	/* Trace control command. */
 #define MBC_GEN_SYSTEM_ERROR		0x2a	/* Generate System Error. */
+#define MBC_WRITE_SFP			0x30	/* Write SFP Data. */
 #define MBC_READ_SFP			0x31	/* Read SFP Data. */
 #define MBC_SET_TIMEOUT_PARAMS		0x32	/* Set FW timeouts. */
 #define MBC_MID_INITIALIZE_FIRMWARE	0x48	/* MID Initialize firmware. */
@@ -2387,6 +2388,10 @@ struct qla_hw_data {
 	void		*sfp_data;
 	dma_addr_t	sfp_data_dma;
 
+	uint8_t		*edc_data;
+	dma_addr_t	edc_data_dma;
+	uint16_t	edc_data_len;
+
 	struct task_struct	*dpc_thread;
 	uint8_t dpc_active;                  /* DPC routine is active */
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 41c3f41..528913f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -265,6 +265,14 @@ extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
 
 extern int
+qla2x00_read_edc(scsi_qla_host_t *, uint16_t, uint16_t, dma_addr_t,
+    uint8_t *, uint16_t, uint16_t);
+
+extern int
+qla2x00_write_edc(scsi_qla_host_t *, uint16_t, uint16_t, dma_addr_t,
+    uint8_t *, uint16_t, uint16_t);
+
+extern int
 qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
 
 extern int qla84xx_verify_chip(struct scsi_qla_host *, uint16_t *);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7af9bd7..951537e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3347,3 +3347,81 @@ qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
 
 	return rval;
 }
+
+int
+qla2x00_read_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
+    dma_addr_t sfp_dma, uint8_t *sfp, uint16_t len, uint16_t opt)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_READ_SFP;
+	mcp->mb[1] = dev;
+	mcp->mb[2] = MSW(sfp_dma);
+	mcp->mb[3] = LSW(sfp_dma);
+	mcp->mb[6] = MSW(MSD(sfp_dma));
+	mcp->mb[7] = LSW(MSD(sfp_dma));
+	mcp->mb[8] = len;
+	mcp->mb[9] = adr;
+	mcp->mb[10] = opt;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (opt & BIT_0)
+		if (sfp)
+			*sfp = mcp->mb[8];
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
+		    vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
+	}
+
+	return rval;
+}
+
+int
+qla2x00_write_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
+    dma_addr_t sfp_dma, uint8_t *sfp, uint16_t len, uint16_t opt)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	if (opt & BIT_0)
+		if (sfp)
+			len = *sfp;
+
+	mcp->mb[0] = MBC_WRITE_SFP;
+	mcp->mb[1] = dev;
+	mcp->mb[2] = MSW(sfp_dma);
+	mcp->mb[3] = LSW(sfp_dma);
+	mcp->mb[6] = MSW(MSD(sfp_dma));
+	mcp->mb[7] = LSW(MSD(sfp_dma));
+	mcp->mb[8] = len;
+	mcp->mb[9] = adr;
+	mcp->mb[10] = opt;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
+		    vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ba3309f..9bb4b2e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2337,6 +2337,9 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	if (ha->sfp_data)
 		dma_pool_free(ha->s_dma_pool, ha->sfp_data, ha->sfp_data_dma);
 
+	if (ha->edc_data)
+		dma_pool_free(ha->s_dma_pool, ha->edc_data, ha->edc_data_dma);
+
 	if (ha->ms_iocb)
 		dma_pool_free(ha->s_dma_pool, ha->ms_iocb, ha->ms_iocb_dma);
 
-- 
1.6.2.rc0.55.g30aa4f

