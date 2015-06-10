From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 4/9] qla2xxx: release request queue reservation.
Date: Wed, 10 Jun 2015 11:05:20 -0400
Message-ID: <1433948725-4073-5-git-send-email-himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44359 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964798AbbFJPtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:11 -0400
In-Reply-To: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Request IOCB queue element(s) is reserved during
good path IO.  Under error condition such as unable
to allocate IOCB handle condition, the IOCB count
that was reserved is not released.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1f9a41a..75eb042 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2341,9 +2341,10 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 		res = qlt_build_ctio_crc2_pkt(&prm, vha);
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
-	if (unlikely(res != 0))
+	if (unlikely(res != 0)) {
+		vha->req->cnt += full_req_cnt;
 		goto out_unmap_unlock;
-
+	}
 
 	pkt = (struct ctio7_to_24xx *)prm.pkt;
 
@@ -2481,8 +2482,11 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	else
 		res = qlt_24xx_build_ctio_pkt(&prm, vha);
 
-	if (unlikely(res != 0))
+	if (unlikely(res != 0)) {
+		vha->req->cnt += prm.req_cnt;
 		goto out_unlock_free_unmap;
+	}
+
 	pkt = (struct ctio7_to_24xx *)prm.pkt;
 	pkt->u.status0.flags |= __constant_cpu_to_le16(CTIO7_FLAGS_DATA_OUT |
 	    CTIO7_FLAGS_STATUS_MODE_0);
-- 
1.7.7

