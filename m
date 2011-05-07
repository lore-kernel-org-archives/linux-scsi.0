From: madhu.iyengar@qlogic.com
Subject: [PATCH 10/12] qla2xxx: Unify the read/write sfp mailbox command routines.
Date: Fri,  6 May 2011 17:30:21 -0700
Message-ID: <1304728223-30817-16-git-send-email-madhu.iyengar@qlogic.com>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32820 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753728Ab1EGAnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:11 -0400
In-Reply-To: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Make the read/write sfp mailbox command routines uniform, and remove redundancy.
Also protect against attempting to do a single byte dma in these routines.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   12 +++---
 drivers/scsi/qla2xxx/qla_gbl.h  |   11 ++----
 drivers/scsi/qla2xxx/qla_mbx.c  |   72 ++++++++++++--------------------------
 3 files changed, 33 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4e51124..532313e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -496,8 +496,8 @@ do_read:
 			offset = 0;
 		}
 
-		rval = qla2x00_read_sfp(vha, ha->sfp_data_dma, addr, offset,
-		    SFP_BLOCK_SIZE);
+		rval = qla2x00_read_sfp(vha, ha->sfp_data_dma, ha->sfp_data,
+		    addr, offset, SFP_BLOCK_SIZE, 0);
 		if (rval != QLA_SUCCESS) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to read SFP data (%x/%x/%x).\n", rval,
@@ -628,8 +628,8 @@ qla2x00_sysfs_write_edc(struct file *filp, struct kobject *kobj,
 
 	memcpy(ha->edc_data, &buf[8], len);
 
-	rval = qla2x00_write_edc(vha, dev, adr, ha->edc_data_dma,
-	    ha->edc_data, len, opt);
+	rval = qla2x00_write_sfp(vha, ha->edc_data_dma, ha->edc_data,
+	    dev, adr, len, opt);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "Unable to write EDC (%x) %02x:%02x:%04x:%02x:%02x.\n",
@@ -685,8 +685,8 @@ qla2x00_sysfs_write_edc_status(struct file *filp, struct kobject *kobj,
 			return -EINVAL;
 
 	memset(ha->edc_data, 0, len);
-	rval = qla2x00_read_edc(vha, dev, adr, ha->edc_data_dma,
-	    ha->edc_data, len, opt);
+	rval = qla2x00_read_sfp(vha, ha->edc_data_dma, ha->edc_data,
+			dev, adr, len, opt);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "Unable to write EDC status (%x) %02x:%02x:%04x:%02x.\n",
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 79a12aa..0b38122 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -323,15 +323,12 @@ extern int
 qla2x00_disable_fce_trace(scsi_qla_host_t *, uint64_t *, uint64_t *);
 
 extern int
-qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t, uint16_t);
+qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint8_t *,
+	uint16_t, uint16_t, uint16_t, uint16_t);
 
 extern int
-qla2x00_read_edc(scsi_qla_host_t *, uint16_t, uint16_t, dma_addr_t,
-    uint8_t *, uint16_t, uint16_t);
-
-extern int
-qla2x00_write_edc(scsi_qla_host_t *, uint16_t, uint16_t, dma_addr_t,
-    uint8_t *, uint16_t, uint16_t);
+qla2x00_write_sfp(scsi_qla_host_t *, dma_addr_t, uint8_t *,
+	uint16_t, uint16_t, uint16_t, uint16_t);
 
 extern int
 qla2x00_set_idma_speed(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t *);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index aab628b..7184b87 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2787,44 +2787,6 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *vha, uint64_t *wr, uint64_t *rd)
 }
 
 int
-qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint16_t addr,
-    uint16_t off, uint16_t count)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-
-	if (!IS_FWI2_CAPABLE(vha->hw))
-		return QLA_FUNCTION_FAILED;
-
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
-	mcp->mb[0] = MBC_READ_SFP;
-	mcp->mb[1] = addr;
-	mcp->mb[2] = MSW(sfp_dma);
-	mcp->mb[3] = LSW(sfp_dma);
-	mcp->mb[6] = MSW(MSD(sfp_dma));
-	mcp->mb[7] = LSW(MSD(sfp_dma));
-	mcp->mb[8] = count;
-	mcp->mb[9] = off;
-	mcp->mb[10] = 0;
-	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(vha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
-	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
-	}
-
-	return rval;
-}
-
-int
 qla2x00_get_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 	uint16_t *port_speed, uint16_t *mb)
 {
@@ -3589,15 +3551,22 @@ qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
 }
 
 int
-qla2x00_read_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
-    dma_addr_t sfp_dma, uint8_t *sfp, uint16_t len, uint16_t opt)
+qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
+	uint16_t dev, uint16_t off, uint16_t len, uint16_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
+	if (len == 1)
+		opt |= BIT_0;
+
 	mcp->mb[0] = MBC_READ_SFP;
 	mcp->mb[1] = dev;
 	mcp->mb[2] = MSW(sfp_dma);
@@ -3605,7 +3574,7 @@ qla2x00_read_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
 	mcp->mb[6] = MSW(MSD(sfp_dma));
 	mcp->mb[7] = LSW(MSD(sfp_dma));
 	mcp->mb[8] = len;
-	mcp->mb[9] = adr;
+	mcp->mb[9] = off;
 	mcp->mb[10] = opt;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_1|MBX_0;
@@ -3614,8 +3583,7 @@ qla2x00_read_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (opt & BIT_0)
-		if (sfp)
-			*sfp = mcp->mb[1];
+		*sfp = mcp->mb[1];
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
@@ -3628,18 +3596,24 @@ qla2x00_read_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
 }
 
 int
-qla2x00_write_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
-    dma_addr_t sfp_dma, uint8_t *sfp, uint16_t len, uint16_t opt)
+qla2x00_write_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
+	uint16_t dev, uint16_t off, uint16_t len, uint16_t opt)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
+	if (len == 1)
+		opt |= BIT_0;
+
 	if (opt & BIT_0)
-		if (sfp)
-			len = *sfp;
+		len = *sfp;
 
 	mcp->mb[0] = MBC_WRITE_SFP;
 	mcp->mb[1] = dev;
@@ -3648,10 +3622,10 @@ qla2x00_write_edc(scsi_qla_host_t *vha, uint16_t dev, uint16_t adr,
 	mcp->mb[6] = MSW(MSD(sfp_dma));
 	mcp->mb[7] = LSW(MSD(sfp_dma));
 	mcp->mb[8] = len;
-	mcp->mb[9] = adr;
+	mcp->mb[9] = off;
 	mcp->mb[10] = opt;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
-- 
1.6.0.2

