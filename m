From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: advansys.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:03:45 +0200
Message-ID: <1401627825-17179-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/advansys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d814588..201ea3b 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11394,7 +11394,7 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 	struct asc_board *boardp = shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc_varp = NULL;
 	ADV_DVC_VAR *adv_dvc_varp = NULL;
-	int share_irq, warn_code, ret;
+	int share_irq, warn_code, ret = 0;
 
 	pdev = (bus_type == ASC_IS_PCI) ? to_pci_dev(boardp->dev) : NULL;
 
-- 
1.7.10.4
