From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH RESEND] cxlflash: drop unlikely before IS_ERR_OR_NULL
Date: Thu,  3 Dec 2015 15:18:49 -0600
Message-ID: <1449177529-58863-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geliang Tang <geliangtang@163.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Geliang Tang <geliangtang@163.com>

IS_ERR_OR_NULL already contain an unlikely compiler flag. Drop it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Manoj Kumar <manoj@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
This patch was originally sent by Geliang Tang in October 2015. As a
valid simplification, I'd like to see this make it into 'next'. I've
gone ahead and performed the rebase so that it applies cleanly.

 drivers/scsi/cxlflash/superpipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 34b21a0..f4020db 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1372,7 +1372,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	}
 
 	ctx = cxl_dev_context_init(cfg->dev);
-	if (unlikely(IS_ERR_OR_NULL(ctx))) {
+	if (IS_ERR_OR_NULL(ctx)) {
 		dev_err(dev, "%s: Could not initialize context %p\n",
 			__func__, ctx);
 		rc = -ENODEV;
@@ -1500,7 +1500,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	struct afu *afu = cfg->afu;
 
 	ctx = cxl_dev_context_init(cfg->dev);
-	if (unlikely(IS_ERR_OR_NULL(ctx))) {
+	if (IS_ERR_OR_NULL(ctx)) {
 		dev_err(dev, "%s: Could not initialize context %p\n",
 			__func__, ctx);
 		rc = -ENODEV;
-- 
2.1.0
