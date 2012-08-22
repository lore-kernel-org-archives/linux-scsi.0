From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 18/42] qla2xxx: Fix rval may be used uninitialized in this function warning.
Date: Wed, 22 Aug 2012 14:21:12 -0400
Message-ID: <1345659696-3670-19-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:54850 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964987Ab2HVSiR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:17 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Fix compile warning in qla25xx_process_bidir_status_iocb as rval is not
initialized with a return value.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8f37531..6860992 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1735,7 +1735,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	uint16_t	comp_status;
 	uint16_t	scsi_status;
 	uint16_t thread_id;
-	uint32_t rval;
+	uint32_t rval = EXT_STATUS_OK;
 	struct fc_bsg_job *bsg_job = NULL;
 	sts_entry_t *sts;
 	struct sts_entry_24xx *sts24;
-- 
1.7.7

