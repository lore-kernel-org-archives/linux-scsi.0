From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: qla2xxx: Add LLD target-mode infrastructure for >= 24xx series
Date: Mon, 7 May 2012 16:59:24 +0300
Message-ID: <20120507135924.GA32419@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47839 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2EGN7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2012 09:59:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Hello Nicholas Bellinger,

This is a semi-automatic email about new static checker warnings.

The patch 2c0532cbbbb5: "qla2xxx: Add LLD target-mode infrastructure 
for >= 24xx series" from May 3, 2012, leads to the following Smatch 
complaint:

drivers/scsi/qla2xxx/qla_target.c:2965 qlt_abort_task()
	 error: we previously assumed 'sess' could be null (see line 2958)

drivers/scsi/qla2xxx/qla_target.c
  2957		sess = ha->tgt.tgt_ops->find_sess_by_loop_id(vha, loop_id);
  2958		if (sess == NULL) {
                    ^^^^^^^^^^^^
New check.

  2959			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf025,
  2960			    "qla_target(%d): task abort for unexisting "
  2961			    "session\n", vha->vp_idx);
  2962			res = qlt_sched_sess_work(ha->tgt.qla_tgt,
  2963			    QLA_TGT_SESS_WORK_ABORT, iocb, sizeof(*iocb));
  2964			if (res != 0)
  2965				sess->tgt->tm_to_unknown = 1;
                                ^^^^^^^^^
New dereference.

  2966	
  2967			return res;

regards,
dan carpenter

