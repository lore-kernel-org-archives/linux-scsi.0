From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH] scsi: ufs: remove the duplicated checking for supporting
 clkscaling
Date: Tue, 21 Mar 2017 21:19:57 +0900
Message-ID: <20170321121957.18655-1-jh80.chung@samsung.com>
References: <CGME20170321121957epcas1p3ccd834d3ac572a1858684e8ab4bb24e1@epcas1p3.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, Jaehoon Chung <jh80.chung@samsung.com>
List-Id: linux-scsi@vger.kernel.org

There are same conditions for checking whether supporting clkscaling or
not.
When ufshcd is supporting clkscaling, active_reqs should be decreased by
two.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dc6efbd..f2cbc71 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4598,8 +4598,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 		}
 		if (ufshcd_is_clkscaling_supported(hba))
 			hba->clk_scaling.active_reqs--;
-		if (ufshcd_is_clkscaling_supported(hba))
-			hba->clk_scaling.active_reqs--;
 	}
 
 	/* clear corresponding bits of completed commands */
-- 
2.10.2
