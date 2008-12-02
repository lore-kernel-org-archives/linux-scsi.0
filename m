From: michaelc@cs.wisc.edu
Subject: [PATCH 12/13] libiscsi: handle init task failures.
Date: Tue,  2 Dec 2008 00:32:15 -0600
Message-ID: <1228199536-12595-13-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-7-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-8-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-9-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-10-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-11-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-12-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52478 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYLBGc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:28 -0500
In-Reply-To: <1228199536-12595-12-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Mgmt setup used to not fail so we did not have to check
the return value. Now with cxgb3i it can so this has us
pass up a error.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8ba55c1..7830220 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -475,8 +475,8 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 		}
 	}
 
-	if (session->tt->init_task)
-		session->tt->init_task(task);
+	if (session->tt->init_task && session->tt->init_task(task))
+		return -EIO;
 
 	if ((hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
 		session->state = ISCSI_STATE_LOGGING_OUT;
-- 
1.5.6.5

