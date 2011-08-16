From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 07/12] qla2xxx: During loopdown perform Diagnostic loopback.
Date: Tue, 16 Aug 2011 11:31:50 -0700
Message-ID: <1313519515-23122-8-git-send-email-chad.dupuis@qlogic.com>
References: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11183 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1HPSoi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:44:38 -0400
In-Reply-To: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 07d1767..e5954a4 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -704,6 +704,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 	elreq.options = bsg_job->request->rqst_data.h_vendor.vendor_cmd[1];
 
 	if ((ha->current_topology == ISP_CFG_F ||
+	    (atomic_read(&vha->loop_state) == LOOP_DOWN) ||
 	    (IS_QLA81XX(ha) &&
 	    le32_to_cpu(*(uint32_t *)req_data) == ELS_OPCODE_BYTE
 	    && req_data_len == MAX_ELS_FRAME_PAYLOAD)) &&
-- 
1.6.0.2


