From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libiscsi: Sparse fixes
Date: Sat, 14 Jan 2012 17:20:09 +0000
Message-ID: <1615778.NrW5zPd29d@asus>
References: <4244426.qSxXFqNKnO@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:54420 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2ANRUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 12:20:12 -0500
In-Reply-To: <4244426.qSxXFqNKnO@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Reduce the number of complaints reported by sparse on libiscsi.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>

---
Please ignore the previous version of this patch - it was a reverse patch instead of  a regular patch.

 drivers/scsi/libiscsi.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 143bbe4..3faa45a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1762,6 +1762,8 @@ static void iscsi_tmf_timedout(unsigned long data)
 static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
+	__releases(&conn->session->lock)
+	__acquires(&conn->session->lock)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
@@ -2384,7 +2386,7 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
  *
  * This will attempt to send a warm target reset.
  */
-int iscsi_eh_target_reset(struct scsi_cmnd *sc)
+static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
-- 
1.7.7


