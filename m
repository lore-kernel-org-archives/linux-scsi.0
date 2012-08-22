From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 33/42] qla2xxx: Get fcal position map should not be called for p2p topology.
Date: Wed, 22 Aug 2012 14:21:27 -0400
Message-ID: <1345659696-3670-34-git-send-email-chad.dupuis@qlogic.com>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:59772 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S965009Ab2HVSig (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 14:38:36 -0400
In-Reply-To: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    3 ++-
 drivers/scsi/qla2xxx/qla_init.c |    5 -----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 6d3cf6e..3e081bd 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -15,7 +15,8 @@
  * | Mailbox commands             |       0x114f       | 0x111a-0x111b  |
  * |                              |                    | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
- * | Device Discovery             |       0x2087       | 0x2020-0x2022  |
+ * | Device Discovery             |       0x2087       | 0x2020-0x2022, |
+ * |                              |                    | 0x2016         |
  * | Queue Command and IO tracing |       0x3030       | 0x3006,0x3008  |
  * |                              |                    | 0x302d-0x302e  |
  * | DPC Thread                   |       0x401d       | 0x4002,0x4013  |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b46ff87..ba3a2fa 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2764,11 +2764,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	new_fcport = NULL;
 	entries = MAX_FIBRE_DEVICES_LOOP;
 
-	ql_dbg(ql_dbg_disc, vha, 0x2016,
-	    "Getting FCAL position map.\n");
-	if (ql2xextended_error_logging & ql_dbg_disc)
-		qla2x00_get_fcal_position_map(vha, NULL);
-
 	/* Get list of logged in devices. */
 	memset(ha->gid_list, 0, qla2x00_gid_list_size(ha));
 	rval = qla2x00_get_id_list(vha, ha->gid_list, ha->gid_list_dma,
-- 
1.7.7

