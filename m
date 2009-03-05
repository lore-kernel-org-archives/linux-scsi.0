From: michaelc@cs.wisc.edu
Subject: [PATCH 13/14] libiscsi: fix possbile null ptr session command cleanup
Date: Thu,  5 Mar 2009 14:46:07 -0600
Message-ID: <12362859782510-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
 <12362859754088-git-send-email-michaelc@cs.wisc.edu>
 <1236285975607-git-send-email-michaelc@cs.wisc.edu>
 <12362859763502-git-send-email-michaelc@cs.wisc.edu>
 <12362859771656-git-send-email-michaelc@cs.wisc.edu>
 <12362859771239-git-send-email-michaelc@cs.wisc.edu>
 <12362859782406-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52841 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbZCEUqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:24 -0500
In-Reply-To: <12362859782406-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the iscsi eh fires when the current task is a nop, then
the task->sc pointer is null. fail_all_commands could
then try to do task->sc->device and oops. We actually do
not need to access the curr task in this path, because
if it is a cmd task the fail_command call will handle
this and if it is mgmt task then the flush of the mgmt
queues will handle that.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d070179..dfaa8ad 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1603,8 +1603,11 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 {
 	struct iscsi_task *task, *tmp;
 
-	if (conn->task && (conn->task->sc->device->lun == lun || lun == -1))
-		conn->task = NULL;
+	if (conn->task) {
+		if (lun == -1 ||
+		    (conn->task->sc && conn->task->sc->device->lun == lun))
+			conn->task = NULL;
+	}
 
 	/* flush pending */
 	list_for_each_entry_safe(task, tmp, &conn->xmitqueue, running) {
-- 
1.6.0.6

