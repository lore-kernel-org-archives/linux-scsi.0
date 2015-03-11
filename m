From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] scsi: match wait_for_completion_timeout return type
Date: Wed, 11 Mar 2015 07:57:36 -0400
Message-ID: <1426075056-27410-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:55510 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbbCKMCB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Mar 2015 08:02:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>

wait_for_completion_timeout returns unsigned long not int. As other
instances of wait_for_completion_timeout in fc_fcp.c use ticks_left
of appropriate type, this name is used here as well.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was only compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y
CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m

Patch is against 4.0-rc3 (localversion-next is -next-20150310)

 drivers/scsi/libfc/fc_fcp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c679594..c94a518 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1261,7 +1261,7 @@ static void fc_lun_reset_send(unsigned long data)
 static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 			unsigned int id, unsigned int lun)
 {
-	int rc;
+	unsigned long ticks_left;
 
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_tm_flags = FCP_TMF_LUN_RESET;
@@ -1276,7 +1276,8 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	 * wait for completion of reset
 	 * after that make sure all commands are terminated
 	 */
-	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
+	ticks_left = wait_for_completion_timeout(&fsp->tm_done,
+						 FC_SCSI_TM_TOV);
 
 	spin_lock_bh(&fsp->scsi_pkt_lock);
 	fsp->state |= FC_SRB_COMPL;
@@ -1292,7 +1293,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	fsp->wait_for_comp = 0;
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
 
-	if (!rc) {
+	if (!ticks_left) {
 		FC_SCSI_DBG(lport, "lun reset failed\n");
 		return FAILED;
 	}
-- 
1.7.10.4

