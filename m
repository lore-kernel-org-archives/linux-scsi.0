From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: re: qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
Date: Mon, 07 May 2012 13:51:34 -0700
Message-ID: <1336423894.14368.44.camel@haakon2.linux-iscsi.org>
References: <20120507135924.GA32419@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54220 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2EGUvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2012 16:51:52 -0400
In-Reply-To: <20120507135924.GA32419@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, Arun Easi <arun.easi@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>

On Mon, 2012-05-07 at 16:59 +0300, Dan Carpenter wrote:
> Hello Nicholas Bellinger,
> 
> This is a semi-automatic email about new static checker warnings.
> 

Hey Dan,

> The patch 2c0532cbbbb5: "qla2xxx: Add LLD target-mode infrastructure 
> for >= 24xx series" from May 3, 2012, leads to the following Smatch 
> complaint:
> 
> drivers/scsi/qla2xxx/qla_target.c:2965 qlt_abort_task()
> 	 error: we previously assumed 'sess' could be null (see line 2958)
> 
> drivers/scsi/qla2xxx/qla_target.c
>   2957		sess = ha->tgt.tgt_ops->find_sess_by_loop_id(vha, loop_id);
>   2958		if (sess == NULL) {
>                     ^^^^^^^^^^^^
> New check.
> 
>   2959			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf025,
>   2960			    "qla_target(%d): task abort for unexisting "
>   2961			    "session\n", vha->vp_idx);
>   2962			res = qlt_sched_sess_work(ha->tgt.qla_tgt,
>   2963			    QLA_TGT_SESS_WORK_ABORT, iocb, sizeof(*iocb));
>   2964			if (res != 0)
>   2965				sess->tgt->tm_to_unknown = 1;
>                                 ^^^^^^^^^
> New dereference.
> 

So it looks like ->tm_to_unknown is actually left-over cruft before the
conversion to proper workqueue usage in qla_target.c, and now it's safe
to go ahead and drop this plus other unnecessary sess_works_pending
bitfield..

I'm committing the following patch into lio-core.git, and will fold into
for-next-merge for reference.

Qlogic folks, please also fold into your linux-scsi submission, or let
me know if you would prefer an updated target series.

Thanks!

--nab

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2baef81..d1d5380 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -421,7 +421,6 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	    "Using sess for qla_tgt_reset: %p\n", sess);
 	if (!sess) {
 		res = -ESRCH;
-		ha->tgt.qla_tgt->tm_to_unknown = 1;
 		return res;
 	}
 
@@ -1066,10 +1065,7 @@ static int qlt_sched_sess_work(struct qla_tgt *tgt, int type,
 	memcpy(&prm->tm_iocb, param, param_size);
 
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
-	if (!tgt->sess_works_pending)
-		tgt->tm_to_unknown = 0;
 	list_add_tail(&prm->sess_works_list_entry, &tgt->sess_works_list);
-	tgt->sess_works_pending = 1;
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
 
 	schedule_work(&tgt->sess_work);
@@ -1343,7 +1339,6 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		rc = qlt_sched_sess_work(ha->tgt.qla_tgt,
 		    QLA_TGT_SESS_WORK_ABORT, abts, sizeof(*abts));
 		if (rc != 0) {
-			ha->tgt.qla_tgt->tm_to_unknown = 1;
 			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_REJECTED,
 			    false);
 		}
@@ -2897,8 +2892,6 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 		    "non-existant session\n", vha->vp_idx, fn);
 		res = qlt_sched_sess_work(tgt, QLA_TGT_SESS_WORK_TM, iocb,
 		    sizeof(atio_from_isp_t));
-		if (res != 0)
-			tgt->tm_to_unknown = 1;
 
 		return res;
 	}
@@ -2961,8 +2954,6 @@ static int qlt_abort_task(struct scsi_qla_host *vha, imm_ntfy_from_isp_t *iocb)
 		    "session\n", vha->vp_idx);
 		res = qlt_sched_sess_work(ha->tgt.qla_tgt,
 		    QLA_TGT_SESS_WORK_ABORT, iocb, sizeof(*iocb));
-		if (res != 0)
-			sess->tgt->tm_to_unknown = 1;
 
 		return res;
 	}
@@ -4254,7 +4245,6 @@ static void qlt_sess_work_fn(struct work_struct *work)
 {
 	struct qla_tgt *tgt = container_of(work, struct qla_tgt, sess_work);
 	struct scsi_qla_host *vha = tgt->vha;
-	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf000, "Sess work (tgt %p)", tgt);
@@ -4290,15 +4280,6 @@ static void qlt_sess_work_fn(struct work_struct *work)
 		kfree(prm);
 	}
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	spin_lock(&tgt->sess_work_lock);
-	if (list_empty(&tgt->sess_works_list)) {
-		tgt->sess_works_pending = 0;
-		tgt->tm_to_unknown = 0;
-	}
-	spin_unlock(&tgt->sess_work_lock);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
 /* Must be called under tgt_host_action_mutex */
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index f0280ae..7d5849f 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -763,8 +763,6 @@ struct qla_tgt {
 	/* Target's flags, serialized by pha->hardware_lock */
 	unsigned int tgt_enable_64bit_addr:1; /* 64-bits PCI addr enabled */
 	unsigned int link_reinit_iocb_pending:1;
-	unsigned int tm_to_unknown:1; /* TM to unknown session was sent */
-	unsigned int sess_works_pending:1; /* there are sess_work entries */
 
 	/*
 	 * Protected by tgt_mutex AND hardware_lock for writing and tgt_mutex

