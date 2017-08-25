From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 2/3] cxlflash: Avoid double mutex unlock
Date: Fri, 25 Aug 2017 17:18:03 -0500
Message-ID: <1503699483-61541-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52033 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933883AbdHYWSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 18:18:11 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7PMGufw046966
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:18:11 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cjsrsqsxy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2017 18:18:11 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 25 Aug 2017 18:18:10 -0400
In-Reply-To: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The AFU recovery routine uses an interruptible mutex to control the
flow of in-flight recoveries. Upon receiving an interruptible signal
the code branches to a common exit path which wrongly assumes the
mutex is held. Add a local variable to track when the mutex should be
unlocked.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index ad0f996..e9ee1d9 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1650,6 +1650,7 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 	u64 ctxid = DECODE_CTXID(recover->context_id),
 	    rctxid = recover->context_id;
 	long reg;
+	bool locked = true;
 	int lretry = 20; /* up to 2 seconds */
 	int new_adap_fd = -1;
 	int rc = 0;
@@ -1658,8 +1659,11 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 	up_read(&cfg->ioctl_rwsem);
 	rc = mutex_lock_interruptible(mutex);
 	down_read(&cfg->ioctl_rwsem);
-	if (rc)
+	if (rc) {
+		locked = false;
 		goto out;
+	}
+
 	rc = check_state(cfg);
 	if (rc) {
 		dev_err(dev, "%s: Failed state rc=%d\n", __func__, rc);
@@ -1693,8 +1697,10 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 				mutex_unlock(mutex);
 				msleep(100);
 				rc = mutex_lock_interruptible(mutex);
-				if (rc)
+				if (rc) {
+					locked = false;
 					goto out;
+				}
 				goto retry_recover;
 			}
 
@@ -1738,7 +1744,8 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 out:
 	if (likely(ctxi))
 		put_context(ctxi);
-	mutex_unlock(mutex);
+	if (locked)
+		mutex_unlock(mutex);
 	atomic_dec_if_positive(&cfg->recovery_threads);
 	return rc;
 }
-- 
2.1.0
