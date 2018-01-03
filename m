From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 3/6] cxlflash: Explicitly cache number of interrupts per context
Date: Wed,  3 Jan 2018 16:54:37 -0600
Message-ID: <1515020077-43685-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750928AbeACWyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 17:54:51 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id w03MsFt0133311
        for <linux-scsi@vger.kernel.org>; Wed, 3 Jan 2018 17:54:51 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2f98cd00rq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jan 2018 17:54:50 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 3 Jan 2018 15:54:48 -0700
In-Reply-To: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The number of interrupts a user requests during a context attach is
presently stored within the CXL work ioctl structure that is nested
alongside the per context metadata. Keeping this data in a structure
that is tied to a particular hardware implementation (CXL) will only
complicate matters when supporting newer accelerator transports.

Instead of relying upon the number of interrupts being cached within
a CXL-specific structure, explicitly cache the value within the context
information structure.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 14 +++++++++-----
 drivers/scsi/cxlflash/superpipe.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 18f6240..ecfa553 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -814,15 +814,18 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg)
  * @ctxid:	Previously obtained process element associated with CXL context.
  * @file:	Previously obtained file associated with CXL context.
  * @perms:	User-specified permissions.
+ * @irqs:	User-specified number of interrupts.
  */
 static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
-			 void *ctx, int ctxid, struct file *file, u32 perms)
+			 void *ctx, int ctxid, struct file *file, u32 perms,
+			 u64 irqs)
 {
 	struct afu *afu = cfg->afu;
 
 	ctxi->rht_perms = perms;
 	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
 	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
+	ctxi->irqs = irqs;
 	ctxi->pid = task_tgid_nr(current); /* tgid = pid */
 	ctxi->ctx = ctx;
 	ctxi->cfg = cfg;
@@ -1312,6 +1315,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	int rc = 0;
 	u32 perms;
 	int ctxid = -1;
+	u64 irqs = attach->num_interrupts;
 	u64 flags = 0UL;
 	u64 rctxid = 0UL;
 	struct file *file = NULL;
@@ -1320,9 +1324,9 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 
 	int fd = -1;
 
-	if (attach->num_interrupts > 4) {
+	if (irqs > 4) {
 		dev_dbg(dev, "%s: Cannot support this many interrupts %llu\n",
-			__func__, attach->num_interrupts);
+			__func__, irqs);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -1402,7 +1406,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	}
 
 	work = &ctxi->work;
-	work->num_interrupts = attach->num_interrupts;
+	work->num_interrupts = irqs;
 	work->flags = CXL_START_WORK_NUM_IRQS;
 
 	rc = cxl_start_work(ctx, work);
@@ -1430,7 +1434,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
 
 	/* Context mutex is locked upon return */
-	init_context(ctxi, cfg, ctx, ctxid, file, perms);
+	init_context(ctxi, cfg, ctx, ctxid, file, perms, irqs);
 
 	rc = afu_attach(cfg, ctxi);
 	if (unlikely(rc)) {
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 62097df..b761293 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -98,6 +98,7 @@ struct ctx_info {
 
 	struct cxl_ioctl_start_work work;
 	u64 ctxid;
+	u64 irqs; /* Number of interrupts requested for context */
 	pid_t pid;
 	bool initialized;
 	bool unavail;
-- 
2.1.0
