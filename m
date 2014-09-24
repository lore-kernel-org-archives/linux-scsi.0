From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 28/35] qla2xxx: Honor FCP_RSP retry delay timer field.
Date: Wed, 24 Sep 2014 03:08:31 -0400
Message-ID: <1411542518-2477-29-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32850 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbaIXHnq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:43:46 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Parse the retry delay timer field from the FCP response data and if:

- It is not zero
- The SCSI status is busy or queue full

return SCSI_MLQUEUE_TARGET_BUSY for the number of milliseconds specified
in the retry delay timer field.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |    2 ++
 drivers/scsi/qla2xxx/qla_fw.h     |    2 +-
 drivers/scsi/qla2xxx/qla_inline.h |    8 ++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |   12 ++++++++++++
 drivers/scsi/qla2xxx/qla_os.c     |    9 +++++++++
 5 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 62c902c..03da3eb 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2023,6 +2023,8 @@ typedef struct fc_port {
 	unsigned long last_ramp_up;
 
 	uint16_t port_id;
+
+	unsigned long retry_delay_timestamp;
 } fc_port_t;
 
 #include "qla_mr.h"
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 7f2e1c7..42bb357 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -567,7 +567,7 @@ struct sts_entry_24xx {
 #define SF_TRANSFERRED_DATA	BIT_11
 #define SF_FCP_RSP_DMA		BIT_0
 
-	uint16_t reserved_2;
+	uint16_t retry_delay;
 	uint16_t scsi_status;		/* SCSI status. */
 #define SS_CONFIRMATION_REQ		BIT_12
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index b3b1d6f..fee9eb7 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -279,3 +279,11 @@ qla2x00_handle_mbx_completion(struct qla_hw_data *ha, int status)
 		complete(&ha->mbx_intr_comp);
 	}
 }
+
+static inline void
+qla2x00_set_retry_delay_timestamp(fc_port_t *fcport, uint16_t retry_delay)
+{
+	if (retry_delay)
+		fcport->retry_delay_timestamp = jiffies +
+		    (retry_delay * HZ / 10);
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6627fd5..d67fcaa 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1983,6 +1983,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	int logit = 1;
 	int res = 0;
 	uint16_t state_flags = 0;
+	uint16_t retry_delay = 0;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -2076,6 +2077,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
 		ox_id = le16_to_cpu(sts24->ox_id);
 		par_sense_len = sizeof(sts24->data);
+		/* Valid values of the retry delay timer are 0x1-0xffef */
+		if (sts24->retry_delay > 0 && sts24->retry_delay < 0xfff1)
+			retry_delay = sts24->retry_delay;
 	} else {
 		if (scsi_status & SS_SENSE_LEN_VALID)
 			sense_len = le16_to_cpu(sts->req_sense_length);
@@ -2110,6 +2114,14 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		comp_status = CS_DATA_OVERRUN;
 
 	/*
+	 * Check retry_delay_timer value if we receive a busy or
+	 * queue full.
+	 */
+	if (lscsi_status == SAM_STAT_TASK_SET_FULL ||
+	    lscsi_status == SAM_STAT_BUSY)
+		qla2x00_set_retry_delay_timestamp(fcport, retry_delay);
+
+	/*
 	 * Based on Host and scsi status generate status code for Linux
 	 */
 	switch (comp_status) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bf78127..08c8e9c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -730,6 +730,15 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto qc24_target_busy;
 	}
 
+	/*
+	 * Return target busy if we've received a non-zero retry_delay_timer
+	 * in a FCP_RSP.
+	 */
+	if (time_after(jiffies, fcport->retry_delay_timestamp))
+		fcport->retry_delay_timestamp = 0;
+	else
+		goto qc24_target_busy;
+
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto qc24_host_busy;
-- 
1.7.7

