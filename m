From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] cxlflash: a couple off by one bugs
Date: Tue, 22 Sep 2015 15:32:07 +0300
Message-ID: <20150922123206.GC27407@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21323 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbbIVMco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2015 08:32:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The "> MAX_CONTEXT" should be ">= MAX_CONTEXT".  Otherwise we go one
step beyond the end of the cfg->ctx_tbl[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index f1b62ce..05e0ecf 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1315,7 +1315,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	}
 
 	ctxid = cxl_process_element(ctx);
-	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
+	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
 		rc = -EPERM;
 		goto err1;
@@ -1440,7 +1440,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	}
 
 	ctxid = cxl_process_element(ctx);
-	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
+	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
 		rc = -EPERM;
 		goto err1;
