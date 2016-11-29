From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 09/14] cxlflash: Wait for active AFU commands to timeout upon tear down
Date: Mon, 28 Nov 2016 18:42:33 -0600
Message-ID: <1480380153-60497-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44665 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755308AbcK2Aml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 19:42:41 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT0cV9f043064
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:40 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 270xutsgb3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:40 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Mon, 28 Nov 2016 17:42:39 -0700
In-Reply-To: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

With the removal of the static private command pool, the ability to
'complete' outstanding commands was lost. While not an issue for the
commands originating outside the driver, internal AFU commands are
synchronous and therefore have a timeout associated with them. To
avoid a stale memory access, the tear down sequence needs to ensure
that there are not any active commands before proceeding. As these
internal AFU commands are rare events, the simplest way to accomplish
this is detecting the activity and waiting for it to timeout.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 1 +
 drivers/scsi/cxlflash/main.c   | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 7e4ba31..6211677 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -180,6 +180,7 @@ struct afu {
 	u64 *hrrq_end;
 	u64 *hrrq_curr;
 	bool toggle;
+	atomic_t cmds_active;	/* Number of currently active AFU commands */
 	s64 room;
 	spinlock_t rrin_slock; /* Lock to rrin queuing and cmd_room updates */
 	u64 hb;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 19156ad..839eca4 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -531,7 +531,7 @@ static void free_mem(struct cxlflash_cfg *cfg)
  *
  * Safe to call with AFU in a partially allocated/initialized state.
  *
- * Cleans up all state associated with the command queue, and unmaps
+ * Waits for any active internal AFU commands to timeout and then unmaps
  * the MMIO space.
  */
 static void stop_afu(struct cxlflash_cfg *cfg)
@@ -539,6 +539,8 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 	struct afu *afu = cfg->afu;
 
 	if (likely(afu)) {
+		while (atomic_read(&afu->cmds_active))
+			ssleep(1);
 		if (likely(afu->afu_map)) {
 			cxl_psa_unmap((void __iomem *)afu->afu_map);
 			afu->afu_map = NULL;
@@ -1721,6 +1723,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	}
 
 	mutex_lock(&sync_active);
+	atomic_inc(&afu->cmds_active);
 	buf = kzalloc(sizeof(*cmd) + __alignof__(*cmd) - 1, GFP_KERNEL);
 	if (unlikely(!buf)) {
 		dev_err(dev, "%s: no memory for command\n", __func__);
@@ -1762,6 +1765,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 		     (cmd->sa.host_use_b[0] & B_ERROR)))
 		rc = -1;
 out:
+	atomic_dec(&afu->cmds_active);
 	mutex_unlock(&sync_active);
 	kfree(buf);
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
-- 
2.1.0

