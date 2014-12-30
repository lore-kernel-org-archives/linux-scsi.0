From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 1/2] mpt2sas,mpt3sas: correct master-abort checking in doorbell ack
Date: Tue, 30 Dec 2014 09:07:19 -0500
Message-ID: <1419948455-31624-2-git-send-email-joe.lawrence@stratus.com>
References: <1419948455-31624-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o141.mxlogic.net ([208.65.144.74]:36688 "EHLO
	p02c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaL3OIs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 09:08:48 -0500
In-Reply-To: <1419948455-31624-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Derek Shute <derek.shute@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Test against the invalid data pattern ~0 before testing valid data
patterns.

Reported-by: Derek Shute <derek.shute@stratus.com>
Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    7 ++++---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 3fb01d1883c6..16d6fd5e037e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2983,7 +2983,9 @@ _base_wait_for_doorbell_ack(struct MPT2SAS_ADAPTER *ioc, int timeout,
 	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
-		if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) {
+		if (int_status == 0xFFFFFFFF)
+			goto out;
+		else if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) {
 			dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 			    "successful count(%d), timeout(%d)\n", ioc->name,
 			    __func__, count, timeout));
@@ -2995,8 +2997,7 @@ _base_wait_for_doorbell_ack(struct MPT2SAS_ADAPTER *ioc, int timeout,
 				mpt2sas_base_fault_info(ioc , doorbell);
 				return -EFAULT;
 			}
-		} else if (int_status == 0xFFFFFFFF)
-			goto out;
+		}
 
 		if (sleep_flag == CAN_SLEEP)
 			msleep(1);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b9c27398e206..878bf6ddd2a0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3157,7 +3157,9 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout,
 	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
-		if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) {
+		if (int_status == 0xFFFFFFFF)
+			goto out;
+		else if (!(int_status & MPI2_HIS_SYS2IOC_DB_STATUS)) {
 			dhsprintk(ioc, pr_info(MPT3SAS_FMT
 				"%s: successful count(%d), timeout(%d)\n",
 				ioc->name, __func__, count, timeout));
@@ -3169,8 +3171,7 @@ _base_wait_for_doorbell_ack(struct MPT3SAS_ADAPTER *ioc, int timeout,
 				mpt3sas_base_fault_info(ioc , doorbell);
 				return -EFAULT;
 			}
-		} else if (int_status == 0xFFFFFFFF)
-			goto out;
+		}
 
 		if (sleep_flag == CAN_SLEEP)
 			usleep_range(1000, 1500);
-- 
1.7.10.4

