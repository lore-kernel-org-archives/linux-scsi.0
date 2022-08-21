Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BB0C00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 03:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiHUD6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Aug 2022 23:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiHUD6s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Aug 2022 23:58:48 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89F722518
        for <linux-scsi@vger.kernel.org>; Sat, 20 Aug 2022 20:58:46 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 27L3wSWJ026781;
        Sun, 21 Aug 2022 12:58:28 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Sun, 21 Aug 2022 12:58:28 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 27L3wSMw026778
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 21 Aug 2022 12:58:28 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <a0e53c70-b801-adf5-0549-b2b1e421a819@I-love.SAKURA.ne.jp>
Date:   Sun, 21 Aug 2022 12:58:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: [PATCH v5 2/4] scsi: qla2xxx: Remove unused qlt_tmr_work()
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <0c335e86-5624-b599-5137-f1377419fb0c@I-love.SAKURA.ne.jp>
In-Reply-To: <0c335e86-5624-b599-5137-f1377419fb0c@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qlt_tmr_work() is no longer used since commit fb35265b12bb9ba4 ("scsi:
qla2xxx: Remove session creation redundant code").

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
Changes in v5:
  Added Reviewed-by and Tested-by from Himanshu Madhani.

 drivers/scsi/qla2xxx/qla_target.c | 66 -------------------------------
 drivers/scsi/qla2xxx/qla_target.h |  1 -
 2 files changed, 67 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 164bd0637a08..e5614f7f4be6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6334,69 +6334,6 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-static void qlt_tmr_work(struct qla_tgt *tgt,
-	struct qla_tgt_sess_work_param *prm)
-{
-	struct atio_from_isp *a = &prm->tm_iocb2;
-	struct scsi_qla_host *vha = tgt->vha;
-	struct qla_hw_data *ha = vha->hw;
-	struct fc_port *sess;
-	unsigned long flags;
-	be_id_t s_id;
-	int rc;
-	u64 unpacked_lun;
-	int fn;
-	void *iocb;
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-
-	if (tgt->tgt_stop)
-		goto out_term2;
-
-	s_id = prm->tm_iocb2.u.isp24.fcp_hdr.s_id;
-	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
-	if (!sess) {
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-		sess = qlt_make_local_sess(vha, s_id);
-		/* sess has got an extra creation ref */
-
-		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-		if (!sess)
-			goto out_term2;
-	} else {
-		if (sess->deleted) {
-			goto out_term2;
-		}
-
-		if (!kref_get_unless_zero(&sess->sess_kref)) {
-			ql_dbg(ql_dbg_tgt_tmr, vha, 0xf020,
-			    "%s: kref_get fail %8phC\n",
-			     __func__, sess->port_name);
-			goto out_term2;
-		}
-	}
-
-	iocb = a;
-	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
-	unpacked_lun =
-	    scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
-
-	rc = qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-	ha->tgt.tgt_ops->put_sess(sess);
-
-	if (rc != 0)
-		goto out_term;
-	return;
-
-out_term2:
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-out_term:
-	qlt_send_term_exchange(ha->base_qpair, NULL, &prm->tm_iocb2, 1, 0);
-}
-
 static void qlt_sess_work_fn(struct work_struct *work)
 {
 	struct qla_tgt *tgt = container_of(work, struct qla_tgt, sess_work);
@@ -6423,9 +6360,6 @@ static void qlt_sess_work_fn(struct work_struct *work)
 		case QLA_TGT_SESS_WORK_ABORT:
 			qlt_abort_work(tgt, prm);
 			break;
-		case QLA_TGT_SESS_WORK_TM:
-			qlt_tmr_work(tgt, prm);
-			break;
 		default:
 			BUG_ON(1);
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index e899e13696e9..080c46eb8245 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -942,7 +942,6 @@ struct qla_tgt_sess_work_param {
 	struct list_head sess_works_list_entry;
 
 #define QLA_TGT_SESS_WORK_ABORT	1
-#define QLA_TGT_SESS_WORK_TM	2
 	int type;
 
 	union {
-- 
2.18.4

