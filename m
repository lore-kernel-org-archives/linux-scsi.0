From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 1/3] scsi: ufs: clean-up task resource immediately only if
 task is responded
Date: Wed, 24 Jul 2019 13:50:16 +0800
Message-ID: <1563947418-16394-2-git-send-email-stanley.chu@mediatek.com>
References: <1563947418-16394-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1563947418-16394-1-git-send-email-stanley.chu@mediatek.com>
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

In __ufshcd_issue_tm_cmd(), if host is unable to clear TM command by
setting "clear register", the TM command may be still "outstanding"
in the device. In this case, it may be better to do cleanup after reset
is done. Therefore let __ufshcd_issue_tm_cmd() clean-up task resource
immediately only if task is responded.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3804a704e565..66c8e7402001 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5628,6 +5628,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	struct Scsi_Host *host = hba->host;
 	unsigned long flags;
 	int free_slot, task_tag, err;
+	bool cleanup = true;
 
 	/*
 	 * Get free slot, sleep if slots are unavailable.
@@ -5667,26 +5668,33 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-		if (ufshcd_clear_tm_cmd(hba, free_slot))
+		if (ufshcd_clear_tm_cmd(hba, free_slot)) {
 			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
 					__func__, free_slot);
+			/*
+			 * unable to clear task, cleanup shall be done
+			 * during error handling
+			 */
+			cleanup = false;
+		}
 		err = -ETIMEDOUT;
 	} else {
 		err = 0;
 		memcpy(treq, hba->utmrdl_base_addr + free_slot, sizeof(*treq));
 
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete");
+	}
 
+	if (likely(cleanup)) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		__clear_bit(free_slot, &hba->outstanding_tasks);
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+		clear_bit(free_slot, &hba->tm_condition);
+		ufshcd_put_tm_slot(hba, free_slot);
+		wake_up(&hba->tm_tag_wq);
 	}
 
-	clear_bit(free_slot, &hba->tm_condition);
-	ufshcd_put_tm_slot(hba, free_slot);
-	wake_up(&hba->tm_tag_wq);
-
 	ufshcd_release(hba);
 	return err;
 }
-- 
2.18.0
