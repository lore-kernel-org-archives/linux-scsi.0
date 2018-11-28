From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 40/41] scsi: ufs: ufshcd: mark expected switch fall-throughs
Date: Tue, 27 Nov 2018 22:34:25 -0600
Message-ID: <f4ee30ab52b0fadd2242dd189fe03b60ecba1f47.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1087954 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 003d489f1b4b..be207197b63f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1551,6 +1551,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 * currently running. Hence, fall through to cancel gating
 		 * work and to enable clocks.
 		 */
+		/* fall through */
 	case CLKS_OFF:
 		ufshcd_scsi_block_requests(hba);
 		hba->clk_gating.state = REQ_CLKS_ON;
@@ -1562,6 +1563,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 * fall through to check if we should wait for this
 		 * work to be done or not.
 		 */
+		/* fall through */
 	case REQ_CLKS_ON:
 		if (async) {
 			rc = -EAGAIN;
@@ -4620,6 +4622,7 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
 	switch (scsi_status) {
 	case SAM_STAT_CHECK_CONDITION:
 		ufshcd_copy_sense_data(lrbp);
+		/* fall through */
 	case SAM_STAT_GOOD:
 		result |= DID_OK << 16 |
 			  COMMAND_COMPLETE << 8 |
-- 
2.17.1
