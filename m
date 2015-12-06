From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 06/72] ncr5380: Remove NCR5380_instance_name macro
Date: Sun, 06 Dec 2015 12:31:32 +1100
Message-ID: <20151206013128.485502134@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-NCR5380_instance_name
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This macro makes the code cryptic. Remove it.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c   |    2 +-
 drivers/scsi/g_NCR5380.c |    7 ++++---
 drivers/scsi/g_NCR5380.h |    2 --
 3 files changed, 5 insertions(+), 6 deletions(-)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-06 12:29:25.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-06 12:29:29.000000000 +1100
@@ -412,10 +412,11 @@ static int __init generic_NCR5380_detect
 			continue;
 		}
 
-		instance->NCR5380_instance_name = overrides[current_override].NCR5380_map_name;
 #ifndef SCSI_G_NCR5380_MEM
+		instance->io_port = overrides[current_override].NCR5380_map_name;
 		instance->n_io_port = region_size;
 #else
+		instance->base = overrides[current_override].NCR5380_map_name;
 		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
 #endif
 
@@ -464,10 +465,10 @@ static int generic_NCR5380_release_resou
 	NCR5380_exit(instance);
 
 #ifndef SCSI_G_NCR5380_MEM
-	release_region(instance->NCR5380_instance_name, instance->n_io_port);
+	release_region(instance->io_port, instance->n_io_port);
 #else
 	iounmap(((struct NCR5380_hostdata *)instance->hostdata)->iomem);
-	release_mem_region(instance->NCR5380_instance_name, NCR5380_region_size);
+	release_mem_region(instance->base, NCR5380_region_size);
 #endif
 
 
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2015-12-06 12:29:25.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2015-12-06 12:29:29.000000000 +1100
@@ -36,7 +36,6 @@
 
 #define NCR5380_map_type int
 #define NCR5380_map_name port
-#define NCR5380_instance_name io_port
 #define NCR53C400_register_offset 0
 #define NCR53C400_address_adjust 8
 
@@ -58,7 +57,6 @@
 
 #define NCR5380_map_type unsigned long
 #define NCR5380_map_name base
-#define NCR5380_instance_name base
 #define NCR53C400_register_offset 0x108
 #define NCR53C400_address_adjust 0
 #define NCR53C400_mem_base 0x3880
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:25.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:29.000000000 +1100
@@ -790,7 +790,7 @@ static int NCR5380_init(struct Scsi_Host
 
 #ifdef NCR53C400
 	if (flags & FLAG_NCR53C400)
-		instance->NCR5380_instance_name += NCR53C400_address_adjust;
+		instance->io_port += NCR53C400_address_adjust;
 #endif
 
 	hostdata->aborted = 0;
