From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 3/3] scsi: ufs: fix broken hba->outstanding_tasks
Date: Wed, 24 Jul 2019 13:50:18 +0800
Message-ID: <1563947418-16394-4-git-send-email-stanley.chu@mediatek.com>
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

Currently bits in hba->outstanding_tasks are cleared only after their
corresponding task management commands are successfully done by
__ufshcd_issue_tm_cmd().

If timeout happens in a task management command, its corresponding
bit in hba->outstanding_tasks will not be cleared until next task
management command with the same tag used successfully finishes.

This is wrong and can lead to some issues, like power issue.
For example, ufshcd_release() and ufshcd_gate_work() will do nothing
if hba->outstanding_tasks is not zero even if both UFS host and devices
are actually idle.

Referring to error handling flow of hba->outstanding_reqs, all timed-out
bits will be cleared by
ufshcd_reset_and_restore() => ufshcd_transfer_req_compl()
after reset is done. Therefore similar handling for hba->outstanding_tasks
could be applied, for example, by
ufshcd_reset_and_restore() => ufshcd_tmc_handler().

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 114c15ed75f7..3cb942ef64e2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5535,11 +5535,25 @@ static void ufshcd_tm_cmd_compl(struct ufs_hba *hba, int tag)
  */
 static void ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	u32 tm_doorbell;
+	u32 tm_doorbell, tag;
 
 	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
+
+	/*
+	 * resource of timed-out tasks shall be cleaned.
+	 * No effect for normal tasks.
+	 */
+	for_each_set_bit(tag, &hba->tm_condition, hba->nutmrs)
+		ufshcd_tm_cmd_compl(hba, tag);
+
 	wake_up(&hba->tm_wq);
+
+	/*
+	 * If a timed-out task is cleaned done above,
+	 * free tag is available now for waiters.
+	 */
+	wake_up(&hba->tm_tag_wq);
 }
 
 /**
-- 
2.18.0
