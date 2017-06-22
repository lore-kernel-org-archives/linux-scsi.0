From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 06/17] cxlflash: Track pending scsi commands in each hardware queue
Date: Wed, 21 Jun 2017 21:14:43 -0500
Message-ID: <1498097683-8898-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751140AbdFVCPB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:15:01 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2Ehgi131388
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:15:00 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b7ts7kbdw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:15:00 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 20:14:59 -0600
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Currently, there is no book keeping of the pending scsi commands in the
cxlflash driver. This lack of tracking in-flight requests is too
restrictive and requires a heavy-hammer reset each time an adapter error is
encountered. Additionally, it does not allow for commands to be properly
retried.

In order to avoid this problem and to better handle error path command
cleanup, introduce a linked list for each hardware queue that tracks
pending commands.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h | 2 ++
 drivers/scsi/cxlflash/main.c   | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index e9b6108..3eaa3be 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -158,6 +158,7 @@ struct afu_cmd {
 	u32 hwq_index;
 
 	u8 cmd_tmf:1;
+	struct list_head list;	/* Pending commands link */
 
 	/* As per the SISLITE spec the IOARCB EA has to be 16-byte aligned.
 	 * However for performance reasons the IOARCB/IOASA should be
@@ -193,6 +194,7 @@ struct hwq {
 	struct sisl_ctrl_map __iomem *ctrl_map;		/* MC control map */
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
 	u32 index;		/* Index of this hwq */
+	struct list_head pending_cmds;	/* Commands pending completion */
 
 	atomic_t hsq_credits;
 	spinlock_t hsq_slock;	/* Hardware send queue lock */
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 20c2c5e..1446fab 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -162,8 +162,13 @@ static void cmd_complete(struct afu_cmd *cmd)
 	struct afu *afu = cmd->parent;
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
+	struct hwq *hwq = get_hwq(afu, cmd->hwq_index);
 	bool cmd_is_tmf;
 
+	spin_lock_irqsave(&hwq->hsq_slock, lock_flags);
+	list_del(&cmd->list);
+	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
+
 	if (cmd->scp) {
 		scp = cmd->scp;
 		if (unlikely(cmd->sa.ioasc))
@@ -279,6 +284,7 @@ static int send_cmd_ioarrin(struct afu *afu, struct afu_cmd *cmd)
 		hwq->room = room - 1;
 	}
 
+	list_add(&cmd->list, &hwq->pending_cmds);
 	writeq_be((u64)&cmd->rcb, &hwq->host_map->ioarrin);
 out:
 	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
@@ -319,6 +325,8 @@ static int send_cmd_sq(struct afu *afu, struct afu_cmd *cmd)
 		hwq->hsq_curr++;
 	else
 		hwq->hsq_curr = hwq->hsq_start;
+
+	list_add(&cmd->list, &hwq->pending_cmds);
 	writeq_be((u64)hwq->hsq_curr, &hwq->host_map->sq_tail);
 
 	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
@@ -1840,6 +1848,7 @@ static int init_mc(struct cxlflash_cfg *cfg, u32 index)
 
 	hwq->afu = cfg->afu;
 	hwq->index = index;
+	INIT_LIST_HEAD(&hwq->pending_cmds);
 
 	if (index == PRIMARY_HWQ)
 		ctx = cxl_get_context(cfg->dev);
-- 
2.1.0
