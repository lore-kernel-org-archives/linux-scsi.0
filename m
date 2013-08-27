From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 22/29] qla2xxx: Add loopback IDC-TIME-EXTEND aen handling support.
Date: Tue, 27 Aug 2013 01:37:48 -0400
Message-ID: <1377581875-8574-23-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:17489 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927Ab3H0GGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:52 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R65GY1019637
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690x3-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

Earlier IDC-TIME-EXTEND aen was a nop and ignored by driver.
We now have to handle the aen so that other protocol drivers can use time
extension during some loopback operations.

Signed-off-by: Santosh Vernekar <santosh.vernekar@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   17 ++++++++++++-
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |   47 +++++++++++++++++++++++++--------------
 4 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index fb5bd6e..b989add 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -627,6 +627,7 @@ qla81xx_set_loopback_mode(scsi_qla_host_t *vha, uint16_t *config,
 {
 	int ret = 0;
 	int rval = 0;
+	unsigned long rem_tmo = 0, current_tmo = 0;
 	struct qla_hw_data *ha = vha->hw;
 
 	if (!IS_QLA81XX(ha) && !IS_QLA8031(ha) && !IS_QLA8044(ha))
@@ -652,8 +653,19 @@ qla81xx_set_loopback_mode(scsi_qla_host_t *vha, uint16_t *config,
 	}
 
 	/* Wait for DCBX complete event */
-	if (!wait_for_completion_timeout(&ha->dcbx_comp,
-	    (DCBX_COMP_TIMEOUT * HZ))) {
+	current_tmo = DCBX_COMP_TIMEOUT * HZ;
+	while (1) {
+		rem_tmo = wait_for_completion_timeout(&ha->dcbx_comp,
+		    current_tmo);
+		if (!ha->idc_extend_tmo || rem_tmo) {
+			ha->idc_extend_tmo = 0;
+			break;
+		}
+		current_tmo = ha->idc_extend_tmo * HZ;
+		ha->idc_extend_tmo = 0;
+	}
+
+	if (!rem_tmo) {
 		ql_dbg(ql_dbg_user, vha, 0x7022,
 		    "DCBX completion not received.\n");
 		ret = qla81xx_reset_loopback_mode(vha, new_config, 0, 0);
@@ -678,6 +690,7 @@ qla81xx_set_loopback_mode(scsi_qla_host_t *vha, uint16_t *config,
 	}
 
 	ha->notify_dcbx_comp = 0;
+	ha->idc_extend_tmo = 0;
 
 done_set_internal:
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index ca6bcf6..f192c52 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -26,7 +26,7 @@
  * |                              |                    | 0x3036,0x3038  |
  * |                              |                    | 0x303a		|
  * | DPC Thread                   |       0x4022       | 0x4002,0x4013  |
- * | Async Events                 |       0x5086       | 0x502b-0x502f  |
+ * | Async Events                 |       0x5087       | 0x502b-0x502f  |
  * |                              |                    | 0x5047,0x5052  |
  * |                              |                    | 0x5040,0x5075  |
  * |                              |                    | 0x503d,0x5044  |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d6eefb8..93db74e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3292,6 +3292,7 @@ struct qla_hw_data {
 
 	/* QLA83XX IDC specific fields */
 	uint32_t	idc_audit_ts;
+	uint32_t	idc_extend_tmo;
 
 	/* DPC low-priority workqueue */
 	struct workqueue_struct *dpc_lp_wq;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index bbc24d3..df1b30b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -282,25 +282,38 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t aen, uint16_t descr)
 	    "%04x %04x %04x %04x %04x %04x %04x.\n",
 	    event[aen & 0xff], mb[0], mb[1], mb[2], mb[3],
 	    mb[4], mb[5], mb[6]);
-	if ((aen == MBA_IDC_COMPLETE && mb[1] >> 15)) {
-		vha->hw->flags.idc_compl_status = 1;
-		if (vha->hw->notify_dcbx_comp)
-			complete(&vha->hw->dcbx_comp);
-	}
-
-	/* Acknowledgement needed? [Notify && non-zero timeout]. */
-	timeout = (descr >> 8) & 0xf;
-	if (aen != MBA_IDC_NOTIFY || !timeout)
-		return;
+	switch (aen) {
+	/* Handle IDC Error completion case. */
+	case MBA_IDC_COMPLETE:
+		if (mb[1] >> 15) {
+			vha->hw->flags.idc_compl_status = 1;
+			if (vha->hw->notify_dcbx_comp)
+				complete(&vha->hw->dcbx_comp);
+		}
+		break;
 
-	ql_dbg(ql_dbg_async, vha, 0x5022,
-	    "%lu Inter-Driver Communication %s -- ACK timeout=%d.\n",
-	    vha->host_no, event[aen & 0xff], timeout);
+	case MBA_IDC_NOTIFY:
+		/* Acknowledgement needed? [Notify && non-zero timeout]. */
+		timeout = (descr >> 8) & 0xf;
+		ql_dbg(ql_dbg_async, vha, 0x5022,
+		    "%lu Inter-Driver Communication %s -- ACK timeout=%d.\n",
+		    vha->host_no, event[aen & 0xff], timeout);
 
-	rval = qla2x00_post_idc_ack_work(vha, mb);
-	if (rval != QLA_SUCCESS)
-		ql_log(ql_log_warn, vha, 0x5023,
-		    "IDC failed to post ACK.\n");
+		if (!timeout)
+			return;
+		rval = qla2x00_post_idc_ack_work(vha, mb);
+		if (rval != QLA_SUCCESS)
+			ql_log(ql_log_warn, vha, 0x5023,
+			    "IDC failed to post ACK.\n");
+		break;
+	case MBA_IDC_TIME_EXT:
+		vha->hw->idc_extend_tmo = descr;
+		ql_dbg(ql_dbg_async, vha, 0x5087,
+		    "%lu Inter-Driver Communication %s -- "
+		    "Extend timeout by=%d.\n",
+		    vha->host_no, event[aen & 0xff], vha->hw->idc_extend_tmo);
+		break;
+	}
 }
 
 #define LS_UNKNOWN	2
-- 
1.7.7

