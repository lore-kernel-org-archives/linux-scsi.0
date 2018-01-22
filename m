From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/2] qla2xxx: Fix logo flag for qlt_free_session_done()
Date: Mon, 22 Jan 2018 12:04:20 -0800
Message-ID: <20180122200420.19516-3-himanshu.madhani@cavium.com>
References: <20180122200420.19516-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0049.outbound.protection.outlook.com ([104.47.37.49]:58289
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751046AbeAVUGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jan 2018 15:06:33 -0500
In-Reply-To: <20180122200420.19516-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <hmadhani@redhat.com>

Commit 3515832cc61467bfb87191a30401de1700e9956a fixed the target
re-login after session relogin is complete, but missed out the
qlt_free_session_done() path.

This patch clears send_els_logo flag in qlt_free_session_done() callback.

Fixes: 3515832cc614 ("scsi: qla2xxx: Reset the logo flag, after target re-login.")
Signed-off-by: Himanshu Madhani <hmadhani@redhat.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index dd8edae4c152..14359656591e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -988,6 +988,7 @@ void qlt_free_session_done(struct work_struct *work)
 
 			logo.id = sess->d_id;
 			logo.cmd_count = 0;
+			sess->send_els_logo = 0;
 			qlt_send_first_logo(vha, &logo);
 		}
 
-- 
2.12.0
