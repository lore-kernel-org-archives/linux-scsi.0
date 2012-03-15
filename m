From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: qla2xxx: NULL deref in qla_tgt_abort_task()
Date: Thu, 15 Mar 2012 16:24:35 -0700
Message-ID: <1331853875.10203.140.camel@haakon2.linux-iscsi.org>
References: <20120313172140.GF31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120313172140.GF31808@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-03-13 at 20:21 +0300, Dan Carpenter wrote:
> Hello Nicholas,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 962f988d031f: "qla2xxx: Add LLD target-mode infrastructure 
> for >= 24xx series" from Mar 8, 2012, leads to the following Smatch 
> complaint:
> 
> drivers/scsi/qla2xxx/qla_target.c:2873 qla_tgt_abort_task()
> 	 error: we previously assumed 'sess' could be null (see line 2870)
> 
> drivers/scsi/qla2xxx/qla_target.c
>   2869		sess = ha->tgt_ops->find_sess_by_loop_id(vha, loop_id);
>   2870		if (sess == NULL) {
>                     ^^^^^^^^^^^^
> Test.
> 
>   2871			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe129, "qla_target(%d): task abort for unexisting "
>   2872				"session\n", vha->vp_idx);
>   2873			res = qla_tgt_sched_sess_work(sess->tgt, QLA_TGT_SESS_WORK_ABORT,
>                                                       ^^^^^^^^^
> NULL dereference.
> 
>   2874						iocb, sizeof(*iocb));
>   2875			if (res != 0)
> 

Should be using qla_hw_data->qla_tgt instead of sess->tgt..

Applying the following patch.

Thanks again DanC!

--nab

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 2af075b..7210b28 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2857,7 +2857,7 @@ static int qla_tgt_abort_task(struct scsi_qla_host *vha, imm_ntfy_from_isp_t *io
        if (sess == NULL) {
                ql_dbg(ql_dbg_tgt_mgt, vha, 0xe129, "qla_target(%d): task abort for unexisting "
                        "session\n", vha->vp_idx);
-               res = qla_tgt_sched_sess_work(sess->tgt, QLA_TGT_SESS_WORK_ABORT,
+               res = qla_tgt_sched_sess_work(ha->qla_tgt, QLA_TGT_SESS_WORK_ABORT,
                                        iocb, sizeof(*iocb));
                if (res != 0)
                        sess->tgt->tm_to_unknown = 1;
