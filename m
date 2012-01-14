From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] libiscsi: Sparse fixes
Date: Sat, 14 Jan 2012 16:40:22 +0000
Message-ID: <4244426.qSxXFqNKnO@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:58418 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab2ANQkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 11:40:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

Reduce the number of complaints reported by sparse on libiscsi.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3faa45a..143bbe4 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1762,8 +1762,6 @@ static void iscsi_tmf_timedout(unsigned long data)
 static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
-	__releases(&conn->session->lock)
-	__acquires(&conn->session->lock)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
@@ -2386,7 +2384,7 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
  *
  * This will attempt to send a warm target reset.
  */
-static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
+int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
-- 
1.7.7


