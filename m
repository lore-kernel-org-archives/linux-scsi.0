From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 15/30] cxlflash: Fix location of setting resid
Date: Wed, 16 Sep 2015 11:57:59 -0500
Message-ID: <1442422679-41576-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:40240 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbbIPQ6d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 12:58:33 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 12:58:32 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 228C96E804C
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 12:50:13 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GGwTpd59506688
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 16:58:29 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GGwPYO013626
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 12:58:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The resid is incorrectly set which can lead to unnecessary retry
attempts by the stack. This is due to resid _always_ being set
using a value returned from the adapter. Instead, the value
should only be interpreted and set when in an underrun scenario.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 29e40cc..b3838af 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -107,6 +107,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 {
 	struct sisl_ioarcb *ioarcb;
 	struct sisl_ioasa *ioasa;
+	u32 resid;
 
 	if (unlikely(!cmd))
 		return;
@@ -115,9 +116,10 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 	ioasa = &(cmd->sa);
 
 	if (ioasa->rc.flags & SISL_RC_FLAGS_UNDERRUN) {
-		pr_debug("%s: cmd underrun cmd = %p scp = %p\n",
-			 __func__, cmd, scp);
-		scp->result = (DID_ERROR << 16);
+		resid = ioasa->resid;
+		scsi_set_resid(scp, resid);
+		pr_debug("%s: cmd underrun cmd = %p scp = %p, resid = %d\n",
+			 __func__, cmd, scp, resid);
 	}
 
 	if (ioasa->rc.flags & SISL_RC_FLAGS_OVERRUN) {
@@ -158,8 +160,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 				/* If the SISL_RC_FLAGS_OVERRUN flag was set,
 				 * then we will handle this error else where.
 				 * If not then we must handle it here.
-				 * This is probably an AFU bug. We will
-				 * attempt a retry to see if that resolves it.
+				 * This is probably an AFU bug.
 				 */
 				scp->result = (DID_ERROR << 16);
 			}
@@ -183,7 +184,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 		/* We have an AFU error */
 		switch (ioasa->rc.afu_rc) {
 		case SISL_AFU_RC_NO_CHANNELS:
-			scp->result = (DID_MEDIUM_ERROR << 16);
+			scp->result = (DID_NO_CONNECT << 16);
 			break;
 		case SISL_AFU_RC_DATA_DMA_ERR:
 			switch (ioasa->afu_extra) {
@@ -217,7 +218,6 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
 static void cmd_complete(struct afu_cmd *cmd)
 {
 	struct scsi_cmnd *scp;
-	u32 resid;
 	ulong lock_flags;
 	struct afu *afu = cmd->parent;
 	struct cxlflash_cfg *cfg = afu->parent;
@@ -229,14 +229,11 @@ static void cmd_complete(struct afu_cmd *cmd)
 
 	if (cmd->rcb.scp) {
 		scp = cmd->rcb.scp;
-		if (unlikely(cmd->sa.rc.afu_rc ||
-			     cmd->sa.rc.scsi_rc ||
-			     cmd->sa.rc.fc_rc))
+		if (unlikely(cmd->sa.ioasc))
 			process_cmd_err(cmd, scp);
 		else
 			scp->result = (DID_OK << 16);
 
-		resid = cmd->sa.resid;
 		cmd_is_tmf = cmd->cmd_tmf;
 		cmd_checkin(cmd); /* Don't use cmd after here */
 
@@ -244,7 +241,6 @@ static void cmd_complete(struct afu_cmd *cmd)
 				     "ioasc=%d\n", __func__, scp, scp->result,
 				     cmd->sa.ioasc);
 
-		scsi_set_resid(scp, resid);
 		scsi_dma_unmap(scp);
 		scp->scsi_done(scp);
 
-- 
2.1.0

