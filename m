From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 2/4] qla2xxx: Fix crash during firmware dump procedure.
Date: Sat,  9 Mar 2013 06:04:52 -0500
Message-ID: <1362827094-13912-3-git-send-email-chad.dupuis@qlogic.com>
References: <1362827094-13912-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:20147 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757816Ab3CIL1F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Mar 2013 06:27:05 -0500
In-Reply-To: <1362827094-13912-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

System crashes, in initiator mode operation, with
qla2xxx_copy_atioqueues() in stack trace when firmware dump is
attempted.

Check for atio_q_length alone does not indicate if atio_ring is
allocated, make explicit check of atio_ring to avoid the crash.

Applicable to 24XX, 25XX, 81XX & 83XX line of HBAs.

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2bf0214..fbc305f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -402,7 +402,7 @@ qla2xxx_copy_atioqueues(struct qla_hw_data *ha, void *ptr,
 		void *ring;
 	} aq, *aqp;
 
-	if (!ha->tgt.atio_q_length)
+	if (!ha->tgt.atio_ring)
 		return ptr;
 
 	num_queues = 1;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 09eae54..b592033 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1397,7 +1397,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			mq_size += ha->max_rsp_queues *
 			    (rsp->length * sizeof(response_t));
 		}
-		if (ha->tgt.atio_q_length)
+		if (ha->tgt.atio_ring)
 			mq_size += ha->tgt.atio_q_length * sizeof(request_t);
 		/* Allocate memory for Fibre Channel Event Buffer. */
 		if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha) && !IS_QLA83XX(ha))
-- 
1.7.7

