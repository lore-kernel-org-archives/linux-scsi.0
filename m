From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 4/6] cxlflash: Remove embedded CXL work structures
Date: Wed,  3 Jan 2018 16:54:50 -0600
Message-ID: <1515020090-43721-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49586 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750928AbeACWzA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 17:55:00 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id w03MsFmD003091
        for <linux-scsi@vger.kernel.org>; Wed, 3 Jan 2018 17:55:00 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2f94et93dn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jan 2018 17:55:00 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 3 Jan 2018 15:54:58 -0700
In-Reply-To: <1515020002-43551-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The CXL-specific work structure used to request the number of interrupts
currently resides as a nested member of both the context information and
hardware queue structures. It is used to cache values (specifically the
number of interrupts) required by the CXL layer when starting a context.

To facilitate staging that will ultimately allow the cxlflash core to
become agnostic of the underlying accelerator transport, remove these
embedded work structures.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h    |  1 -
 drivers/scsi/cxlflash/main.c      |  4 +---
 drivers/scsi/cxlflash/superpipe.c | 15 +++++++++------
 drivers/scsi/cxlflash/superpipe.h |  1 -
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index d2a180d..48df89f 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -204,7 +204,6 @@ struct hwq {
 	 */
 	struct afu *afu;
 	void *ctx_cookie;
-	struct cxl_ioctl_start_work work;
 	struct sisl_host_map __iomem *host_map;		/* MC host map */
 	struct sisl_ctrl_map __iomem *ctrl_map;		/* MC control map */
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 3880d52..b6cadeb 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1611,9 +1611,7 @@ static int start_context(struct cxlflash_cfg *cfg, u32 index)
 	struct hwq *hwq = get_hwq(cfg->afu, index);
 	int rc = 0;
 
-	rc = cxl_start_context(hwq->ctx_cookie,
-			       hwq->work.work_element_descriptor,
-			       NULL);
+	rc = cxl_start_context(hwq->ctx_cookie, 0, NULL);
 
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
 	return rc;
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index ecfa553..51f67dc 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1309,7 +1309,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	struct afu *afu = cfg->afu;
 	struct llun_info *lli = sdev->hostdata;
 	struct glun_info *gli = lli->parent;
-	struct cxl_ioctl_start_work *work;
+	struct cxl_ioctl_start_work work = { 0 };
 	struct ctx_info *ctxi = NULL;
 	struct lun_access *lun_access = NULL;
 	int rc = 0;
@@ -1405,11 +1405,10 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 		goto err;
 	}
 
-	work = &ctxi->work;
-	work->num_interrupts = irqs;
-	work->flags = CXL_START_WORK_NUM_IRQS;
+	work.num_interrupts = irqs;
+	work.flags = CXL_START_WORK_NUM_IRQS;
 
-	rc = cxl_start_work(ctx, work);
+	rc = cxl_start_work(ctx, &work);
 	if (unlikely(rc)) {
 		dev_dbg(dev, "%s: Could not start context rc=%d\n",
 			__func__, rc);
@@ -1534,6 +1533,7 @@ static int recover_context(struct cxlflash_cfg *cfg,
 	struct file *file;
 	void *ctx;
 	struct afu *afu = cfg->afu;
+	struct cxl_ioctl_start_work work = { 0 };
 
 	ctx = cxl_dev_context_init(cfg->dev);
 	if (IS_ERR_OR_NULL(ctx)) {
@@ -1543,7 +1543,10 @@ static int recover_context(struct cxlflash_cfg *cfg,
 		goto out;
 	}
 
-	rc = cxl_start_work(ctx, &ctxi->work);
+	work.num_interrupts = ctxi->irqs;
+	work.flags = CXL_START_WORK_NUM_IRQS;
+
+	rc = cxl_start_work(ctx, &work);
 	if (unlikely(rc)) {
 		dev_dbg(dev, "%s: Could not start context rc=%d\n",
 			__func__, rc);
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index b761293..35c3cbf 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -96,7 +96,6 @@ struct ctx_info {
 	struct llun_info **rht_lun;       /* Mapping of RHT entries to LUNs */
 	u8 *rht_needs_ws;	/* User-desired write-same function per RHTE */
 
-	struct cxl_ioctl_start_work work;
 	u64 ctxid;
 	u64 irqs; /* Number of interrupts requested for context */
 	pid_t pid;
-- 
2.1.0
