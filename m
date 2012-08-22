From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 27/42] qla2xxx: Do not restrict the number of NPIV ports for ISP83xx.
Date: Wed, 22 Aug 2012 14:21:21 -0400
Message-ID: <1345659696-3670-28-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:63378 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S964999Ab2HVSi3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:29 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6987fbe..2b9b750 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1907,7 +1907,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	ql_dbg(ql_dbg_init, vha, 0x00d1, "Issue init firmware.\n");
 
 	if (ha->flags.npiv_supported) {
-		if (ha->operating_mode == LOOP)
+		if (ha->operating_mode == LOOP && !IS_CNA_CAPABLE(ha))
 			ha->max_npiv_vports = MIN_MULTI_ID_FABRIC - 1;
 		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
 	}
-- 
1.7.7

