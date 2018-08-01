From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] scsi: ufs: Suspend clock scaling only once in ufshcd_hba_exit()
Date: Wed,  1 Aug 2018 16:31:45 -0700
Message-ID: <20180801233145.65049-1-mka@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Stephen Boyd <sboyd@kernel.org>, Matthias Kaehlcke <mka@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Commit 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during
clock gating") introduced a check in ufshcd_hba_exit() to suspend
clock scaling only when the controller supports clock scaling.
However the unconditional call to ufshcd_suspend_clkscaling() was
also left in place, so that it is now called twice when clock
scaling is supported and still once when the controller doesn't
support it. Remove the unconditional call.

Fixes: 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during clock gating")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 397081d320b1..dca7525af696 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7186,7 +7186,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	if (hba->is_powered) {
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
-		ufshcd_suspend_clkscaling(hba);
 		if (ufshcd_is_clkscaling_supported(hba)) {
 			if (hba->devfreq)
 				ufshcd_suspend_clkscaling(hba);
-- 
2.18.0.597.ga71716f1ad-goog
