From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 8/9] qla2xxx: Set the task attributes after memsetting fcp cmnd.
Date: Tue, 16 Aug 2011 11:29:29 -0700
Message-ID: <1313519370-22963-9-git-send-email-chad.dupuis@qlogic.com>
References: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53245 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab1HPSje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:39:34 -0400
In-Reply-To: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

The memset of the fcp_cmnd struct needs to be moved so that it will not
zero-out valid data.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 02704fe..049807c 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2839,6 +2839,16 @@ sufficient_dsds:
 		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
+		/* build FCP_CMND IU */
+		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
+		int_to_scsilun(sp->cmd->device->lun, &ctx->fcp_cmnd->lun);
+		ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
+
+		if (cmd->sc_data_direction == DMA_TO_DEVICE)
+			ctx->fcp_cmnd->additional_cdb_len |= 1;
+		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+			ctx->fcp_cmnd->additional_cdb_len |= 2;
+
 		/*
 		 * Update tagged queuing modifier -- default is TSK_SIMPLE (0).
 		 */
@@ -2855,16 +2865,6 @@ sufficient_dsds:
 			}
 		}
 
-		/* build FCP_CMND IU */
-		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
-		int_to_scsilun(sp->cmd->device->lun, &ctx->fcp_cmnd->lun);
-		ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
-
-		if (cmd->sc_data_direction == DMA_TO_DEVICE)
-			ctx->fcp_cmnd->additional_cdb_len |= 1;
-		else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
-			ctx->fcp_cmnd->additional_cdb_len |= 2;
-
 		memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 
 		fcp_dl = (uint32_t *)(ctx->fcp_cmnd->cdb + 16 +
-- 
1.6.0.2


