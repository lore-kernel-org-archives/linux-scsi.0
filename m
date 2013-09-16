From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 3/5] pm80xx: Phy settings support for motherboard controller.
Date: Mon, 16 Sep 2013 08:55:39 -0700
Message-ID: <523729FB.6090408@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:34571 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab3IPPw5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Sep 2013 11:52:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Viswas.G@pmcs.com, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Nikith.Ganigarakoppal@pmcs.com

>From ab4925b27bd0717c287fe617e6343ea82cd5e6d0 Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Tue, 3 Sep 2013 15:32:05 +0530
Subject: [PATCH 3/5] pm80xx: Phy settings support for motherboard controller.

Phy profile implementation to support phy settings feature
for motherboard controllers.Display controller BIOS version.

Signed-off-by: Anandkumar.Santhanam@pmcs.com

---
 drivers/scsi/pm8001/pm8001_ctl.c  |   34 ++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |    2 +
 drivers/scsi/pm8001/pm8001_hwi.c  |   10 ++++++
 drivers/scsi/pm8001/pm8001_init.c |   28 +++++++++++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |    3 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  |   61 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h  |    4 ++
 7 files changed, 139 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index d99f41c..5a19e19 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -309,6 +309,39 @@ static ssize_t pm8001_ctl_aap_log_show(struct device *cdev,
 }
 static DEVICE_ATTR(aap_log, S_IRUGO, pm8001_ctl_aap_log_show, NULL);
 /**
+ * pm8001_ctl_bios_version_show - Bios version Display
+ * @cdev:pointer to embedded class device
+ * @buf:the buffer returned
+ * A sysfs 'read-only' shost attribute.
+ */
+static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
+	struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	char *str = buf;
+	void *virt_addr;
+	int bios_index;
+	DECLARE_COMPLETION_ONSTACK(completion);
+	struct pm8001_ioctl_payload payload;
+
+	pm8001_ha->nvmd_completion = &completion;
+	payload.minor_function = 7;
+	payload.offset = 0;
+	payload.length = 4096;
+	payload.func_specific = kzalloc(4096, GFP_KERNEL);
+	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
+	wait_for_completion(&completion);
+	virt_addr = pm8001_ha->memoryMap.region[NVMD].virt_ptr;
+	for (bios_index = BIOSOFFSET; bios_index < BIOS_OFFSET_LIMIT;
+		bios_index++)
+		str += sprintf(str, "%c",
+			*((u8 *)((u8 *)virt_addr+bios_index)));
+	return str - buf;
+}
+static DEVICE_ATTR(bios_version, S_IRUGO, pm8001_ctl_bios_version_show, NULL);
+/**
  * pm8001_ctl_aap_log_show - IOP event log
  * @cdev: pointer to embedded class device
  * @buf: the buffer returned
@@ -609,6 +642,7 @@ struct device_attribute *pm8001_host_attrs[] = {
 	&dev_attr_sas_spec_support,
 	&dev_attr_logging_level,
 	&dev_attr_host_sas_address,
+	&dev_attr_bios_version,
 	NULL,
 };
 
diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index 63ad4aa..c6d8fdd 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -45,6 +45,8 @@
 #define HEADER_LEN			28
 #define SIZE_OFFSET			16
 
+#define BIOSOFFSET			56
+#define BIOS_OFFSET_LIMIT		61
 
 #define FLASH_OK                        0x000000
 #define FAIL_OPEN_BIOS_FILE             0x000100
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 4a21957..2fd8c38 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4778,6 +4778,16 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
 		    cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);
 		break;
 	}
+	case IOP_RDUMP: {
+		nvmd_req.len_ir_vpdd = cpu_to_le32(IPMode | IOP_RDUMP);
+		nvmd_req.resp_len = cpu_to_le32(ioctl_payload->length);
+		nvmd_req.vpd_offset = cpu_to_le32(ioctl_payload->offset);
+		nvmd_req.resp_addr_hi =
+		cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_hi);
+		nvmd_req.resp_addr_lo =
+		cpu_to_le32(pm8001_ha->memoryMap.region[NVMD].phys_addr_lo);
+		break;
+	}
 	default:
 		break;
 	}
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 09e557b..e697cee 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -667,6 +667,31 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 #endif
 }
 
+/*
+ * pm8001_get_phy_settings_info : Read phy setting values.
+ * @pm8001_ha : our hba.
+ */
+void pm8001_get_phy_settings_info(struct pm8001_hba_info *pm8001_ha)
+{
+
+#ifdef PM8001_READ_VPD
+	/*OPTION ROM FLASH read for the SPC cards */
+	DECLARE_COMPLETION_ONSTACK(completion);
+	struct pm8001_ioctl_payload payload;
+
+	pm8001_ha->nvmd_completion = &completion;
+	/* SAS ADDRESS read from flash / EEPROM */
+	payload.minor_function = 6;
+	payload.offset = 0;
+	payload.length = 4096;
+	payload.func_specific = kzalloc(4096, GFP_KERNEL);
+	/* Read phy setting values from flash */
+	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
+	wait_for_completion(&completion);
+	pm8001_set_phy_profile(pm8001_ha, sizeof(u8), payload.func_specific);
+#endif
+}
+
 #ifdef PM8001_USE_MSIX
 /**
  * pm8001_setup_msix - enable MSI-X interrupt
@@ -847,6 +872,9 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	}
 
 	pm8001_init_sas_add(pm8001_ha);
+	/* phy setting support for motherboard controller */
+	if (pdev->subsystem_vendor != PCI_VENDOR_ID_ADAPTEC2)
+		pm8001_get_phy_settings_info(pm8001_ha);
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
 	if (rc)
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index a4fe235..fcdc4d4 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -633,7 +633,8 @@ struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
 int pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha);
 
 int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue);
-
+void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
+	u32 length, u8 *buf);
 /* ctl shared API */
 extern struct device_attribute *pm8001_host_attrs[];
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 158e91d..70fa7d9 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3104,9 +3104,27 @@ static int mpi_get_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
-	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" pm80xx_addition_functionality\n"));
+	u8 page_code;
+	struct set_phy_profile_resp *pPayload =
+		(struct set_phy_profile_resp *)(piomb + 4);
+	u32 ppc_phyid = le32_to_cpu(pPayload->ppc_phyid);
+	u32 status = le32_to_cpu(pPayload->status);
 
+	page_code = (u8)((ppc_phyid & 0xFF00) >> 8);
+	if (status) {
+		/* status is FAILED */
+		PM8001_FAIL_DBG(pm8001_ha,
+			pm8001_printk("PhyProfile command failed  with status "
+			"0x%08X \n", status));
+		return -1;
+	} else {
+		if (page_code != SAS_PHY_ANALOG_SETTINGS_PAGE) {
+			PM8001_FAIL_DBG(pm8001_ha,
+				pm8001_printk("Invalid page code 0x%X\n",
+					page_code));
+			return -1;
+		}
+	}
 	return 0;
 }
 
@@ -4128,6 +4146,45 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	return IRQ_HANDLED;
 }
 
+void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
+	u32 operation, u32 phyid, u32 length, u32 *buf)
+{
+	u32 tag , i, j = 0;
+	int rc;
+	struct set_phy_profile_req payload;
+	struct inbound_queue_table *circularQ;
+	u32 opc = OPC_INB_SET_PHY_PROFILE;
+
+	memset(&payload, 0, sizeof(payload));
+	rc = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (rc)
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid tag\n"));
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+	payload.tag = cpu_to_le32(tag);
+	payload.ppc_phyid = (((operation & 0xF) << 8) | (phyid  & 0xFF));
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk(" phy profile command for phy %x ,length is %d\n",
+			payload.ppc_phyid, length));
+	for (i = length ; i < (length + PHY_DWORD_LENGTH - 1) ; i++) {
+		payload.reserved[j] =  cpu_to_le32(*((u32 *)buf + i));
+		j++;
+	}
+	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
+}
+
+void pm8001_set_phy_profile(struct pm8001_hba_info *pm8001_ha,
+	u32 length, u8 *buf)
+{
+	u32 page_code, i;
+
+	page_code = SAS_PHY_ANALOG_SETTINGS_PAGE;
+	for (i = 0 ; i < pm8001_ha->chip->n_phy ; i++) {
+		mpi_set_phy_profile_req(pm8001_ha,
+			SAS_PHY_ANALOG_SETTINGS_PAGE, i, length, (u32 *)buf);
+		length = length + PHY_DWORD_LENGTH;
+	}
+	PM8001_INIT_DBG(pm8001_ha, pm8001_printk("phy settings completed\n"));
+}
 const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.name			= "pmc80xx",
 	.chip_init		= pm80xx_chip_init,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 9a9116d..872d5cf 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -170,6 +170,10 @@
 #define LINKRATE_60			(0x06 << 8)
 #define LINKRATE_120			(0x08 << 8)
 
+/* phy_profile */
+#define SAS_PHY_ANALOG_SETTINGS_PAGE	0x04
+#define PHY_DWORD_LENGTH		0xC
+
 /* Thermal related */
 #define	THERMAL_ENABLE			0x1
 #define	THERMAL_LOG_ENABLE		0x1
-- 
1.7.1

