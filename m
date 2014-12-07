From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfad.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:07:53 +0100
Message-ID: <1417990073-18840-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove the function bfad_drv_uninit() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfad.c     |   20 --------------------
 drivers/scsi/bfa/bfad_drv.h |    1 -
 2 files changed, 21 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e90a374..336a857 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -865,26 +865,6 @@ bfad_drv_init(struct bfad_s *bfad)
 }
 
 void
-bfad_drv_uninit(struct bfad_s *bfad)
-{
-	unsigned long   flags;
-
-	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	init_completion(&bfad->comp);
-	bfa_iocfc_stop(&bfad->bfa);
-	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	wait_for_completion(&bfad->comp);
-
-	del_timer_sync(&bfad->hal_tmo);
-	bfa_isr_disable(&bfad->bfa);
-	bfa_detach(&bfad->bfa);
-	bfad_remove_intr(bfad);
-	bfad_hal_mem_release(bfad);
-
-	bfad->bfad_flags &= ~BFAD_DRV_INIT_DONE;
-}
-
-void
 bfad_drv_start(struct bfad_s *bfad)
 {
 	unsigned long	flags;
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 8b97877..659132b 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -317,7 +317,6 @@ void		bfad_bfa_tmo(unsigned long data);
 void		bfad_init_timer(struct bfad_s *bfad);
 int		bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad);
 void		bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad);
-void		bfad_drv_uninit(struct bfad_s *bfad);
 int		bfad_worker(void *ptr);
 void		bfad_debugfs_init(struct bfad_port_s *port);
 void		bfad_debugfs_exit(struct bfad_port_s *port);
-- 
1.7.10.4
