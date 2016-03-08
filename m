From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 02/17] scsi: ufs: avoid spurious UFS host controller interrupts
Date: Tue,  8 Mar 2016 14:35:53 +0200
Message-ID: <1457440568-13084-3-git-send-email-ygardi@codeaurora.org>
References: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48558 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbcCHMgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2016 07:36:51 -0500
In-Reply-To: <1457440568-13084-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

When control reaches to Linux UFS driver during UFS boot mode, UFS host
controller interrupt status/enable registers may have left over
settings.
In order to avoid any spurious interrupts due to these left overs,
it's important to clear these interrupt status/enable registers before
enabling UFS interrupt handling.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a8e42df..de7280c 100644
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
