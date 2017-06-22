From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 02/17] cxlflash: Update cxlflash_afu_sync() to return errno
Date: Wed, 21 Jun 2017 21:13:48 -0500
Message-ID: <1498097628-8753-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45681 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751140AbdFVCN7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:13:59 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M29mRC120986
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:13:58 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7ts7kagu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:13:58 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 22:13:58 -0400
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

The cxlflash_afu_sync() routine returns a negative one to indicate any kind
of failure. This makes it impossible to establish why the error occurred.

Update the return codes to clearly indicate the failure cause to the
caller.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 64ea597ca..815d04b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2022,8 +2022,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
  * going away).
  *
  * Return:
- *	0 on success
- *	-1 on failure
+ *	0 on success, -errno on failure
  */
 int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 		      res_hndl_t res_hndl_u, u8 mode)
@@ -2047,7 +2046,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	buf = kzalloc(sizeof(*cmd) + __alignof__(*cmd) - 1, GFP_KERNEL);
 	if (unlikely(!buf)) {
 		dev_err(dev, "%s: no memory for command\n", __func__);
-		rc = -1;
+		rc = -ENOMEM;
 		goto out;
 	}
 
@@ -2071,12 +2070,14 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	*((__be32 *)&cmd->rcb.cdb[4]) = cpu_to_be32(res_hndl_u);
 
 	rc = afu->send_cmd(afu, cmd);
-	if (unlikely(rc))
+	if (unlikely(rc)) {
+		rc = -ENOBUFS;
 		goto out;
+	}
 
 	rc = wait_resp(afu, cmd);
 	if (unlikely(rc))
-		rc = -1;
+		rc = -EIO;
 out:
 	atomic_dec(&afu->cmds_active);
 	mutex_unlock(&sync_active);
-- 
2.1.0
