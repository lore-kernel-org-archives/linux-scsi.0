From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 3/3] scsi: ufs: Add error-handling of Auto-Hibernate
Date: Mon, 20 May 2019 22:10:45 +0800
Message-ID: <1558361445-30994-4-git-send-email-stanley.chu@mediatek.com>
References: <1558361445-30994-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1558361445-30994-1-git-send-email-stanley.chu@mediatek.com>
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
Cc: marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, matthias.bgg@gmail.com, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Currently auto-hibernate is activated if host supports
auto-hibern8 capability. However error-handling is not implemented,
which makes the feature somewhat risky.

If either "Hibernate Enter" or "Hibernate Exit" fail during
auto-hibernate flow, the corresponding interrupt
"UIC_HIBERNATE_ENTER" or "UIC_HIBERNATE_EXIT" shall be raised
according to UFS specification.

This patch adds auto-hibernate error-handling:

- Monitor "Hibernate Enter" and "Hibernate Exit" interrupts after
  auto-hibernate feature is activated.

- If fail happens, trigger error-handling just like "manual-hibernate"
  fail and apply the same recovery flow: schedule UFS error handler in
  ufshcd_check_errors(), and then do host reset and restore
  in UFS error handler.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshci.h |  6 ++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c904625d9905..da304cbf9b0b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5254,6 +5254,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 			goto skip_err_handling;
 	}
 	if ((hba->saved_err & INT_FATAL_ERRORS) ||
+	    (hba->saved_err & UFSHCD_UIC_HIBERN8_MASK) ||
 	    ((hba->saved_err & UIC_ERROR) &&
 	    (hba->saved_uic_err & (UFSHCD_UIC_DL_PA_INIT_ERROR |
 				   UFSHCD_UIC_DL_NAC_RECEIVED_ERROR |
@@ -5413,6 +5414,23 @@ static void ufshcd_update_uic_error(struct ufs_hba *hba)
 			__func__, hba->uic_error);
 }
 
+static bool ufshcd_is_auto_hibern8_error(struct ufs_hba *hba,
+					 u32 intr_mask)
+{
+	if (!ufshcd_is_auto_hibern8_supported(hba))
+		return false;
+
+	if (!(intr_mask & UFSHCD_UIC_HIBERN8_MASK))
+		return false;
+
+	if (hba->active_uic_cmd &&
+	    (hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_ENTER ||
+	    hba->active_uic_cmd->command == UIC_CMD_DME_HIBER_EXIT))
+		return false;
+
+	return true;
+}
+
 /**
  * ufshcd_check_errors - Check for errors that need s/w attention
  * @hba: per-adapter instance
@@ -5431,6 +5449,15 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 			queue_eh_work = true;
 	}
 
+	if (hba->errors & UFSHCD_UIC_HIBERN8_MASK) {
+		dev_err(hba->dev,
+			"%s: Auto Hibern8 %s failed - status: 0x%08x, upmcrs: 0x%08x\n",
+			__func__, (hba->errors & UIC_HIBERNATE_ENTER) ?
+			"Enter" : "Exit",
+			hba->errors, ufshcd_get_upmcrs(hba));
+		queue_eh_work = true;
+	}
+
 	if (queue_eh_work) {
 		/*
 		 * update the transfer error masks to sticky bits, let's do this
@@ -5493,6 +5520,10 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
 static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 {
 	hba->errors = UFSHCD_ERROR_MASK & intr_status;
+
+	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
+		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+
 	if (hba->errors)
 		ufshcd_check_errors(hba);
 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6fa889de5ee5..dbb75cd28dc8 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -144,8 +144,10 @@ enum {
 #define CONTROLLER_FATAL_ERROR			0x10000
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
 
-#define UFSHCD_UIC_PWR_MASK	(UIC_HIBERNATE_ENTER |\
-				UIC_HIBERNATE_EXIT |\
+#define UFSHCD_UIC_HIBERN8_MASK	(UIC_HIBERNATE_ENTER |\
+				UIC_HIBERNATE_EXIT)
+
+#define UFSHCD_UIC_PWR_MASK	(UFSHCD_UIC_HIBERN8_MASK |\
 				UIC_POWER_MODE)
 
 #define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL | UFSHCD_UIC_PWR_MASK)
-- 
2.18.0
