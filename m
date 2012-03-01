From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH v2 1/8] ACPI: Introduce ACPI D3_COLD state support
Date: Thu,  1 Mar 2012 17:02:50 +0800
Message-ID: <1330592577-16546-2-git-send-email-ming.m.lin@intel.com>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab2CAJE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Mar 2012 04:04:27 -0500
In-Reply-To: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>

From: Zhang Rui <rui.zhang@intel.com>

If a device has _PR3, it means the device supports D3_COLD.
Add the ability to validate and enter D3_COLD state in ACPI.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/acpi/power.c |    4 ++--
 drivers/acpi/scan.c  |    7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

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
index 8ab80ba..571396c 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -885,6 +885,13 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
 				acpi_bus_add_power_resource(ps->resources.handles[j]);
 		}
 
+		/* The exist of _PR3 indicates D3Cold support */
+		if (i == ACPI_STATE_D3) {
+			status = acpi_get_handle(device->handle, object_name, &handle);
+			if (ACPI_SUCCESS(status))
+				device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
+		}
+
 		/* Evaluate "_PSx" to see if we can do explicit sets */
 		object_name[2] = 'S';
 		status = acpi_get_handle(device->handle, object_name, &handle);
-- 
1.7.2.5

