From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 05/14] cxlflash: Remove unused buffer from AFU command
Date: Mon, 28 Nov 2016 18:42:01 -0600
Message-ID: <1480380121-60346-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753935AbcK2AmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 19:42:12 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT0cYvL017391
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:11 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0a-001b2d01.pphosted.com with ESMTP id 270rpgfd1w-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:11 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Mon, 28 Nov 2016 17:42:10 -0700
In-Reply-To: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The cxlflash driver originally required a per-command 4K buffer that
hosted data passed to the AFU. When the routines that initiate AFU
and internal SCSI commands were refactored to use scsi_execute(), the
need for this buffer became obsolete. As it is no longer necessary,
the buffer is removed.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  1 -
 drivers/scsi/cxlflash/main.c   | 28 ++--------------------------
 2 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index ef2943d..4525514 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -134,7 +134,6 @@ struct afu_cmd {
 	struct sisl_ioasa sa;	/* IOASA must follow IOARCB */
 	spinlock_t slock;
 	struct completion cevent;
-	char *buf;		/* per command buffer */
 	struct afu *parent;
 	int slot;
 	atomic_t free;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 1292a74..9f2821d 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -41,8 +41,7 @@ MODULE_LICENSE("GPL");
  * Commands are checked out in a round-robin fashion. Note that since
  * the command pool is larger than the hardware queue, the majority of
  * times we will only loop once or twice before getting a command. The
- * buffer and CDB within the command are initialized (zeroed) prior to
- * returning.
+ * CDB within the command is initialized (zeroed) prior to returning.
  *
  * Return: The checked out command or NULL when command pool is empty.
  */
@@ -59,7 +58,6 @@ static struct afu_cmd *cmd_checkout(struct afu *afu)
 		if (!atomic_dec_if_positive(&cmd->free)) {
 			pr_devel("%s: returning found index=%d cmd=%p\n",
 				 __func__, cmd->slot, cmd);
-			memset(cmd->buf, 0, CMD_BUFSIZE);
 			memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
 			return cmd;
 		}
@@ -590,17 +588,9 @@ static void cxlflash_wait_for_pci_err_recovery(struct cxlflash_cfg *cfg)
  */
 static void free_mem(struct cxlflash_cfg *cfg)
 {
-	int i;
-	char *buf = NULL;
 	struct afu *afu = cfg->afu;
 
 	if (cfg->afu) {
-		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
-			buf = afu->cmd[i].buf;
-			if (!((u64)buf & (PAGE_SIZE - 1)))
-				free_page((ulong)buf);
-		}
-
 		free_pages((ulong)afu, get_order(sizeof(struct afu)));
 		cfg->afu = NULL;
 	}
@@ -849,7 +839,6 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 {
 	int rc = 0;
 	int i;
-	char *buf = NULL;
 	struct device *dev = &cfg->dev->dev;
 
 	/* AFU is ~12k, i.e. only one 64k page or up to four 4k pages */
@@ -864,20 +853,7 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 	cfg->afu->parent = cfg;
 	cfg->afu->afu_map = NULL;
 
-	for (i = 0; i < CXLFLASH_NUM_CMDS; buf += CMD_BUFSIZE, i++) {
-		if (!((u64)buf & (PAGE_SIZE - 1))) {
-			buf = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
-			if (unlikely(!buf)) {
-				dev_err(dev,
-					"%s: Allocate command buffers fail!\n",
-				       __func__);
-				rc = -ENOMEM;
-				free_mem(cfg);
-				goto out;
-			}
-		}
-
-		cfg->afu->cmd[i].buf = buf;
+	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
 		atomic_set(&cfg->afu->cmd[i].free, 1);
 		cfg->afu->cmd[i].slot = i;
 	}
-- 
2.1.0

