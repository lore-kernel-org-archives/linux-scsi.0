From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/5] bnx2fc: call scsi_done if session goes to not ready
 from ready
Date: Mon, 25 Apr 2011 12:30:08 -0700
Message-ID: <1303759810-22570-3-git-send-email-bprakash@broadcom.com>
References: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3659 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587Ab1DYTa1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2011 15:30:27 -0400
In-Reply-To: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

If the session is not ready yet, we ask the SCSI-ml to retry. However, if the
session is just uploaded, we should not retry, but instead call scsi_done to
fail the IO.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 96013a9..f9cb535 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1663,6 +1663,12 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 	tgt = (struct bnx2fc_rport *)&rp[1];
 
 	if (!test_bit(BNX2FC_FLAG_SESSION_READY, &tgt->flags)) {
+		if (test_bit(BNX2FC_FLAG_UPLD_REQ_COMPL, &tgt->flags))  {
+			sc_cmd->result = DID_NO_CONNECT << 16;
+			sc_cmd->scsi_done(sc_cmd);
+			return 0;
+
+		}
 		/*
 		 * Session is not offloaded yet. Let SCSI-ml retry
 		 * the command.
-- 
1.7.0.6


