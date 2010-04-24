From: michaelc@cs.wisc.edu
Subject: [PATCH] libiscsi: regression: fix header digest errors
Date: Sat, 24 Apr 2010 16:21:19 -0500
Message-ID: <1272144079-10494-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0DXVU6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Apr 2010 17:20:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This fixes a regression introduced with this commit:
d3305f3407fa3e9452079ec6cc8379067456e4aa
in 2.6.32.

When I moved the hdr->cmdsn after init_task, I added
a bug when header digests are used. The problem is
that the LLD may calculate the header digest in init_task,
so if we then set the cmdsn after the init_task call we
change what the digest will be calculated by the target.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6d5ae44..633e090 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -471,12 +471,12 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 
 	WARN_ON(hdrlength >= 256);
 	hdr->hlength = hdrlength & 0xFF;
+	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 
 	if (session->tt->init_task && session->tt->init_task(task))
 		return -EIO;
 
 	task->state = ISCSI_TASK_RUNNING;
-	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 
 	conn->scsicmd_pdus_cnt++;
-- 
1.6.6.1

