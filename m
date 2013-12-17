From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] qla2xxx: Fix scsi_host leak on qlt_lport_register callback failure
Date: Tue, 17 Dec 2013 09:40:17 +0000
Message-ID: <1387273217-25384-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a possible scsi_host reference leak in qlt_lport_register(),
when a non zero return from the passed (*callback) does not call drop the
local reference via scsi_host_put() before returning.

This currently does not effect existing tcm_qla2xxx code as the passed callback
will never fail, but fix this up regardless for future code.

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 3bb0a1d..38a1257 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4291,6 +4291,7 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
 		if (rc != 0) {
 			ha->tgt.tgt_ops = NULL;
 			ha->tgt.target_lport_ptr = NULL;
+			scsi_host_put(host);
 		}
 		mutex_unlock(&qla_tgt_mutex);
 		return rc;
-- 
1.7.10.4
