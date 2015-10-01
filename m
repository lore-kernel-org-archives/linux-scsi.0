From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH 3/3] cxlflash: drop unlikely before IS_ERR_OR_NULL
Date: Thu,  1 Oct 2015 10:55:31 +0800
Message-ID: <7685ffa3f47126617d740292cf35bf92cda193c3.1443667610.git.geliangtang@163.com>
References: <03d18502ed7ed417f136c091f417d2d88c147ec6.1443667610.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <03d18502ed7ed417f136c091f417d2d88c147ec6.1443667610.git.geliangtang@163.com>
In-Reply-To: <081982d1188978b6020952afb4c2dcf3bc42fa1f.1443667610.git.geliangtang@163.com>
References: <03d18502ed7ed417f136c091f417d2d88c147ec6.1443667610.git.geliangtang@163.com> <081982d1188978b6020952afb4c2dcf3bc42fa1f.1443667610.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Neuling <mikey@neuling.org>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

IS_ERR_OR_NULL already contain an unlikely compiler flag. Drop it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/scsi/cxlflash/superpipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index f1b62ce..eb1b01e 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1307,7 +1307,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	}
 
 	ctx = cxl_dev_context_init(cfg->dev);
-	if (unlikely(IS_ERR_OR_NULL(ctx))) {
+	if (IS_ERR_OR_NULL(ctx)) {
 		dev_err(dev, "%s: Could not initialize context %p\n",
 			__func__, ctx);
 		rc = -ENODEV;
@@ -1432,7 +1432,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	struct afu *afu = cfg->afu;
 
 	ctx = cxl_dev_context_init(cfg->dev);
-	if (unlikely(IS_ERR_OR_NULL(ctx))) {
+	if (IS_ERR_OR_NULL(ctx)) {
 		dev_err(dev, "%s: Could not initialize context %p\n",
 			__func__, ctx);
 		rc = -ENODEV;
-- 
2.5.0
