From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 14/14] cxlflash: Migrate scsi command pointer to AFU command
Date: Tue, 15 Nov 2016 17:16:16 -0600
Message-ID: <1479251776-23186-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964885AbcKOXQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:16:24 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFNEAHj122579
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:16:24 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26r77vtjak-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:16:24 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 16:16:23 -0700
In-Reply-To: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Currently, when sending a SCSI command, the pointer is stored in a
reserved field of the AFU command descriptor for retrieval once the
SCSI command has completed. In order to support new descriptor formats
that make use of the reserved field, the pointer is migrated to outside
the descriptor where it can still be found during completion processing.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h  |  1 +
 drivers/scsi/cxlflash/main.c    | 10 +++++-----
 drivers/scsi/cxlflash/sislite.h |  2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 30c3cdb..7a892c5 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -129,6 +129,7 @@ struct afu_cmd {
 	struct sisl_ioarcb rcb;	/* IOARCB (cache line aligned) */
 	struct sisl_ioasa sa;	/* IOASA must follow IOARCB */
 	struct afu *parent;
+	struct scsi_cmnd *scp;
 	struct completion cevent;
 
 	u8 cmd_tmf:1;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 7fc8843..08ef68a 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -151,7 +151,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
  *
  * Prepares and submits command that has either completed or timed out to
  * the SCSI stack. Checks AFU command back into command pool for non-internal
- * (rcb.scp populated) commands.
+ * (cmd->scp populated) commands.
  */
 static void cmd_complete(struct afu_cmd *cmd)
 {
@@ -161,8 +161,8 @@ static void cmd_complete(struct afu_cmd *cmd)
 	struct cxlflash_cfg *cfg = afu->parent;
 	bool cmd_is_tmf;
 
-	if (cmd->rcb.scp) {
-		scp = cmd->rcb.scp;
+	if (cmd->scp) {
+		scp = cmd->scp;
 		if (unlikely(cmd->sa.ioasc))
 			process_cmd_err(cmd, scp);
 		else
@@ -340,7 +340,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	cfg->tmf_active = true;
 	spin_unlock_irqrestore(&cfg->tmf_slock, lock_flags);
 
-	cmd->rcb.scp = scp;
+	cmd->scp = scp;
 	cmd->parent = afu;
 	cmd->cmd_tmf = true;
 
@@ -470,7 +470,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 		cmd->rcb.data_ea = sg_dma_address(sg);
 	}
 
-	cmd->rcb.scp = scp;
+	cmd->scp = scp;
 	cmd->parent = afu;
 
 	cmd->rcb.ctx_id = afu->ctx_hndl;
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 347fc16..1a2d09c 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -72,7 +72,7 @@ struct sisl_ioarcb {
 	u16 timeout;		/* in units specified by req_flags */
 	u32 rsvd1;
 	u8 cdb[16];		/* must be in big endian */
-	struct scsi_cmnd *scp;
+	u64 reserved;		/* Reserved area */
 } __packed;
 
 struct sisl_rc {
-- 
2.1.0

