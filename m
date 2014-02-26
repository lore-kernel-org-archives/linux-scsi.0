From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESUBMIT 09/23] qla2xxx: Set host can_queue value based on available resources.
Date: Wed, 26 Feb 2014 04:15:04 -0500
Message-ID: <1393406118-6586-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:60529 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaBZJvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:51:31 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Tell the mid-layer that number of commands we can queue is the available
resources we have minus a small amount for internal commands.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c698e10..925d45c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2561,10 +2561,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	host = base_vha->host;
 	base_vha->req = req;
-	if (IS_QLAFX00(ha))
-		host->can_queue = QLAFX00_MAX_CANQUEUE;
-	else
-		host->can_queue = req->length + 128;
 	if (IS_QLA2XXX_MIDTYPE(ha))
 		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;
 	else
@@ -2587,11 +2583,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!IS_QLA82XX(ha))
 			host->sg_tablesize = QLA_SG_ALL;
 	}
-	ql_dbg(ql_dbg_init, base_vha, 0x0032,
-	    "can_queue=%d, req=%p, "
-	    "mgmt_svr_loop_id=%d, sg_tablesize=%d.\n",
-	    host->can_queue, base_vha->req,
-	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 	host->max_id = ha->max_fibre_devices;
 	host->cmd_per_lun = 3;
 	host->unique_id = host->host_no;
@@ -2707,6 +2698,16 @@ que_init:
 		goto probe_failed;
 	}
 
+	if (IS_QLAFX00(ha))
+		host->can_queue = QLAFX00_MAX_CANQUEUE;
+	else
+		host->can_queue = req->num_outstanding_cmds - 10;
+
+	ql_dbg(ql_dbg_init, base_vha, 0x0032,
+	    "can_queue=%d, req=%p, mgmt_svr_loop_id=%d, sg_tablesize=%d.\n",
+	    host->can_queue, base_vha->req,
+	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
+
 	if (ha->mqenable) {
 		if (qla25xx_setup_mode(base_vha)) {
 			ql_log(ql_log_warn, base_vha, 0x00ec,
-- 
1.7.7

