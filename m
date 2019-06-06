From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: [PATCH v2] drivers: scsi: remove unnecessary #ifdef MODULE
Date: Thu,  6 Jun 2019 17:04:31 +0200
Message-ID: <1559833471-30534-1-git-send-email-info@metux.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: khalid@gonehiking.org, jejb@linux.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Enrico Weigelt <info@metux.net>

The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
so the extra check here is not necessary.

Changes v2:
    * make dptids const to fix warning on unused variable

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/scsi/BusLogic.c | 2 --
 drivers/scsi/dpt_i2o.c  | 5 +----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index e41e51f..68cc68b 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3893,7 +3893,6 @@ static void __exit blogic_exit(void)
 
 __setup("BusLogic=", blogic_setup);
 
-#ifdef MODULE
 /*static struct pci_device_id blogic_pci_tbl[] = {
 	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
@@ -3909,7 +3908,6 @@ static void __exit blogic_exit(void)
 	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT)},
 	{0, },
 };
-#endif
 MODULE_DEVICE_TABLE(pci, blogic_pci_tbl);
 
 module_init(blogic_init);
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index abc74fd..162d56a 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -177,14 +177,11 @@ static u8 adpt_read_blink_led(adpt_hba* host)
  *============================================================================
  */
 
-#ifdef MODULE
-static struct pci_device_id dptids[] = {
+static const struct pci_device_id dptids[] = {
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, }
 };
-#endif
-
 MODULE_DEVICE_TABLE(pci,dptids);
 
 static int adpt_detect(struct scsi_host_template* sht)
-- 
1.9.1
