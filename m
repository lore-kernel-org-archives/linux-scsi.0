From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: qla2xxx: Cleanup NPIV host in target mode during
 config teardown
Date: Fri, 25 Aug 2017 00:15:21 +0300
Message-ID: <20170824211521.4hrwymr44vswi6ta@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18437 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbdHXVPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2017 17:15:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: quinn.tran@cavium.com
Cc: linux-scsi@vger.kernel.org

Hello Quinn Tran,

This is a semi-automatic email about new static checker warnings.

The patch 821c9f4cab5e: "scsi: qla2xxx: Cleanup NPIV host in target
mode during config teardown" from Aug 23, 2017, leads to the
following Smatch complaint:

    drivers/scsi/qla2xxx/qla_target.c:1553 qlt_release()
    error: we previously assumed 'vha->vha_tgt.qla_tgt' could be null (see line 1533)

drivers/scsi/qla2xxx/qla_target.c
  1532	
  1533		if ((vha->vha_tgt.qla_tgt != NULL) && !tgt->tgt_stop &&
  1534		    !tgt->tgt_stopped)
  1535			qlt_stop_phase1(tgt);
  1536	
  1537		if ((vha->vha_tgt.qla_tgt != NULL) && !tgt->tgt_stopped)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Existing code assumes this can be NULL.

  1538			qlt_stop_phase2(tgt);
  1539	
  1540		for (i = 0; i < vha->hw->max_qpairs + 1; i++) {
  1541			unsigned long flags;
  1542	
  1543			h = &tgt->qphints[i];
  1544			if (h->qpair) {
  1545				spin_lock_irqsave(h->qpair->qp_lock_ptr, flags);
  1546				list_del(&h->hint_elem);
  1547				spin_unlock_irqrestore(h->qpair->qp_lock_ptr, flags);
  1548				h->qpair = NULL;
  1549			}
  1550		}
  1551		kfree(tgt->qphints);
  1552		mutex_lock(&qla_tgt_mutex);
  1553		list_del(&vha->vha_tgt.qla_tgt->tgt_list_entry);\
                          ^^^^^^^^^^^^^^^^^^^^
The patch adds a new dereference.

  1554		mutex_unlock(&qla_tgt_mutex);
  1555	

regards,
dan carpenter
