From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 3/6] ACPI: Runtime resume all devices covered by a power resource
Date: Mon, 13 Feb 2012 17:11:08 +0800
Message-ID: <1329124271-29464-4-git-send-email-ming.m.lin@intel.com>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

When an ACPI Power Resource is turned on, we should runtime
resume all the devices covered by this ACPI Power Resource.
So that they have a chance to runtime suspend again.
Or else, they will be in uninitialized state after powered on.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/power.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index a7e2305..86791e3 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
@@ -201,6 +202,7 @@ static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
 static int __acpi_power_on(struct acpi_power_resource *resource)
 {
 	acpi_status status = AE_OK;
+	struct acpi_powered_device *apd;
 
 	status = acpi_evaluate_object(resource->device->handle, "_ON", NULL, NULL);
 	if (ACPI_FAILURE(status))
@@ -212,6 +214,13 @@ static int __acpi_power_on(struct acpi_power_resource *resource)
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Power resource [%s] turned on\n",
 			  resource->name));
 
+	/* resume all the devices when power resource is turned on */
+	list_for_each_entry(apd, &resource->devices, node){
+		pm_request_resume(apd->dev);
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "resume device %s\n",
+						apd->dev->kobj.name));
+	}
+
 	return 0;
 }
 
-- 
1.7.2.5
