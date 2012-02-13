From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
Date: Mon, 13 Feb 2012 17:11:06 +0800
Message-ID: <1329124271-29464-2-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

If a device has _PR3._ON, it means the device supports D3_HOT.
If a device has _PR3._OFF, it means the device supports D3_COLD.
Add the ability to validate and enter D3_COLD state in ACPI.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/power.c |    4 ++--
 drivers/acpi/scan.c  |   10 +++++++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 9ac2a9f..0d681fb 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -500,14 +500,14 @@ int acpi_power_transition(struct acpi_device *device, int state)
 {
 	int result;
 
-	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
+	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
 		return -EINVAL;
 
 	if (device->power.state == state)
 		return 0;
 
 	if ((device->power.state < ACPI_STATE_D0)
-	    || (device->power.state > ACPI_STATE_D3))
+	    || (device->power.state > ACPI_STATE_D3_COLD))
 		return -ENODEV;
 
 	/* TBD: Resources must be ordered. */
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 8ab80ba..a9d4391 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -881,8 +881,16 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
 
 			device->power.flags.power_resources = 1;
 			ps->flags.valid = 1;
-			for (j = 0; j < ps->resources.count; j++)
+			for (j = 0; j < ps->resources.count; j++) {
 				acpi_bus_add_power_resource(ps->resources.handles[j]);
+				/* Check for D3_COLD support. _PR3._OFF equals D3_COLD ? */
+				if (i == ACPI_STATE_D3) {
+					if (j == 0)
+						device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
+					status = acpi_get_handle(ps->resources.handles[j], "_OFF",  &handle);
+					device->power.states[ACPI_STATE_D3_COLD].flags.valid &= ACPI_SUCCESS(status);
+				}
+			}
 		}
 
 		/* Evaluate "_PSx" to see if we can do explicit sets */
-- 
1.7.2.5
