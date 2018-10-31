From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v7 3/8] mpt3sas: Refactor mpt3sas_wait_for_ioc function
Date: Wed, 31 Oct 2018 18:53:34 +0530
Message-ID: <1540992219-20291-4-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

No functional change. Doing code refactor of function
mpt3sas_wait_for_ioc() for better readability.

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 3b5f28a..f25bc3c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5093,22 +5093,20 @@ mpt3sas_wait_for_ioc(struct MPT3SAS_ADAPTER *ioc, int timeout)
 	int wait_state_count = 0;
 	u32 ioc_state;
 
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-
-		if (wait_state_count++ == timeout) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			return -EFAULT;
-		}
-		ssleep(1);
+	do {
 		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
+		if (ioc_state == MPI2_IOC_STATE_OPERATIONAL)
+			break;
+		ssleep(1);
 		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
+				__func__, ++wait_state_count);
+	} while (--timeout);
+	if (!timeout) {
+		ioc_err(ioc, "%s: failed due to ioc not operational\n", __func__);
+		return -EFAULT;
 	}
 	if (wait_state_count)
 		ioc_info(ioc, "ioc is operational\n");
-
 	return 0;
 }
 
-- 
1.8.3.1
