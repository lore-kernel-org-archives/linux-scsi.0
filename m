From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 12/22] mpt3sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
Date: Thu, 20 Nov 2014 12:35:45 +0530
Message-ID: <1416467155-16869-13-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:45944 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbaKTHNZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 02:13:25 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so1962045pab.26
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2014 23:13:24 -0800 (PST)
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Driver initialization fails if driver tries to send IOC facts request message when the IOC is in reset or in a fault state.

This patch will make sure that
 1.Driver to send IOC facts request message only if HBA is in operational or ready state.
 2.If IOC is in fault state, a diagnostic reset would be issued.
 3.If IOC is in reset state then driver will wait for 10 seconds to exit out of reset state.
   If the HBA continues to be in reset state, then the HBA wouldn't be claimed by the driver.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 65 +++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 958a870..527f91b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3159,6 +3159,9 @@ _base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc, u32 ioc_state, int timeout,
  * Notes: MPI2_HIS_IOC2SYS_DB_STATUS - set to one when IOC writes to doorbell.
  */
 static int
+_base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int sleep_flag);
+
+static int
 _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout,
 	int sleep_flag)
 {
@@ -3701,6 +3704,61 @@ _base_get_port_facts(struct MPT3SAS_ADAPTER *ioc, int port, int sleep_flag)
 }
 
 /**
+ * _base_wait_for_iocstate - Wait until the card is in READY or OPERATIONAL
+ * @ioc: per adapter object
+ * @timeout:
+ * @sleep_flag: CAN_SLEEP or NO_SLEEP
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc, int timeout,
+	int sleep_flag)
+{
+	u32 ioc_state;
+	int rc;
+
+	dinitprintk(ioc, printk(MPT3SAS_FMT "%s\n", ioc->name,
+	    __func__));
+
+	if (ioc->pci_error_recovery)
+		return 0;
+
+	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
+	dhsprintk(ioc, printk(MPT3SAS_FMT "%s: ioc_state(0x%08x)\n",
+	    ioc->name, __func__, ioc_state));
+
+	if (((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_READY) ||
+	    (ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_OPERATIONAL)
+		return 0;
+
+	if (ioc_state & MPI2_DOORBELL_USED) {
+		dhsprintk(ioc, printk(MPT3SAS_FMT
+		    "unexpected doorbell active!\n", ioc->name));
+		goto issue_diag_reset;
+	}
+
+	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
+		mpt3sas_base_fault_info(ioc, ioc_state &
+		    MPI2_DOORBELL_DATA_MASK);
+		goto issue_diag_reset;
+	}
+
+	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
+	    timeout, sleep_flag);
+	if (ioc_state) {
+		dfailprintk(ioc, printk(MPT3SAS_FMT
+		    "%s: failed going to ready state (ioc_state=0x%x)\n",
+		    ioc->name, __func__, ioc_state));
+		return -EFAULT;
+	}
+
+ issue_diag_reset:
+	rc = _base_diag_reset(ioc, sleep_flag);
+	return rc;
+}
+
+/**
  * _base_get_ioc_facts - obtain ioc facts reply and save in ioc
  * @ioc: per adapter object
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
@@ -3718,6 +3776,13 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
 
+	r = _base_wait_for_iocstate(ioc, 10, sleep_flag);
+	if (r) {
+		dfailprintk(ioc, printk(MPT3SAS_FMT
+		    "%s: failed getting to correct state\n",
+		    ioc->name, __func__));
+		return r;
+	}
 	mpi_reply_sz = sizeof(Mpi2IOCFactsReply_t);
 	mpi_request_sz = sizeof(Mpi2IOCFactsRequest_t);
 	memset(&mpi_request, 0, mpi_request_sz);
-- 
2.0.2

