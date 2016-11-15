From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 08/14] cxlflash: Remove private command pool
Date: Tue, 15 Nov 2016 17:15:12 -0600
Message-ID: <1479251712-22965-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45051 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1161074AbcKOXP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:15:26 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFNE9Y6129720
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:15:20 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26r1yxu29s-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:15:20 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 16:15:19 -0700
In-Reply-To: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Clean up and remove the remaining private command pool infrastructure
that is no longer required.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  7 -----
 drivers/scsi/cxlflash/main.c   | 68 ------------------------------------------
 2 files changed, 75 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 40507a9..465330f 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -136,8 +136,6 @@ struct afu_cmd {
 	spinlock_t slock;
 	struct completion cevent;
 	struct afu *parent;
-	int slot;
-	atomic_t free;
 
 	u8 cmd_tmf:1;
 
@@ -164,10 +162,6 @@ struct afu {
 	/* Stuff requiring alignment go first. */
 
 	u64 rrq_entry[NUM_RRQ_ENTRY];	/* 2K RRQ */
-	/*
-	 * Command & data for AFU commands.
-	 */
-	struct afu_cmd cmd[CXLFLASH_NUM_CMDS];
 
 	/* Beware of alignment till here. Preferably introduce new
 	 * fields after this point
@@ -189,7 +183,6 @@ struct afu {
 	bool read_room;
 	atomic64_t room;
 	u64 hb;
-	u32 cmd_couts;		/* Number of command checkouts */
 	u32 internal_lun;	/* User-desired LUN mode for this AFU */
 
 	char version[16];
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 7fa27db..a17bff2 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -35,33 +35,6 @@ MODULE_AUTHOR("Matthew R. Ochs <mrochs@linux.vnet.ibm.com>");
 MODULE_LICENSE("GPL");
 
 /**
- * cmd_checkin() - checks in an AFU command
- * @cmd:	AFU command to checkin.
- *
- * Safe to pass commands that have already been checked in. Several
- * internal tracking fields are reset as part of the checkin. Note
- * that these are intentionally reset prior to toggling the free bit
- * to avoid clobbering values in the event that the command is checked
- * out right away.
- */
-static void cmd_checkin(struct afu_cmd *cmd)
-{
-	cmd->rcb.scp = NULL;
-	cmd->rcb.timeout = 0;
-	cmd->sa.ioasc = 0;
-	cmd->cmd_tmf = false;
-	cmd->sa.host_use[0] = 0; /* clears both completion and retry bytes */
-
-	if (unlikely(atomic_inc_return(&cmd->free) != 1)) {
-		pr_err("%s: Freeing cmd (%d) that is not in use!\n",
-		       __func__, cmd->slot);
-		return;
-	}
-
-	pr_devel("%s: released cmd %p index=%d\n", __func__, cmd, cmd->slot);
-}
-
-/**
  * process_cmd_err() - command error handler
  * @cmd:	AFU command that experienced the error.
  * @scp:	SCSI command associated with the AFU command in error.
@@ -585,28 +558,12 @@ static void free_mem(struct cxlflash_cfg *cfg)
  *
  * Cleans up all state associated with the command queue, and unmaps
  * the MMIO space.
- *
- *  - complete() will take care of commands we initiated (they'll be checked
- *  in as part of the cleanup that occurs after the completion)
- *
- *  - cmd_checkin() will take care of entries that we did not initiate and that
- *  have not (and will not) complete because they are sitting on a [now stale]
- *  hardware queue
  */
 static void stop_afu(struct cxlflash_cfg *cfg)
 {
-	int i;
 	struct afu *afu = cfg->afu;
-	struct afu_cmd *cmd;
 
 	if (likely(afu)) {
-		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
-			cmd = &afu->cmd[i];
-			complete(&cmd->cevent);
-			if (!atomic_read(&cmd->free))
-				cmd_checkin(cmd);
-		}
-
 		if (likely(afu->afu_map)) {
 			cxl_psa_unmap((void __iomem *)afu->afu_map);
 			afu->afu_map = NULL;
@@ -819,7 +776,6 @@ static void cxlflash_remove(struct pci_dev *pdev)
 static int alloc_mem(struct cxlflash_cfg *cfg)
 {
 	int rc = 0;
-	int i;
 	struct device *dev = &cfg->dev->dev;
 
 	/* AFU is ~12k, i.e. only one 64k page or up to four 4k pages */
@@ -833,12 +789,6 @@ static int alloc_mem(struct cxlflash_cfg *cfg)
 	}
 	cfg->afu->parent = cfg;
 	cfg->afu->afu_map = NULL;
-
-	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
-		atomic_set(&cfg->afu->cmd[i].free, 1);
-		cfg->afu->cmd[i].slot = i;
-	}
-
 out:
 	return rc;
 }
@@ -1468,13 +1418,6 @@ static void init_pcr(struct cxlflash_cfg *cfg)
 
 	/* Program the Endian Control for the master context */
 	writeq_be(SISL_ENDIAN_CTRL, &afu->host_map->endian_ctrl);
-
-	/* Initialize cmd fields that never change */
-	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
-		afu->cmd[i].rcb.ctx_id = afu->ctx_hndl;
-		afu->cmd[i].rcb.msi = SISL_MSI_RRQ_UPDATED;
-		afu->cmd[i].rcb.rrq = 0x0;
-	}
 }
 
 /**
@@ -1563,19 +1506,8 @@ static int init_global(struct cxlflash_cfg *cfg)
 static int start_afu(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
-	struct afu_cmd *cmd;
-
-	int i = 0;
 	int rc = 0;
 
-	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
-		cmd = &afu->cmd[i];
-
-		init_completion(&cmd->cevent);
-		spin_lock_init(&cmd->slock);
-		cmd->parent = afu;
-	}
-
 	init_pcr(cfg);
 
 	/* After an AFU reset, RRQ entries are stale, clear them */
-- 
2.1.0

