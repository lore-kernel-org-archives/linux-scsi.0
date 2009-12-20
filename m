From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 3/3] g_NCR5380: fix missing pnp_device_detach and scsi_unregister on rmmod
Date: Sun, 20 Dec 2009 20:41:42 +0100
Message-ID: <200912202041.44198.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756343AbZLTTlz@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add missing pnp_device_detach() and scsi_unregister() at rmmod time.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.32-orig/drivers/scsi/g_NCR5380.h	2009-12-20 20:32:25.000000000 +0100
+++ linux-source-2.6.32/drivers/scsi/g_NCR5380.h	2009-12-20 20:32:39.000000000 +0100
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
--- linux-source-2.6.32-orig/drivers/scsi/g_NCR5380.c	2009-12-20 20:32:25.000000000 +0100
+++ linux-source-2.6.32/drivers/scsi/g_NCR5380.c	2009-12-20 20:32:39.000000000 +0100
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
 

-- 
Ondrej Zary
