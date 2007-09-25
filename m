From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] pluto: Don't abuse ->done for internal commands
Date: Tue, 25 Sep 2007 12:42:02 -0400
Message-ID: <11907385243827-git-send-email-willy@linux.intel.com>
References: <1190738524460-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:44289 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXIYQmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 12:42:07 -0400
In-Reply-To: <1190738524460-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

We can simply call the internal done function directly

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/pluto.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pluto.c b/drivers/scsi/pluto.c
index e221389..0363c1c 100644
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -160,7 +160,6 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 	
 		SCpnt->request->cmd_flags &= ~REQ_STARTED;
 		
-		SCpnt->done = pluto_detect_done;
 		SCpnt->request_bufflen = 256;
 		SCpnt->request_buffer = fcs[i].inquiry;
 		PLD(("set up %d %08lx\n", i, (long)SCpnt))
@@ -195,7 +194,7 @@ int __init pluto_detect(struct scsi_host_template *tpnt)
 		SCpnt = &(fcs[i].cmd);
 		
 		/* Let FC mid-level free allocated resources */
-		SCpnt->done (SCpnt);
+		pluto_detect_scsi_done(SCpnt);
 		
 		if (!SCpnt->result) {
 			struct pluto_inquiry *inq;
-- 
1.5.3.1

