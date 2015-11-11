From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 06/25] mpt3sas: Define 'hba_mpi_version_belonged' IOC variable
Date: Wed, 11 Nov 2015 17:30:22 +0530
Message-ID: <1447243241-10912-7-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

1. Use 'hba_mpi_version_belonged' IOC varable to uniquely
identify each individual generation driver functionality at
runtime.

2. Declared global variable 'driver_name' and used
this variable while reserving PCI regions and while
allocating the IRQ's.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_module.c |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c   |  8 +++----
 drivers/scsi/mpt3sas/mpt3sas_base.h   |  3 +++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c    | 18 +++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_module.c |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  | 39 ++++++++++++++++++++++++++++++++++-
 6 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_module.c b/drivers/scsi/mpt2sas/mpt2sas_module.c
index 2b70693..d407ed0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_module.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_module.c
@@ -196,6 +196,7 @@ _mpt2sas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!shost)
 		return -ENODEV;
 
+	sprintf(driver_name, "%s", MPT2SAS_DRIVER_NAME);
 	rv = scsih_probe(pdev, shost);
 	return rv;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 302f02a..8a7f93e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1643,10 +1643,10 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
-		    MPT3SAS_DRIVER_NAME, ioc->id, index);
+		    driver_name, ioc->id, index);
 	else
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
-		    MPT3SAS_DRIVER_NAME, ioc->id);
+		    driver_name, ioc->id);
 	r = request_irq(vector, _base_interrupt, IRQF_SHARED, reply_q->name,
 	    reply_q);
 	if (r) {
@@ -1872,7 +1872,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 
 
 	if (pci_request_selected_regions(pdev, ioc->bars,
-	    MPT3SAS_DRIVER_NAME)) {
+	    driver_name)) {
 		pr_warn(MPT3SAS_FMT "pci_request_selected_regions: failed\n",
 			ioc->name);
 		ioc->bars = 0;
@@ -4021,7 +4021,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request.WhoInit = MPI2_WHOINIT_HOST_DRIVER;
 	mpi_request.VF_ID = 0; /* TODO */
 	mpi_request.VP_ID = 0;
-	mpi_request.MsgVersion = cpu_to_le16(MPI25_VERSION);
+	mpi_request.MsgVersion = cpu_to_le16(ioc->hba_mpi_version_belonged);
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
 
 	if (_base_is_controller_msix_enabled(ioc))
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 0f86729..4c9a154 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -870,6 +870,7 @@ struct MPT3SAS_ADAPTER {
 	MPT_BUILD_SG    build_sg;
 	MPT_BUILD_ZERO_LEN_SGE build_zero_len_sge;
 	u16             sge_size_ieee;
+	u16		hba_mpi_version_belonged;
 
 	/* function ptr for MPI sg elements only */
 	MPT_BUILD_SG    build_sg_mpi;
@@ -1023,6 +1024,8 @@ typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 
 /* base shared API */
 extern struct list_head mpt3sas_ioc_list;
+extern char    driver_name[MPT_NAME_LENGTH];
+
 void mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_base_stop_watchdog(struct MPT3SAS_ADAPTER *ioc);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index ffe7982..8b46cbf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1023,7 +1023,6 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	    __func__));
 
 	memset(&karg, 0 , sizeof(karg));
-	karg.adapter_type = MPT3_IOCTL_INTERFACE_SAS3;
 	if (ioc->pfacts)
 		karg.port_number = ioc->pfacts[0].PortNumber;
 	karg.hw_rev = ioc->pdev->revision;
@@ -1035,9 +1034,22 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	karg.pci_information.u.bits.function = PCI_FUNC(ioc->pdev->devfn);
 	karg.pci_information.segment_id = pci_domain_nr(ioc->pdev->bus);
 	karg.firmware_version = ioc->facts.FWVersion.Word;
-	strcpy(karg.driver_version, MPT3SAS_DRIVER_NAME);
+	strcpy(karg.driver_version, driver_name);
 	strcat(karg.driver_version, "-");
-	strcat(karg.driver_version, MPT3SAS_DRIVER_VERSION);
+	switch  (ioc->hba_mpi_version_belonged) {
+	case MPI2_VERSION:
+		karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
+		strcat(karg.driver_version, MPT2SAS_DRIVER_VERSION);
+		break;
+	case MPI25_VERSION:
+		karg.adapter_type = MPT3_IOCTL_INTERFACE_SAS3;
+		strcat(karg.driver_version, MPT3SAS_DRIVER_VERSION);
+		break;
+	}
+	if (ioc->hba_mpi_version_belonged == MPI2_VERSION)
+		strcat(karg.driver_version, MPT2SAS_DRIVER_VERSION);
+	else
+		strcat(karg.driver_version, MPT3SAS_DRIVER_VERSION);
 	karg.bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
 	if (copy_to_user(arg, &karg, sizeof(karg))) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_module.c b/drivers/scsi/mpt3sas/mpt3sas_module.c
index e5f43ba..322dc8d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_module.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_module.c
@@ -168,6 +168,7 @@ _mpt3sas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!shost)
 		return -ENODEV;
 
+	sprintf(driver_name, "%s", MPT3SAS_DRIVER_NAME);
 	rv = scsih_probe(pdev, shost);
 	return rv;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 56726a0..233627d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -73,6 +73,7 @@ static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
+char    driver_name[MPT_NAME_LENGTH];
 
 /* local parameters */
 static u8 scsi_io_cb_idx = -1;
@@ -7924,6 +7925,39 @@ scsih_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	return 1;
 }
 
+void
+_scsih_determine_hba_mpi_version(struct MPT3SAS_ADAPTER *ioc) {
+
+	switch (ioc->pdev->device) {
+	case MPI2_MFGPAGE_DEVID_SAS2004:
+	case MPI2_MFGPAGE_DEVID_SAS2008:
+	case MPI2_MFGPAGE_DEVID_SAS2108_1:
+	case MPI2_MFGPAGE_DEVID_SAS2108_2:
+	case MPI2_MFGPAGE_DEVID_SAS2108_3:
+	case MPI2_MFGPAGE_DEVID_SAS2116_1:
+	case MPI2_MFGPAGE_DEVID_SAS2116_2:
+	case MPI2_MFGPAGE_DEVID_SAS2208_1:
+	case MPI2_MFGPAGE_DEVID_SAS2208_2:
+	case MPI2_MFGPAGE_DEVID_SAS2208_3:
+	case MPI2_MFGPAGE_DEVID_SAS2208_4:
+	case MPI2_MFGPAGE_DEVID_SAS2208_5:
+	case MPI2_MFGPAGE_DEVID_SAS2208_6:
+	case MPI2_MFGPAGE_DEVID_SAS2308_1:
+	case MPI2_MFGPAGE_DEVID_SAS2308_2:
+	case MPI2_MFGPAGE_DEVID_SAS2308_3:
+		ioc->hba_mpi_version_belonged = MPI2_VERSION;
+		break;
+	case MPI25_MFGPAGE_DEVID_SAS3004:
+	case MPI25_MFGPAGE_DEVID_SAS3008:
+	case MPI25_MFGPAGE_DEVID_SAS3108_1:
+	case MPI25_MFGPAGE_DEVID_SAS3108_2:
+	case MPI25_MFGPAGE_DEVID_SAS3108_5:
+	case MPI25_MFGPAGE_DEVID_SAS3108_6:
+		ioc->hba_mpi_version_belonged = MPI25_VERSION;
+		break;
+	}
+}
+
 /**
  * scsih_probe - attach and add scsi host
  * @pdev: PCI device struct
@@ -7944,7 +7978,7 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
 	ioc->shost = shost;
 	ioc->id = mpt_ids++;
-	sprintf(ioc->name, "%s%d", MPT3SAS_DRIVER_NAME, ioc->id);
+
 	ioc->pdev = pdev;
 	ioc->scsi_io_cb_idx = scsi_io_cb_idx;
 	ioc->tm_cb_idx = tm_cb_idx;
@@ -7979,6 +8013,9 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
 
+	_scsih_determine_hba_mpi_version(ioc);
+	sprintf(ioc->name, "%s_cm%d", driver_name, ioc->id);
+
 	/* init shost parameters */
 	shost->max_cmd_len = 32;
 	shost->max_lun = max_lun;
-- 
2.0.2
