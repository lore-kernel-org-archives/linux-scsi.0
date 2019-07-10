From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 2/4] scsi: ufs: Add fatal and auto-hibern8 error history
Date: Wed, 10 Jul 2019 21:38:19 +0800
Message-ID: <1562765901-18328-3-git-send-email-stanley.chu@mediatek.com>
References: <1562765901-18328-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1562765901-18328-1-git-send-email-stanley.chu@mediatek.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com, pedrom.sousa@synopsys.com
Cc: sthumma@codeaurora.org, marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, peter.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, ygardi@codeaurora.org, matthias.bgg@gmail.com, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Provide more information of fatal errros and auto-hibern8 errors
to improve debugging by extending extend existed UFS error history
framework.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++++++++-
 drivers/scsi/ufs/ufshcd.h | 10 +++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eb062aba0d21..b8b874311509 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -429,6 +429,9 @@ static void ufshcd_print_host_regs(struct ufs_hba *hba)
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.nl_err, "nl_err");
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.tl_err, "tl_err");
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.dme_err, "dme_err");
+	ufshcd_print_err_hist(hba, &hba->ufs_stats.fatal_err, "fatal_err");
+	ufshcd_print_err_hist(hba, &hba->ufs_stats.auto_hibern8_err,
+			      "auto_hibern8_err");
 
 	ufshcd_print_clk_freqs(hba);
 
@@ -5440,8 +5443,10 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 {
 	bool queue_eh_work = false;
 
-	if (hba->errors & INT_FATAL_ERRORS)
+	if (hba->errors & INT_FATAL_ERRORS) {
+		ufshcd_update_reg_hist(&hba->ufs_stats.fatal_err, hba->errors);
 		queue_eh_work = true;
+	}
 
 	if (hba->errors & UIC_ERROR) {
 		hba->uic_error = 0;
@@ -5456,6 +5461,8 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 			__func__, (hba->errors & UIC_HIBERNATE_ENTER) ?
 			"Enter" : "Exit",
 			hba->errors, ufshcd_get_upmcrs(hba));
+		ufshcd_update_reg_hist(&hba->ufs_stats.auto_hibern8_err,
+				       hba->errors);
 		queue_eh_work = true;
 	}
 
@@ -6693,6 +6700,8 @@ static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
 	memset(&hba->ufs_stats.nl_err, 0, err_reg_hist_size);
 	memset(&hba->ufs_stats.tl_err, 0, err_reg_hist_size);
 	memset(&hba->ufs_stats.dme_err, 0, err_reg_hist_size);
+	memset(&hba->ufs_stats.fatal_err, 0, err_reg_hist_size);
+	memset(&hba->ufs_stats.auto_hibern8_err, 0, err_reg_hist_size);
 
 	hba->req_abort_count = 0;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index dcc61f857c38..c6ec5c749ceb 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -414,7 +414,7 @@ struct ufs_init_prefetch {
 
 #define UFS_ERR_REG_HIST_LENGTH 8
 /**
- * struct ufs_err_reg_hist - keeps history of uic errors
+ * struct ufs_err_reg_hist - keeps history of errors
  * @pos: index to indicate cyclic buffer position
  * @reg: cyclic buffer for registers value
  * @tstamp: cyclic buffer for time stamp
@@ -436,15 +436,23 @@ struct ufs_err_reg_hist {
  * @nl_err: tracks nl-uic errors
  * @tl_err: tracks tl-uic errors
  * @dme_err: tracks dme errors
+ * @fatal_err: tracks fatal errors
+ * @auto_hibern8_err: tracks auto-hibernate errors
  */
 struct ufs_stats {
 	u32 hibern8_exit_cnt;
 	ktime_t last_hibern8_exit_tstamp;
+
+	/* uic specific errors */
 	struct ufs_err_reg_hist pa_err;
 	struct ufs_err_reg_hist dl_err;
 	struct ufs_err_reg_hist nl_err;
 	struct ufs_err_reg_hist tl_err;
 	struct ufs_err_reg_hist dme_err;
+
+	/* fatal errors */
+	struct ufs_err_reg_hist fatal_err;
+	struct ufs_err_reg_hist auto_hibern8_err;
 };
 
 /**
-- 
2.18.0
