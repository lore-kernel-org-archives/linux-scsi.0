From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/5] scsi_transport_iscsi: Remove set-but-not-used variables
Date: Wed, 30 Mar 2016 11:27:27 -0700
Message-ID: <56FC1A8F.1030504@sandisk.com>
References: <56FC1A3B.4040704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0093.outbound.protection.outlook.com ([157.56.111.93]:55648
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751367AbcC3S1b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 14:27:31 -0400
In-Reply-To: <56FC1A3B.4040704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that building with W=1 causes gcc to report warnings about
set-but-not-used variables.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4414816..446781d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2067,13 +2067,10 @@ EXPORT_SYMBOL_GPL(iscsi_alloc_session);
 
 int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
-	struct Scsi_Host *shost = iscsi_session_to_shost(session);
-	struct iscsi_cls_host *ihost;
 	unsigned long flags;
 	int id = 0;
 	int err;
 
-	ihost = shost->shost_data;
 	session->sid = atomic_add_return(1, &iscsi_session_nr);
 
 	if (target_id == ISCSI_MAX_TARGET) {
-- 
2.7.3

