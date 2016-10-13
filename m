From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 15/17] lpfc: Synchronize link speed with boot driver
Date: Thu, 13 Oct 2016 15:06:16 -0700
Message-ID: <58000558.oQvh2S/jqBX/2X/s%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.61]:55042 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbcJMWHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:07:21 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 78FA410074B
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Synchronize link speed with boot driver

Link speed settings set by the boot driver are reported by the hw.
Driver will attempt to read them, and if set, will respect their
values.
The driver can override the settings with its own if instructed by
user space (via bsg), with the new values being picked up by the
boot driver.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
v3 mods:
 parens cleanup
 use shost_priv() on new code

 drivers/scsi/lpfc/lpfc.h      |  4 ++++
 drivers/scsi/lpfc/lpfc_attr.c |  7 +++++-
 drivers/scsi/lpfc/lpfc_bsg.c  | 45 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_bsg.h  | 10 ++++++++
 drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
 drivers/scsi/lpfc/lpfc_init.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index debba5e..8a20b4e 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -648,6 +648,10 @@ struct lpfc_hba {
 #define HBA_FCP_IOQ_FLUSH	0x8000 /* FCP I/O queues being flushed */
 #define HBA_FW_DUMP_OP		0x10000 /* Skips fn reset before FW dump */
 #define HBA_RECOVERABLE_UE	0x20000 /* Firmware supports recoverable UE */
+#define HBA_FORCED_LINK_SPEED	0x40000 /*
+					 * Firmware supports Forced Link Speed
+					 * capability
+					 */
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 3740e5d..c847755 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3668,7 +3668,12 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 	int nolip = 0;
 	const char *val_buf = buf;
 	int err;
-	uint32_t prev_val;
+	uint32_t prev_val, if_type;
+
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	if (if_type == LPFC_SLI_INTF_IF_TYPE_2 &&
+	    phba->hba_flag & HBA_FORCED_LINK_SPEED)
+		return -EPERM;
 
 	if (!strncmp(buf, "nolip ", strlen("nolip "))) {
 		nolip = 1;
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 05dcc2a..e6a5254 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5185,6 +5185,48 @@ no_dd_data:
 	return rc;
 }
 
+static int
+lpfc_forced_link_speed(struct fc_bsg_job *job)
+{
+	struct Scsi_Host *shost = job->shost;
+	struct lpfc_vport *vport = shost_priv(shost);
+	struct lpfc_hba *phba = vport->phba;
+	struct forced_link_speed_support_reply *forced_reply;
+	int rc = 0;
+
+	if (job->request_len <
+	    sizeof(struct fc_bsg_request) +
+	    sizeof(struct get_forced_link_speed_support)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"0048 Received FORCED_LINK_SPEED request "
+				"below minimum size\n");
+		rc = -EINVAL;
+		goto job_error;
+	}
+
+	forced_reply = (struct forced_link_speed_support_reply *)
+		job->reply->reply_data.vendor_reply.vendor_rsp;
+
+	if (job->reply_len <
+	    sizeof(struct fc_bsg_request) +
+	    sizeof(struct forced_link_speed_support_reply)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"0049 Received FORCED_LINK_SPEED reply below "
+				"minimum size\n");
+		rc = -EINVAL;
+		goto job_error;
+	}
+
+	forced_reply->supported = (phba->hba_flag & HBA_FORCED_LINK_SPEED)
+				   ? LPFC_FORCED_LINK_SPEED_SUPPORTED
+				   : LPFC_FORCED_LINK_SPEED_NOT_SUPPORTED;
+job_error:
+	job->reply->result = rc;
+	if (rc == 0)
+		job->job_done(job);
+	return rc;
+}
+
 /**
  * lpfc_bsg_hst_vendor - process a vendor-specific fc_bsg_job
  * @job: fc_bsg_job to handle
@@ -5227,6 +5269,9 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 	case LPFC_BSG_VENDOR_MENLO_DATA:
 		rc = lpfc_menlo_cmd(job);
 		break;
+	case LPFC_BSG_VENDOR_FORCED_LINK_SPEED:
+		rc = lpfc_forced_link_speed(job);
+		break;
 	default:
 		rc = -EINVAL;
 		job->reply->reply_payload_rcv_len = 0;
diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index e557bcd..f2247aa 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -35,6 +35,7 @@
 #define LPFC_BSG_VENDOR_MENLO_DATA		9
 #define LPFC_BSG_VENDOR_DIAG_MODE_END		10
 #define LPFC_BSG_VENDOR_LINK_DIAG_TEST		11
+#define LPFC_BSG_VENDOR_FORCED_LINK_SPEED	14
 
 struct set_ct_event {
 	uint32_t command;
@@ -284,6 +285,15 @@ struct lpfc_sli_config_mbox {
 	} un;
 };
 
+#define LPFC_FORCED_LINK_SPEED_NOT_SUPPORTED	0
+#define LPFC_FORCED_LINK_SPEED_SUPPORTED	1
+struct get_forced_link_speed_support {
+	uint32_t command;
+};
+struct forced_link_speed_support_reply {
+	uint8_t supported;
+};
+
 /* driver only */
 #define SLI_CONFIG_NOT_HANDLED		0
 #define SLI_CONFIG_HANDLED		1
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 0b2c337..bbdcb5a 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2290,6 +2290,9 @@ struct lpfc_mbx_read_config {
 #define lpfc_mbx_rd_conf_r_a_tov_SHIFT		0
 #define lpfc_mbx_rd_conf_r_a_tov_MASK		0x0000FFFF
 #define lpfc_mbx_rd_conf_r_a_tov_WORD		word6
+#define lpfc_mbx_rd_conf_link_speed_SHIFT	16
+#define lpfc_mbx_rd_conf_link_speed_MASK	0x0000FFFF
+#define lpfc_mbx_rd_conf_link_speed_WORD	word6
 	uint32_t rsvd_7;
 	uint32_t rsvd_8;
 	uint32_t word9;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 117c69a..53227e5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6931,6 +6931,8 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 	struct lpfc_mbx_get_func_cfg *get_func_cfg;
 	struct lpfc_rsrc_desc_fcfcoe *desc;
 	char *pdesc_0;
+	uint16_t forced_link_speed;
+	uint32_t if_type;
 	int length, i, rc = 0, rc2;
 
 	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -7024,6 +7026,58 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 	if (rc)
 		goto read_cfg_out;
 
+	/* Update link speed if forced link speed is supported */
+	if_type = bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf);
+	if (if_type == LPFC_SLI_INTF_IF_TYPE_2) {
+		forced_link_speed =
+			bf_get(lpfc_mbx_rd_conf_link_speed, rd_config);
+		if (forced_link_speed) {
+			phba->hba_flag |= HBA_FORCED_LINK_SPEED;
+
+			switch (forced_link_speed) {
+			case LINK_SPEED_1G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_1G;
+				break;
+			case LINK_SPEED_2G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_2G;
+				break;
+			case LINK_SPEED_4G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_4G;
+				break;
+			case LINK_SPEED_8G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_8G;
+				break;
+			case LINK_SPEED_10G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_10G;
+				break;
+			case LINK_SPEED_16G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_16G;
+				break;
+			case LINK_SPEED_32G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_32G;
+				break;
+			case 0xffff:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_AUTO;
+				break;
+			default:
+				lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+						"0047 Unrecognized link "
+						"speed : %d\n",
+						forced_link_speed);
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_AUTO;
+			}
+		}
+	}
+
 	/* Reset the DFT_HBA_Q_DEPTH to the max xri  */
 	length = phba->sli4_hba.max_cfg_param.max_xri -
 			lpfc_sli4_get_els_iocb_cnt(phba);
-- 
2.5.0


