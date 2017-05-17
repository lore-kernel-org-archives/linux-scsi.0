From: John Garry <john.garry@huawei.com>
Subject: [PATCH 09/22] scsi: hisi_sas: retrieve SAS address for pci-based controller
Date: Wed, 17 May 2017 18:49:44 +0800
Message-ID: <1495018197-120535-10-git-send-email-john.garry@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

For a pci-based controller, retrieve the SAS address from the
ACPI tables.

The retrieval is based on the ACPI device node name. Sample is
as follows:
Scope(_SB)
{
    Device(SAS0) {
		Name(_HID, "HISI0163")
		Name (_DSD, Package () {
              ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
              Package () {
				Package (2) {"sas-addr", Package() {0x50, 0x01, 0x88, 0x20, 0x16, 00, 00, 0x00}},
              }
          })
	}
}

If the ACPI node or node property is not available, then we fall
back on a default address.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h          |   2 +
 drivers/scsi/hisi_sas/hisi_sas_pci_init.c | 104 ++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |   2 +-
 3 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9bc9550..9fd874d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -190,6 +190,7 @@ struct hisi_sas_pci_hw {
 	int n_phy;
 	int queue_count;
 	const struct hisi_sas_hw *hw;
+	const char *fw_name;
 };
 
 struct hisi_hba {
@@ -250,6 +251,7 @@ struct hisi_hba {
 	struct hisi_sas_slot	*slot_info;
 	unsigned long flags;
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
+	const char *fw_name;
 	unsigned long sata_dev_bitmap[BITS_TO_LONGS(HISI_SAS_MAX_DEVICES)];
 	struct work_struct rst_work;
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_pci_init.c b/drivers/scsi/hisi_sas/hisi_sas_pci_init.c
index e00b482..6d92893 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_pci_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_pci_init.c
@@ -11,6 +11,107 @@
 #include "hisi_sas.h"
 #define DRV_NAME "hisi_sas_pci"
 
+
+static const u8 default_sas_addr[SAS_ADDR_SIZE] = {
+		0x50, 0x01, 0x88, 0x20, 0x16, 0x0, 0x0, 0x0};
+static void hisi_sas_pci_set_sas_addr(struct hisi_hba *hisi_hba);
+
+static void
+hisi_sas_pci_set_default_sas_addr(struct hisi_hba *hisi_hba)
+{
+	dev_warn(hisi_hba->dev, "using default SAS ADDR\n");
+	memcpy(hisi_hba->sas_addr, default_sas_addr, SAS_ADDR_SIZE);
+}
+
+#if defined(CONFIG_ACPI)
+static int
+acpi_get_sas_address(struct device *dev, struct acpi_device *adev,
+				u8 *dst)
+{
+	u8 addr[SAS_ADDR_SIZE];
+	int rc;
+
+	rc = fwnode_property_read_u8_array(acpi_fwnode_handle(adev),
+					    "sas-addr", addr, SAS_ADDR_SIZE);
+	if (rc) {
+		dev_warn(dev, "could not read sas-addr (%d)\n", rc);
+		return rc;
+	}
+
+	dev_info(dev, "SAS address set to: %pM\n", addr);
+
+	memcpy(dst, addr, SAS_ADDR_SIZE);
+
+	return 0;
+}
+
+static acpi_status
+hisi_sas_acpi_match_id(acpi_handle handle, u32 lvl,
+		       void *context, void **ret_val)
+{
+	struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct hisi_hba *hisi_hba = context;
+	struct device *dev = hisi_hba->dev;
+	struct acpi_device *adev;
+	int rc;
+
+	if (ACPI_FAILURE(acpi_get_name(handle, ACPI_SINGLE_NAME, &string))) {
+		dev_warn(dev, "Invalid link device\n");
+		return AE_OK;
+	}
+
+	if (strncmp(string.pointer, hisi_hba->fw_name, 4))
+		return AE_OK;
+
+	rc = acpi_bus_get_device(handle, &adev);
+
+	if (rc == 0)
+		rc = acpi_get_sas_address(dev, adev, hisi_hba->sas_addr);
+	else
+		dev_warn(dev, "could not get acpi bus device (%d)\n", rc);
+
+	if (rc == 0)
+		*(acpi_handle *)ret_val = handle;
+
+	kfree(string.pointer);
+	return AE_CTRL_TERMINATE;
+}
+
+static acpi_status
+hisi_sas_acpi_set_sas_addr(struct hisi_hba *hisi_hba)
+{
+	acpi_status status1;
+	acpi_handle *acpi_handle = NULL;
+
+	status1 = acpi_get_devices(NULL, hisi_sas_acpi_match_id,
+				   hisi_hba, (void **)&acpi_handle);
+
+	if (status1 != AE_OK)
+		return status1;
+
+	if (!acpi_handle)
+		return AE_ERROR;
+
+	return AE_OK;
+}
+#else
+static acpi_status
+hisi_sas_acpi_set_sas_addr(struct hisi_hba *hisi_hba)
+{
+	return AE_ERROR;
+}
+#endif
+
+static void hisi_sas_pci_set_sas_addr(struct hisi_hba *hisi_hba)
+{
+	acpi_status status = AE_ERROR;
+	if (!acpi_disabled)
+		status = hisi_sas_acpi_set_sas_addr(hisi_hba);
+	if (status == AE_OK)
+		return;
+	hisi_sas_pci_set_default_sas_addr(hisi_hba);
+}
+
 static struct Scsi_Host *
 hisi_sas_shost_alloc_pci(struct pci_dev *pdev,
 			 const struct hisi_sas_pci_hw *hw)
@@ -32,6 +133,9 @@
 	hisi_hba->shost = shost;
 	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
 
+	hisi_hba->fw_name = hw->fw_name;
+	hisi_sas_pci_set_sas_addr(hisi_hba);
+
 	init_timer(&hisi_hba->timer);
 
 	if (hisi_sas_alloc(hisi_hba, shost)) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 80707f6..68b9b0e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -20,7 +20,7 @@ enum {
 };
 
 static const struct hisi_sas_pci_hw hisi_sas_pci_hw_info[] = {
-	[hip08] = {8, 16, &hisi_sas_v3_hw},
+	[hip08] = {8, 16, &hisi_sas_v3_hw, "SAS0"},
 };
 
 static const struct pci_device_id sas_v3_pci_table[] = {
-- 
1.9.1
