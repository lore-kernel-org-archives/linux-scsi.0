From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi: Log msg when getting Unit Attention
Date: Sun, 25 Apr 2010 07:03:57 -0500
Message-ID: <1272197037-3155-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0DYMDm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2010 08:03:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the user accidentally changes LUN mappings or it occurs
due to a bug, then it can cause data corruption that can take
months and months to track down. This patch adds a log
message when getting REPORT_LUNS_DATA_CHANGED and it adds
a generic message for other Unit Attentions with asc == 0x3f.

We are working on adding support for handling of these errors,
but I think until then we should at least log a message so
tracking down problems as a result of one of these changes
is a little easier.

Patch was made over scsi-rc-fixes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_error.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d45c69c..6f8000a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -302,6 +302,19 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
+	
+		if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
+			scmd_printk(KERN_WARNING, scmd,
+				    "Warning! Received an indication that the "
+				    "LUN assignments on this target have "
+				    "changed. The Linux SCSI layer does not "
+				    "automatically remap LUN assignments.\n");
+		else if (sshdr.asc == 0x3f)
+			scmd_printk(KERN_WARNING, scmd,
+				    "Warning! Received an indication that the "
+				    "operating parameters on this target have "
+				    "changed. The Linux SCSI layer does not "
+				    "automatically adjust these parameters.\n");
 		return SUCCESS;
 
 		/* these three are not supported */
-- 
1.6.6.1

