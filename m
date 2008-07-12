From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] qla4xxx: fix queue depth setting
Date: Fri, 11 Jul 2008 19:50:33 -0500
Message-ID: <1215823835-4865-3-git-send-email-michaelc@cs.wisc.edu>
References: <1215823835-4865-1-git-send-email-michaelc@cs.wisc.edu>
 <1215823835-4865-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086AbYGLAvJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 20:51:09 -0400
In-Reply-To: <1215823835-4865-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, promise_linux@promise.com, david.somayajulu@qlogic.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We want to set the queue depth to something reasonable - not
the can_queue.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5822dd5..88bebb1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -46,6 +46,8 @@ MODULE_PARM_DESC(ql4xextended_error_logging,
 
 int ql4_mod_unload = 0;
 
+#define QL4_DEF_QDEPTH 32
+
 /*
  * SCSI host template entry points
  */
@@ -1387,7 +1389,7 @@ static int qla4xxx_slave_alloc(struct scsi_device *sdev)
 
 	sdev->hostdata = ddb;
 	sdev->tagged_supported = 1;
-	scsi_activate_tcq(sdev, sdev->host->can_queue);
+	scsi_activate_tcq(sdev, QL4_DEF_QDEPTH);
 	return 0;
 }
 
-- 
1.5.4.1

