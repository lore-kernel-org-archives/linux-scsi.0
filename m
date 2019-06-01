From: "Enrico Weigelt, metux IT consult" <info@metux.net>
Subject: [PATCH 2/3] drivers: scsi: remove unnecessary #ifdef MODULE
Date: Sat,  1 Jun 2019 16:01:39 +0200
Message-ID: <1559397700-15585-3-git-send-email-info@metux.net>
References: <1559397700-15585-1-git-send-email-info@metux.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559397700-15585-1-git-send-email-info@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, viresh.kumar@linaro.org, jdelvare@suse.com, linux@roeck-us.net, khalid@gonehiking.org, jejb@linux.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com, linux-pm@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The MODULE_DEVICE_TABLE() macro already checks for MODULE defined,
so the extra check here is not necessary.

Signed-off-by: Enrico Weigelt <info@metux.net>
---
 drivers/scsi/BusLogic.c | 2 --
 drivers/scsi/dpt_i2o.c  | 3 ---
 2 files changed, 5 deletions(-)

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
index abc74fd..9b28f9f 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -177,14 +177,11 @@ static u8 adpt_read_blink_led(adpt_hba* host)
  *============================================================================
  */
 
-#ifdef MODULE
 static struct pci_device_id dptids[] = {
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
