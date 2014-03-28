From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/3] [SCSI] Fix abort state memory problem
Date: Fri, 28 Mar 2014 10:49:35 -0700
Message-ID: <1396028975.15365.31.camel@dabdike>
References: <1396028874.15365.30.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44310 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbaC1Rtg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 13:49:36 -0400
In-Reply-To: <1396028874.15365.30.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

The abort state is being stored persistently across commands, meaning if the
command times out a second time, the error handler thinks an abort is still
pending.  Fix this by properly resetting the abort flag after the abort is
finished.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
---
 drivers/scsi/scsi_error.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 771c16b..b9f3b07 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -869,10 +869,13 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 
 static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 {
-	if (!hostt->eh_abort_handler)
-		return FAILED;
+	int retval = FAILED;
+
+	if (hostt->eh_abort_handler)
+		retval = hostt->eh_abort_handler(scmd);
 
-	return hostt->eh_abort_handler(scmd);
+	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
+	return retval;
 }
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
-- 
1.9.1



