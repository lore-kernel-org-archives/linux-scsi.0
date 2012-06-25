From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v6 04/11] libata-acpi: set acpi state for SATA port
Date: Mon, 25 Jun 2012 16:13:05 +0800
Message-ID: <1340611992-41457-5-git-send-email-ming.m.lin@intel.com>
References: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, ata_acpi_set_state() only sets acpi sate for IDE port.
Remove this limitation.

Acked-by: Aaron Lu <aaron.lu@amd.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-acpi.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index c6f0101..bb20fd5 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -852,23 +852,25 @@ void ata_acpi_on_resume(struct ata_port *ap)
 void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 {
 	struct ata_device *dev;
-
-	if (!ata_ap_acpi_handle(ap) || (ap->flags & ATA_FLAG_ACPI_SATA))
-		return;
+	acpi_handle handle;
 
 	/* channel first and then drives for power on and vica versa
 	   for power off */
-	if (state.event == PM_EVENT_ON)
-		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D0);
+	handle = ata_ap_acpi_handle(ap);
+	if (handle && state.event == PM_EVENT_ON)
+		acpi_bus_set_power(handle, ACPI_STATE_D0);
 
 	ata_for_each_dev(dev, &ap->link, ENABLED) {
-		if (ata_dev_acpi_handle(dev))
-			acpi_bus_set_power(ata_dev_acpi_handle(dev),
+		handle = ata_dev_acpi_handle(dev);
+		if (handle)
+			acpi_bus_set_power(handle,
 				state.event == PM_EVENT_ON ?
 					ACPI_STATE_D0 : ACPI_STATE_D3);
 	}
-	if (state.event != PM_EVENT_ON)
-		acpi_bus_set_power(ata_ap_acpi_handle(ap), ACPI_STATE_D3);
+
+	handle = ata_ap_acpi_handle(ap);
+	if (handle && state.event != PM_EVENT_ON)
+		acpi_bus_set_power(handle, ACPI_STATE_D3);
 }
 
 /**
-- 
1.7.10
