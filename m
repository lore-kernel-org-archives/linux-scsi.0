From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: qla2xxx: NULL deref in qla_tgt_abort_task()
Date: Tue, 13 Mar 2012 20:21:40 +0300
Message-ID: <20120313172140.GF31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:19832 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab2CMRVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 13:21:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

Hello Nicholas,

This is a semi-automatic email about new static checker warnings.

The patch 962f988d031f: "qla2xxx: Add LLD target-mode infrastructure 
for >= 24xx series" from Mar 8, 2012, leads to the following Smatch 
complaint:

drivers/scsi/qla2xxx/qla_target.c:2873 qla_tgt_abort_task()
	 error: we previously assumed 'sess' could be null (see line 2870)

drivers/scsi/qla2xxx/qla_target.c
  2869		sess = ha->tgt_ops->find_sess_by_loop_id(vha, loop_id);
  2870		if (sess == NULL) {
                    ^^^^^^^^^^^^
Test.

  2871			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe129, "qla_target(%d): task abort for unexisting "
  2872				"session\n", vha->vp_idx);
  2873			res = qla_tgt_sched_sess_work(sess->tgt, QLA_TGT_SESS_WORK_ABORT,
                                                      ^^^^^^^^^
NULL dereference.

  2874						iocb, sizeof(*iocb));
  2875			if (res != 0)

regards,
dan carpenter

