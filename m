From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] mvumi: fix build warning
Date: Thu,  3 Mar 2016 18:36:53 +0530
Message-ID: <1457010413-12809-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

While building tilepro allmodconfig we were getting build warning:
drivers/scsi/mvumi.c:2632:12: warning: 'mvumi_suspend' defined but not used
drivers/scsi/mvumi.c:2651:12: warning: 'mvumi_resume' defined but not used

mvumi_suspend() and mvumi_resume() are only used when CONFIG_PM is
defined as mentioned in the mvumi_pci_driver.	

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/scsi/mvumi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 02360de..d9d0736 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2629,6 +2629,7 @@ static void mvumi_shutdown(struct pci_dev *pdev)
 	mvumi_flush_cache(mhba);
 }
 
+#ifdef CONFIG_PM
 static int mvumi_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct mvumi_hba *mhba = NULL;
@@ -2716,6 +2717,7 @@ fail:
 
 	return ret;
 }
+#endif
 
 static struct pci_driver mvumi_pci_driver = {
 
-- 
1.9.1
