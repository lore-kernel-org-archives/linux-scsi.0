From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 5/5] hpsa: do not unconditionally copy sense data
Date: Thu, 03 Jul 2014 10:18:19 -0500
Message-ID: <20140703151819.22132.96424.stgit@beardog.cce.hp.com>
References: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:2449 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbaGCPTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 11:19:11 -0400
In-Reply-To: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com, hch@lst.de

From: Robert Elliott <elliott@hp.com>

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a97a7ff..f937ea9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1708,7 +1708,14 @@ static void complete_scsi_command(struct CommandList *cp)
 
 	cmd->result |= ei->ScsiStatus;
 
-	/* copy the sense data whether we need to or not. */
+	scsi_set_resid(cmd, ei->ResidualCnt);
+	if (ei->CommandStatus == 0) {
+		cmd_free(h, cp);
+		cmd->scsi_done(cmd);
+		return;
+	}
+
+	/* copy the sense data */
 	if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
 		sense_data_size = SCSI_SENSE_BUFFERSIZE;
 	else
@@ -1717,13 +1724,6 @@ static void complete_scsi_command(struct CommandList *cp)
 		sense_data_size = ei->SenseLen;
 
 	memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
-	scsi_set_resid(cmd, ei->ResidualCnt);
-
-	if (ei->CommandStatus == 0) {
-		cmd_free(h, cp);
-		cmd->scsi_done(cmd);
-		return;
-	}
 
 	/* For I/O accelerator commands, copy over some fields to the normal
 	 * CISS header used below for error handling.

