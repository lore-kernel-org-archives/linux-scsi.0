Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="c5uDGSzQ"
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E97DE
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 07:27:15 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cfb30ce241so50297395ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 07:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1701876434; x=1702481234; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KEtgryMGxMSABwQqKTrLP5eIooPvdRlWy4aB3qUs82M=;
        b=c5uDGSzQiEkuONiICrqoQeKQxl+4Q3JMj1SHBfWlC6ZwNmH2CCEwox5Vg9TITQe2YZ
         thfscOJAnZlM2QYNM9/2tQryyzLnA8KHxB+cqmnqEAEe3nAcRlIsSsmy6nu94esQ9eiJ
         oekWINOWJ0Ieju3/5EZ5KxGGSDmXMggwV9+JE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701876434; x=1702481234;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEtgryMGxMSABwQqKTrLP5eIooPvdRlWy4aB3qUs82M=;
        b=OhK6tPNP7R01++W3bRLCWawig9VrgPGqOcHuqoQLCSyMvVif5l8WRgfinyennPwXRw
         yfhmgCHF89YCA00bPUaZCTmr8jC0wRaoMQlSRrye5uCfLPgW4APD+UeiXL9zEiFMYjdX
         InGCfx0G+oAThQknegjyZun91NE2UWOWNH365SRgLGBJnM/OBatp/VifATFSvwD7tKY8
         3OnJ60K3aWJ45SzY0uW6zGw1MWmX/zlWDaXiArE0hELXspNqPxkmi0eDQMNSjokpM9KW
         HiVgHGrHi28AFqQikc9OMjQA4PPSru4R7FaRkQ9gUbKHYlHMhXZDvvdOjJkLbcOwJuRx
         l1vg==
X-Gm-Message-State: AOJu0Yy4H8zjTFQYs1xi92Cyd8ViLFzbaJoiFtVBeDWfS+mDVOEvAI0d
	7ODDRCTE3TX6QPFZw84QPZ2tbgfHNgi4PndP4hyz6uyWXAgiOenqD97n9H1SK5n766jh52Dp4ht
	VQ6VhpGvhsMSya31vqNaAGcpIv2ItZIpfMAun7PH+Awt1TqbqsbNpvfytyAy8Vr0Kn8QtLJBBaJ
	Qf89Z5FU9I8Q==
X-Google-Smtp-Source: AGHT+IEt4mG8vtUuy3e2z8h9XlKXApoV3aKVh5ivHmBj2CAbPd6bNTHQkQm7ftJplRmrqqUY0GB45w==
X-Received: by 2002:a17:903:2344:b0:1d0:9471:808d with SMTP id c4-20020a170903234400b001d09471808dmr916874plh.93.1701876433789;
        Wed, 06 Dec 2023 07:27:13 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id w17-20020a170902e89100b001cfc2e0a82fsm12182553plg.26.2023.12.06.07.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 07:27:12 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/4] mpi3mr: Support PCIe Error Recovery callback handlers
Date: Wed,  6 Dec 2023 20:55:11 +0530
Message-Id: <20231206152513.71253-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231206152513.71253-1-ranjan.kumar@broadcom.com>
References: <20231206152513.71253-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000055ab6d060bd8fc37"

--00000000000055ab6d060bd8fc37
Content-Transfer-Encoding: 8bit

The driver has been upgraded to include support for the
PCIe error recovery callback handler which is crucial for
the recovery of the controllers. This feature is
necessary for addressing the errors reported by
the PCIe AER (Advanced Error Reporting) mechanism.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h           |  31 +++
 drivers/scsi/mpi3mr/mpi3mr_app.c       |  64 +++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c        |  30 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c        | 330 +++++++++++++++++++++----
 drivers/scsi/mpi3mr/mpi3mr_transport.c |  39 ++-
 5 files changed, 408 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index e44e262748ea..de953eb055d0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -23,6 +23,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/aer.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -481,6 +482,7 @@ struct mpi3mr_throttle_group_info {
 
 /* HBA port flags */
 #define MPI3MR_HBA_PORT_FLAG_DIRTY	0x01
+#define MPI3MR_HBA_PORT_FLAG_NEW       0x02
 
 /* IOCTL data transfer sge*/
 #define MPI3MR_NUM_IOCTL_SGE		256
@@ -900,6 +902,29 @@ struct scmd_priv {
 	u8 mpi3mr_scsiio_req[MPI3MR_ADMIN_REQ_FRAME_SZ];
 };
 
+/**
+ * struct mpi3mr_pdevinfo - PCI device information
+ *
+ * @dev_id: PCI device ID of the adapter
+ * @dev_hw_rev: PCI revision of the adapter
+ * @subsys_dev_id: PCI subsystem device ID of the adapter
+ * @subsys_ven_id: PCI subsystem vendor ID of the adapter
+ * @dev: PCI device
+ * @func: PCI function
+ * @bus: PCI bus
+ * @seg_id: PCI segment ID
+ */
+struct mpi3mr_pdevinfo {
+	u16 id;
+	u16 ssid;
+	u16 ssvid;
+	u16 segment;
+	u8 dev:5;
+	u8 func:3;
+	u8 bus;
+	u8 revision;
+};
+
 /**
  * struct mpi3mr_ioc - Adapter anchor structure stored in shost
  * private data
@@ -1056,6 +1081,9 @@ struct scmd_priv {
  * @ioctl_chain_sge: DMA buffer descriptor for IOCTL chain
  * @ioctl_resp_sge: DMA buffer descriptor for Mgmt cmd response
  * @ioctl_sges_allocated: Flag for IOCTL SGEs allocated or not
+ * @pcie_err_recovery: PCIe error recovery in progress
+ * @block_on_pcie_err: Block IO during PCI error recovery
+ * @pdevinfo: PCI device information
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -1247,6 +1275,9 @@ struct mpi3mr_ioc {
 	struct dma_memory_desc ioctl_chain_sge;
 	struct dma_memory_desc ioctl_resp_sge;
 	bool ioctl_sges_allocated;
+	bool pcie_err_recovery;
+	bool block_on_pcie_err;
+	struct mpi3mr_pdevinfo pdevinfo;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 4b93b7440da6..a11d6f026f0e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -31,7 +31,7 @@ static int mpi3mr_bsg_pel_abort(struct mpi3mr_ioc *mrioc)
 		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
 		return -1;
 	}
-	if (mrioc->stop_bsgs) {
+	if (mrioc->stop_bsgs || mrioc->block_on_pcie_err) {
 		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
 		return -1;
 	}
@@ -424,6 +424,9 @@ static long mpi3mr_bsg_adp_reset(struct mpi3mr_ioc *mrioc,
 		goto out;
 	}
 
+	if (mrioc->unrecoverable || mrioc->block_on_pcie_err)
+		return -EINVAL;
+
 	sg_copy_to_buffer(job->request_payload.sg_list,
 			  job->request_payload.sg_cnt,
 			  &adpreset, sizeof(adpreset));
@@ -470,25 +473,29 @@ static long mpi3mr_bsg_populate_adpinfo(struct mpi3mr_ioc *mrioc,
 
 	memset(&adpinfo, 0, sizeof(adpinfo));
 	adpinfo.adp_type = MPI3MR_BSG_ADPTYPE_AVGFAMILY;
-	adpinfo.pci_dev_id = mrioc->pdev->device;
-	adpinfo.pci_dev_hw_rev = mrioc->pdev->revision;
-	adpinfo.pci_subsys_dev_id = mrioc->pdev->subsystem_device;
-	adpinfo.pci_subsys_ven_id = mrioc->pdev->subsystem_vendor;
-	adpinfo.pci_bus = mrioc->pdev->bus->number;
-	adpinfo.pci_dev = PCI_SLOT(mrioc->pdev->devfn);
-	adpinfo.pci_func = PCI_FUNC(mrioc->pdev->devfn);
-	adpinfo.pci_seg_id = pci_domain_nr(mrioc->pdev->bus);
 	adpinfo.app_intfc_ver = MPI3MR_IOCTL_VERSION;
 
-	ioc_state = mpi3mr_get_iocstate(mrioc);
-	if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
-		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
-	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
+	if (mrioc->reset_in_progress || mrioc->stop_bsgs ||
+	    mrioc->block_on_pcie_err)
 		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_IN_RESET;
-	else if (ioc_state == MRIOC_STATE_FAULT)
-		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
-	else
-		adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
+	else {
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
+			adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
+		else if (ioc_state == MRIOC_STATE_FAULT)
+			adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
+		else
+			adpinfo.adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
+	}
+
+	adpinfo.pci_dev_id = mrioc->pdevinfo.id;
+	adpinfo.pci_dev_hw_rev = mrioc->pdevinfo.revision;
+	adpinfo.pci_subsys_dev_id = mrioc->pdevinfo.ssid;
+	adpinfo.pci_subsys_ven_id = mrioc->pdevinfo.ssvid;
+	adpinfo.pci_bus = mrioc->pdevinfo.bus;
+	adpinfo.pci_dev = mrioc->pdevinfo.dev;
+	adpinfo.pci_func = mrioc->pdevinfo.func;
+	adpinfo.pci_seg_id = mrioc->pdevinfo.segment;
 
 	memcpy((u8 *)&adpinfo.driver_info, (u8 *)&mrioc->driver_info,
 	    sizeof(adpinfo.driver_info));
@@ -1495,7 +1502,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 		mutex_unlock(&mrioc->bsg_cmds.mutex);
 		goto out;
 	}
-	if (mrioc->stop_bsgs) {
+	if (mrioc->stop_bsgs || mrioc->block_on_pcie_err) {
 		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
 		rval = -EAGAIN;
 		mutex_unlock(&mrioc->bsg_cmds.mutex);
@@ -2020,17 +2027,20 @@ adp_state_show(struct device *dev, struct device_attribute *attr,
 	enum mpi3mr_iocstate ioc_state;
 	uint8_t adp_state;
 
-	ioc_state = mpi3mr_get_iocstate(mrioc);
-	if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
-		adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
-	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
+	if (mrioc->reset_in_progress || mrioc->stop_bsgs ||
+		 mrioc->block_on_pcie_err)
 		adp_state = MPI3MR_BSG_ADPSTATE_IN_RESET;
-	else if (ioc_state == MRIOC_STATE_FAULT)
-		adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
-	else
-		adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
+	else {
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+		if (ioc_state == MRIOC_STATE_UNRECOVERABLE)
+			adp_state = MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
+		else if (ioc_state == MRIOC_STATE_FAULT)
+			adp_state = MPI3MR_BSG_ADPSTATE_FAULT;
+		else
+			adp_state = MPI3MR_BSG_ADPSTATE_OPERATIONAL;
+	}
 
-	return sysfs_emit(buf, "%u\n", adp_state);
+	return snprintf(buf, PAGE_SIZE, "%u\n", adp_state);
 }
 
 static DEVICE_ATTR_RO(adp_state);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 9e4a075fd7f0..e0d69f147fce 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -595,7 +595,7 @@ int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	mrioc = (struct mpi3mr_ioc *)shost->hostdata;
 
 	if ((mrioc->reset_in_progress || mrioc->prepare_for_reset ||
-	    mrioc->unrecoverable))
+	    mrioc->unrecoverable || mrioc->pcie_err_recovery))
 		return 0;
 
 	num_entries = mpi3mr_process_op_reply_q(mrioc,
@@ -1037,14 +1037,16 @@ enum mpi3mr_iocstate mpi3mr_get_iocstate(struct mpi3mr_ioc *mrioc)
 	u32 ioc_status, ioc_config;
 	u8 ready, enabled;
 
-	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
-	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
-
 	if (mrioc->unrecoverable)
 		return MRIOC_STATE_UNRECOVERABLE;
+
+	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
+
 	if (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT)
 		return MRIOC_STATE_FAULT;
 
+	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
+
 	ready = (ioc_status & MPI3_SYSIF_IOC_STATUS_READY);
 	enabled = (ioc_config & MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC);
 
@@ -1667,6 +1669,12 @@ int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 		retval = -EAGAIN;
 		goto out;
 	}
+	if (mrioc->pcie_err_recovery) {
+		ioc_err(mrioc, "admin request queue submission failed due to pcie error recovery in progress\n");
+		retval = -EAGAIN;
+		goto out;
+	}
+
 	areq_entry = (u8 *)mrioc->admin_req_base +
 	    (areq_pi * MPI3MR_ADMIN_REQ_FRAME_SZ);
 	memset(areq_entry, 0, MPI3MR_ADMIN_REQ_FRAME_SZ);
@@ -2337,6 +2345,11 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		retval = -EAGAIN;
 		goto out;
 	}
+	if (mrioc->pcie_err_recovery) {
+		ioc_err(mrioc, "operational request queue submission failed due to pcie error recovery in progress\n");
+		retval = -EAGAIN;
+		goto out;
+	}
 
 	segment_base_addr = segments[pi / op_req_q->segment_qd].segment;
 	req_entry = (u8 *)segment_base_addr +
@@ -2585,7 +2598,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	u32 fault, host_diagnostic, ioc_status;
 	u32 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
-	if (mrioc->reset_in_progress)
+	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
 		return;
 
 	if (!mrioc->unrecoverable && !pci_device_is_present(mrioc->pdev)) {
@@ -4111,7 +4124,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
-	if (is_resume) {
+	if (is_resume || mrioc->block_on_pcie_err) {
 		dprint_reset(mrioc, "setting up single ISR\n");
 		retval = mpi3mr_setup_isr(mrioc, 1);
 		if (retval) {
@@ -4151,7 +4164,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed;
 	}
 
-	if (is_resume) {
+	if (is_resume || mrioc->block_on_pcie_err) {
 		dprint_reset(mrioc, "setting up multiple ISR\n");
 		retval = mpi3mr_setup_isr(mrioc, 0);
 		if (retval) {
@@ -4645,7 +4658,8 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
 
 	ioc_state = mpi3mr_get_iocstate(mrioc);
 
-	if ((!mrioc->unrecoverable) && (!mrioc->reset_in_progress) &&
+	if (!mrioc->unrecoverable && !mrioc->reset_in_progress &&
+	    !mrioc->pcie_err_recovery &&
 	    (ioc_state == MRIOC_STATE_READY)) {
 		if (mpi3mr_issue_and_process_mur(mrioc,
 		    MPI3MR_RESET_FROM_CTLR_CLEANUP))
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 1bffd629c124..d58aa1ecf9b1 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -919,7 +919,7 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 	int retval = 0;
 	struct mpi3mr_tgt_dev *tgtdev;
 
-	if (mrioc->reset_in_progress)
+	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
 		return -1;
 
 	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
@@ -2000,9 +2000,13 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	}
 	case MPI3_EVENT_WAIT_FOR_DEVICES_TO_REFRESH:
 	{
-		while (mrioc->device_refresh_on)
+		while ((mrioc->device_refresh_on || mrioc->block_on_pcie_err) &&
+		    !mrioc->unrecoverable && !mrioc->pcie_err_recovery) {
 			msleep(500);
+		}
 
+		if (mrioc->unrecoverable || mrioc->pcie_err_recovery)
+			break;
 		dprint_event_bh(mrioc,
 		    "scan for non responding and newly added devices after soft reset started\n");
 		if (mrioc->sas_transport_enabled) {
@@ -3680,6 +3684,13 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 		mutex_unlock(&drv_cmd->mutex);
 		goto out;
 	}
+	if (mrioc->block_on_pcie_err) {
+		retval = -1;
+		dprint_tm(mrioc, "sending task management failed due to\n"
+				"pcie error recovery in progress\n");
+		mutex_unlock(&drv_cmd->mutex);
+		goto out;
+	}
 
 	drv_cmd->state = MPI3MR_CMD_PENDING;
 	drv_cmd->is_waiting = 1;
@@ -4073,12 +4084,19 @@ static int mpi3mr_eh_bus_reset(struct scsi_cmnd *scmd)
 	if (dev_type == MPI3_DEVICE_DEVFORM_VD) {
 		mpi3mr_wait_for_host_io(mrioc,
 			MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
-		if (!mpi3mr_get_fw_pending_ios(mrioc))
+		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
+			while (mrioc->reset_in_progress ||
+			       mrioc->prepare_for_reset ||
+			       mrioc->block_on_pcie_err)
+				ssleep(1);
 			retval = SUCCESS;
+			goto out;
+		}
 	}
 	if (retval == FAILED)
 		mpi3mr_print_pending_host_io(mrioc);
 
+out:
 	sdev_printk(KERN_INFO, scmd->device,
 		"Bus reset is %s for scmd(%p)\n",
 		((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
@@ -4779,7 +4797,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 
-	if (mrioc->reset_in_progress) {
+	if (mrioc->reset_in_progress || mrioc->prepare_for_reset
+	    || mrioc->block_on_pcie_err) {
 		retval = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
@@ -5123,8 +5142,15 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mrioc->logging_level = logging_level;
 	mrioc->shost = shost;
 	mrioc->pdev = pdev;
+	mrioc->pdevinfo.id = pdev->device;
+	mrioc->pdevinfo.revision = pdev->revision;
+	mrioc->pdevinfo.ssid = pdev->subsystem_device;
+	mrioc->pdevinfo.ssvid = pdev->subsystem_vendor;
+	mrioc->pdevinfo.bus = pdev->bus->number;
+	mrioc->pdevinfo.dev = PCI_SLOT(pdev->devfn);
+	mrioc->pdevinfo.func = PCI_FUNC(pdev->devfn);
+	mrioc->pdevinfo.segment = pci_domain_nr(pdev->bus);
 	mrioc->stop_bsgs = 1;
-
 	mrioc->max_sgl_entries = max_sgl_entries;
 	if (max_sgl_entries > MPI3MR_MAX_SGL_ENTRIES)
 		mrioc->max_sgl_entries = MPI3MR_MAX_SGL_ENTRIES;
@@ -5230,6 +5256,35 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return retval;
 }
 
+/**
+ * mpi3mr_get_shost_and_mrioc - get shost and ioc reference if
+ *			they are valid
+ * @pdev: PCI device struct
+ * @shost: address to store scsi host reference
+ * @ioc: address store HBA adapter reference
+ *
+ * Return: 0 if *shost and *ioc are not NULL otherwise -1.
+ */
+
+static int
+mpi3mr_get_shost_and_mrioc(struct pci_dev *pdev,
+	struct Scsi_Host **shost, struct mpi3mr_ioc **mrioc)
+{
+	*shost = pci_get_drvdata(pdev);
+	if (*shost == NULL) {
+		dev_err(&pdev->dev, "pdev's driver data is null\n");
+		return -1;
+	}
+
+	*mrioc = shost_priv(*shost);
+	if (*mrioc == NULL) {
+		dev_err(&pdev->dev, "shost's private data is null\n");
+		*shost = NULL;
+		return -1;
+}
+	return 0;
+}
+
 /**
  * mpi3mr_remove - PCI remove callback
  * @pdev: PCI device instance
@@ -5242,22 +5297,26 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  */
 static void mpi3mr_remove(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
-	struct mpi3mr_hba_port *port, *hba_port_next;
-	struct mpi3mr_sas_node *sas_expander, *sas_expander_next;
 
-	if (!shost)
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
 		return;
 
-	mrioc = shost_priv(shost);
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 
-	if (!pci_device_is_present(mrioc->pdev)) {
+	if (mrioc->block_on_pcie_err) {
+		mrioc->block_on_pcie_err = false;
+		scsi_unblock_requests(shost);
+		mrioc->unrecoverable = 1;
+	}
+
+	if (!pci_device_is_present(mrioc->pdev) ||
+	    mrioc->pcie_err_recovery) {
 		mrioc->unrecoverable = 1;
 		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
 	}
@@ -5287,29 +5346,6 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	mpi3mr_cleanup_ioc(mrioc);
 	mpi3mr_free_mem(mrioc);
 	mpi3mr_cleanup_resources(mrioc);
-
-	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
-	list_for_each_entry_safe_reverse(sas_expander, sas_expander_next,
-	    &mrioc->sas_expander_list, list) {
-		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-		mpi3mr_expander_node_remove(mrioc, sas_expander);
-		spin_lock_irqsave(&mrioc->sas_node_lock, flags);
-	}
-	list_for_each_entry_safe(port, hba_port_next, &mrioc->hba_port_table_list, list) {
-		ioc_info(mrioc,
-		    "removing hba_port entry: %p port: %d from hba_port list\n",
-		    port, port->port_id);
-		list_del(&port->list);
-		kfree(port);
-	}
-	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
-
-	if (mrioc->sas_hba.num_phys) {
-		kfree(mrioc->sas_hba.phy);
-		mrioc->sas_hba.phy = NULL;
-		mrioc->sas_hba.num_phys = 0;
-	}
-
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
 	spin_unlock(&mrioc_list_lock);
@@ -5328,19 +5364,25 @@ static void mpi3mr_remove(struct pci_dev *pdev)
  */
 static void mpi3mr_shutdown(struct pci_dev *pdev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	struct workqueue_struct	*wq;
 	unsigned long flags;
 
-	if (!shost)
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
 		return;
 
-	mrioc = shost_priv(shost);
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 
 	mrioc->stop_drv_processing = 1;
+
+	if (mrioc->block_on_pcie_err) {
+		mrioc->block_on_pcie_err = false;
+		scsi_unblock_requests(shost);
+		mrioc->unrecoverable = 1;
+	}
+
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
 	wq = mrioc->fwevt_worker_thread;
@@ -5361,19 +5403,18 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
  * Change the power state to the given value and cleanup the IOC
  * by issuing MUR and shutdown notification
  *
- * Return: 0 always.
+ * Return: 0 on success, non-zero on failure
  */
 static int __maybe_unused
 mpi3mr_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 
-	if (!shost)
-		return 0;
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
+		return -1;
 
-	mrioc = shost_priv(shost);
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 	mrioc->stop_drv_processing = 1;
@@ -5402,15 +5443,13 @@ static int __maybe_unused
 mpi3mr_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost;
 	struct mpi3mr_ioc *mrioc;
 	pci_power_t device_state = pdev->current_state;
 	int r;
 
-	if (!shost)
-		return 0;
-
-	mrioc = shost_priv(shost);
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
+		return -1;
 
 	ioc_info(mrioc, "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
 	    pdev, pci_name(pdev), device_state);
@@ -5440,6 +5479,195 @@ mpi3mr_resume(struct device *dev)
 	return 0;
 }
 
+/**
+ * mpi3mr_pcierr_detected - PCI error detected callback
+ * @pdev: PCI device instance
+ * @state: channel state
+ *
+ * This function is called by the PCI error recovery driver and
+ * based on the state passed the driver decides what actions to
+ * be recommended back to PCI driver.
+ *
+ * For all of the states if there is no valid mrioc or scsi host
+ * references in the pci device then this function will retyrn
+ * the resul as disconnect.
+ *
+ * For normal state, this function will return the result as can
+ * recover.
+ *
+ * For frozen state, this function will block for any pennding
+ * controller initialization or re-initialization to complete,
+ * stop any new interactions with the controller and return
+ * status as reset required.
+ *
+ * For permanent failure state, this function will mark the
+ * controller as unrecoverable and return status as disconnect.
+ *
+ * Returns: PCI_ERS_RESULT_NEED_RESET or CAN_RECOVER or
+ * DISCONNECT based on the controller state.
+ */
+static pci_ers_result_t
+mpi3mr_pcierr_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+	pci_ers_result_t ret_val = PCI_ERS_RESULT_DISCONNECT;
+
+	dev_info(&pdev->dev, "%s: callback invoked state(%d)\n", __func__,
+	    state);
+
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
+		dev_err(&pdev->dev, "device not available\n");
+		return ret_val;
+	}
+
+	switch (state) {
+	case pci_channel_io_normal:
+		ret_val = PCI_ERS_RESULT_CAN_RECOVER;
+		break;
+	case pci_channel_io_frozen:
+		mrioc->pcie_err_recovery = true;
+		mrioc->block_on_pcie_err = true;
+		while (mrioc->reset_in_progress || mrioc->is_driver_loading)
+			ssleep(1);
+		scsi_block_requests(mrioc->shost);
+		mpi3mr_stop_watchdog(mrioc);
+		mpi3mr_cleanup_resources(mrioc);
+		mrioc->pdev = NULL;
+		ret_val = PCI_ERS_RESULT_NEED_RESET;
+		break;
+	case pci_channel_io_perm_failure:
+		mrioc->pcie_err_recovery = true;
+		mrioc->block_on_pcie_err = true;
+		mrioc->unrecoverable = 1;
+		mpi3mr_stop_watchdog(mrioc);
+		mpi3mr_flush_cmds_for_unrecovered_controller(mrioc);
+		ret_val = PCI_ERS_RESULT_DISCONNECT;
+		break;
+	default:
+		break;
+	}
+	return ret_val;
+}
+
+/**
+ * mpi3mr_pcierr_slot_reset_done - Post slot reset callback
+ * @pdev: PCI device instance
+ *
+ * This function is called by the PCI error recovery driver
+ * after a slot or link reset issued by it for the recovery, the
+ * driver is expected to bring back the controller and
+ * initialize it.
+ *
+ * This function restores pci state and reinitializes controller
+ * resoruces and the controller, this blocks for any pending
+ * reset to complete.
+ *
+ * Returns: PCI_ERS_RESULT_DISCONNECT on failure or
+ * PCI_ERS_RESULT_RECOVERED
+ */
+static pci_ers_result_t mpi3mr_pcierr_slot_reset_done(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+
+
+	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
+
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
+		dev_err(&pdev->dev, "device not available\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	while (mrioc->reset_in_progress)
+		ssleep(1);
+
+	mrioc->pdev = pdev;
+	pci_restore_state(pdev);
+
+	if (mpi3mr_setup_resources(mrioc)) {
+		ioc_err(mrioc, "setup resources failed\n");
+		goto out_failed;
+	}
+	mrioc->unrecoverable = 0;
+	mrioc->pcie_err_recovery = false;
+
+	if (mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_FIRMWARE, 0))
+		goto out_failed;
+
+	return PCI_ERS_RESULT_RECOVERED;
+
+out_failed:
+	mrioc->unrecoverable = 1;
+	mrioc->block_on_pcie_err = false;
+	scsi_unblock_requests(shost);
+	mpi3mr_start_watchdog(mrioc);
+	return PCI_ERS_RESULT_DISCONNECT;
+}
+
+/**
+ * mpi3mr_pcierr_resume - PCI error recovery resume
+ * callback
+ * @pdev: PCI device instance
+ *
+ * This function enables all I/O and IOCTLs post reset issued as
+ * part of the PCI advacned error reporting and handling
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_pcierr_resume(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+
+	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
+
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
+		dev_err(&pdev->dev, "device not available\n");
+		return;
+	}
+
+	pci_aer_clear_nonfatal_status(pdev);
+
+	if (mrioc->block_on_pcie_err) {
+		mrioc->block_on_pcie_err = false;
+		scsi_unblock_requests(shost);
+		mpi3mr_start_watchdog(mrioc);
+	}
+
+}
+
+/**
+ * mpi3mr_pcierr_mmio_enabled - PCI error recovery callback
+ * @pdev: PCI device instance
+ *
+ * This is called only if _pcierr_error_detected returns
+ * PCI_ERS_RESULT_CAN_RECOVER.
+ *
+ * Return: PCI_ERS_RESULT_DISCONNECT when the controller is
+ * unrecoverable or when the shost/mnrioc reference cannot be
+ * found, else return PCI_ERS_RESULT_RECOVERED
+ */
+static pci_ers_result_t mpi3mr_pcierr_mmio_enabled(struct pci_dev *pdev)
+{
+
+	struct Scsi_Host *shost;
+	struct mpi3mr_ioc *mrioc;
+/*
+ *
+ */
+	dev_info(&pdev->dev, "%s: callback invoked\n", __func__);
+
+	if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc)) {
+		dev_err(&pdev->dev, "device not available\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+	if (mrioc->unrecoverable)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
 static const struct pci_device_id mpi3mr_pci_id_table[] = {
 	{
 		PCI_DEVICE_SUB(MPI3_MFGPAGE_VENDORID_BROADCOM,
@@ -5457,6 +5685,13 @@ static const struct pci_device_id mpi3mr_pci_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, mpi3mr_pci_id_table);
 
+static struct pci_error_handlers mpi3mr_err_handler = {
+	.error_detected = mpi3mr_pcierr_detected,
+	.mmio_enabled = mpi3mr_pcierr_mmio_enabled,
+	.slot_reset = mpi3mr_pcierr_slot_reset_done,
+	.resume = mpi3mr_pcierr_resume,
+};
+
 static SIMPLE_DEV_PM_OPS(mpi3mr_pm_ops, mpi3mr_suspend, mpi3mr_resume);
 
 static struct pci_driver mpi3mr_pci_driver = {
@@ -5465,6 +5700,7 @@ static struct pci_driver mpi3mr_pci_driver = {
 	.probe = mpi3mr_probe,
 	.remove = mpi3mr_remove,
 	.shutdown = mpi3mr_shutdown,
+	.err_handler = &mpi3mr_err_handler,
 	.driver.pm = &mpi3mr_pm_ops,
 };
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index c0c8ab586957..8c8368104a27 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -149,6 +149,11 @@ static int mpi3mr_report_manufacture(struct mpi3mr_ioc *mrioc,
 		return -EFAULT;
 	}
 
+	if (mrioc->pcie_err_recovery) {
+		ioc_err(mrioc, "%s: pcie error recovery in progress!\n", __func__);
+		return -EFAULT;
+	}
+
 	data_out_sz = sizeof(struct rep_manu_request);
 	data_in_sz = sizeof(struct rep_manu_reply);
 	data_out = dma_alloc_coherent(&mrioc->pdev->dev,
@@ -792,6 +797,12 @@ static int mpi3mr_set_identify(struct mpi3mr_ioc *mrioc, u16 handle,
 		return -EFAULT;
 	}
 
+	if (mrioc->pcie_err_recovery) {
+		ioc_err(mrioc, "%s: pcie error recovery in progress!\n",
+		    __func__);
+		return -EFAULT;
+	}
+
 	if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &device_pg0,
 	    sizeof(device_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE, handle))) {
 		ioc_err(mrioc, "%s: device page0 read failed\n", __func__);
@@ -1009,6 +1020,9 @@ mpi3mr_alloc_hba_port(struct mpi3mr_ioc *mrioc, u16 port_id)
 	hba_port->port_id = port_id;
 	ioc_info(mrioc, "hba_port entry: %p, port: %d is added to hba_port list\n",
 	    hba_port, hba_port->port_id);
+	if (mrioc->reset_in_progress ||
+		mrioc->pcie_err_recovery)
+		hba_port->flags = MPI3MR_HBA_PORT_FLAG_NEW;
 	list_add_tail(&hba_port->list, &mrioc->hba_port_table_list);
 	return hba_port;
 }
@@ -1057,7 +1071,7 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_sas_node *mr_sas_node;
 	struct mpi3mr_sas_phy *mr_sas_phy;
 
-	if (mrioc->reset_in_progress)
+	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
 		return;
 
 	spin_lock_irqsave(&mrioc->sas_node_lock, flags);
@@ -1965,7 +1979,7 @@ int mpi3mr_expander_add(struct mpi3mr_ioc *mrioc, u16 handle)
 	if (!handle)
 		return -1;
 
-	if (mrioc->reset_in_progress)
+	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
 		return -1;
 
 	if ((mpi3mr_cfg_get_sas_exp_pg0(mrioc, &ioc_status, &expander_pg0,
@@ -2171,7 +2185,7 @@ void mpi3mr_expander_node_remove(struct mpi3mr_ioc *mrioc,
 	/* remove sibling ports attached to this expander */
 	list_for_each_entry_safe(mr_sas_port, next,
 	   &sas_expander->sas_port_list, port_list) {
-		if (mrioc->reset_in_progress)
+		if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
 			return;
 		if (mr_sas_port->remote_identify.device_type ==
 		    SAS_END_DEVICE)
@@ -2221,7 +2235,7 @@ void mpi3mr_expander_remove(struct mpi3mr_ioc *mrioc, u64 sas_address,
 	struct mpi3mr_sas_node *sas_expander;
 	unsigned long flags;
 
-	if (mrioc->reset_in_progress)
+	if (mrioc->reset_in_progress || mrioc->pcie_err_recovery)
 		return;
 
 	if (!hba_port)
@@ -2532,6 +2546,11 @@ static int mpi3mr_get_expander_phy_error_log(struct mpi3mr_ioc *mrioc,
 		return -EFAULT;
 	}
 
+	if (mrioc->pcie_err_recovery) {
+		ioc_err(mrioc, "%s: pcie error recovery in progress!\n", __func__);
+		return -EFAULT;
+	}
+
 	data_out_sz = sizeof(struct phy_error_log_request);
 	data_in_sz = sizeof(struct phy_error_log_reply);
 	sz = data_out_sz + data_in_sz;
@@ -2791,6 +2810,12 @@ mpi3mr_expander_phy_control(struct mpi3mr_ioc *mrioc,
 		return -EFAULT;
 	}
 
+	if (mrioc->pcie_err_recovery) {
+		ioc_err(mrioc, "%s: pcie error recovery in progress!\n",
+		    __func__);
+		return -EFAULT;
+	}
+
 	data_out_sz = sizeof(struct phy_control_request);
 	data_in_sz = sizeof(struct phy_control_reply);
 	sz = data_out_sz + data_in_sz;
@@ -3214,6 +3239,12 @@ mpi3mr_transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 		goto out;
 	}
 
+	if (mrioc->pcie_err_recovery) {
+		ioc_err(mrioc, "%s: pcie error recovery in progress!\n", __func__);
+		rc = -EFAULT;
+		goto out;
+	}
+
 	rc = mpi3mr_map_smp_buffer(&mrioc->pdev->dev, &job->request_payload,
 	    &dma_addr_out, &dma_len_out, &addr_out);
 	if (rc)
-- 
2.31.1


--00000000000055ab6d060bd8fc37
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQbQYJKoZIhvcNAQcCoIIQXjCCEFoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3EMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBUwwggQ0oAMCAQICDExX4+q15YXlYbDuOzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjExMTQxMjAzMThaFw0yNTExMTQxMjAzMThaMIGO
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xFTATBgNVBAMTDFJhbmphbiBLdW1hcjEoMCYGCSqGSIb3DQEJ
ARYZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAOgccBnKTcRY5ViAG6iAGKWZ8pjYBaC0yPSOnu903VijdPFPnRdvshVcVxr6QvmlBCzKJaet
zZlOdDzH9Sh5FfHxwia1H790mce+cjggA6koNdslP25m4SfoAUcvLxNk1koVjbyxvNPG40Mlg8f8
Dp9JubCHz3kEFHjItKFkpS8CHMR1Hx4Cnws434zD/pz1TMUmYyq1kma0Vi8YPVlwkaHgq4J/9Lw/
GK2Ee6ez7fr/FL1RWbOPVHJR+deNIorOjW7U5HVwnRYhM1OR4mAkrkqcN+3kwae0KmVO3SDKFd7h
Ok4L2e1ixyaRTo379Ur3iVTnagglDOliayMGRITBPe0CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcmFuamFuLmt1bWFyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU8WuEiYXvpeCaubgLCCFoyRBc
8QwwDQYJKoZIhvcNAQELBQADggEBAA5th3yz1fvJCBmK21x68IdDNFC0gmynT76I3fOgslLHc7ey
lC9VXLb+vJ863blS/WxEOwf0fvc0ks7qYWl8xisInHu5AX9glaooGhLImlzE0l9rDf0tcq2kkgc4
CXL9UGDEoqdxfRj3j9xn9fm9gpTBWSck6ufc/8RV1TLVjcZvrYkMqQwoVulGkr+HCnzaEFxBRmO/
nWsVitGa1sKS9usFXoW1bQXgJ9TtRdy8gka8b9SaKnh4TaiEKpdl8ztXhugWp7RpFGVu/ZZ8narx
0H1L9W/UIr3J/uYokdFr+hIrXOfOwJLB18bWOTCVWxTEo4zYC8qZ/h7UcS5aispm/rkxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxMV+PqteWF5WGw7jsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL1VVdLWNPv9E68po8MZOYp3oa5mJ2aI
zIqBGgNATouBMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMTIw
NjE1MjcxNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCE0eO6HYLBFcsPd296PgB0tg0EnHtE0OCBw/KaQI4x6Klj4kEQ
tLMlpy+kOfRIc98RZ5GXVcD6urgnMCAkCBEZr/b+JYylhvN5vHtaa2nWPKEYpmG/azovfbtEvmQ0
SyDr0DP+uWeisjhON4QADvCcVOqpOA859Krvj/XlR8KxipFacvIElof9y4Eh2/EXUUPJ9MpINBv4
AHH9LKBTXMsQiPvkrtyL+WyxINGIoa49EpXsPa5w7zJhI4aZhfvj6nNLDohJof2TkETUCbPd4rnD
qTuLz4j8oAg++YoO4aoC9ZoYPN9LUNM0N3kxzn49uHgPk8rqgput4gEONA/Yogos
--00000000000055ab6d060bd8fc37--
