From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 12/12] qla2xxx: Fix "active_mask" may be used uninitialized warning.
Date: Tue, 16 Aug 2011 11:31:55 -0700
Message-ID: <1313519515-23122-13-git-send-email-chad.dupuis@qlogic.com>
References: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26549 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753020Ab1HPSmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2011 14:42:43 -0400
In-Reply-To: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Since active_mask is first assigned in an "else" block, the compiler throws
a warning saying that the active_mask variable may be used uninitialized in
a print statement later.  Initialize active_mask to 0 in the declaration to
stop the warning.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 18e6874..27a0f60 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3538,7 +3538,8 @@ qla82xx_dev_failed_handler(scsi_qla_host_t *vha)
 static void
 qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 {
-	uint32_t dev_state, drv_state, drv_active, active_mask;
+	uint32_t dev_state, drv_state, drv_active;
+	uint32_t active_mask = 0;
 	unsigned long reset_timeout;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
-- 
1.6.0.2


