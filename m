From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/5] libiscsi: Unexport iscsi_eh_target_reset()
Date: Wed, 30 Mar 2016 11:26:46 -0700
Message-ID: <56FC1A66.9090407@sandisk.com>
References: <56FC1A3B.4040704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0066.outbound.protection.outlook.com ([65.55.169.66]:29424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753512AbcC3S0u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 14:26:50 -0400
In-Reply-To: <56FC1A3B.4040704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Running "git grep -nHw iscsi_eh_target_reset" shows that this
function is only called from inside the drivers/scsi/libiscsi.c
source file. Hence unexport this function.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6bffd91..120150a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2423,7 +2423,7 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
  *
  * This will attempt to send a warm target reset.
  */
-int iscsi_eh_target_reset(struct scsi_cmnd *sc)
+static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -2495,7 +2495,6 @@ done:
 	mutex_unlock(&session->eh_mutex);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(iscsi_eh_target_reset);
 
 /**
  * iscsi_eh_recover_target - reset target and possibly the session
-- 
2.7.3

