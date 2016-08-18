From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/5] block-cciss: Use memdup_user() rather than duplicating
 its implementation
Date: Thu, 18 Aug 2016 11:55:04 +0200
Message-ID: <15b21d09-67ce-8d70-0d76-f0414e7c43f9@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <686a1f95-a76c-2624-50e1-9d0e59948e64@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: esc.storagedev@microsemi.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, Don Brace <don.brace@microsemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 17 Aug 2016 22:10:29 +0200

* Reuse existing functionality from memdup_user() instead of keeping
  duplicate source code.

  This issue was detected by using the Coccinelle software.

* Return directly if this copy operation failed.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/block/cciss.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index db9d6bb..e044342 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1587,15 +1587,9 @@ static int cciss_bigpassthru(ctlr_info_t *h, void __user *argp)
 		return -EINVAL;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
-	if (!ioc) {
-		status = -ENOMEM;
-		goto cleanup1;
-	}
-	if (copy_from_user(ioc, argp, sizeof(*ioc))) {
-		status = -EFAULT;
-		goto cleanup1;
-	}
+	ioc = memdup_user(argp, sizeof(*ioc));
+	if (IS_ERR(ioc))
+		return PTR_ERR(ioc);
 	if ((ioc->buf_size < 1) &&
 	    (ioc->Request.Type.Direction != XFER_NONE)) {
 		status = -EINVAL;
-- 
2.9.3
