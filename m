From: michaelc@cs.wisc.edu
Subject: [PATCH 5/6] mptfc: use SCSI_MLQUEUE_TARGET_BUSY when catching the rport transition race
Date: Sun, 17 Aug 2008 15:24:42 -0500
Message-ID: <1219004683-6468-6-git-send-email-michaelc@cs.wisc.edu>
References: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-4-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47580 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYHQUZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:25:23 -0400
In-Reply-To: <1219004683-6468-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Eric Moore <Eric.Moore@lsi.com>, Michael Reed <mdr@sgi.com>

From: Mike Christie <michaelc@cs.wisc.edu>

We do want to call right back into the queuecommand during the race,
so we can just use SCSI_MLQUEUE_TARGET_BUSY.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Michael Reed <mdr@sgi.com>

---
 drivers/message/fusion/mptfc.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index c3c24fd..e9ab90f 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -665,11 +665,8 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 
 	/* dd_data is null until finished adding target */
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
-	if (unlikely(!ri)) {
-		SCpnt->result = DID_IMM_RETRY << 16;
-		done(SCpnt);
-		return 0;
-	}
+	if (unlikely(!ri))
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	return mptscsih_qcmd(SCpnt,done);
 }
-- 
1.5.4.1

