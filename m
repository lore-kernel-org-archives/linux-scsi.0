From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 3/3] cxlflash: Derive pid through accessors
Date: Wed, 25 Oct 2017 16:36:29 -0500
Message-ID: <1508967389-54524-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1508967302-54403-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751753AbdJYVgk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 17:36:40 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9PLZPXH064187
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:36:40 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2du2jhr7qt-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2017 17:36:39 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 25 Oct 2017 15:36:39 -0600
In-Reply-To: <1508967302-54403-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The cxlflash driver tracks process IDs alongside contexts to validate
context ownership. Currently, the process IDs are derived by directly
accessing values from the 'current' task pointer. While this method
of access is fine for the current process, it is incorrect when the
parent process ID is needed as the access requires serialization.

To address the incorrect issue and provide a consistent means of
deriving the process ID within the cxlflash driver, use the task
accessors defined linux/sched.h.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index ed46e8d..170fff5 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -165,7 +165,7 @@ struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 rctxid,
 	struct llun_info *lli = arg;
 	u64 ctxid = DECODE_CTXID(rctxid);
 	int rc;
-	pid_t pid = current->tgid, ctxpid = 0;
+	pid_t pid = task_tgid_nr(current), ctxpid = 0;
 
 	if (ctx_ctrl & CTX_CTRL_FILE) {
 		lli = NULL;
@@ -173,7 +173,7 @@ struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 rctxid,
 	}
 
 	if (ctx_ctrl & CTX_CTRL_CLONE)
-		pid = current->parent->tgid;
+		pid = task_ppid_nr(current);
 
 	if (likely(ctxid < MAX_CONTEXT)) {
 		while (true) {
@@ -824,7 +824,7 @@ static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
 	ctxi->rht_perms = perms;
 	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
 	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
-	ctxi->pid = current->tgid; /* tgid = pid */
+	ctxi->pid = task_tgid_nr(current); /* tgid = pid */
 	ctxi->ctx = ctx;
 	ctxi->cfg = cfg;
 	ctxi->file = file;
-- 
2.1.0
