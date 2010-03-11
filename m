From: akpm@linux-foundation.org
Subject: [patch 15/26] g_NCR5380: fix missing pnp_device_detach and scsi_unregister on rmmod
Date: Thu, 11 Mar 2010 14:09:47 -0800
Message-ID: <201003112209.o2BM9lo2013651@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758400Ab0CKWJw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:09:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux@rainbow-software.org

From: Ondrej Zary <linux@rainbow-software.org>

Add missing pnp_device_detach() and scsi_unregister() at rmmod time.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/g_NCR5380.c |    7 ++++++-
 drivers/scsi/g_NCR5380.h |    5 +++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/g_NCR5380.c~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod
+++ a/drivers/scsi/g_NCR5380.c
@@ -290,6 +290,7 @@ int __init generic_NCR5380_detect(struct
 #ifndef SCSI_G_NCR5380_MEM
 	int i;
 	unsigned long region_size = 16;
+	struct pnp_dev *pnpdevs[NO_OVERRIDES];
 #endif
 	static unsigned int __initdata ncr_53c400a_ports[] = {
 		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
@@ -337,6 +338,7 @@ int __init generic_NCR5380_detect(struct
 				pnp_device_detach(dev);
 				continue;
 			}
+			pnpdevs[count] = dev;
 			if (pnp_irq_valid(dev, 0))
 				overrides[count].irq = pnp_irq(dev, 0);
 			else
@@ -449,6 +451,7 @@ int __init generic_NCR5380_detect(struct
 		instance->NCR5380_instance_name = overrides[current_override].NCR5380_map_name;
 #ifndef SCSI_G_NCR5380_MEM
 		instance->n_io_port = region_size;
+		((struct NCR5380_hostdata *)instance->hostdata)->pnpdev = pnpdevs[current_override];
 #else
 		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
 #endif
@@ -520,12 +523,14 @@ int generic_NCR5380_release_resources(st
 
 #ifndef SCSI_G_NCR5380_MEM
 	release_region(instance->NCR5380_instance_name, instance->n_io_port);
+	if (((struct NCR5380_hostdata *)instance->hostdata)->pnpdev)
+		pnp_device_detach(((struct NCR5380_hostdata *)instance->hostdata)->pnpdev);
 #else
 	iounmap(((struct NCR5380_hostdata *)instance->hostdata)->iomem);
 	release_mem_region(instance->NCR5380_instance_name, NCR5380_region_size);
 #endif
 
-
+	scsi_unregister(instance);
 	return 0;
 }
 
diff -puN drivers/scsi/g_NCR5380.h~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod drivers/scsi/g_NCR5380.h
--- a/drivers/scsi/g_NCR5380.h~g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod
+++ a/drivers/scsi/g_NCR5380.h
@@ -82,10 +82,11 @@ static const char* generic_NCR5380_info(
 #define NCR5380_write(reg, value) (outb((value), (NCR5380_map_name + (reg))))
 
 #define NCR5380_implementation_fields \
-    NCR5380_map_type NCR5380_map_name
+    NCR5380_map_type NCR5380_map_name; \
+    struct pnp_dev *pnpdev;
 
 #define NCR5380_local_declare() \
-    register NCR5380_implementation_fields
+    NCR5380_map_type NCR5380_map_name
 
 #define NCR5380_setup(instance) \
     NCR5380_map_name = (NCR5380_map_type)((instance)->NCR5380_instance_name)
_
