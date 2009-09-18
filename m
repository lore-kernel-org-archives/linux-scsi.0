From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/5] scsi: Fix protection scsi_data_buffer leak
Date: Fri, 18 Sep 2009 17:33:01 -0400
Message-ID: <1253309583-22170-4-git-send-email-martin.petersen@oracle.com>
References: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:32187 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbZIRVdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 17:33:11 -0400
In-Reply-To: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

We would leak a scsi_data_buffer if the free_list command was of the
protected variety.

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b6e0307..dd098ca 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -241,10 +241,7 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
  */
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
-	struct scsi_cmnd *cmd;
-	unsigned char *buf;
-
-	cmd = scsi_host_alloc_command(shost, gfp_mask);
+	struct scsi_cmnd *cmd = scsi_host_alloc_command(shost, gfp_mask);
 
 	if (unlikely(!cmd)) {
 		unsigned long flags;
@@ -258,9 +255,15 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 		if (cmd) {
+			void *buf, *prot;
+
 			buf = cmd->sense_buffer;
+			prot = cmd->prot_sdb;
+
 			memset(cmd, 0, sizeof(*cmd));
+
 			cmd->sense_buffer = buf;
+			cmd->prot_sdb = prot;
 		}
 	}
 
-- 
1.6.0.6

