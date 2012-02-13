From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 5/6] PCI: Move acpi_dev_run_wake to acpi core
Date: Mon, 13 Feb 2012 17:11:10 +0800
Message-ID: <1329124271-29464-6-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

acpi_dev_run_wake is a generic function which can be used by
other subsystem too. Rename it to acpi_pm_device_run_wake, to be
consistent with acpi_pm_device_sleep_wake.

Then move it to acpi core.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/sleep.c    |   35 +++++++++++++++++++++++++++++++++++
 drivers/pci/pci-acpi.c  |   40 +++-------------------------------------
 include/acpi/acpi_bus.h |    5 +++++
 3 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index ca191ff..00fa664 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -17,6 +17,7 @@
 #include <linux/suspend.h>
 #include <linux/reboot.h>
 #include <linux/acpi.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/io.h>
 
@@ -730,6 +731,40 @@ int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p)
 
 #ifdef CONFIG_PM_SLEEP
 /**
+ * acpi_pm_device_run_wake - Enable/disable wake-up for given device.
+ * @phys_dev: Device to enable/disable the platform to wake-up the system for.
+ * @enable: Whether enable or disable the wake-up functionality.
+ *
+ * Find the ACPI device object corresponding to @pci_dev and try to
+ * enable/disable the GPE associated with it.
+ */
+int acpi_pm_device_run_wake(struct device *phys_dev, bool enable)
+{
+	struct acpi_device *dev;
+	acpi_handle handle;
+
+	if (!device_run_wake(phys_dev))
+		return -EINVAL;
+
+	handle = DEVICE_ACPI_HANDLE(phys_dev);
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
+		dev_dbg(phys_dev, "ACPI handle has no context in %s!\n",
+			__func__);
+		return -ENODEV;
+	}
+
+	if (enable) {
+		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
+		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
+	} else {
+		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
+		acpi_disable_wakeup_device_power(dev);
+	}
+
+	return 0;
+}
+
+/**
  *	acpi_pm_device_sleep_wake - enable or disable the system wake-up
  *                                  capability of given device
  *	@dev: device to handle
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 060fd22..0f150f2 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -277,40 +277,6 @@ static int acpi_pci_sleep_wake(struct pci_dev *dev, bool enable)
 	return 0;
 }
 
-/**
- * acpi_dev_run_wake - Enable/disable wake-up for given device.
- * @phys_dev: Device to enable/disable the platform to wake-up the system for.
- * @enable: Whether enable or disable the wake-up functionality.
- *
- * Find the ACPI device object corresponding to @pci_dev and try to
- * enable/disable the GPE associated with it.
- */
-static int acpi_dev_run_wake(struct device *phys_dev, bool enable)
-{
-	struct acpi_device *dev;
-	acpi_handle handle;
-
-	if (!device_run_wake(phys_dev))
-		return -EINVAL;
-
-	handle = DEVICE_ACPI_HANDLE(phys_dev);
-	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &dev))) {
-		dev_dbg(phys_dev, "ACPI handle has no context in %s!\n",
-			__func__);
-		return -ENODEV;
-	}
-
-	if (enable) {
-		acpi_enable_wakeup_device_power(dev, ACPI_STATE_S0);
-		acpi_enable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
-	} else {
-		acpi_disable_gpe(dev->wakeup.gpe_device, dev->wakeup.gpe_number);
-		acpi_disable_wakeup_device_power(dev);
-	}
-
-	return 0;
-}
-
 static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
 {
 	while (bus->parent) {
@@ -318,14 +284,14 @@ static void acpi_pci_propagate_run_wake(struct pci_bus *bus, bool enable)
 
 		if (bridge->pme_interrupt)
 			return;
-		if (!acpi_dev_run_wake(&bridge->dev, enable))
+		if (!acpi_pm_device_run_wake(&bridge->dev, enable))
 			return;
 		bus = bus->parent;
 	}
 
 	/* We have reached the root bus. */
 	if (bus->bridge)
-		acpi_dev_run_wake(bus->bridge, enable);
+		acpi_pm_device_run_wake(bus->bridge, enable);
 }
 
 static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
@@ -333,7 +299,7 @@ static int acpi_pci_run_wake(struct pci_dev *dev, bool enable)
 	if (dev->pme_interrupt)
 		return 0;
 
-	if (!acpi_dev_run_wake(&dev->dev, enable))
+	if (!acpi_pm_device_run_wake(&dev->dev, enable))
 		return 0;
 
 	acpi_pci_propagate_run_wake(dev->bus, enable);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 32fb899..2d556e3 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -394,8 +394,13 @@ static inline int acpi_pm_device_sleep_state(struct device *d, int *p)
 #endif
 
 #ifdef CONFIG_PM_SLEEP
+int acpi_pm_device_run_wake(struct device *, bool);
 int acpi_pm_device_sleep_wake(struct device *, bool);
 #else
+static inline int acpi_pm_device_run_wake(struct device *dev, bool enable)
+{
+	return -ENODEV;
+}
 static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
 {
 	return -ENODEV;
-- 
1.7.2.5
