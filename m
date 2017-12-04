From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 12/22] qla2xxx: Clear send ELS LOGO flag after target re-login
Date: Mon, 4 Dec 2017 14:45:07 -0800
Message-ID: <20171204224517.3409-13-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0054.outbound.protection.outlook.com ([104.47.36.54]:18813
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752426AbdLDWpo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:45:44 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

This patch fixes clearing out els_send_logo flag at the
time of session deletion.

Fixes: 3515832cc614 ("scsi: qla2xxx: Reset the logo flag, after target re-login.")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 283ff316e4b2..e824cdc77139 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -983,6 +983,7 @@ static void qlt_free_session_done(struct work_struct *work)
 			logo.id = sess->d_id;
 			logo.cmd_count = 0;
 			qlt_send_first_logo(vha, &logo);
+			sess->send_els_logo = 0;
 		}
 
 		if (sess->logout_on_delete) {
-- 
2.12.0
