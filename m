From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 10/14] cxlflash: Remove AFU command lock
Date: Mon, 28 Nov 2016 18:42:42 -0600
Message-ID: <1480380162-60533-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55600 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755308AbcK2Amv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 19:42:51 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAT0cViw104536
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:50 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 270xspstsa-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2016 19:42:50 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Mon, 28 Nov 2016 19:42:49 -0500
In-Reply-To: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The original design of the cxlflash driver required AFU commands
to convey state information across multiple threads. The IOASA
"host use" byte was used to track if a command was done, errored,
or timed out. A per-command spin lock was used to serialize access
to this byte. As this is no longer required with the introduction
of completions and various refactoring over time, the spin lock,
state tracking, and associated code can be removed. To support the
simplification, the wait_resp() routine is refactored to return a
success or failure. Additionally, as the simplification to the
AFU internal command routine, explicit assignments of AFU command
fields to zero are removed as the memory is zeroed upon allocation.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  8 +-------
 drivers/scsi/cxlflash/main.c   | 46 ++++++++++++++----------------------------
 2 files changed, 16 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 6211677..bed8e60 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -63,11 +63,6 @@ static inline void check_sizes(void)
 /* AFU defines a fixed size of 4K for command buffers (borrow 4K page define) */
 #define CMD_BUFSIZE     SIZE_4K
 
-/* flags in IOA status area for host use */
-#define B_DONE       0x01
-#define B_ERROR      0x02	/* set with B_DONE */
-#define B_TIMEOUT    0x04	/* set with B_DONE & B_ERROR */
-
 enum cxlflash_lr_state {
 	LINK_RESET_INVALID,
 	LINK_RESET_REQUIRED,
@@ -133,9 +128,8 @@ struct cxlflash_cfg {
 struct afu_cmd {
 	struct sisl_ioarcb rcb;	/* IOARCB (cache line aligned) */
 	struct sisl_ioasa sa;	/* IOASA must follow IOARCB */
-	spinlock_t slock;
-	struct completion cevent;
 	struct afu *parent;
+	struct completion cevent;
 
 	u8 cmd_tmf:1;
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 839eca4..db77030 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -161,10 +161,6 @@ static void cmd_complete(struct afu_cmd *cmd)
 	struct cxlflash_cfg *cfg = afu->parent;
 	bool cmd_is_tmf;
 
-	spin_lock_irqsave(&cmd->slock, lock_flags);
-	cmd->sa.host_use_b[0] |= B_DONE;
-	spin_unlock_irqrestore(&cmd->slock, lock_flags);
-
 	if (cmd->rcb.scp) {
 		scp = cmd->rcb.scp;
 		if (unlikely(cmd->sa.ioasc))
@@ -204,21 +200,9 @@ static void context_reset(struct afu_cmd *cmd)
 	struct afu *afu = cmd->parent;
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
-	ulong lock_flags;
 
 	pr_debug("%s: cmd=%p\n", __func__, cmd);
 
-	spin_lock_irqsave(&cmd->slock, lock_flags);
-
-	/* Already completed? */
-	if (cmd->sa.host_use_b[0] & B_DONE) {
-		spin_unlock_irqrestore(&cmd->slock, lock_flags);
-		return;
-	}
-
-	cmd->sa.host_use_b[0] |= (B_DONE | B_ERROR | B_TIMEOUT);
-	spin_unlock_irqrestore(&cmd->slock, lock_flags);
-
 	writeq_be(rrin, &afu->host_map->ioarrin);
 	do {
 		rrin = readq_be(&afu->host_map->ioarrin);
@@ -278,20 +262,30 @@ static int send_cmd(struct afu *afu, struct afu_cmd *cmd)
  * wait_resp() - polls for a response or timeout to a sent AFU command
  * @afu:	AFU associated with the host.
  * @cmd:	AFU command that was sent.
+ *
+ * Return:
+ *	0 on success, -1 on timeout/error
  */
-static void wait_resp(struct afu *afu, struct afu_cmd *cmd)
+static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
 {
+	int rc = 0;
 	ulong timeout = msecs_to_jiffies(cmd->rcb.timeout * 2 * 1000);
 
 	timeout = wait_for_completion_timeout(&cmd->cevent, timeout);
-	if (!timeout)
+	if (!timeout) {
 		context_reset(cmd);
+		rc = -1;
+	}
 
-	if (unlikely(cmd->sa.ioasc != 0))
+	if (unlikely(cmd->sa.ioasc != 0)) {
 		pr_err("%s: CMD 0x%X failed, IOASC: flags 0x%X, afu_rc 0x%X, "
 		       "scsi_rc 0x%X, fc_rc 0x%X\n", __func__, cmd->rcb.cdb[0],
 		       cmd->sa.rc.flags, cmd->sa.rc.afu_rc, cmd->sa.rc.scsi_rc,
 		       cmd->sa.rc.fc_rc);
+		rc = -1;
+	}
+
+	return rc;
 }
 
 /**
@@ -339,7 +333,6 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	/* Stash the scp in the command, for reuse during interrupt */
 	cmd->rcb.scp = scp;
 	cmd->parent = afu;
-	spin_lock_init(&cmd->slock);
 
 	/* Copy the CDB from the cmd passed in */
 	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
@@ -466,7 +459,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	/* Stash the scp in the reserved field, for reuse during interrupt */
 	cmd->rcb.scp = scp;
 	cmd->parent = afu;
-	spin_lock_init(&cmd->slock);
 
 	nseg = scsi_dma_map(scp);
 	if (unlikely(nseg < 0)) {
@@ -1733,7 +1725,6 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 
 	cmd = (struct afu_cmd *)PTR_ALIGN(buf, __alignof__(*cmd));
 	init_completion(&cmd->cevent);
-	spin_lock_init(&cmd->slock);
 	cmd->parent = afu;
 
 	pr_debug("%s: afu=%p cmd=%p %d\n", __func__, afu, cmd, ctx_hndl_u);
@@ -1741,10 +1732,6 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
 	cmd->rcb.ctx_id = afu->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
-	cmd->rcb.port_sel = 0x0;	/* NA */
-	cmd->rcb.lun_id = 0x0;	/* NA */
-	cmd->rcb.data_len = 0x0;
-	cmd->rcb.data_ea = 0x0;
 	cmd->rcb.timeout = MC_AFU_SYNC_TIMEOUT;
 
 	cmd->rcb.cdb[0] = 0xC0;	/* AFU Sync */
@@ -1758,11 +1745,8 @@ int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
 	if (unlikely(rc))
 		goto out;
 
-	wait_resp(afu, cmd);
-
-	/* Set on timeout */
-	if (unlikely((cmd->sa.ioasc != 0) ||
-		     (cmd->sa.host_use_b[0] & B_ERROR)))
+	rc = wait_resp(afu, cmd);
+	if (unlikely(rc))
 		rc = -1;
 out:
 	atomic_dec(&afu->cmds_active);
-- 
2.1.0

