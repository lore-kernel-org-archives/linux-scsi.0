From: michaelc@cs.wisc.edu
Subject: [PATCH 11/12] libiscsi: don't call into lld to cleanup task
Date: Thu, 31 Aug 2006 18:09:34 -0400
Message-ID: <11570621882323-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu> <11570621821931-git-send-email-michaelc@cs.wisc.edu> <11570621832165-git-send-email-michaelc@cs.wisc.edu> <1157062184454-git-send-email-michaelc@cs.wisc.edu> <11570621852186-git-send-email-michaelc@cs.wisc.edu> <1157062186420-git-send-email-michaelc@cs.wisc.edu> <11570621871297-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36998 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932479AbWHaXJc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:32 -0400
In-Reply-To: <11570621871297-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

In the normal IO path we should not be calling back
into the LLD since the LLD will have cleaned up the
task before or after calling complete pdu.

For the fail_command path we still need to do this
to force the cleanup.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1799dc8..2caa25b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -213,12 +213,8 @@ static void iscsi_get_ctask(struct iscsi
 
 static void __iscsi_put_ctask(struct iscsi_cmd_task *ctask)
 {
-	struct iscsi_conn *conn = ctask->conn;
-
-	if (atomic_dec_and_test(&ctask->refcount)) {
-		conn->session->tt->cleanup_cmd_task(conn, ctask);
+	if (atomic_dec_and_test(&ctask->refcount))
 		iscsi_complete_command(ctask);
-	}
 }
 
 static void iscsi_put_ctask(struct iscsi_cmd_task *ctask)
@@ -1129,10 +1125,13 @@ static void fail_command(struct iscsi_co
 	sc = ctask->sc;
 	if (!sc)
 		return;
+
+	conn->session->tt->cleanup_cmd_task(conn, ctask);
 	iscsi_ctask_mtask_cleanup(ctask);
 
 	sc->result = err;
 	sc->resid = sc->request_bufflen;
+	/* release ref from queuecommand */
 	__iscsi_put_ctask(ctask);
 }
 
-- 
1.4.1.1

