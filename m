From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [v4 02/14] scsi: ufs: avoid spurious UFS host controller interrupts
Date: Thu,  4 Feb 2016 12:36:08 +0200
Message-ID: <1454582180-3823-3-git-send-email-ygardi@codeaurora.org>
References: <1454582180-3823-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1454582180-3823-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

When control reaches to Linux UFS driver during UFS boot mode, UFS host
controller interrupt status/enable registers may have left over
settings.
In order to avoid any spurious interrupts due to these left overs,
it's important to clear these interrupt status/enable registers before
enabling UFS interrupt handling.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 65593b3..b0ef94d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5837,6 +5837,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	init_waitqueue_head(&hba->dev_cmd.tag_wq);
 
 	ufshcd_init_clk_gating(hba);
+
+	/*
+	 * In order to avoid any spurious interrupt immediately after
+	 * registering UFS controller interrupt handler, clear any pending UFS
+	 * interrupt status and disable all the UFS interrupts.
+	 */
+	ufshcd_writel(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS),
+		      REG_INTERRUPT_STATUS);
+	ufshcd_writel(hba, 0, REG_INTERRUPT_ENABLE);
+	/*
+	 * Make sure that UFS interrupts are disabled and any pending interrupt
+	 * status is cleared before registering UFS interrupt handler.
+	 */
+	mb();
+
 	/* IRQ registration */
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
