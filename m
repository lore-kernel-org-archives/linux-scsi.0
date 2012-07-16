From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 6/7] qla2xxx: Remove racy, now-redundant check of sess_tearing_down
Date: Mon, 16 Jul 2012 11:04:41 -0700
Message-ID: <1342461882-5848-7-git-send-email-roland@kernel.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:41745 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753989Ab2GPSE4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 14:04:56 -0400
Received: by pbbrr13 with SMTP id rr13so10116059pbb.12
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 11:04:54 -0700 (PDT)
In-Reply-To: <1342461882-5848-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>

From: Roland Dreier <roland@purestorage.com>

Now that target_submit_cmd() / target_get_sess_cmd() check
sess_tearing_down before adding commands to the list, we no longer
need the check in qlt_do_work().  In fact this check is racy anyway
(and that race is what inspired the change to add the check of
sess_tearing_down to the target core).

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 87b5a330..5b30132 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2643,19 +2643,9 @@ static void qlt_do_work(struct work_struct *work)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
 	    atio->u.isp24.fcp_hdr.s_id);
-	if (sess) {
-		if (unlikely(sess->se_sess->sess_tearing_down)) {
-			sess = NULL;
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			goto out_term;
-		} else {
-			/*
-			 * Do the extra kref_get() before dropping
-			 * qla_hw_data->hardware_lock.
-			 */
-			kref_get(&sess->se_sess->sess_kref);
-		}
-	}
+	/* Do kref_get() before dropping qla_hw_data->hardware_lock. */
+	if (sess)
+		kref_get(&sess->se_sess->sess_kref);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (unlikely(!sess)) {
-- 
1.7.10.4

