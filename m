From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] be2iscsi: fix null ptr when accessing task hdr
Date: Fri, 31 Dec 2010 02:22:20 -0600
Message-ID: <1293783742-8238-4-git-send-email-michaelc@cs.wisc.edu>
References: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0LaIWg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2010 03:22:36 -0500
In-Reply-To: <1293783742-8238-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If alloc_pdu fails then the task->hdr pointer may not be
set. This adds a check for this case in the cleanup callback.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index be07ca0..79cefbe 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3914,7 +3914,8 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 			io_task->psgl_handle = NULL;
 		}
 	} else {
-		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN)
+		if (task->hdr &&
+		   ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN))
 			return;
 		if (io_task->psgl_handle) {
 			spin_lock(&phba->mgmt_sgl_lock);
-- 
1.7.0.1

