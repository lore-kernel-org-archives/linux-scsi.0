From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] BNX2I: Fixed kernel panic caused by unprotected
 task->sc->request deref
Date: Tue, 6 Dec 2011 22:41:21 -0800
Message-ID: <1323240081-5328-1-git-send-email-eddie.wai@broadcom.com>
References: <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3277 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1LGGmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Dec 2011 01:42:05 -0500
In-Reply-To: <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

During session recovery, the conn_stop call will trigger a flush
to all outstanding SCSI cmds in the xmit queue.  This will set
all outstanding task->sc to NULL prior to the session_teardown
call which frees the task memory.

In the bnx2i SCSI response processing path, only the task was being checked
for NULL under the session lock before the task->sc->request dereferencing.
If there are outstanding SCSI cmd responses pending for process, the
following kernel panic can be exposed where task->sc was found to be NULL.

 Call Trace:
[   69.720205]  [<ffffffffa040d0d0>] bnx2i_process_new_cqes+0x290/0x3c0 [bnx2i]
[   69.804289]  [<ffffffffa040d233>] bnx2i_fastpath_notification+0x33/0xa0 [bnx2
i]
[   69.891490]  [<ffffffffa040d37b>] bnx2i_indicate_kcqe+0xdb/0x330 [bnx2i]
[   69.971427]  [<ffffffffa03eac5e>] service_kcqes+0x16e/0x1d0 [cnic]
[   70.045132]  [<ffffffffa03eacea>] cnic_service_bnx2x_kcq+0x2a/0x50 [cnic]
[   70.126105]  [<ffffffffa03ead53>] cnic_service_bnx2x_bh+0x43/0x140 [cnic]
[   70.207081]  [<ffffffff81060676>] tasklet_action+0x66/0x110
[   70.273521]  [<ffffffff8106025f>] __do_softirq+0xef/0x220
[   70.337887]  [<ffffffff81447ebc>] call_softirq+0x1c/0x30

This patch adds the !task->sc check and also protects the sc dereferencing
under the session lock.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index dba72a4..1ad0b82 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1906,18 +1906,19 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
 	spin_lock(&session->lock);
 	task = iscsi_itt_to_task(bnx2i_conn->cls_conn->dd_data,
 				 cqe->itt & ISCSI_CMD_RESPONSE_INDEX);
-	if (!task) {
+	if (!task || !task->sc) {
 		spin_unlock(&session->lock);
 		return -EINVAL;
 	}
 	sc = task->sc;
-	spin_unlock(&session->lock);
 
 	if (!blk_rq_cpu_valid(sc->request))
 		cpu = smp_processor_id();
 	else
 		cpu = sc->request->cpu;
 
+	spin_unlock(&session->lock);
+
 	p = &per_cpu(bnx2i_percpu, cpu);
 	spin_lock(&p->p_work_lock);
 	if (unlikely(!p->iothread)) {
-- 
1.7.7.4


