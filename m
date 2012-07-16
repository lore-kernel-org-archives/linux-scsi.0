From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/7] qla2xxx: Get rid of redundant qla_tgt_sess.tearing_down
Date: Mon, 16 Jul 2012 11:04:36 -0700
Message-ID: <1342461882-5848-2-git-send-email-roland@kernel.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:33102 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753829Ab2GPSEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 14:04:51 -0400
Received: by yhjj56 with SMTP id j56so1962357yhj.6
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2012 11:04:49 -0700 (PDT)
In-Reply-To: <1342461882-5848-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>

From: Roland Dreier <roland@purestorage.com>

The only place that sets qla_tgt_sess.tearing_down calls
target_splice_sess_cmd_list() immediately afterwards, without dropping
the lock it holds.  That function sets se_session.sess_tearing_down,
so we can get rid of the qla_target-specific flag, and in the one
place that looks at the qla_tgt_sess.tearing_down flag just test
se_session.sess_tearing_down instead.

Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |    2 +-
 drivers/scsi/qla2xxx/qla_target.h  |    1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 77759c7..87b5a330 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2644,7 +2644,7 @@ static void qlt_do_work(struct work_struct *work)
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
 	    atio->u.isp24.fcp_hdr.s_id);
 	if (sess) {
-		if (unlikely(sess->tearing_down)) {
+		if (unlikely(sess->se_sess->sess_tearing_down)) {
 			sess = NULL;
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			goto out_term;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 9f9ef16..07aa265 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -813,7 +813,6 @@ struct qla_tgt_sess {
 	unsigned int conf_compl_supported:1;
 	unsigned int deleted:1;
 	unsigned int local:1;
-	unsigned int tearing_down:1;
 
 	struct se_session *se_sess;
 	struct scsi_qla_host *vha;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6e64314..3cb2b97 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -466,7 +466,6 @@ static int tcm_qla2xxx_shutdown_session(struct se_session *se_sess)
 	vha = sess->vha;
 
 	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
-	sess->tearing_down = 1;
 	target_splice_sess_cmd_list(se_sess);
 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 
-- 
1.7.10.4

