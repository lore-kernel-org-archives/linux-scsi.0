From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 02/16] BNX2I: Added fix for NOP-Out response panic from
 unsolicited NOP-In
Date: Wed, 10 Nov 2010 15:04:43 -0800
Message-ID: <1289430297-30221-3-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2878 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757419Ab0KJXDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:10 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The patch fixes the following situations where NOP-Out pkt is called for:
- local unsolicited NOP-Out requests (requesting no NOP-In response)
- local NOP-Out responses to unsolicited NOP-In requests

kernel panic is observed due to double session spin_lock requests; one in the
bnx2i_process_nopin_local_cmpl routine in bnx2i_hwi.c and the other in the
iscsi_put_task routine in libiscsi.c

The proposed fix is to export the currently static __iscsi_put_task() routine
and have bnx2i call it directly instead of the iscsi_put_task() routine which
holds the session spin lock.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Anil Veerabhadrappa <anilgv@broadcom.com>
Acked-by: Benjamin Li <benli@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
 drivers/scsi/libiscsi.c        |    3 ++-
 include/scsi/libiscsi.h        |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 16c76e0..32cf930 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1513,7 +1513,7 @@ static void bnx2i_process_nopin_local_cmpl(struct iscsi_session *session,
 	task = iscsi_itt_to_task(conn,
 				 nop_in->itt & ISCSI_NOP_IN_MSG_INDEX);
 	if (task)
-		iscsi_put_task(task);
+		__iscsi_put_task(task);
 	spin_unlock(&session->lock);
 }
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 633e090..b63e2a4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -539,11 +539,12 @@ void __iscsi_get_task(struct iscsi_task *task)
 }
 EXPORT_SYMBOL_GPL(__iscsi_get_task);
 
-static void __iscsi_put_task(struct iscsi_task *task)
+void __iscsi_put_task(struct iscsi_task *task)
 {
 	if (atomic_dec_and_test(&task->refcount))
 		iscsi_free_task(task);
 }
+EXPORT_SYMBOL_GPL(__iscsi_put_task);
 
 void iscsi_put_task(struct iscsi_task *task)
 {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ae5196a..2ea9aec 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -420,6 +420,7 @@ extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
 extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
+extern void __iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
-- 
1.7.0.5


