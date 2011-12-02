From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] qla4xxx: a small loop fix
Date: Thu,  1 Dec 2011 21:38:42 -0600
Message-ID: <1322797123-5299-3-git-send-email-michaelc@cs.wisc.edu>
References: <1322797123-5299-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab1LBDcM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2011 22:32:12 -0500
In-Reply-To: <1322797123-5299-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tomas Henzl <thenzl@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Tomas Henzl <thenzl@redhat.com>

When the qla4xxx_get_fwddb_entry returns QLA_ERROR
the nex_idx is not updated,
      for (idx = 0; idx < max_ddbs; idx = next_idx) {
                ret = qla4xxx_get_fwddb_entry(ha, idx, NULL, 0, NULL,
                                              &next_idx, &state, &conn_err,
                                                NULL, NULL);
                if (ret == QLA_ERROR)
                        continue;

This means there is a risk that the 'idx < max_ddbs' condition will never
met and the loop will loop forever.
Fix this by explicitly increasing the next_idx in the error condition.

Maybe a break instead of continue is more appropriate, leaving the decision
on the qlogic maintainer.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_init.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 0497873..1bdfa81 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -787,8 +787,10 @@ void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
 		ret = qla4xxx_get_fwddb_entry(ha, idx, NULL, 0, NULL,
 					      &next_idx, &state, &conn_err,
 						NULL, NULL);
-		if (ret == QLA_ERROR)
+		if (ret == QLA_ERROR) {
+			next_idx++;
 			continue;
+		}
 		if (state == DDB_DS_NO_CONNECTION_ACTIVE ||
 		    state == DDB_DS_SESSION_FAILED) {
 			DEBUG2(ql4_printk(KERN_INFO, ha,
-- 
1.7.6

