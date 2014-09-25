From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 13/35] qla2xxx: Incorrect linked list semantic in qlafx00_get_fcport().
Date: Thu, 25 Sep 2014 05:16:44 -0400
Message-ID: <1411636626-7566-14-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:45814 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbaIYJvU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:20 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 8ecf6de..620e60a 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1675,17 +1675,16 @@ qlafx00_get_fcport(struct scsi_qla_host *vha, int tgt_id)
 	fc_port_t	*fcport;
 
 	/* Check for matching device in remote port list. */
-	fcport = NULL;
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (fcport->tgt_id == tgt_id) {
 			ql_dbg(ql_dbg_async, vha, 0x5072,
 			    "Matching fcport(%p) found with TGT-ID: 0x%x "
 			    "and Remote TGT_ID: 0x%x\n",
 			    fcport, fcport->tgt_id, tgt_id);
-			break;
+			return fcport;
 		}
 	}
-	return fcport;
+	return NULL;
 }
 
 static void
-- 
1.7.7

