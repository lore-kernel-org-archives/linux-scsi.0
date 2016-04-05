From: Bastien Philbert <bastienphilbert@gmail.com>
Subject: [PATCH] mpt3sas:Make sure mpt3sas adapter has been reset in scsih_resume
Date: Tue,  5 Apr 2016 19:37:11 -0400
Message-ID: <1459899431-22564-1-git-send-email-bastienphilbert@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com
Cc: chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This fixes the issue in the function scih_resume that we assume
that the mpt3sas adapter has been reset properly with a call to
mpt3sas_base_hard_reset_handler by checking if this function
call returns a error code and exit adpater resume prematurely

Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e0e4920..be2a7c3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8892,7 +8892,11 @@ scsih_resume(struct pci_dev *pdev)
 	if (r)
 		return r;
 
-	mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
+	r = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
+	if (r) {
+		mpt3sas_base_free_resources(ioc);
+		return r;
+	}
 	scsi_unblock_requests(shost);
 	mpt3sas_base_start_watchdog(ioc);
 	return 0;
-- 
2.5.0
