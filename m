From: Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH] scsi: ufs: Check workqueue exists before destroying it
Date: Wed,  1 Aug 2018 17:14:35 -0700
Message-ID: <20180802001435.116963-1-mka@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Stephen Boyd <sboyd@kernel.org>, Matthias Kaehlcke <mka@chromium.org>
List-Id: linux-scsi@vger.kernel.org

In ufshcd_hba_exit() the clock gating workqueue is always destroyed
when clock gating is supported. However the workqueue pointer is NULL
when ufshcd_init() fails before the workqueue is created. Only destroy
the workqueue if it exists.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 397081d320b1..401f7dbe2981 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7190,7 +7190,8 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		if (ufshcd_is_clkscaling_supported(hba)) {
 			if (hba->devfreq)
 				ufshcd_suspend_clkscaling(hba);
-			destroy_workqueue(hba->clk_scaling.workq);
+			if (hba->clk_scaling.workq)
+				destroy_workqueue(hba->clk_scaling.workq);
 			ufshcd_devfreq_remove(hba);
 		}
 		ufshcd_setup_clocks(hba, false);
-- 
2.18.0.597.ga71716f1ad-goog
