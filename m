From: michaelc@cs.wisc.edu
Subject: [PATCH 5/6] qla4xxx: Fix srb lookup in qla4xxx_eh_device_reset
Date: Mon, 13 Jul 2009 22:24:07 -0500
Message-ID: <1247541848-30412-5-git-send-email-michaelc@cs.wisc.edu>
References: <1247541848-30412-1-git-send-email-michaelc@cs.wisc.edu>
 <1247541848-30412-2-git-send-email-michaelc@cs.wisc.edu>
 <1247541848-30412-3-git-send-email-michaelc@cs.wisc.edu>
 <1247541848-30412-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38067 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbZGNDYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jul 2009 23:24:14 -0400
In-Reply-To: <1247541848-30412-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Higgins <karen.higgins@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Higgins <karen.higgins@qlogic.com>

eh_device_reset may be called from scsi error handler or sg_reset, etc.
When called from sg_reset, there will not be an associated srb.  The
driver should lookup the corresponding device handle given information
from the supplied cmd structure and should not assume that there exists
an srb.

Patch was made over scsi-rc-fixes.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e1cc0d2..40e3caf 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1543,11 +1543,9 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
-	struct srb *sp;
 	int ret = FAILED, stat;
 
-	sp = (struct srb *) cmd->SCp.ptr;
-	if (!sp || !ddb_entry)
+	if (!ddb_entry)
 		return ret;
 
 	dev_info(&ha->pdev->dev,
-- 
1.6.2.2

