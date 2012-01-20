From: Holger Macht <holger@homac.de>
Subject: [PATCHv2 1/8] scsi: Add wrapper to access and set scsi_bus_type in
 struct acpi_bus_type
Date: Fri, 20 Jan 2012 01:18:33 +0100
Message-ID: <20120120001833.GB27706@homac.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@redhat.com>
List-Id: linux-scsi@vger.kernel.org

For being able to bind ata devices against acpi devices, scsi_bus_type
needs to be set as bus in struct acpi_bus_type. So add wrapper to
scsi_lib to accomplish that.

Signed-off-by: Holger Macht <holger@homac.de>
---
 drivers/scsi/scsi_lib.c |   11 +++++++++++
 include/scsi/scsi.h     |   10 ++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2c95db..79f2654 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -68,6 +68,17 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
 
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
+#endif
+
 /*
  * When to reinvoke queueing after a resource shortage. It's 3 msecs to
  * not change behaviour from the previous unplug mechanism, experimentation
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8001ae4..548fe9a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -213,6 +213,16 @@ scsi_command_size(const unsigned char *cmnd)
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
 
+#ifdef CONFIG_ACPI
+struct acpi_bus_type;
+
+extern int
+scsi_register_acpi_bus_type(struct acpi_bus_type *bus);
+
+static inline void
+scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus) { return; }
+#endif
+
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
-- 
1.7.8

