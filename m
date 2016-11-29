From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 06/14] cxlflash: Allocate memory instead of using command pool for AFU sync
Date: Mon, 28 Nov 2016 18:42:11 -0600
Message-ID: <1480380131-60389-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44231 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753935AbcK2AmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 19:42:20 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT0cWFA131633
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:19 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 270w686ev3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:19 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Mon, 28 Nov 2016 17:42:18 -0700
In-Reply-To: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As staging for the removal of the AFU command pool, remove the reliance
upon the pool for the internal AFU sync command. Instead of obtaining an
AFU command from the pool, dynamically allocate memory with the appropriate
alignment requirements. Since the AFU sync service is only executed from
the process environment, blocking is acceptable.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 9f2821d..0f13b4d 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1823,8 +1823,8 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd = NULL;
+	char *buf = NULL;
 	int rc = 0;
-	int retry_cnt = 0;
 	static DEFINE_MUTEX(sync_active);
 
 	if (cfg->state != STATE_NORMAL) {
@@ -1833,23 +1833,23 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	}
 
 	mutex_lock(&sync_active);
-retry:
-	cmd = cmd_checkout(afu);
-	if (unlikely(!cmd)) {
-		retry_cnt++;
-		udelay(1000 * retry_cnt);
-		if (retry_cnt < MC_RETRY_CNT)
-			goto retry;
-		dev_err(dev, "%s: could not get a free command\n", __func__);
+	buf = kzalloc(sizeof(*cmd) + __alignof__(*cmd) - 1, GFP_KERNEL);
+	if (unlikely(!buf)) {
+		dev_err(dev, "%s: no memory for command\n", __func__);
 		rc = -1;
 		goto out;
 	}
 
-	pr_debug("%s: afu=%p cmd=%p %d\n", __func__, afu, cmd, ctx_hndl_u);
+	cmd = (struct afu_cmd *)PTR_ALIGN(buf, __alignof__(*cmd));
+	init_completion(&cmd->cevent);
+	spin_lock_init(&cmd->slock);
+	cmd->parent = afu;
 
-	memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
+	pr_debug("%s: afu=%p cmd=%p %d\n", __func__, afu, cmd, ctx_hndl_u);
 
 	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
+	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
 	cmd->rcb.port_sel = 0x0;	/* NA */
 	cmd->rcb.lun_id = 0x0;	/* NA */
 	cmd->rcb.data_len = 0x0;
@@ -1875,8 +1875,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 		rc = -1;
 out:
 	mutex_unlock(&sync_active);
-	if (cmd)
-		cmd_checkin(cmd);
+	kfree(buf);
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
 }
-- 
2.1.0

