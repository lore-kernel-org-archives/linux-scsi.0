From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ipr: PCI error recovery fix
Date: Tue, 23 Jan 2007 11:25:37 -0600
Message-ID: <200701231725.l0NHPb9t020204@d03av03.boulder.ibm.com>
References: <1169573123318-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:59459 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067AbXAWRZm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 12:25:42 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0NHPdTC002766
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 12:25:39 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0NHPcpj496558
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 10:25:38 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0NHPbMb020239
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2007 10:25:38 -0700
In-Reply-To: <1169573123318-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brazilnut@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Since the pci_block_user_cfg_access API was modified to track
block/unblocks, it was discovered that the ipr driver had a
path through its code (in PCI error recovery) which would unblock
when not previously blocked.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_eeh_recovery_fix drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_eeh_recovery_fix	2007-01-18 17:08:08.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-01-18 17:08:08.000000000 -0600
@@ -6308,7 +6308,6 @@ static int ipr_reset_restore_cfg_space(s
 	int rc;
 
 	ENTER;
-	pci_unblock_user_cfg_access(ioa_cfg->pdev);
 	rc = pci_restore_state(ioa_cfg->pdev);
 
 	if (rc != PCIBIOS_SUCCESSFUL) {
@@ -6349,6 +6348,24 @@ static int ipr_reset_restore_cfg_space(s
 }
 
 /**
+ * ipr_reset_bist_done - BIST has completed on the adapter.
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: Unblock config space and resume the reset process.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE
+ **/
+static int ipr_reset_bist_done(struct ipr_cmnd *ipr_cmd)
+{
+	ENTER;
+	pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
+	ipr_cmd->job_step = ipr_reset_restore_cfg_space;
+	LEAVE;
+	return IPR_RC_JOB_CONTINUE;
+}
+
+/**
  * ipr_reset_start_bist - Run BIST on the adapter.
  * @ipr_cmd:	ipr command struct
  *
@@ -6370,7 +6387,7 @@ static int ipr_reset_start_bist(struct i
 		ipr_cmd->ioasa.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
 		rc = IPR_RC_JOB_CONTINUE;
 	} else {
-		ipr_cmd->job_step = ipr_reset_restore_cfg_space;
+		ipr_cmd->job_step = ipr_reset_bist_done;
 		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
 		rc = IPR_RC_JOB_RETURN;
 	}
_
