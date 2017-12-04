From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 13/22] qla2xxx: Fix PRLI state check
Date: Mon, 4 Dec 2017 14:45:08 -0800
Message-ID: <20171204224517.3409-14-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0075.outbound.protection.outlook.com ([104.47.32.75]:8167
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752434AbdLDWpq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:45:46 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Get Port Database MBX cmd is to validate current Login state upon
PRLI completion. Current code looks at the last login state for
re-validation which was incorrect. This patch removed incorrect
state check.

Fixes: 15f30a5752287 ("qla2xxx: Use IOCB interface to submit non-critical MBX.")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index cb717d47339f..e2b5fa47bb57 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6160,8 +6160,7 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
 	}
 
 	/* Check for logged in state. */
-	if (current_login_state != PDS_PRLI_COMPLETE &&
-	    last_login_state != PDS_PRLI_COMPLETE) {
+	if (current_login_state != PDS_PRLI_COMPLETE) {
 		ql_dbg(ql_dbg_mbx, vha, 0x119a,
 		    "Unable to verify login-state (%x/%x) for loop_id %x.\n",
 		    current_login_state, last_login_state, fcport->loop_id);
-- 
2.12.0
