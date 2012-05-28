From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 06/13] libata-acpi: add ata port runtime D3Cold support
Date: Mon, 28 May 2012 13:08:33 +0800
Message-ID: <1338181720-4149-7-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ATA port may support runtime D3Cold state, for example, Zero-power ODD case.
This patch adds wakeup notifier and enable/disable run_wake during
supend/resume.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-acpi.c |   77 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/ata/libata-scsi.c |    3 ++
 drivers/ata/libata.h      |    4 ++
 3 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index bf14010..23c0d3b 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -16,6 +16,7 @@
 #include <linux/libata.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <scsi/scsi_device.h>
 #include "libata.h"
 
@@ -852,10 +853,23 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 
 	ata_for_each_dev(dev, &ap->link, ENABLED) {
 		handle = ata_dev_acpi_handle(dev);
-		if (handle)
-			acpi_bus_set_power(handle,
-				state.event == PM_EVENT_ON ?
-					ACPI_STATE_D0 : ACPI_STATE_D3);
+		if (!handle)
+			continue;
+
+		if (state.event != PM_EVENT_ON) {
+			acpi_state = acpi_pm_device_sleep_state(
+				&dev->sdev->sdev_gendev, NULL);
+			if (acpi_state > 0)
+				acpi_bus_set_power(handle, acpi_state);
+			/* TBD: need to check if it's runtime pm request */
+			acpi_pm_device_run_wake(
+				&dev->sdev->sdev_gendev, true);
+		} else {
+			/* Ditto */
+			acpi_pm_device_run_wake(
+				&dev->sdev->sdev_gendev, false);
+			acpi_bus_set_power(handle, ACPI_STATE_D0);
+		}
 	}
 
 	handle = ata_ap_acpi_handle(ap);
@@ -955,6 +969,61 @@ void ata_acpi_on_disable(struct ata_device *dev)
 	ata_acpi_clear_gtf(dev);
 }
 
+static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
+{
+	struct ata_device *ata_dev = context;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
+			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
+		scsi_autopm_get_device(ata_dev->sdev);
+}
+
+static void ata_acpi_add_pm_notifier(struct ata_device *dev)
+{
+	struct acpi_device *acpi_dev;
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_SUCCESS(status)) {
+		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+			ata_acpi_wake_dev, dev);
+		device_set_run_wake(&dev->sdev->sdev_gendev, true);
+	}
+}
+
+static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
+{
+	struct acpi_device *acpi_dev;
+	acpi_handle handle;
+	acpi_status status;
+
+	handle = ata_dev_acpi_handle(dev);
+	if (!handle)
+		return;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_SUCCESS(status)) {
+		device_set_run_wake(&dev->sdev->sdev_gendev, false);
+		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+			ata_acpi_wake_dev);
+	}
+}
+
+void ata_acpi_bind(struct ata_device *dev)
+{
+	ata_acpi_add_pm_notifier(dev);
+}
+
+void ata_acpi_unbind(struct ata_device *dev)
+{
+	ata_acpi_remove_pm_notifier(dev);
+}
+
 static int is_pci_ata(struct device *dev)
 {
 	struct pci_dev *pdev;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2222635..8ec81ca 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3445,6 +3445,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
+				ata_acpi_bind(dev);
 			} else {
 				dev->sdev = NULL;
 			}
@@ -3541,6 +3542,8 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	mutex_lock(&ap->scsi_host->scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
+	ata_acpi_unbind(dev);
+
 	/* clearing dev->sdev is protected by host lock */
 	sdev = dev->sdev;
 	dev->sdev = NULL;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 6aba606..b0ba924 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -118,6 +118,8 @@ extern void ata_acpi_on_disable(struct ata_device *dev);
 extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
+extern void ata_acpi_bind(struct ata_device *dev);
+extern void ata_acpi_unbind(struct ata_device *dev);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -128,6 +130,8 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
 				      pm_message_t state) { }
 static inline int ata_acpi_register(void) { return 0; }
 static void ata_acpi_unregister(void) { }
+static void ata_acpi_bind(struct ata_device *dev) { }
+static void ata_acpi_unbind(struct ata_device *dev) { }
 #endif
 
 /* libata-scsi.c */
-- 
1.7.2.5
