From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 20/22] Revert "qla2xxx: During loopdown perform Diagnostic loopback."
Date: Tue, 15 May 2012 14:34:27 -0400
Message-ID: <1337106869-14191-21-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:54616 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966441Ab2EOS5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:47 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

The LOOP_DOWN test is not needed.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 449ac9c..c688838 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -708,7 +708,6 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	elreq.options = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
 
 	if ((ha->current_topology == ISP_CFG_F ||
-	    (atomic_read(&vha->loop_state) == LOOP_DOWN) ||
 	    ((IS_QLA81XX(ha) || IS_QLA8031(ha)) &&
 	    le32_to_cpu(*(uint32_t *)req_data) == ELS_OPCODE_BYTE
 	    && req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
-- 
1.7.7

