From: michaelc@cs.wisc.edu
Subject: [PATCH 9/9] mptfc: convert mptfc to use fc queueing helper.
Date: Sun,  2 Mar 2008 03:03:22 -0600
Message-ID: <1204448602-5435-9-git-send-email-michaelc@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-2-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-3-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-4-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-5-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-6-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-7-git-send-email-michaelc@cs.wisc.edu>
 <1204448602-5435-8-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYCBJEJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:04:09 -0500
In-Reply-To: <1204448602-5435-8-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Convert mptfc to use fc queueing helper.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/message/fusion/mptfc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 3cdd4e9..1189bbe 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -656,9 +656,10 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 		return 0;
 	}
 
-	err = fc_remote_port_chkready(rport);
-	if (unlikely(err)) {
-		SCpnt->result = err;
+	err = fc_remote_port_queue_ready(rport, SCpnt);
+	if (err)
+		return err;
+	if (SCpnt->result) {
 		done(SCpnt);
 		return 0;
 	}
-- 
1.5.4.1

