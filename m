From: shyam.iyer.t@gmail.com
Subject: [PATCH 1/2] [SCSI] Log thin provisioning threshold event
Date: Sat, 26 Feb 2011 01:59:44 -0500
Message-ID: <1298703585-15387-2-git-send-email-shyam_iyer@dell.com>
References: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62621 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1BZHAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2011 02:00:17 -0500
Received: by mail-qy0-f181.google.com with SMTP id 14so2072783qyg.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2011 23:00:17 -0800 (PST)
In-Reply-To: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Shyam Iyer <shyam_iyer@dell.com>

From: Shyam Iyer <shyam_iyer@dell.com>

At least log the message that we received a THIN PROVISIONING SOFT THRESHOLD REACHED
Unit Attention

Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
---
 drivers/scsi/scsi_error.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 991de3c..98a1da0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -320,6 +320,12 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 				    "changed. The Linux SCSI layer does not "
 				    "automatically adjust these parameters.\n");
 
+		if (sshdr.asc == 0x38 && sshdr.ascq == 0x07)
+			scmd_printk(KERN_WARNING, scmd,
+				    "Warning! Received an indication that the "
+				    "LUN reached a thin provisioning soft "
+				    "threshold.\n");
+
 		/*
 		 * Pass the UA upwards for a determination in the completion
 		 * functions.
-- 
1.7.2.3

