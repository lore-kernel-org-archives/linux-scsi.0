From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 19/42] qla2xxx: Perform ROM mbx cmd access only after ISP soft-reset during f/w recovery.
Date: Wed, 22 Aug 2012 14:21:13 -0400
Message-ID: <1345659696-3670-20-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:9483 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964954Ab2HVSiS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:18 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

Signed-off-by: Santosh Vernekar <santosh.vernekar@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5fcc0b6..cf8944f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4300,17 +4300,17 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	struct req_que *req = ha->req_q_map[0];
 	unsigned long flags;
 
-	if (IS_QLA8031(ha)) {
-		ql_dbg(ql_dbg_p3p, vha, 0xb05c,
-		    "Clearing fcoe driver presence.\n");
-		if (qla83xx_clear_drv_presence(vha) != QLA_SUCCESS)
-			ql_dbg(ql_dbg_p3p, vha, 0xb073,
-			    "Erro while clearing DRV-Presence.\n");
-	}
-
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
 
+		if (IS_QLA8031(ha)) {
+			ql_dbg(ql_dbg_p3p, vha, 0xb05c,
+			    "Clearing fcoe driver presence.\n");
+			if (qla83xx_clear_drv_presence(vha) != QLA_SUCCESS)
+				ql_dbg(ql_dbg_p3p, vha, 0xb073,
+				    "Error while clearing DRV-Presence.\n");
+		}
+
 		if (unlikely(pci_channel_offline(ha->pdev) &&
 		    ha->flags.pci_channel_io_perm_failure)) {
 			clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
-- 
1.7.7

