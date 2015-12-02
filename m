From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH RESEND] cxlflash: a couple off by one bugs
Date: Wed,  2 Dec 2015 17:26:28 -0600
Message-ID: <1449098788-21695-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:35403 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbbLBX05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2015 18:26:57 -0500
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 2 Dec 2015 16:26:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The "> MAX_CONTEXT" should be ">= MAX_CONTEXT".  Otherwise we go one
step beyond the end of the cfg->ctx_tbl[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
This patch was originally sent by Dan Carpenter in September 2015. I had
based my large patch series that went into 4.4 off of it but this patch
appears to have not made it in. As a valid fix, I'd like to see this make
it into 'next'. I've gone ahead and performed the rebase so that it
applies cleanly.

 drivers/scsi/cxlflash/superpipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index cac2e6a..34b21a0 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1380,7 +1380,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	}
 
 	ctxid = cxl_process_element(ctx);
-	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
+	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
 		rc = -EPERM;
 		goto err2;
@@ -1508,7 +1508,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	}
 
 	ctxid = cxl_process_element(ctx);
-	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
+	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
 		rc = -EPERM;
 		goto err1;
-- 
2.1.0

