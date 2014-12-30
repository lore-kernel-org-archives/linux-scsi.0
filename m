From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 2/2] mpt2sas,mpt3sas: additional master abort checks
Date: Tue, 30 Dec 2014 09:07:20 -0500
Message-ID: <1419948455-31624-3-git-send-email-joe.lawrence@stratus.com>
References: <1419948455-31624-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:56738 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaL3OJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 09:09:19 -0500
In-Reply-To: <1419948455-31624-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Derek Shute <derek.shute@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

Add checks for PCI master abort reads in _base_wait_for_doorbell_int and
_base_wait_for_doorbell_not_used, which contain potentially long loops
around readl calls.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   10 ++++++++--
 drivers/scsi/mpt3sas/mpt3sas_base.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 16d6fd5e037e..6ad1268cc57b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2942,7 +2942,9 @@ _base_wait_for_doorbell_int(struct MPT2SAS_ADAPTER *ioc, int timeout,
 	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
-		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
+		if (int_status == 0xFFFFFFFF)
+			goto out;
+		else if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
 			dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 			    "successful count(%d), timeout(%d)\n", ioc->name,
 			    __func__, count, timeout));
@@ -2955,6 +2957,7 @@ _base_wait_for_doorbell_int(struct MPT2SAS_ADAPTER *ioc, int timeout,
 		count++;
 	} while (--cntdn);
 
+ out:
 	printk(MPT2SAS_ERR_FMT "%s: failed due to timeout count(%d), "
 	    "int_status(%x)!\n", ioc->name, __func__, count, int_status);
 	return -EFAULT;
@@ -3032,7 +3035,9 @@ _base_wait_for_doorbell_not_used(struct MPT2SAS_ADAPTER *ioc, int timeout,
 	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
 	do {
 		doorbell_reg = readl(&ioc->chip->Doorbell);
-		if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
+		if (doorbell_reg == 0xFFFFFFFF)
+			goto out;
+		else if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
 			dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
 			    "successful count(%d), timeout(%d)\n", ioc->name,
 			    __func__, count, timeout));
@@ -3045,6 +3050,7 @@ _base_wait_for_doorbell_not_used(struct MPT2SAS_ADAPTER *ioc, int timeout,
 		count++;
 	} while (--cntdn);
 
+ out:
 	printk(MPT2SAS_ERR_FMT "%s: failed due to timeout count(%d), "
 	    "doorbell_reg(%x)!\n", ioc->name, __func__, count, doorbell_reg);
 	return -EFAULT;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 878bf6ddd2a0..d3b6549640c7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3115,7 +3115,9 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout,
 	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
 	do {
 		int_status = readl(&ioc->chip->HostInterruptStatus);
-		if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
+		if (int_status == 0xFFFFFFFF)
+			goto out;
+		else if (int_status & MPI2_HIS_IOC2SYS_DB_STATUS) {
 			dhsprintk(ioc, pr_info(MPT3SAS_FMT
 				"%s: successful count(%d), timeout(%d)\n",
 				ioc->name, __func__, count, timeout));
@@ -3128,6 +3130,7 @@ _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout,
 		count++;
 	} while (--cntdn);
 
+ out:
 	pr_err(MPT3SAS_FMT
 		"%s: failed due to timeout count(%d), int_status(%x)!\n",
 		ioc->name, __func__, count, int_status);
@@ -3207,7 +3210,9 @@ _base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc, int timeout,
 	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
 	do {
 		doorbell_reg = readl(&ioc->chip->Doorbell);
-		if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
+		if (doorbell_reg == 0xFFFFFFFF)
+			goto out;
+		else if (!(doorbell_reg & MPI2_DOORBELL_USED)) {
 			dhsprintk(ioc, pr_info(MPT3SAS_FMT
 				"%s: successful count(%d), timeout(%d)\n",
 				ioc->name, __func__, count, timeout));
@@ -3220,6 +3225,7 @@ _base_wait_for_doorbell_not_used(struct MPT3SAS_ADAPTER *ioc, int timeout,
 		count++;
 	} while (--cntdn);
 
+ out:
 	pr_err(MPT3SAS_FMT
 		"%s: failed due to timeout count(%d), doorbell_reg(%x)!\n",
 		ioc->name, __func__, count, doorbell_reg);
-- 
1.7.10.4

