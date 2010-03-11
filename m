From: akpm@linux-foundation.org
Subject: [patch 14/26] g_NCR5380: fix broken MMIO compilation
Date: Thu, 11 Mar 2010 14:09:46 -0800
Message-ID: <201003112209.o2BM9lSb013645@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758400Ab0CKWJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:09:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux@rainbow-software.org, awalls@radix.net

From: Ondrej Zary <linux@rainbow-software.org>

The ifdefs are broken so the MMIO code is never compiled and so it's
broken too.  Fix them all.  Untested as I don't have the hardware.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Andy Walls <awalls@radix.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/g_NCR5380.c |   43 +++++++++++++++++++------------------
 drivers/scsi/g_NCR5380.h |    6 ++---
 2 files changed, 26 insertions(+), 23 deletions(-)

diff -puN drivers/scsi/g_NCR5380.c~g_ncr5380-fix-broken-mmio-compilation drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c~g_ncr5380-fix-broken-mmio-compilation
+++ a/drivers/scsi/g_NCR5380.c
@@ -285,9 +285,12 @@ static int __init do_DTC3181E_setup(char
 int __init generic_NCR5380_detect(struct scsi_host_template * tpnt)
 {
 	static int current_override = 0;
-	int count, i;
+	int count;
 	unsigned int *ports;
+#ifndef SCSI_G_NCR5380_MEM
+	int i;
 	unsigned long region_size = 16;
+#endif
 	static unsigned int __initdata ncr_53c400a_ports[] = {
 		0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
 	};
@@ -296,7 +299,7 @@ int __init generic_NCR5380_detect(struct
 	};
 	int flags = 0;
 	struct Scsi_Host *instance;
-#ifdef CONFIG_SCSI_G_NCR5380_MEM
+#ifdef SCSI_G_NCR5380_MEM
 	unsigned long base;
 	void __iomem *iomem;
 #endif
@@ -315,7 +318,7 @@ int __init generic_NCR5380_detect(struct
 		overrides[0].board = BOARD_NCR53C400A;
 	else if (dtc_3181e != NCR_NOT_SET)
 		overrides[0].board = BOARD_DTC3181E;
-
+#ifndef SCSI_G_NCR5380_MEM
 	if (!current_override && isapnp_present()) {
 		struct pnp_dev *dev = NULL;
 		count = 0;
@@ -347,7 +350,7 @@ int __init generic_NCR5380_detect(struct
 			count++;
 		}
 	}
-
+#endif
 	tpnt->proc_name = "g_NCR5380";
 
 	for (count = 0; current_override < NO_OVERRIDES; ++current_override) {
@@ -372,7 +375,7 @@ int __init generic_NCR5380_detect(struct
 			break;
 		}
 
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 		if (ports) {
 			/* wakeup sequence for the NCR53C400A and DTC3181E */
 
@@ -434,7 +437,7 @@ int __init generic_NCR5380_detect(struct
 #endif
 		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
 		if (instance == NULL) {
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 			release_region(overrides[current_override].NCR5380_map_name, region_size);
 #else
 			iounmap(iomem);
@@ -444,10 +447,10 @@ int __init generic_NCR5380_detect(struct
 		}
 
 		instance->NCR5380_instance_name = overrides[current_override].NCR5380_map_name;
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 		instance->n_io_port = region_size;
 #else
-		((struct NCR5380_hostdata *)instance->hostdata).iomem = iomem;
+		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
 #endif
 
 		NCR5380_init(instance, flags);
@@ -515,10 +518,10 @@ int generic_NCR5380_release_resources(st
 		free_irq(instance->irq, instance);
 	NCR5380_exit(instance);
 
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 	release_region(instance->NCR5380_instance_name, instance->n_io_port);
 #else
-	iounmap(((struct NCR5380_hostdata *)instance->hostdata).iomem);
+	iounmap(((struct NCR5380_hostdata *)instance->hostdata)->iomem);
 	release_mem_region(instance->NCR5380_instance_name, NCR5380_region_size);
 #endif
 
@@ -588,14 +591,14 @@ static inline int NCR5380_pread(struct S
 		}
 		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY);
 
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 		{
 			int i;
 			for (i = 0; i < 128; i++)
 				dst[start + i] = NCR5380_read(C400_HOST_BUFFER);
 		}
 #else
-		/* implies CONFIG_SCSI_G_NCR5380_MEM */
+		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_fromio(dst + start, iomem + NCR53C400_host_buffer, 128);
 #endif
 		start += 128;
@@ -608,14 +611,14 @@ static inline int NCR5380_pread(struct S
 			// FIXME - no timeout
 		}
 
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 		{
 			int i;	
 			for (i = 0; i < 128; i++)
 				dst[start + i] = NCR5380_read(C400_HOST_BUFFER);
 		}
 #else
-		/* implies CONFIG_SCSI_G_NCR5380_MEM */
+		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_fromio(dst + start, iomem + NCR53C400_host_buffer, 128);
 #endif
 		start += 128;
@@ -674,13 +677,13 @@ static inline int NCR5380_pwrite(struct 
 		}
 		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - timeout
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 		{
 			for (i = 0; i < 128; i++)
 				NCR5380_write(C400_HOST_BUFFER, src[start + i]);
 		}
 #else
-		/* implies CONFIG_SCSI_G_NCR5380_MEM */
+		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_toio(iomem + NCR53C400_host_buffer, src + start, 128);
 #endif
 		start += 128;
@@ -690,13 +693,13 @@ static inline int NCR5380_pwrite(struct 
 		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - no timeout
 
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 		{
 			for (i = 0; i < 128; i++)
 				NCR5380_write(C400_HOST_BUFFER, src[start + i]);
 		}
 #else
-		/* implies CONFIG_SCSI_G_NCR5380_MEM */
+		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_toio(iomem + NCR53C400_host_buffer, src + start, 128);
 #endif
 		start += 128;
@@ -936,7 +939,7 @@ module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
 MODULE_LICENSE("GPL");
 
-
+#ifndef SCSI_G_NCR5380_MEM
 static struct isapnp_device_id id_table[] __devinitdata = {
 	{
 	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
@@ -946,7 +949,7 @@ static struct isapnp_device_id id_table[
 };
 
 MODULE_DEVICE_TABLE(isapnp, id_table);
-
+#endif
 
 __setup("ncr5380=", do_NCR5380_setup);
 __setup("ncr53c400=", do_NCR53C400_setup);
diff -puN drivers/scsi/g_NCR5380.h~g_ncr5380-fix-broken-mmio-compilation drivers/scsi/g_NCR5380.h
--- a/drivers/scsi/g_NCR5380.h~g_ncr5380-fix-broken-mmio-compilation
+++ a/drivers/scsi/g_NCR5380.h
@@ -63,7 +63,7 @@ static const char* generic_NCR5380_info(
 #define __STRVAL(x) #x
 #define STRVAL(x) __STRVAL(x)
 
-#ifndef CONFIG_SCSI_G_NCR5380_MEM
+#ifndef SCSI_G_NCR5380_MEM
 
 #define NCR5380_map_config port
 #define NCR5380_map_type int
@@ -91,7 +91,7 @@ static const char* generic_NCR5380_info(
     NCR5380_map_name = (NCR5380_map_type)((instance)->NCR5380_instance_name)
 
 #else 
-/* therefore CONFIG_SCSI_G_NCR5380_MEM */
+/* therefore SCSI_G_NCR5380_MEM */
 
 #define NCR5380_map_config memory
 #define NCR5380_map_type unsigned long
@@ -114,7 +114,7 @@ static const char* generic_NCR5380_info(
     register void __iomem *iomem
 
 #define NCR5380_setup(instance) \
-    iomem = (((struct NCR5380_hostdata *)(instance)->hostdata).iomem)
+    iomem = (((struct NCR5380_hostdata *)(instance)->hostdata)->iomem)
 
 #endif
 
_
