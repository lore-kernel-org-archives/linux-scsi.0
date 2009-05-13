From: michaelc@cs.wisc.edu
Subject: [PATCH 04/13] libiscsi: export iscsi_itt_to_task for bnx2i
Date: Wed, 13 May 2009 17:57:41 -0500
Message-ID: <12422554724154-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51806 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761724AbZEMW5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:53 -0400
In-Reply-To: <1242255472240-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

bnx2i needs to be able to look up mgmt task like login and nop, because
it does some processing of them on the completion path. This exports
iscsi_itt_to_task so it can look up the task.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    3 ++-
 include/scsi/libiscsi.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b4aaf2e..a6e6eef 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -828,7 +828,7 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
  *
  * The session lock must be held.
  */
-static struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
+struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
 	int i;
@@ -845,6 +845,7 @@ static struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 
 	return session->cmds[i];
 }
+EXPORT_SYMBOL_GPL(iscsi_itt_to_task);
 
 /**
  * __iscsi_complete_pdu - complete pdu
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 0289f57..88d33a4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -406,6 +406,7 @@ extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 				char *, int);
 extern int iscsi_verify_itt(struct iscsi_conn *, itt_t);
 extern struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *, itt_t);
+extern struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *, itt_t);
 extern void iscsi_requeue_task(struct iscsi_task *task);
 extern void iscsi_put_task(struct iscsi_task *task);
 extern void __iscsi_get_task(struct iscsi_task *task);
-- 
1.5.2.1

