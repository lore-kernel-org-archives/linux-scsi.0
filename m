From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 11/18] bnx2fc: IO errors when receiving unsolicited LOGO
Date: Thu, 4 Aug 2011 11:47:06 -0700
Message-ID: <1312483633-479-12-git-send-email-bprakash@broadcom.com>
References: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4794 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1HDSrl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 14:47:41 -0400
In-Reply-To: <1312483633-479-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

During the unsolicited LOGO processing, the session is uploaded and offloaded
after the relogin is complete. In between any new IOs are errored back as the
upload completion flag is set. Upon exhausting the retry count, the application
fails the IOs. Return target busy for all the cases when session is not ready.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index cb1791c..120618d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1789,12 +1789,6 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 	tgt = (struct bnx2fc_rport *)&rp[1];
 
 	if (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags)) {
-		if (test_bit(BNX2FC_FLAG_UPLD_REQ_COMPL, &tgt->flags))  {
-			sc_cmd->result = DID_NO_CONNECT << 16;
-			sc_cmd->scsi_done(sc_cmd);
-			return 0;
-
-		}
 		/*
 		 * Session is not offloaded yet. Let SCSI-ml retry
 		 * the command.
-- 
1.7.0.6


