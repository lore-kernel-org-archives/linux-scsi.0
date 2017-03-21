From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.11-rc3
Date: Tue, 21 Mar 2017 11:08:51 -0400
Message-ID: <1490108931.11580.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Nine small fixes: the biggest is probably finally sorting out Kconfig
issues with lpfc nvme.  There are some performance fixes for megaraid
and hpsa and a static checker fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Don Brace (3):
      scsi: hpsa: do not timeout reset operations
      scsi: hpsa: limit outstanding rescans
      scsi: hpsa: update check for logical volume status

James Smart (1):
      scsi: lpfc: Finalize Kconfig options for nvme

Shivasharan S (4):
      scsi: megaraid_sas: Driver version upgrade
      scsi: megaraid_sas: raid6 also require cpuSel check same as raid5
      scsi: megaraid_sas: add correct return type check for ldio hint logic for raid1
      scsi: megaraid_sas: enable intx only if msix request fails

Tomas Winkler (1):
      scsi: ufs: don't check unsigned type for a negative value

And the diffstat:

 drivers/scsi/Kconfig                        | 14 --------
 drivers/scsi/hpsa.c                         | 53 +++++++++++++++++------------
 drivers/scsi/hpsa.h                         |  1 +
 drivers/scsi/hpsa_cmd.h                     |  2 ++
 drivers/scsi/lpfc/lpfc_attr.c               |  4 +--
 drivers/scsi/lpfc/lpfc_init.c               |  7 ++++
 drivers/scsi/lpfc/lpfc_nvme.c               |  8 ++---
 drivers/scsi/lpfc/lpfc_nvmet.c              |  8 ++---
 drivers/scsi/megaraid/megaraid_sas.h        |  4 +--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 17 ++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 +--
 drivers/scsi/ufs/ufshcd.c                   |  2 +-
 12 files changed, 69 insertions(+), 55 deletions(-)

James

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4bf55b5..3c52867 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1253,20 +1253,6 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
-config LPFC_NVME_INITIATOR
-	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
-	depends on SCSI_LPFC && NVME_FC
-	---help---
-	  This enables NVME Initiator support in the Emulex lpfc driver.
-
-config LPFC_NVME_TARGET
-	bool "Emulex LightPulse Fibre Channel NVME Initiator Support"
-	depends on SCSI_LPFC && NVME_TARGET_FC
-	---help---
-	  This enables NVME Target support in the Emulex lpfc driver.
-	  Target enablement must still be enabled on a per adapter
-	  basis by module parameters.
-
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 524a0c7..0d0be77 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2956,7 +2956,7 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 	/* fill_cmd can't fail here, no data buffer to map. */
 	(void) fill_cmd(c, reset_type, h, NULL, 0, 0,
 			scsi3addr, TYPE_MSG);
-	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, DEFAULT_TIMEOUT);
+	rc = hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
 	if (rc) {
 		dev_warn(&h->pdev->dev, "Failed to send reset command\n");
 		goto out;
@@ -3714,7 +3714,7 @@ static int hpsa_get_volume_status(struct ctlr_info *h,
  *  # (integer code indicating one of several NOT READY states
  *     describing why a volume is to be kept offline)
  */
-static int hpsa_volume_offline(struct ctlr_info *h,
+static unsigned char hpsa_volume_offline(struct ctlr_info *h,
 					unsigned char scsi3addr[])
 {
 	struct CommandList *c;
@@ -3735,7 +3735,7 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 					DEFAULT_TIMEOUT);
 	if (rc) {
 		cmd_free(h, c);
-		return 0;
+		return HPSA_VPD_LV_STATUS_UNSUPPORTED;
 	}
 	sense = c->err_info->SenseInfo;
 	if (c->err_info->SenseLen > sizeof(c->err_info->SenseInfo))
@@ -3746,19 +3746,13 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 	cmd_status = c->err_info->CommandStatus;
 	scsi_status = c->err_info->ScsiStatus;
 	cmd_free(h, c);
-	/* Is the volume 'not ready'? */
-	if (cmd_status != CMD_TARGET_STATUS ||
-		scsi_status != SAM_STAT_CHECK_CONDITION ||
-		sense_key != NOT_READY ||
-		asc != ASC_LUN_NOT_READY)  {
-		return 0;
-	}
 
 	/* Determine the reason for not ready state */
 	ldstat = hpsa_get_volume_status(h, scsi3addr);
 
 	/* Keep volume offline in certain cases: */
 	switch (ldstat) {
+	case HPSA_LV_FAILED:
 	case HPSA_LV_UNDERGOING_ERASE:
 	case HPSA_LV_NOT_AVAILABLE:
 	case HPSA_LV_UNDERGOING_RPI:
@@ -3780,7 +3774,7 @@ static int hpsa_volume_offline(struct ctlr_info *h,
 	default:
 		break;
 	}
-	return 0;
+	return HPSA_LV_OK;
 }
 
 /*
@@ -3853,10 +3847,10 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	/* Do an inquiry to the device to see what it is. */
 	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
 		(unsigned char) OBDR_TAPE_INQ_SIZE) != 0) {
-		/* Inquiry failed (msg printed already) */
 		dev_err(&h->pdev->dev,
-			"hpsa_update_device_info: inquiry failed\n");
-		rc = -EIO;
+			"%s: inquiry failed, device will be skipped.\n",
+			__func__);
+		rc = HPSA_INQUIRY_FAILED;
 		goto bail_out;
 	}
 
@@ -3885,15 +3879,19 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	if ((this_device->devtype == TYPE_DISK ||
 		this_device->devtype == TYPE_ZBC) &&
 		is_logical_dev_addr_mode(scsi3addr)) {
-		int volume_offline;
+		unsigned char volume_offline;
 
 		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
 		volume_offline = hpsa_volume_offline(h, scsi3addr);
-		if (volume_offline < 0 || volume_offline > 0xff)
-			volume_offline = HPSA_VPD_LV_STATUS_UNSUPPORTED;
-		this_device->volume_offline = volume_offline & 0xff;
+		if (volume_offline == HPSA_LV_FAILED) {
+			rc = HPSA_LV_FAILED;
+			dev_err(&h->pdev->dev,
+				"%s: LV failed, device will be skipped.\n",
+				__func__);
+			goto bail_out;
+		}
 	} else {
 		this_device->raid_level = RAID_UNKNOWN;
 		this_device->offload_config = 0;
@@ -4379,8 +4377,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 			goto out;
 		}
 		if (rc) {
-			dev_warn(&h->pdev->dev,
-				"Inquiry failed, skipping device.\n");
+			h->drv_req_rescan = 1;
 			continue;
 		}
 
@@ -5558,7 +5555,7 @@ static void hpsa_scan_complete(struct ctlr_info *h)
 
 	spin_lock_irqsave(&h->scan_lock, flags);
 	h->scan_finished = 1;
-	wake_up_all(&h->scan_wait_queue);
+	wake_up(&h->scan_wait_queue);
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 }
 
@@ -5576,11 +5573,23 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 	if (unlikely(lockup_detected(h)))
 		return hpsa_scan_complete(h);
 
+	/*
+	 * If a scan is already waiting to run, no need to add another
+	 */
+	spin_lock_irqsave(&h->scan_lock, flags);
+	if (h->scan_waiting) {
+		spin_unlock_irqrestore(&h->scan_lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&h->scan_lock, flags);
+
 	/* wait until any scan already in progress is finished. */
 	while (1) {
 		spin_lock_irqsave(&h->scan_lock, flags);
 		if (h->scan_finished)
 			break;
+		h->scan_waiting = 1;
 		spin_unlock_irqrestore(&h->scan_lock, flags);
 		wait_event(h->scan_wait_queue, h->scan_finished);
 		/* Note: We don't need to worry about a race between this
@@ -5590,6 +5599,7 @@ static void hpsa_scan_start(struct Scsi_Host *sh)
 		 */
 	}
 	h->scan_finished = 0; /* mark scan as in progress */
+	h->scan_waiting = 0;
 	spin_unlock_irqrestore(&h->scan_lock, flags);
 
 	if (unlikely(lockup_detected(h)))
@@ -8792,6 +8802,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	init_waitqueue_head(&h->event_sync_wait_queue);
 	mutex_init(&h->reset_mutex);
 	h->scan_finished = 1; /* no scan currently in progress */
+	h->scan_waiting = 0;
 
 	pci_set_drvdata(pdev, h);
 	h->ndevices = 0;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index bf6cdc1..6f04f2a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -201,6 +201,7 @@ struct ctlr_info {
 	dma_addr_t		errinfo_pool_dhandle;
 	unsigned long  		*cmd_pool_bits;
 	int			scan_finished;
+	u8			scan_waiting : 1;
 	spinlock_t		scan_lock;
 	wait_queue_head_t	scan_wait_queue;
 
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index a584cdf..5961705 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -156,6 +156,7 @@
 #define CFGTBL_BusType_Fibre2G  0x00000200l
 
 /* VPD Inquiry types */
+#define HPSA_INQUIRY_FAILED		0x02
 #define HPSA_VPD_SUPPORTED_PAGES        0x00
 #define HPSA_VPD_LV_DEVICE_ID           0x83
 #define HPSA_VPD_LV_DEVICE_GEOMETRY     0xC1
@@ -166,6 +167,7 @@
 /* Logical volume states */
 #define HPSA_VPD_LV_STATUS_UNSUPPORTED			0xff
 #define HPSA_LV_OK                                      0x0
+#define HPSA_LV_FAILED					0x01
 #define HPSA_LV_NOT_AVAILABLE				0x0b
 #define HPSA_LV_UNDERGOING_ERASE			0x0F
 #define HPSA_LV_UNDERGOING_RPI				0x12
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 5c3be3e..22819af 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3315,9 +3315,9 @@ LPFC_ATTR_R(nvmet_mrq_post, LPFC_DEF_MRQ_POST,
  * lpfc_enable_fc4_type: Defines what FC4 types are supported.
  * Supported Values:  1 - register just FCP
  *                    3 - register both FCP and NVME
- * Supported values are [1,3]. Default value is 3
+ * Supported values are [1,3]. Default value is 1
  */
-LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_BOTH,
+LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
 	    LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
 	    "Define fc4 type to register with fabric.");
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2697d49..6cc561b 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5891,10 +5891,17 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		/* Check to see if it matches any module parameter */
 		for (i = 0; i < lpfc_enable_nvmet_cnt; i++) {
 			if (wwn == lpfc_enable_nvmet[i]) {
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 						"6017 NVME Target %016llx\n",
 						wwn);
 				phba->nvmet_support = 1; /* a match */
+#else
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"6021 Can't enable NVME Target."
+						" NVME_TARGET_FC infrastructure"
+						" is not in kernel\n");
+#endif
 			}
 		}
 	}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 0a4c190..0024de1 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2149,7 +2149,7 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 	/* localport is allocated from the stack, but the registration
 	 * call allocates heap memory as well as the private area.
 	 */
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	ret = nvme_fc_register_localport(&nfcp_info, &lpfc_nvme_template,
 					 &vport->phba->pcidev->dev, &localport);
 #else
@@ -2190,7 +2190,7 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 void
 lpfc_nvme_destroy_localport(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
 	struct lpfc_nvme_rport *rport = NULL, *rport_next = NULL;
@@ -2274,7 +2274,7 @@ lpfc_nvme_update_localport(struct lpfc_vport *vport)
 int
 lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	int ret = 0;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
@@ -2403,7 +2403,7 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 void
 lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
-#ifdef CONFIG_LPFC_NVME_INITIATOR
+#if (IS_ENABLED(CONFIG_NVME_FC))
 	int ret;
 	struct nvme_fc_local_port *localport;
 	struct lpfc_nvme_lport *lport;
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index b7739a5..7ca868f 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -671,7 +671,7 @@ lpfc_nvmet_create_targetport(struct lpfc_hba *phba)
 	lpfc_tgttemplate.target_features = NVMET_FCTGTFEAT_READDATA_RSP |
 					   NVMET_FCTGTFEAT_NEEDS_CMD_CPUSCHED;
 
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	error = nvmet_fc_register_targetport(&pinfo, &lpfc_tgttemplate,
 					     &phba->pcidev->dev,
 					     &phba->targetport);
@@ -756,7 +756,7 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 void
 lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 {
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_tgtport *tgtp;
 
 	if (phba->nvmet_support == 0)
@@ -788,7 +788,7 @@ static void
 lpfc_nvmet_unsol_ls_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			   struct hbq_dmabuf *nvmebuf)
 {
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
 	struct lpfc_nvmet_rcv_ctx *ctxp;
@@ -891,7 +891,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 			    struct rqb_dmabuf *nvmebuf,
 			    uint64_t isr_timestamp)
 {
-#ifdef CONFIG_LPFC_NVME_TARGET
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct fc_frame_header *fc_hdr;
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index e7e5974..2b209bb 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.701.16.00-rc1"
-#define MEGASAS_RELDATE				"February 2, 2017"
+#define MEGASAS_VERSION				"07.701.17.00-rc1"
+#define MEGASAS_RELDATE				"March 2, 2017"
 
 /*
  * Device IDs
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 7ac9a9e..0016f12 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1963,6 +1963,9 @@ static int megasas_slave_alloc(struct scsi_device *sdev)
 	if (!mr_device_priv_data)
 		return -ENOMEM;
 	sdev->hostdata = mr_device_priv_data;
+
+	atomic_set(&mr_device_priv_data->r1_ldio_hint,
+		   instance->r1_ldio_hint_default);
 	return 0;
 }
 
@@ -5034,10 +5037,12 @@ megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 					 &instance->irq_context[j]);
 			/* Retry irq register for IO_APIC*/
 			instance->msix_vectors = 0;
-			if (is_probe)
+			if (is_probe) {
+				pci_free_irq_vectors(instance->pdev);
 				return megasas_setup_irqs_ioapic(instance);
-			else
+			} else {
 				return -1;
+			}
 		}
 	}
 	return 0;
@@ -5277,9 +5282,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			MPI2_REPLY_POST_HOST_INDEX_OFFSET);
 	}
 
-	i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
-	if (i < 0)
-		goto fail_setup_irqs;
+	if (!instance->msix_vectors) {
+		i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
+		if (i < 0)
+			goto fail_setup_irqs;
+	}
 
 	dev_info(&instance->pdev->dev,
 		"firmware supports msix\t: (%d)", fw_msix_count);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 29650ba..f990ab4d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2159,7 +2159,7 @@ megasas_set_raidflag_cpu_affinity(union RAID_CONTEXT_UNION *praid_context,
 				cpu_sel = MR_RAID_CTX_CPUSEL_1;
 
 			if (is_stream_detected(rctx_g35) &&
-			    (raid->level == 5) &&
+			    ((raid->level == 5) || (raid->level == 6)) &&
 			    (raid->writeMode == MR_RL_WRITE_THROUGH_MODE) &&
 			    (cpu_sel == MR_RAID_CTX_CPUSEL_FCFS))
 				cpu_sel = MR_RAID_CTX_CPUSEL_0;
@@ -2338,7 +2338,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 				fp_possible = false;
 				atomic_dec(&instance->fw_outstanding);
 			} else if ((scsi_buff_len > MR_LARGE_IO_MIN_SIZE) ||
-				   atomic_dec_if_positive(&mrdev_priv->r1_ldio_hint)) {
+				   (atomic_dec_if_positive(&mrdev_priv->r1_ldio_hint) > 0)) {
 				fp_possible = false;
 				atomic_dec(&instance->fw_outstanding);
 				if (scsi_buff_len > MR_LARGE_IO_MIN_SIZE)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1359913..e8c26e6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7642,7 +7642,7 @@ static inline ssize_t ufshcd_pm_lvl_store(struct device *dev,
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
-	if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))
+	if (value >= UFS_PM_LVL_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
