From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v6 1/4] mpt3sas: Separate out mpt3sas_wait_for_ioc_to_operational
Date: Tue, 23 Oct 2018 15:51:18 +0530
Message-ID: <1540290081-15827-2-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: helgaas@kernel.org, lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

No functional changes. This section of code
 "wait for IOC to be operational" is used in many places
 across the driver, and hence moved this code in to
 a function "mpt3sas_wait_for_ioc_to_operational()"

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 73 ++++++++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_config.c    | 24 +++--------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 ++-------
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 63 ++++-----------------------
 5 files changed, 62 insertions(+), 123 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 166b607..243bf32 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5079,6 +5079,41 @@ _base_send_ioc_reset(struct MPT3SAS_ADAPTER *ioc, u8 reset_type, int timeout)
 }
 
 /**
+ * mpt3sas_wait_for_ioc_to_operational - IOC's operational
+ *		state and HBA hot unplug status are checked here.
+ * @ioc: per adapter object
+ * @wait_count: timeout in seconds
+ *
+ * Return: Waits up to timeout seconds for the IOC to
+ * become operational. Returns 0 if IOC is present
+ * and operational; otherwise returns -EFAULT.
+ */
+
+int
+mpt3sas_wait_for_ioc_to_operational(struct MPT3SAS_ADAPTER *ioc,
+	int timeout)
+{
+	int wait_state_count = 0;
+	u32 ioc_state;
+
+	do {
+		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
+		if (ioc_state == MPI2_IOC_STATE_OPERATIONAL)
+			break;
+		ssleep(1);
+		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
+				__func__, ++wait_state_count);
+	} while (--timeout);
+	if (!timeout) {
+		ioc_err(ioc, "%s: failed due to ioc not operational\n", __func__);
+		return -EFAULT;
+	}
+	if (wait_state_count)
+		ioc_info(ioc, "ioc is operational\n");
+	return 0;
+}
+
+/**
  * _base_handshake_req_reply_wait - send request thru doorbell interface
  * @ioc: per adapter object
  * @request_bytes: request length
@@ -5212,11 +5247,9 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2SasIoUnitControlRequest_t *mpi_request)
 {
 	u16 smid;
-	u32 ioc_state;
 	u8 issue_reset = 0;
 	int rc;
 	void *request;
-	u16 wait_state_count;
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -5228,20 +5261,9 @@ mpt3sas_base_sas_iounit_control(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 	}
 
-	wait_state_count = 0;
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			rc = -EFAULT;
-			goto out;
-		}
-		ssleep(1);
-		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
-	}
+	rc = mpt3sas_wait_for_ioc_to_operational(ioc, IOC_OPERATIONAL_WAIT_COUNT);
+	if (rc)
+		goto out;
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
 	if (!smid) {
@@ -5307,11 +5329,9 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2SepReply_t *mpi_reply, Mpi2SepRequest_t *mpi_request)
 {
 	u16 smid;
-	u32 ioc_state;
 	u8 issue_reset = 0;
 	int rc;
 	void *request;
-	u16 wait_state_count;
 
 	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
 
@@ -5323,20 +5343,9 @@ mpt3sas_base_scsi_enclosure_processor(struct MPT3SAS_ADAPTER *ioc,
 		goto out;
 	}
 
-	wait_state_count = 0;
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			rc = -EFAULT;
-			goto out;
-		}
-		ssleep(1);
-		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
-	}
+	rc = mpt3sas_wait_for_ioc_to_operational(ioc, IOC_OPERATIONAL_WAIT_COUNT);
+	if (rc)
+		goto out;
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
 	if (!smid) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 8f1d6b0..c860ed2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -139,6 +139,8 @@
 #define DEFAULT_NUM_FWCHAIN_ELEMTS	8
 
 #define FW_IMG_HDR_READ_TIMEOUT	15
+
+#define IOC_OPERATIONAL_WAIT_COUNT	10
 /*
  * NVMe defines
  */
@@ -1487,6 +1489,8 @@ mpt3sas_wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc);
 
 u8 mpt3sas_base_check_cmd_timeout(struct MPT3SAS_ADAPTER *ioc,
 	u8 status, void *mpi_request, int sz);
+int mpt3sas_wait_for_ioc_to_operational(struct MPT3SAS_ADAPTER *ioc,
+	int wait_count);
 
 /* scsih shared API */
 struct scsi_cmnd *mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 0220944..88062d1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -300,11 +300,9 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	void *config_page, u16 config_page_sz)
 {
 	u16 smid;
-	u32 ioc_state;
 	Mpi2ConfigRequest_t *config_request;
 	int r;
 	u8 retry_count, issue_host_reset = 0;
-	u16 wait_state_count;
 	struct config_request mem;
 	u32 ioc_status = UINT_MAX;
 
@@ -361,23 +359,11 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		ioc_info(ioc, "%s: attempting retry (%d)\n",
 			 __func__, retry_count);
 	}
-	wait_state_count = 0;
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			ioc->config_cmds.status = MPT3_CMD_NOT_USED;
-			r = -EFAULT;
-			goto free_mem;
-		}
-		ssleep(1);
-		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
-	}
-	if (wait_state_count)
-		ioc_info(ioc, "%s: ioc is operational\n", __func__);
+
+	r = mpt3sas_wait_for_ioc_to_operational(ioc,
+				MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT);
+	if (r)
+		goto free_mem;
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->config_cb_idx);
 	if (!smid) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 0f6305c..83fdf11 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -641,7 +641,6 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	MPI2DefaultReply_t *mpi_reply;
 	Mpi26NVMeEncapsulatedRequest_t *nvme_encap_request = NULL;
 	struct _pcie_device *pcie_device = NULL;
-	u32 ioc_state;
 	u16 smid;
 	u8 timeout;
 	u8 issue_reset;
@@ -654,7 +653,6 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 	dma_addr_t data_in_dma = 0;
 	size_t data_in_sz = 0;
 	long ret;
-	u16 wait_state_count;
 	u16 device_handle = MPT3SAS_INVALID_DEVICE_HANDLE;
 	u8 tr_method = MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE;
 
@@ -666,22 +664,9 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		goto out;
 	}
 
-	wait_state_count = 0;
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			ret = -EFAULT;
-			goto out;
-		}
-		ssleep(1);
-		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
-	}
-	if (wait_state_count)
-		ioc_info(ioc, "%s: ioc is operational\n", __func__);
+	ret = mpt3sas_wait_for_ioc_to_operational(ioc, IOC_OPERATIONAL_WAIT_COUNT);
+	if (ret)
+		goto out;
 
 	mpi_request = kzalloc(ioc->request_sz, GFP_KERNEL);
 	if (!mpi_request) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 031b420..bc1e67b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -296,7 +296,6 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	struct rep_manu_request *manufacture_request;
 	int rc;
 	u16 smid;
-	u32 ioc_state;
 	void *psge;
 	u8 issue_reset = 0;
 	void *data_out = NULL;
@@ -304,7 +303,6 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	dma_addr_t data_in_dma;
 	size_t data_in_sz;
 	size_t data_out_sz;
-	u16 wait_state_count;
 
 	if (ioc->shost_recovery || ioc->pci_error_recovery) {
 		ioc_info(ioc, "%s: host reset in progress!\n", __func__);
@@ -320,22 +318,9 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	}
 	ioc->transport_cmds.status = MPT3_CMD_PENDING;
 
-	wait_state_count = 0;
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			rc = -EFAULT;
-			goto out;
-		}
-		ssleep(1);
-		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
-	}
-	if (wait_state_count)
-		ioc_info(ioc, "%s: ioc is operational\n", __func__);
+	rc = mpt3sas_wait_for_ioc_to_operational(ioc, IOC_OPERATIONAL_WAIT_COUNT);
+	if (rc)
+		goto out;
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->transport_cb_idx);
 	if (!smid) {
@@ -1077,13 +1062,11 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	struct phy_error_log_reply *phy_error_log_reply;
 	int rc;
 	u16 smid;
-	u32 ioc_state;
 	void *psge;
 	u8 issue_reset = 0;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
-	u16 wait_state_count;
 
 	if (ioc->shost_recovery || ioc->pci_error_recovery) {
 		ioc_info(ioc, "%s: host reset in progress!\n", __func__);
@@ -1099,22 +1082,9 @@ _transport_get_expander_phy_error_log(struct MPT3SAS_ADAPTER *ioc,
 	}
 	ioc->transport_cmds.status = MPT3_CMD_PENDING;
 
-	wait_state_count = 0;
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			rc = -EFAULT;
-			goto out;
-		}
-		ssleep(1);
-		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
-	}
-	if (wait_state_count)
-		ioc_info(ioc, "%s: ioc is operational\n", __func__);
+	rc = mpt3sas_wait_for_ioc_to_operational(ioc, IOC_OPERATIONAL_WAIT_COUNT);
+	if (rc)
+		goto out;
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->transport_cb_idx);
 	if (!smid) {
@@ -1381,13 +1351,11 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	struct phy_control_reply *phy_control_reply;
 	int rc;
 	u16 smid;
-	u32 ioc_state;
 	void *psge;
 	u8 issue_reset = 0;
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	u32 sz;
-	u16 wait_state_count;
 
 	if (ioc->shost_recovery || ioc->pci_error_recovery) {
 		ioc_info(ioc, "%s: host reset in progress!\n", __func__);
@@ -1403,22 +1371,9 @@ _transport_expander_phy_control(struct MPT3SAS_ADAPTER *ioc,
 	}
 	ioc->transport_cmds.status = MPT3_CMD_PENDING;
 
-	wait_state_count = 0;
-	ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
-		if (wait_state_count++ == 10) {
-			ioc_err(ioc, "%s: failed due to ioc not operational\n",
-				__func__);
-			rc = -EFAULT;
-			goto out;
-		}
-		ssleep(1);
-		ioc_state = mpt3sas_base_get_iocstate(ioc, 1);
-		ioc_info(ioc, "%s: waiting for operational state(count=%d)\n",
-			 __func__, wait_state_count);
-	}
-	if (wait_state_count)
-		ioc_info(ioc, "%s: ioc is operational\n", __func__);
+	rc = mpt3sas_wait_for_ioc_to_operational(ioc, IOC_OPERATIONAL_WAIT_COUNT);
+	if (rc)
+		goto out;
 
 	smid = mpt3sas_base_get_smid(ioc, ioc->transport_cb_idx);
 	if (!smid) {
-- 
1.8.3.1
