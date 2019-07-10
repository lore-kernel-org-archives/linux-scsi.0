From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 4/4] scsi: ufs: Add history of fatal events
Date: Wed, 10 Jul 2019 13:20:17 +0800
Message-ID: <1562736017-29461-5-git-send-email-stanley.chu@mediatek.com>
References: <1562736017-29461-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1562736017-29461-1-git-send-email-stanley.chu@mediatek.com>
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

Currently only "interrupt-based" errors have their own history,
however there are "non-interrupt-based" errors which may be
fatal also needing history to improve debugging or help know
the health status of UFS devices.

For example,
- Link startup fail
- Suspend fail
- Resume fail
- Task or request abort event

This patch tries to add those failed events by existed UFS error
history mechanism.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++++++++---------
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a46c3d2b2ea3..969128a731e1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -432,6 +432,14 @@ static void ufshcd_print_host_regs(struct ufs_hba *hba)
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.fatal_err, "fatal_err");
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.auto_hibern8_err,
 			      "auto_hibern8_err");
+	ufshcd_print_err_hist(hba, &hba->ufs_stats.task_abort_err,
+			      "task_abort");
+	ufshcd_print_err_hist(hba, &hba->ufs_stats.link_startup_err,
+			      "link_startup_fail");
+	ufshcd_print_err_hist(hba, &hba->ufs_stats.suspend_err,
+			      "suspend_fail");
+	ufshcd_print_err_hist(hba, &hba->ufs_stats.resume_err,
+			      "resume_fail");
 
 	ufshcd_print_clk_freqs(hba);
 
@@ -4329,6 +4337,14 @@ static inline int ufshcd_disable_device_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_disable_tx_lcc(hba, true);
 }
 
+static void ufshcd_update_reg_hist(struct ufs_err_reg_hist *reg_hist,
+				   u32 reg)
+{
+	reg_hist->reg[reg_hist->pos] = reg;
+	reg_hist->tstamp[reg_hist->pos] = ktime_get();
+	reg_hist->pos = (reg_hist->pos + 1) % UFS_ERR_REG_HIST_LENGTH;
+}
+
 /**
  * ufshcd_link_startup - Initialize unipro link startup
  * @hba: per adapter instance
@@ -4356,6 +4372,8 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 
 		/* check if device is detected by inter-connect layer */
 		if (!ret && !ufshcd_is_device_present(hba)) {
+			ufshcd_update_reg_hist(&hba->ufs_stats.link_startup_err,
+					       0);
 			dev_err(hba->dev, "%s: Device not present\n", __func__);
 			ret = -ENXIO;
 			goto out;
@@ -4366,8 +4384,11 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		 * but we can't be sure if the link is up until link startup
 		 * succeeds. So reset the local Uni-Pro and try again.
 		 */
-		if (ret && ufshcd_hba_enable(hba))
+		if (ret && ufshcd_hba_enable(hba)) {
+			ufshcd_update_reg_hist(&hba->ufs_stats.link_startup_err,
+					       (u32)ret);
 			goto out;
+		}
 	} while (ret && retries--);
 
 	if (ret)
@@ -5350,14 +5371,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 	pm_runtime_put_sync(hba->dev);
 }
 
-static void ufshcd_update_reg_hist(struct ufs_err_reg_hist *reg_hist,
-				   u32 reg)
-{
-	reg_hist->reg[reg_hist->pos] = reg;
-	reg_hist->tstamp[reg_hist->pos] = ktime_get();
-	reg_hist->pos = (reg_hist->pos + 1) % UFS_ERR_REG_HIST_LENGTH;
-}
-
 /**
  * ufshcd_update_uic_error - check and set fatal UIC error flags.
  * @hba: per-adapter instance
@@ -6043,6 +6056,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 */
 	scsi_print_command(hba->lrb[tag].cmd);
 	if (!hba->req_abort_count) {
+		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort_err, 0);
 		ufshcd_print_host_regs(hba);
 		ufshcd_print_host_state(hba);
 		ufshcd_print_pwr_info(hba);
@@ -7819,6 +7833,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_release(hba);
 out:
 	hba->pm_op_in_progress = 0;
+	if (ret)
+		ufshcd_update_reg_hist(&hba->ufs_stats.suspend_err, (u32)ret);
 	return ret;
 }
 
@@ -7921,6 +7937,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_setup_clocks(hba, false);
 out:
 	hba->pm_op_in_progress = 0;
+	if (ret)
+		ufshcd_update_reg_hist(&hba->ufs_stats.resume_err, (u32)ret);
 	return ret;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c6ec5c749ceb..f9f109da7f18 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -438,6 +438,10 @@ struct ufs_err_reg_hist {
  * @dme_err: tracks dme errors
  * @fatal_err: tracks fatal errors
  * @auto_hibern8_err: tracks auto-hibernate errors
+ * @tsk_abort_err: tracks task abort events
+ * @linkup_err: tracks link-startup fail events
+ * @suspend_err: tracks suspend fail events
+ * @resume_err: tracks resume fail events
  */
 struct ufs_stats {
 	u32 hibern8_exit_cnt;
@@ -453,6 +457,12 @@ struct ufs_stats {
 	/* fatal errors */
 	struct ufs_err_reg_hist fatal_err;
 	struct ufs_err_reg_hist auto_hibern8_err;
+
+	/* fatal events */
+	struct ufs_err_reg_hist task_abort_err;
+	struct ufs_err_reg_hist link_startup_err;
+	struct ufs_err_reg_hist suspend_err;
+	struct ufs_err_reg_hist resume_err;
 };
 
 /**
-- 
2.18.0
