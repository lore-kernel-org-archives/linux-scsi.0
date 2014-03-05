From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH] SCSI/libiscsi: Allow transport xmit_task to fail with non-transient error codes
Date: Wed,  5 Mar 2014 19:46:43 +0200
Message-ID: <1394041603-31261-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:59983 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756608AbaCERqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 12:46:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

Allow transport callback xmit_task to return either transient
errors such as -ENOMEM or -EAGAIN to retry the task, and
non-transient such as -EINVAL to abort it.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/scsi/libiscsi.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3c11acf..749e7bf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1707,10 +1707,17 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
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
+			if (reason == -ENOMEM || reason == -EAGAIN) {
+				reason = FAILURE_SESSION_NOT_READY;
+				goto prepd_reject;
+			} else {
+				sc->result = DID_ABORT << 16;
+				goto prepd_fault;
+			}
 		}
 	} else {
 		list_add_tail(&task->running, &conn->cmdqueue);
-- 
1.7.1

