From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 19/20] qla2xxx: Fix multiqueue MSI-X registration.
Date: Fri, 13 Dec 2013 15:03:59 -0500
Message-ID: <1386965040-20611-20-git-send-email-saurav.kashyap@qlogic.com>
References: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:65376 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164Ab3LMUgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 15:36:47 -0500
In-Reply-To: <1386965040-20611-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   46 ++++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index da5f466..c2aaf6a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2882,6 +2882,7 @@ static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 #define MIN_MSIX_COUNT	2
+#define ATIO_VECTOR	2
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
@@ -2938,34 +2939,47 @@ msix_failed:
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < ha->msix_count; i++) {
+	for (i = 0; i < 2; i++) {
 		qentry = &ha->msix_entries[i];
-		if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
-			ret = request_irq(qentry->vector,
-				qla83xx_msix_entries[i].handler,
-				0, qla83xx_msix_entries[i].name, rsp);
-		} else if (IS_P3P_TYPE(ha)) {
+		if (IS_P3P_TYPE(ha))
 			ret = request_irq(qentry->vector,
 				qla82xx_msix_entries[i].handler,
 				0, qla82xx_msix_entries[i].name, rsp);
-		} else {
+		else
 			ret = request_irq(qentry->vector,
 				msix_entries[i].handler,
 				0, msix_entries[i].name, rsp);
-		}
-		if (ret) {
-			ql_log(ql_log_fatal, vha, 0x00cb,
-			    "MSI-X: unable to register handler -- %x/%d.\n",
-			    qentry->vector, ret);
-			qla24xx_disable_msix(ha);
-			ha->mqenable = 0;
-			goto msix_out;
-		}
+		if (ret)
+			goto msix_register_fail;
 		qentry->have_irq = 1;
 		qentry->rsp = rsp;
 		rsp->msix = qentry;
 	}
 
+	/*
+	 * If target mode is enable, also request the vector for the ATIO
+	 * queue.
+	 */
+	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
+		qentry = &ha->msix_entries[ATIO_VECTOR];
+		ret = request_irq(qentry->vector,
+			qla83xx_msix_entries[ATIO_VECTOR].handler,
+			0, qla83xx_msix_entries[ATIO_VECTOR].name, rsp);
+		qentry->have_irq = 1;
+		qentry->rsp = rsp;
+		rsp->msix = qentry;
+	}
+
+msix_register_fail:
+	if (ret) {
+		ql_log(ql_log_fatal, vha, 0x00cb,
+		    "MSI-X: unable to register handler -- %x/%d.\n",
+		    qentry->vector, ret);
+		qla24xx_disable_msix(ha);
+		ha->mqenable = 0;
+		goto msix_out;
+	}
+
 	/* Enable MSI-X vector for response queue update for queue 0 */
 	if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		if (ha->msixbase && ha->mqiobase &&
-- 
1.7.7

