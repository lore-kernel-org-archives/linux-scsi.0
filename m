From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH RESEND] libiscsi: Don't retry if xmit_task return a non-transient error code
Date: Sun, 17 Aug 2014 18:23:40 +0300
Message-ID: <1408289020-31847-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:39098 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751574AbaHQPXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2014 11:23:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, jbottomley@parallels.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, ogerlitz@mellanox.com

Allow transport callback xmit_task to return a non-transient
error code -EINVAL to inform us not to retry the task. For any
other error code keep the current retry behavior.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/scsi/libiscsi.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3d1bc67..03768a9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1722,10 +1722,17 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 				goto prepd_fault;
 			}
 		}
-		if (session->tt->xmit_task(task)) {
+
+		reason = session->tt->xmit_task(task);
+		if (reason) {
 			session->cmdsn--;
-			reason = FAILURE_SESSION_NOT_READY;
-			goto prepd_reject;
+			if (reason == -EINVAL) {
+				sc->result = DID_ABORT << 16;
+				goto prepd_fault;
+			} else {
+				reason = FAILURE_SESSION_NOT_READY;
+				goto prepd_reject;
+			}
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-- 
1.7.1

