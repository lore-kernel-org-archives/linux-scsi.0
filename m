From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] scsi: match wait_for_completion_timeout return type
Date: Thu, 14 May 2015 20:12:34 +0200
Message-ID: <1431627154-12695-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: linux-scsi@vger.kernel.org

Return type of wait_for_completion_timeout is unsigned long not int.
An appropriately named unsigned long is added, and the assignments
as well as error checking fixed up.

API conformance testing for completions with coccinelle spatches are being
used to locate API usage inconsistencies:
./drivers/scsi/libfc/fc_fcp.c:1279
        int return assigned to unsigned long

Patch was compile tested with x86_64_defconfig + SCSI_LOWLEVEL=y,
CONFIG_SCSI_FC_ATTRS=m, CONFIG_LIBFC=m

Patch is against 4.1-rc3 (localversion-next is -next-20150514)

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
 drivers/scsi/libfc/fc_fcp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c679594..c438b81 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1261,7 +1261,7 @@ static void fc_lun_reset_send(unsigned long data)
 static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 			unsigned int id, unsigned int lun)
 {
-	int rc;
+	unsigned long time_left;
 
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_tm_flags = FCP_TMF_LUN_RESET;
@@ -1276,7 +1276,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	 * wait for completion of reset
 	 * after that make sure all commands are terminated
 	 */
-	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
+	time_left = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
 
 	spin_lock_bh(&fsp->scsi_pkt_lock);
 	fsp->state |= FC_SRB_COMPL;
@@ -1292,7 +1292,7 @@ static int fc_lun_reset(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	fsp->wait_for_comp = 0;
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
 
-	if (!rc) {
+	if (!time_left) {
 		FC_SCSI_DBG(lport, "lun reset failed\n");
 		return FAILED;
 	}
-- 
1.7.10.4
