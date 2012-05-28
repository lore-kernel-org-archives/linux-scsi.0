From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 01/13] [SCSI]: add wrapper to access and set scsi_bus_type in struct acpi_bus_type
Date: Mon, 28 May 2012 13:08:28 +0800
Message-ID: <1338181720-4149-2-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <David.Woodhouse@intel.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Holger Macht <holger@homac.de>

For being able to bind ata devices against acpi devices, scsi_bus_type
needs to be set as bus in struct acpi_bus_type. So add wrapper to
scsi_lib to accomplish that.

Signed-off-by: Holger Macht <holger@homac.de>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_lib.c |   17 +++++++++++++++++
 include/scsi/scsi.h     |   10 ++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..a243212 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -68,6 +68,23 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
 
 struct kmem_cache *scsi_sdb_cache;
 
+#ifdef CONFIG_ACPI
+#include <acpi/acpi_bus.h>
+
+int scsi_register_acpi_bus_type(struct acpi_bus_type *bus)
+{
+        bus->bus = &scsi_bus_type;
+        return register_acpi_bus_type(bus);
+}
+EXPORT_SYMBOL_GPL(scsi_register_acpi_bus_type);
+
+void scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus)
+{
+	unregister_acpi_bus_type(bus);
+}
+EXPORT_SYMBOL_GPL(scsi_unregister_acpi_bus_type);
+#endif
+
 /*
  * When to reinvoke queueing after a resource shortage. It's 3 msecs to
  * not change behaviour from the previous unplug mechanism, experimentation
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index f34a5a8..4527b3a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -214,6 +214,16 @@ scsi_command_size(const unsigned char *cmnd)
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
 
+#ifdef CONFIG_ACPI
+struct acpi_bus_type;
+
+extern int
+scsi_register_acpi_bus_type(struct acpi_bus_type *bus);
+
+extern void
+scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus);
+#endif
+
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
-- 
1.7.2.5
