From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [PATCH 3/9] ACPI / hotplug / PCI: Use global PCI rescan-remove locking
Date: Fri, 10 Jan 2014 15:24:41 +0100
Message-ID: <1889108.hSyl0lYrWr@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1992931.Zv6xBcN8V4@vostro.rjw.lan> <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20440867.YaQfKrcfsQ@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Myron Stowe <myron.stowe@gmail.com>, Benjamin Herrenschmidt <benh@au1.ibm.com>, linux-scsi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Multiple race conditions are possible between the ACPI-based PCI
hotplug (ACPIPHP) and the generic PCI bus rescan and device removal
that can be triggered via sysfs.

To avoid those race conditions make the ACPIPHP code use global PCI
rescan-remove locking.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    5 +++-
 drivers/pci/hotplug/acpiphp_core.c |    2 -
 drivers/pci/hotplug/acpiphp_glue.c |   43 ++++++++++++++++++++++++++++++++-----
 3 files changed, 43 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -77,6 +77,8 @@ struct acpiphp_bridge {
 
 	/* PCI-to-PCI bridge device */
 	struct pci_dev *pci_dev;
+
+	bool is_going_away;
 };
 
 
@@ -150,6 +152,7 @@ struct acpiphp_attention_info
 /* slot flags */
 
 #define SLOT_ENABLED		(0x00000001)
+#define SLOT_IS_GOING_AWAY	(0x00000002)
 
 /* function flags */
 
@@ -169,7 +172,7 @@ void acpiphp_unregister_hotplug_slot(str
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
 int acpiphp_enable_slot(struct acpiphp_slot *slot);
-int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot);
+int acpiphp_disable_slot(struct acpiphp_slot *slot);
 u8 acpiphp_get_power_status(struct acpiphp_slot *slot);
 u8 acpiphp_get_attention_status(struct acpiphp_slot *slot);
 u8 acpiphp_get_latch_status(struct acpiphp_slot *slot);
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -432,6 +432,7 @@ static void cleanup_bridge(struct acpiph
 					pr_err("failed to remove notify handler\n");
 			}
 		}
+		slot->flags |= SLOT_IS_GOING_AWAY;
 		if (slot->slot)
 			acpiphp_unregister_hotplug_slot(slot);
 	}
@@ -439,6 +440,8 @@ static void cleanup_bridge(struct acpiph
 	mutex_lock(&bridge_mutex);
 	list_del(&bridge->list);
 	mutex_unlock(&bridge_mutex);
+
+	bridge->is_going_away = true;
 }
 
 /**
@@ -757,6 +760,10 @@ static void acpiphp_check_bridge(struct
 {
 	struct acpiphp_slot *slot;
 
+	/* Bail out if the bridge is going away. */
+	if (bridge->is_going_away)
+		return;
+
 	list_for_each_entry(slot, &bridge->slots, node) {
 		struct pci_bus *bus = slot->bus;
 		struct pci_dev *dev, *tmp;
@@ -827,6 +834,8 @@ void acpiphp_check_host_bridge(acpi_hand
 	}
 }
 
+static int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot);
+
 static void hotplug_event(acpi_handle handle, u32 type, void *data)
 {
 	struct acpiphp_context *context = data;
@@ -856,6 +865,9 @@ static void hotplug_event(acpi_handle ha
 		} else {
 			struct acpiphp_slot *slot = func->slot;
 
+			if (slot->flags & SLOT_IS_GOING_AWAY)
+				break;
+
 			mutex_lock(&slot->crit_sect);
 			enable_slot(slot);
 			mutex_unlock(&slot->crit_sect);
@@ -871,6 +883,9 @@ static void hotplug_event(acpi_handle ha
 			struct acpiphp_slot *slot = func->slot;
 			int ret;
 
+			if (slot->flags & SLOT_IS_GOING_AWAY)
+				break;
+
 			/*
 			 * Check if anything has changed in the slot and rescan
 			 * from the parent if that's the case.
@@ -900,9 +915,11 @@ static void hotplug_event_work(void *dat
 	acpi_handle handle = context->handle;
 
 	acpi_scan_lock_acquire();
+	pci_lock_rescan_remove();
 
 	hotplug_event(handle, type, context);
 
+	pci_unlock_rescan_remove();
 	acpi_scan_lock_release();
 	acpi_evaluate_hotplug_ost(handle, type, ACPI_OST_SC_SUCCESS, NULL);
 	put_bridge(context->func.parent);
@@ -1070,12 +1087,19 @@ void acpiphp_remove_slots(struct pci_bus
  */
 int acpiphp_enable_slot(struct acpiphp_slot *slot)
 {
+	pci_lock_rescan_remove();
+
+	if (slot->flags & SLOT_IS_GOING_AWAY)
+		return -ENODEV;
+
 	mutex_lock(&slot->crit_sect);
 	/* configure all functions */
 	if (!(slot->flags & SLOT_ENABLED))
 		enable_slot(slot);
 
 	mutex_unlock(&slot->crit_sect);
+
+	pci_unlock_rescan_remove();
 	return 0;
 }
 
@@ -1083,10 +1107,12 @@ int acpiphp_enable_slot(struct acpiphp_s
  * acpiphp_disable_and_eject_slot - power off and eject slot
  * @slot: ACPI PHP slot
  */
-int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot)
+static int acpiphp_disable_and_eject_slot(struct acpiphp_slot *slot)
 {
 	struct acpiphp_func *func;
-	int retval = 0;
+
+	if (slot->flags & SLOT_IS_GOING_AWAY)
+		return -ENODEV;
 
 	mutex_lock(&slot->crit_sect);
 
@@ -1104,9 +1130,18 @@ int acpiphp_disable_and_eject_slot(struc
 		}
 
 	mutex_unlock(&slot->crit_sect);
-	return retval;
+	return 0;
 }
 
+int acpiphp_disable_slot(struct acpiphp_slot *slot)
+{
+	int ret;
+
+	pci_lock_rescan_remove();
+	ret = acpiphp_disable_and_eject_slot(slot);
+	pci_unlock_rescan_remove();
+	return ret;
+}
 
 /*
  * slot enabled:  1
@@ -1117,7 +1152,6 @@ u8 acpiphp_get_power_status(struct acpip
 	return (slot->flags & SLOT_ENABLED);
 }
 
-
 /*
  * latch   open:  1
  * latch closed:  0
@@ -1127,7 +1161,6 @@ u8 acpiphp_get_latch_status(struct acpip
 	return !(get_slot_status(slot) & ACPI_STA_DEVICE_UI);
 }
 
-
 /*
  * adapter presence : 1
  *          absence : 0
Index: linux-pm/drivers/pci/hotplug/acpiphp_core.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_core.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_core.c
@@ -156,7 +156,7 @@ static int disable_slot(struct hotplug_s
 	pr_debug("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* disable the specified slot */
-	return acpiphp_disable_and_eject_slot(slot->acpi_slot);
+	return acpiphp_disable_slot(slot->acpi_slot);
 }
 
 
