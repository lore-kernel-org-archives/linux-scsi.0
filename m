From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v7 6/6] libata: acpi: respect may_power_off flag
Date: Wed, 12 Sep 2012 16:29:57 +0800
Message-ID: <1347438597-5903-7-git-send-email-aaron.lu@intel.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

If user does not want the device to be powered off when runtime
suspended by setting may_power_off flag to 0, we will not choose
D3 cold for it.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 9aca057..24347e0 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -855,6 +855,7 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 	struct ata_device *dev;
 	acpi_handle handle;
 	int acpi_state, ret;
+	bool power_off_allowed;
 
 	/* channel first and then drives for power on and vica versa
 	   for power off */
@@ -868,9 +869,11 @@ void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 			continue;
 
 		if (state.event != PM_EVENT_ON) {
+			power_off_allowed = dev->sdev->ready_to_power_off &&
+					    dev->sdev->may_power_off;
 			acpi_state = acpi_pm_device_sleep_state(
 					&dev->sdev->sdev_gendev, NULL,
-					dev->sdev->ready_to_power_off ?
+					power_off_allowed ?
 					ACPI_STATE_D3 : ACPI_STATE_D3_HOT);
 			if (acpi_state > 0) {
 				ret = acpi_bus_set_power(handle, acpi_state);
-- 
1.7.12.21.g871e293

