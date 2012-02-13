From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] SCSI: Ensure discard failure gets treated as a target problem
Date: Mon, 13 Feb 2012 15:38:22 -0500
Message-ID: <yq1wr7qh3k1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:20854 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042Ab2BMUi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2012 15:38:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, James.Bottomley@hansenpartnership.com


The error reported up the stack for a discard failure did not clearly
indicate that the command was processed and subsequently failed by the
target device.

Return -EREMOTEIO so multipathing does not classify this condition as a
path failure.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2c95db..b932d61 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -880,6 +880,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				    cmd->cmnd[0] == WRITE_SAME)) {
 				description = "Discard failure";
 				action = ACTION_FAIL;
+				error = -EREMOTEIO;
 			} else
 				action = ACTION_FAIL;
 			break;
