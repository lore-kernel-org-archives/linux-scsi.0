From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 13/14] cxlflash: Migrate IOARRIN specific routines to function pointers
Date: Tue, 15 Nov 2016 17:16:03 -0600
Message-ID: <1479251763-23150-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46245 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161085AbcKOXQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:16:14 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFNEJTn129930
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:16:14 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26r1yxu36b-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:16:14 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 16:16:13 -0700
In-Reply-To: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

As staging for supporting hardware with a different queuing mechanism,
move the send_cmd() and context_reset() routines to function pointers
that are configured when the AFU is initialized. In addition, rename
the existing routines to better reflect the queue model they support.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  3 +++
 drivers/scsi/cxlflash/main.c   | 21 +++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index c4a7014..30c3cdb 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -161,6 +161,9 @@ struct afu {
 	 * fields after this point
 	 */
 
+	int (*send_cmd)(struct afu *, struct afu_cmd *);
+	void (*context_reset)(struct afu_cmd *);
+
 	/* AFU HW */
 	struct cxl_ioctl_start_work work;
 	struct cxlflash_afu_map __iomem *afu_map;	/* entire MMIO map */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index d5b355c..7fc8843 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -188,12 +188,10 @@ static void cmd_complete(struct afu_cmd *cmd)
 }
 
 /**
- * context_reset() - timeout handler for AFU commands
+ * context_reset_ioarrin() - reset command owner context via IOARRIN register
  * @cmd:	AFU command that timed out.
- *
- * Sends a reset to the AFU.
  */
-static void context_reset(struct afu_cmd *cmd)
+static void context_reset_ioarrin(struct afu_cmd *cmd)
 {
 	int nretry = 0;
 	u64 rrin = 0x1;
@@ -217,14 +215,14 @@ static void context_reset(struct afu_cmd *cmd)
 }
 
 /**
- * send_cmd() - sends an AFU command
+ * send_cmd_ioarrin() - sends an AFU command via IOARRIN register
  * @afu:	AFU associated with the host.
  * @cmd:	AFU command to send.
  *
  * Return:
  *	0 on success, SCSI_MLQUEUE_HOST_BUSY on failure
  */
-static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
+static int send_cmd_ioarrin(struct afu *afu, struct afu_cmd *cmd)
 {
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
@@ -298,7 +296,7 @@ static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
 
 	timeout = wait_for_completion_timeout(&cmd->cevent, timeout);
 	if (!timeout) {
-		context_reset(cmd);
+		afu->context_reset(cmd);
 		rc = -1;
 	}
 
@@ -355,7 +353,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 			      SISL_REQ_FLAGS_TMF_CMD);
 	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
 
-	rc = send_cmd(afu, cmd);
+	rc = afu->send_cmd(afu, cmd);
 	if (unlikely(rc)) {
 		spin_lock_irqsave(&cfg->tmf_slock, lock_flags);
 		cfg->tmf_active = false;
@@ -486,7 +484,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	cmd->rcb.req_flags = req_flags;
 	memcpy(cmd->rcb.cdb, scp->cmnd, sizeof(cmd->rcb.cdb));
 
-	rc = send_cmd(afu, cmd);
+	rc = afu->send_cmd(afu, cmd);
 	if (unlikely(rc))
 		scsi_dma_unmap(scp);
 out:
@@ -1656,6 +1654,9 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		goto err2;
 	}
 
+	afu->send_cmd = send_cmd_ioarrin;
+	afu->context_reset = context_reset_ioarrin;
+
 	pr_debug("%s: afu version %s, interface version 0x%llX\n", __func__,
 		 afu->version, afu->interface_version);
 
@@ -1747,7 +1748,7 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	*((__be16 *)&cmd->rcb.cdb[2]) = cpu_to_be16(ctx_hndl_u);
 	*((__be32 *)&cmd->rcb.cdb[4]) = cpu_to_be32(res_hndl_u);
 
-	rc = send_cmd(afu, cmd);
+	rc = afu->send_cmd(afu, cmd);
 	if (unlikely(rc))
 		goto out;
 
-- 
2.1.0

