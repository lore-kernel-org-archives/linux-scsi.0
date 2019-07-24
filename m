From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 2/3] scsi: ufs: introduce ufshcd_tm_cmd_compl() to refactor
 task cleanup
Date: Wed, 24 Jul 2019 13:50:17 +0800
Message-ID: <1563947418-16394-3-git-send-email-stanley.chu@mediatek.com>
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

Introduce ufshcd_tm_cmd_compl() to re-factor taks cleanup jobs
to make code more readable and for future wider usage by task error
handling.

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 66c8e7402001..114c15ed75f7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5522,6 +5522,13 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 	 */
 }
 
+static void ufshcd_tm_cmd_compl(struct ufs_hba *hba, int tag)
+{
+	__clear_bit(tag, &hba->outstanding_tasks);
+	__clear_bit(tag, &hba->tm_condition);
+	ufshcd_put_tm_slot(hba, tag);
+}
+
 /**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
@@ -5687,11 +5694,9 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 
 	if (likely(cleanup)) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
-		__clear_bit(free_slot, &hba->outstanding_tasks);
+		ufshcd_tm_cmd_compl(hba, free_slot);
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-		clear_bit(free_slot, &hba->tm_condition);
-		ufshcd_put_tm_slot(hba, free_slot);
 		wake_up(&hba->tm_tag_wq);
 	}
 
-- 
2.18.0
