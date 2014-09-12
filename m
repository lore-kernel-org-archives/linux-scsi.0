From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 08/18][SCSI] mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
Date: Fri, 12 Sep 2014 15:35:23 +0530
Message-ID: <1410516333-3678-9-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:46173 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaILKGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2014 06:06:50 -0400
Received: by mail-pa0-f44.google.com with SMTP id kx10so938718pab.31
        for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2014 03:06:49 -0700 (PDT)
In-Reply-To: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Elliott@hp.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Driver initialization fails if driver tries to send IOC facts request message when the IOC is in reset or in a fault state.

This patch will make sure that
 1.Driver to send IOC facts request message only if HBA is in operational or ready state.
 2.If IOC is in fault state, a diagnostic reset would be issued.
 3.If IOC is in reset state then driver will wait for 10 seconds to exit out of reset state.
   If the HBA continues to be in reset state, then the HBA wouldn't be claimed by the driver.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 68 +++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 51a83d7..32cd7fa 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -95,6 +95,9 @@ MODULE_PARM_DESC(disable_discovery, " disable discovery ");
 static int
 _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag);
 
+static int
+_base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag);
+
 /**
  * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
  *
@@ -3461,6 +3464,64 @@ _base_get_port_facts(struct MPT2SAS_ADAPTER *ioc, int port, int sleep_flag)
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
+_base_wait_for_iocstate(struct MPT2SAS_ADAPTER *ioc, int timeout,
+	int sleep_flag)
+{
+	u32 ioc_state, doorbell;
+	int rc;
+
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+	    __func__));
+
+	if (ioc->pci_error_recovery)
+		return 0;
+
+	doorbell = mpt2sas_base_get_iocstate(ioc, 0);
+	ioc_state = doorbell & MPI2_IOC_STATE_MASK;
+	dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: ioc_state(0x%08x)\n",
+	    ioc->name, __func__, ioc_state));
+
+	switch (ioc_state) {
+	case MPI2_IOC_STATE_READY:
+	case MPI2_IOC_STATE_OPERATIONAL:
+		return 0;
+	}
+
+	if (doorbell & MPI2_DOORBELL_USED) {
+		dhsprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "unexpected doorbell activ!e\n", ioc->name));
+		goto issue_diag_reset;
+	}
+
+	if (ioc_state == MPI2_IOC_STATE_FAULT) {
+		mpt2sas_base_fault_info(ioc, doorbell &
+		    MPI2_DOORBELL_DATA_MASK);
+		goto issue_diag_reset;
+	}
+
+	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
+	    timeout, sleep_flag);
+	if (ioc_state) {
+		printk(MPT2SAS_ERR_FMT
+		    "%s: failed going to ready state (ioc_state=0x%x)\n",
+		    ioc->name, __func__, ioc_state);
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
@@ -3478,6 +3539,13 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
 	    __func__));
 
+	r = _base_wait_for_iocstate(ioc, 10, sleep_flag);
+	if (r) {
+		printk(MPT2SAS_ERR_FMT "%s: failed getting to correct state\n",
+			ioc->name, __func__);
+		return r;
+	}
+
 	mpi_reply_sz = sizeof(Mpi2IOCFactsReply_t);
 	mpi_request_sz = sizeof(Mpi2IOCFactsRequest_t);
 	memset(&mpi_request, 0, mpi_request_sz);
-- 
2.0.2

