From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 4/6] scsi: ufs: prevent IRQ handler accessing already freed hostdata
Date: Sun,  2 Aug 2015 02:19:18 +0900
Message-ID: <1438449560-4106-5-git-send-email-akinobu.mita@gmail.com>
References: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Hannes Reinecke <hare@suse.de>, Sahitya Tummala <stummala@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As UFS driver registers IRQ handler as a shared IRQ, when
CONFIG_DEBUG_SHIRQ=y, an extra call will be made while unregistering
the IRQ handler.  Unfortunately, the extra call will accesses already
freed hostdata.  This is because devm_request_irq() is used to register
IRQ handler so that it will be unregistered automatically on driver
remove, but the hostdata has already been freed at this time.

This fixes it by explicitly registering/unregistering IRQ handler on
driver probe/remove.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sahitya Tummala <stummala@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e25f919..d425816 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5361,6 +5361,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
+	ufshcd_disable_irq(hba);
 	ufshcd_hba_stop(hba);
 
 	ufshcd_exit_clk_gating(hba);
@@ -5611,13 +5612,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	ufshcd_init_clk_gating(hba);
 	/* IRQ registration */
-	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
-	if (err) {
-		dev_err(hba->dev, "request irq failed\n");
+	err = ufshcd_enable_irq(hba);
+	if (err)
 		goto exit_gating;
-	} else {
-		hba->is_irq_enabled = true;
-	}
 
 	/* Enable SCSI tag mapping */
 	err = scsi_init_shared_tag_map(host, host->can_queue);
@@ -5668,9 +5665,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 exit_gating:
+	ufshcd_disable_irq(hba);
 	ufshcd_exit_clk_gating(hba);
 out_disable:
-	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
 out_error:
 	scsi_host_put(host);
-- 
1.9.1
