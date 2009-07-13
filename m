From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] SCSI: lpfc, don't dereference NULL
Date: Mon, 13 Jul 2009 23:25:54 +0200
Message-ID: <1247520354-32145-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757451AbZGMVZ4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

When kzalloc fails in lpfc_hba_alloc, don't dereference the NULL by
lpfc_printf_log. Use dev_err instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index fc67cc6..2452dc9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4130,8 +4130,7 @@ lpfc_hba_alloc(struct pci_dev *pdev)
 	/* Allocate memory for HBA structure */
 	phba = kzalloc(sizeof(struct lpfc_hba), GFP_KERNEL);
 	if (!phba) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1417 Failed to allocate hba struct.\n");
+		dev_err(&pdev->dev, "failed to allocate hba struct\n");
 		return NULL;
 	}
 
-- 
1.6.3.2
