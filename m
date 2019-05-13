From: Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v1 1/3] scsi: ufs: do not overwrite auto-hibern8 timer
Date: Mon, 13 May 2019 22:36:24 +0800
Message-ID: <1557758186-18706-2-git-send-email-stanley.chu@mediatek.com>
References: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1557758186-18706-1-git-send-email-stanley.chu@mediatek.com>
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
Cc: marc.w.gonzalez@free.fr, andy.teng@mediatek.com, chun-hung.wu@mediatek.com, kuohong.wang@mediatek.com, evgreen@chromium.org, subhashj@codeaurora.org, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com, vivek.gautam@codeaurora.org, matthias.bgg@gmail.com, sayalil@codeaurora.org, Stanley Chu <stanley.chu@mediatek.com>, linux-arm-kernel@lists.infradead.org, beanhuo@micron.com
List-Id: linux-scsi@vger.kernel.org

Some vendor-specific initialization flow may set its own
auto-hibern8 timer. In this case, do not overwrite timer value
as "default value" in ufshcd_init().

Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e040f9dd9ff3..1665820c22fd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8309,7 +8309,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 						UIC_LINK_HIBERN8_STATE);
 
 	/* Set the default auto-hiberate idle timer value to 150 ms */
-	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) {
+	if (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT & !hba->ahit) {
 		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, 150) |
 			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
 	}
-- 
2.18.0
