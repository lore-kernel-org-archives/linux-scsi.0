From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] cxlflash: return -EFAULT if copy_from_user() fails
Date: Fri, 30 Jun 2017 11:01:06 +0300
Message-ID: <20170630080106.yxyckztimezvpzrt@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20220 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751494AbdF3IBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 04:01:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The copy_from/to_user() functions return the number of bytes remaining
to be copied but we had intended to return -EFAULT here.

Fixes: bc88ac47d5cb ("scsi: cxlflash: Support AFU debug")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 7a787b6e21c4..56b6e294ab78 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3415,9 +3415,10 @@ static int cxlflash_afu_debug(struct cxlflash_cfg *cfg,
 		if (is_write) {
 			req_flags |= SISL_REQ_FLAGS_HOST_WRITE;
 
-			rc = copy_from_user(kbuf, ubuf, ulen);
-			if (unlikely(rc))
+			if (copy_from_user(kbuf, ubuf, ulen)) {
+				rc = -EFAULT;
 				goto out;
+			}
 		}
 	}
 
@@ -3445,8 +3446,10 @@ static int cxlflash_afu_debug(struct cxlflash_cfg *cfg,
 		goto out;
 	}
 
-	if (ulen && !is_write)
-		rc = copy_to_user(ubuf, kbuf, ulen);
+	if (ulen && !is_write) {
+		if (copy_to_user(ubuf, kbuf, ulen))
+			rc = -EFAULT;
+	}
 out:
 	kfree(buf);
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
