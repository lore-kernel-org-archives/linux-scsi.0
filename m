From: michaelc@cs.wisc.edu
Subject: [PATCH 2/6] qla4xxx: return SCSI_MLQUEUE_TARGET_BUSY when driver has detected session error
Date: Sun, 17 Aug 2008 15:24:39 -0500
Message-ID: <1219004683-6468-3-git-send-email-michaelc@cs.wisc.edu>
References: <1219004683-6468-1-git-send-email-michaelc@cs.wisc.edu>
 <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47570 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYHQUZD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Aug 2008 16:25:03 -0400
In-Reply-To: <1219004683-6468-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When qla4xxx begins recovery and the iscsi class is firing up to handle
it, we need to retrn SCSI_MLQUEUE_TARGET_BUSY from the driver instead
of host busy, because the session recovery only affects the one target.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: David C Somayajulu <david.somayajulu@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 88bebb1..ddcb297 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -439,7 +439,7 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc_fail_command;
 		}
-		goto qc_host_busy;
+		return SCSI_MLQUEUE_TARGET_BUSY;
 	}
 
 	if (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
-- 
1.5.4.1

