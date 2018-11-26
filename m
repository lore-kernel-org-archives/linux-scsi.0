From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] scsi: ufs: add fall through annotation
Date: Mon, 26 Nov 2018 10:10:34 +0200
Message-ID: <20181126081034.30185-1-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Avri Altman <Avri.Altman@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Add /* fallthrough */ annotation, to eliminate compilation warning:
warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3807efd895be..b15f5dab0618 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1549,6 +1549,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 * currently running. Hence, fall through to cancel gating
 		 * work and to enable clocks.
 		 */
+		/* fallthrough */
 	case CLKS_OFF:
 		ufshcd_scsi_block_requests(hba);
 		hba->clk_gating.state = REQ_CLKS_ON;
@@ -1560,6 +1561,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 * fall through to check if we should wait for this
 		 * work to be done or not.
 		 */
+		/* fallthrough */
 	case REQ_CLKS_ON:
 		if (async) {
 			rc = -EAGAIN;
@@ -4618,6 +4620,7 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
 	switch (scsi_status) {
 	case SAM_STAT_CHECK_CONDITION:
 		ufshcd_copy_sense_data(lrbp);
+		/* fallthrough */
 	case SAM_STAT_GOOD:
 		result |= DID_OK << 16 |
 			  COMMAND_COMPLETE << 8 |
-- 
2.17.2
