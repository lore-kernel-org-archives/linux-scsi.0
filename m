From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 08/11] qla2xxx: Provide mbx info in BBCR data after mbx failure
Date: Tue, 26 Jan 2016 12:10:43 -0500
Message-ID: <1453828246-28686-9-git-send-email-himanshu.madhani@qlogic.com>
References: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:1037 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965300AbcAZRyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 12:54:10 -0500
In-Reply-To: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    9 +++++++--
 drivers/scsi/qla2xxx/qla_bsg.h |    4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 913fef2..392c147 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2204,8 +2204,12 @@ qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
 	if (bbcr.status == QLA_BBCR_STATUS_ENABLED) {
 		rval = qla2x00_get_adapter_id(vha, &loop_id, &al_pa,
 			&area, &domain, &topo, &sw_cap);
-		if (rval != QLA_SUCCESS)
-			return -EIO;
+		if (rval != QLA_SUCCESS) {
+			bbcr.status = QLA_BBCR_STATUS_UNKNOWN;
+			bbcr.state = QLA_BBCR_STATE_OFFLINE;
+			bbcr.mbx1 = loop_id;
+			goto done;
+		}
 
 		state = (vha->bbcr >> 12) & 0x1;
 
@@ -2220,6 +2224,7 @@ qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
 		bbcr.configured_bbscn = vha->bbcr & 0xf;
 	}
 
+done:
 	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
 		bsg_job->reply_payload.sg_cnt, &bbcr, sizeof(bbcr));
 	bsg_job->reply->reply_payload_rcv_len = sizeof(bbcr);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index c40dd8b..c80192d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -245,6 +245,7 @@ struct qla_flash_update_caps {
 /* BB_CR Status */
 #define QLA_BBCR_STATUS_DISABLED       0
 #define QLA_BBCR_STATUS_ENABLED        1
+#define QLA_BBCR_STATUS_UNKNOWN        2
 
 /* BB_CR State */
 #define QLA_BBCR_STATE_OFFLINE         0
@@ -262,6 +263,7 @@ struct  qla_bbcr_data {
 	uint8_t   configured_bbscn;       /* 0-15 */
 	uint8_t   negotiated_bbscn;       /* 0-15 */
 	uint8_t   offline_reason_code;
-	uint8_t   reserved[11];
+	uint16_t  mbx1;			/* Port state */
+	uint8_t   reserved[9];
 } __packed;
 #endif
-- 
1.7.7

