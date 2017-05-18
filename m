From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: smartpqi: mark PM functions as __maybe_unused
Date: Thu, 18 May 2017 10:32:18 +0200
Message-ID: <20170518083243.2927102-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kevin Barnett <kevin.barnett@hpe.com>, Scott Benesh <scott.benesh@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The newly added suspend/resume support causes harmless warnings
when CONFIG_PM is disabled:

smartpqi/smartpqi_init.c:5147:12: error: 'pqi_ctrl_wait_for_pending_io' defined but not used [-Werror=unused-function]
smartpqi/smartpqi_init.c:2019:13: error: 'pqi_wait_until_lun_reset_finished' defined but not used [-Werror=unused-function]
smartpqi/smartpqi_init.c:2013:13: error: 'pqi_wait_until_scan_finished' defined but not used [-Werror=unused-function]

We can avoid the warnings by removing the #ifdef around the
handlers and instead marking them as __maybe_unused, which will
let gcc drop the unused code silently.

Fixes: f44d210312a6 ("scsi: smartpqi: add suspend and resume support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0b11ae7e96dc..cb8f886e705c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6213,8 +6213,6 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-
 static void pqi_reinit_queues(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned int i;
@@ -6321,8 +6319,6 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 	return 0;
 }
 
-#endif /* CONFIG_PM */
-
 static inline int pqi_set_pcie_completion_timeout(struct pci_dev *pci_dev,
 	u16 timeout)
 {
@@ -6696,9 +6692,7 @@ static void pqi_process_module_params(void)
 	pqi_process_lockup_action_param();
 }
 
-#if defined(CONFIG_PM)
-
-static int pqi_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct pqi_ctrl_info *ctrl_info;
 
@@ -6728,7 +6722,7 @@ static int pqi_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	return 0;
 }
 
-static int pqi_resume(struct pci_dev *pci_dev)
+static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
@@ -6759,8 +6753,6 @@ static int pqi_resume(struct pci_dev *pci_dev)
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 
-#endif /* CONFIG_PM */
-
 /* Define the PCI IDs for the controllers that we support. */
 static const struct pci_device_id pqi_pci_id_table[] = {
 	{
-- 
2.9.0
