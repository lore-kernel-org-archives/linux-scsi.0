From: madhu.iyengar@qlogic.com
Subject: [PATCH 06/12] qla2xxx: Add flash read/update support using BSG interface
Date: Fri, 15 Oct 2010 11:27:43 -0700
Message-ID: <1287167269-8034-7-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36960 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755593Ab0JOSg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:28 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |  125 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h |    2 +
 2 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index fdfbf83..31a4121 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1307,6 +1307,125 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 }
 
 static int
+qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
+	uint8_t is_update)
+{
+	uint32_t start = 0;
+	int valid = 0;
+
+	bsg_job->reply->reply_payload_rcv_len = 0;
+
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return -EINVAL;
+
+	start = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
+	if (start > ha->optrom_size)
+		return -EINVAL;
+
+	if (ha->optrom_state != QLA_SWAITING)
+		return -EBUSY;
+
+	ha->optrom_region_start = start;
+
+	if (is_update) {
+		if (ha->optrom_size == OPTROM_SIZE_2300 && start == 0)
+			valid = 1;
+		else if (start == (ha->flt_region_boot * 4) ||
+		    start == (ha->flt_region_fw * 4))
+			valid = 1;
+		else if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
+		    IS_QLA8XXX_TYPE(ha))
+			valid = 1;
+		if (!valid) {
+			qla_printk(KERN_WARNING, ha,
+			    "Invalid start region 0x%x/0x%x.\n",
+			    start, bsg_job->request_payload.payload_len);
+			return -EINVAL;
+		}
+
+		ha->optrom_region_size = start +
+		    bsg_job->request_payload.payload_len > ha->optrom_size ?
+		    ha->optrom_size - start :
+		    bsg_job->request_payload.payload_len;
+		ha->optrom_state = QLA_SWRITING;
+	} else {
+		ha->optrom_region_size = start +
+		    bsg_job->reply_payload.payload_len > ha->optrom_size ?
+		    ha->optrom_size - start :
+		    bsg_job->reply_payload.payload_len;
+		ha->optrom_state = QLA_SREADING;
+	}
+
+	ha->optrom_buffer = vmalloc(ha->optrom_region_size);
+	if (!ha->optrom_buffer) {
+		qla_printk(KERN_WARNING, ha,
+		    "Read: Unable to allocate memory for optrom retrieval "
+		    "(%x).\n", ha->optrom_region_size);
+
+		ha->optrom_state = QLA_SWAITING;
+		return -ENOMEM;
+	}
+
+	memset(ha->optrom_buffer, 0, ha->optrom_region_size);
+	return 0;
+}
+
+static int
+qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int rval = 0;
+
+	rval = qla2x00_optrom_setup(bsg_job, ha, 0);
+	if (rval)
+		return rval;
+
+	ha->isp_ops->read_optrom(vha, ha->optrom_buffer,
+	    ha->optrom_region_start, ha->optrom_region_size);
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, ha->optrom_buffer,
+	    ha->optrom_region_size);
+
+	bsg_job->reply->reply_payload_rcv_len = ha->optrom_region_size;
+	bsg_job->reply->result = DID_OK;
+	vfree(ha->optrom_buffer);
+	ha->optrom_buffer = NULL;
+	ha->optrom_state = QLA_SWAITING;
+	bsg_job->job_done(bsg_job);
+	return rval;
+}
+
+static int
+qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
+{
+	struct Scsi_Host *host = bsg_job->shost;
+	scsi_qla_host_t *vha = shost_priv(host);
+	struct qla_hw_data *ha = vha->hw;
+	int rval = 0;
+
+	rval = qla2x00_optrom_setup(bsg_job, ha, 1);
+	if (rval)
+		return rval;
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, ha->optrom_buffer,
+	    ha->optrom_region_size);
+
+	ha->isp_ops->write_optrom(vha, ha->optrom_buffer,
+	    ha->optrom_region_start, ha->optrom_region_size);
+
+	bsg_job->reply->result = DID_OK;
+	vfree(ha->optrom_buffer);
+	ha->optrom_buffer = NULL;
+	ha->optrom_state = QLA_SWAITING;
+	bsg_job->job_done(bsg_job);
+	return rval;
+}
+
+static int
 qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 {
 	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
@@ -1328,6 +1447,12 @@ qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
 	case QL_VND_FCP_PRIO_CFG_CMD:
 		return qla24xx_proc_fcp_prio_cfg_cmd(bsg_job);
 
+	case QL_VND_READ_FLASH:
+		return qla2x00_read_optrom(bsg_job);
+
+	case QL_VND_UPDATE_FLASH:
+		return qla2x00_update_optrom(bsg_job);
+
 	default:
 		bsg_job->reply->result = (DID_ERROR << 16);
 		bsg_job->job_done(bsg_job);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index cc7c52f..074a999 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -14,6 +14,8 @@
 #define QL_VND_A84_MGMT_CMD	0x04
 #define QL_VND_IIDMA		0x05
 #define QL_VND_FCP_PRIO_CFG_CMD	0x06
+#define QL_VND_READ_FLASH	0x07
+#define QL_VND_UPDATE_FLASH	0x08
 
 /* BSG definations for interpreting CommandSent field */
 #define INT_DEF_LB_LOOPBACK_CMD         0
-- 
1.6.0.2

