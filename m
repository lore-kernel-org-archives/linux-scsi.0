From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 06/18] qla2xxx: Limit excessive DPC cycles.
Date: Fri, 18 Nov 2011 09:03:10 -0800
Message-ID: <1321635802-16491-7-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:31250 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758266Ab1KRRQl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:41 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The 'continue' cases neglected to place the thread in an
interruptible state, causing the DPC routine to wake immediately.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c9a7452..51c4655 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3445,27 +3445,21 @@ qla2x00_do_dpc(void *data)
 		schedule();
 		__set_current_state(TASK_RUNNING);
 
-		ql_dbg(ql_dbg_dpc, base_vha, 0x4001,
-		    "DPC handler waking up.\n");
-		ql_dbg(ql_dbg_dpc, base_vha, 0x4002,
-		    "dpc_flags=0x%lx.\n", base_vha->dpc_flags);
-
-		/* Initialization not yet finished. Don't do anything yet. */
-		if (!base_vha->flags.init_done)
-			continue;
+		if (!base_vha->flags.init_done || ha->flags.mbox_busy)
+			goto end_loop;
 
 		if (ha->flags.eeh_busy) {
 			ql_dbg(ql_dbg_dpc, base_vha, 0x4003,
 			    "eeh_busy=%d.\n", ha->flags.eeh_busy);
-			continue;
+			goto end_loop;
 		}
 
 		ha->dpc_active = 1;
 
-		if (ha->flags.mbox_busy) {
-			ha->dpc_active = 0;
-			continue;
-		}
+		ql_dbg(ql_dbg_dpc, base_vha, 0x4001,
+		    "DPC handler waking up.\n");
+		ql_dbg(ql_dbg_dpc, base_vha, 0x4002,
+		    "dpc_flags=0x%lx.\n", base_vha->dpc_flags);
 
 		qla2x00_do_work(base_vha);
 
@@ -3607,6 +3601,7 @@ qla2x00_do_dpc(void *data)
 		qla2x00_do_dpc_all_vps(base_vha);
 
 		ha->dpc_active = 0;
+end_loop:
 		set_current_state(TASK_INTERRUPTIBLE);
 	} /* End of while(1) */
 	__set_current_state(TASK_RUNNING);
-- 
1.6.0.2


