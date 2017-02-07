From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] scsi: qedi: Fix possible memory leak in qedi_iscsi_update_conn()
Date: Tue,  7 Feb 2017 14:52:58 +0000
Message-ID: <20170207145258.31429-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35536 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754191AbdBGOxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 09:53:14 -0500
Received: by mail-pf0-f196.google.com with SMTP id f144so9472026pfa.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2017 06:53:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Manish Rangankar <manish.rangankar@cavium.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

'conn_info' is malloced in qedi_iscsi_update_conn() and should be
freed before leaving from the error handling cases, otherwise it
will cause memory leak.

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI
driver framework.")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index d6a2054..eb64469 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -453,13 +453,9 @@ static int qedi_iscsi_update_conn(struct qedi_ctx *qedi,
 	if (rval) {
 		rval = -ENXIO;
 		QEDI_ERR(&qedi->dbg_ctx, "Could not update connection\n");
-		goto update_conn_err;
 	}
 
 	kfree(conn_info);
-	rval = 0;
-
-update_conn_err:
 	return rval;
 }
