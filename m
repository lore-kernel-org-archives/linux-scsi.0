From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] make scsi logging level a sysctl
Date: Mon, 25 Aug 2003 14:20:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825122030.GA15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:49051 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261732AbTHYMUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:20:49 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

The logging level is now controlled by a
/proc/sys/dev/scsi/logging_level sysctl instead of /proc/scsi/scsi.
The format is the same as the logging_level module parameter.


diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Mon Aug 25 13:37:07 2003
+++ b/drivers/scsi/Makefile	Mon Aug 25 13:37:07 2003
@@ -126,6 +126,7 @@
 				   scsicam.o scsi_error.o scsi_lib.o \
 				   scsi_scan.o scsi_syms.o scsi_sysfs.o \
 				   scsi_devinfo.o
+scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_PROC_FS)	+= scsi_proc.o
 scsi_mod-$(CONFIG_X86_PC9800)	+= scsi_pc98.o
 			
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Aug 25 13:37:07 2003
+++ b/drivers/scsi/scsi.c	Mon Aug 25 13:37:07 2003
@@ -1006,9 +1006,12 @@
 	error = scsi_init_hosts();
 	if (error)
 		goto cleanup_devlist;
-	error = scsi_sysfs_register();
+	error = scsi_init_sysctl();
 	if (error)
 		goto cleanup_hosts;
+	error = scsi_sysfs_register();
+	if (error)
+		goto cleanup_sysctl;
 
 	for (i = 0; i < NR_CPUS; i++)
 		INIT_LIST_HEAD(&done_q[i]);
@@ -1018,6 +1021,8 @@
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
 
+cleanup_sysctl:
+	scsi_exit_sysctl();
 cleanup_hosts:
 	scsi_exit_hosts();
 cleanup_devlist:
@@ -1034,6 +1039,7 @@
 static void __exit exit_scsi(void)
 {
 	scsi_sysfs_unregister();
+	scsi_exit_sysctl();
 	scsi_exit_hosts();
 	scsi_exit_devinfo();
 	devfs_remove("scsi");
diff -Nru a/drivers/scsi/scsi_logging.h b/drivers/scsi/scsi_logging.h
--- a/drivers/scsi/scsi_logging.h	Mon Aug 25 13:37:07 2003
+++ b/drivers/scsi/scsi_logging.h	Mon Aug 25 13:37:07 2003
@@ -46,30 +46,14 @@
         if (((scsi_logging_level >> (SHIFT)) & mask) > (LEVEL))	\
 		(CMD);						\
 }
-
-#define SCSI_SET_LOGGING(SHIFT, BITS, LEVEL)			\
-{								\
-        unsigned int mask = ((1 << (BITS)) - 1) << SHIFT;	\
-        scsi_logging_level = ((scsi_logging_level & ~mask)	\
-                              | ((LEVEL << SHIFT) & mask));	\
-}
 #else
-/*
- * With no logging enabled, stub these out so they don't do anything.
- */
 #define SCSI_CHECK_LOGGING(SHIFT, BITS, LEVEL, CMD)
-#define SCSI_SET_LOGGING(SHIFT, BITS, LEVEL)
 #endif /* CONFIG_SCSI_LOGGING */
 
 /*
  * These are the macros that are actually used throughout the code to
  * log events.  If logging isn't enabled, they are no-ops and will be
  * completely absent from the user's code.
- *
- * The 'set' versions of the macros are really intended to only be called
- * from the /proc filesystem, and in production kernels this will be about
- * all that is ever used.  It could be useful in a debugging environment to
- * bump the logging level when certain strange events are detected, however.
  */
 #define SCSI_LOG_ERROR_RECOVERY(LEVEL,CMD)  \
         SCSI_CHECK_LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL,CMD);
@@ -91,27 +75,5 @@
         SCSI_CHECK_LOGGING(SCSI_LOG_HLCOMPLETE_SHIFT, SCSI_LOG_HLCOMPLETE_BITS, LEVEL,CMD);
 #define SCSI_LOG_IOCTL(LEVEL,CMD)  \
         SCSI_CHECK_LOGGING(SCSI_LOG_IOCTL_SHIFT, SCSI_LOG_IOCTL_BITS, LEVEL,CMD);
-
-
-#define SCSI_SET_ERROR_RECOVERY_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_ERROR_SHIFT, SCSI_LOG_ERROR_BITS, LEVEL);
-#define SCSI_SET_TIMEOUT_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_TIMEOUT_SHIFT, SCSI_LOG_TIMEOUT_BITS, LEVEL);
-#define SCSI_SET_SCAN_BUS_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_SCAN_SHIFT, SCSI_LOG_SCAN_BITS, LEVEL);
-#define SCSI_SET_MLQUEUE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_MLQUEUE_SHIFT, SCSI_LOG_MLQUEUE_BITS, LEVEL);
-#define SCSI_SET_MLCOMPLETE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_MLCOMPLETE_SHIFT, SCSI_LOG_MLCOMPLETE_BITS, LEVEL);
-#define SCSI_SET_LLQUEUE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_LLQUEUE_SHIFT, SCSI_LOG_LLQUEUE_BITS, LEVEL);
-#define SCSI_SET_LLCOMPLETE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_LLCOMPLETE_SHIFT, SCSI_LOG_LLCOMPLETE_BITS, LEVEL);
-#define SCSI_SET_HLQUEUE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_HLQUEUE_SHIFT, SCSI_LOG_HLQUEUE_BITS, LEVEL);
-#define SCSI_SET_HLCOMPLETE_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_HLCOMPLETE_SHIFT, SCSI_LOG_HLCOMPLETE_BITS, LEVEL);
-#define SCSI_SET_IOCTL_LOGGING(LEVEL)  \
-        SCSI_SET_LOGGING(SCSI_LOG_IOCTL_SHIFT, SCSI_LOG_IOCTL_BITS, LEVEL);
 
 #endif /* _SCSI_LOGGING_H */
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:07 2003
+++ b/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:07 2003
@@ -132,6 +132,15 @@
 extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_rescan_device(struct device *);
 
+/* scsi_sysctl.c */
+#ifdef CONFIG_SYSCTL
+extern int scsi_init_sysctl(void);
+extern void scsi_exit_sysctl(void);
+#else
+# define scsi_init_sysctl()		(0)
+# define scsi_exit_sysctl()		do { } while (0)
+#endif /* CONFIG_SYSCTL */
+
 /* scsi_sysfs.c */
 extern int scsi_device_register(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
diff -Nru a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
--- a/drivers/scsi/scsi_proc.c	Mon Aug 25 13:37:07 2003
+++ b/drivers/scsi/scsi_proc.c	Mon Aug 25 13:37:07 2003
@@ -235,106 +235,28 @@
 	char *buffer, *p;
 	int err;
 
-	if (!buf || length>PAGE_SIZE)
+	if (!buf || length > PAGE_SIZE)
 		return -EINVAL;
 
 	buffer = (char *)__get_free_page(GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
-	if (copy_from_user(buffer, buf, length)) {
-		err =-EFAULT;
+
+	err = -EFAULT;
+	if (copy_from_user(buffer, buf, length))
 		goto out;
-	}
 
 	err = -EINVAL;
-
 	if (length < PAGE_SIZE)
 		buffer[length] = '\0';
 	else if (buffer[PAGE_SIZE-1])
 		goto out;
 
-	if (length < 11 || strncmp("scsi", buffer, 4))
-		goto out;
-
-#ifdef CONFIG_SCSI_LOGGING
-	/*
-	 * Usage: echo "scsi log token #N" > /proc/scsi/scsi
-	 * where token is one of [error,scan,mlqueue,mlcomplete,llqueue,
-	 * llcomplete,hlqueue,hlcomplete]
-	 */
-	if (!strncmp("log", buffer + 5, 3)) {
-		char *token;
-		unsigned int level;
-
-		p = buffer + 9;
-		token = p;
-		while (*p != ' ' && *p != '\t' && *p != '\0') {
-			p++;
-		}
-
-		if (*p == '\0') {
-			if (strncmp(token, "all", 3) == 0) {
-				/*
-				 * Turn on absolutely everything.
-				 */
-				scsi_logging_level = ~0;
-			} else if (strncmp(token, "none", 4) == 0) {
-				/*
-				 * Turn off absolutely everything.
-				 */
-				scsi_logging_level = 0;
-			} else {
-				goto out;
-			}
-		} else {
-			*p++ = '\0';
-
-			level = simple_strtoul(p, NULL, 0);
-
-			/*
-			 * Now figure out what to do with it.
-			 */
-			if (strcmp(token, "error") == 0) {
-				SCSI_SET_ERROR_RECOVERY_LOGGING(level);
-			} else if (strcmp(token, "timeout") == 0) {
-				SCSI_SET_TIMEOUT_LOGGING(level);
-			} else if (strcmp(token, "scan") == 0) {
-				SCSI_SET_SCAN_BUS_LOGGING(level);
-			} else if (strcmp(token, "mlqueue") == 0) {
-				SCSI_SET_MLQUEUE_LOGGING(level);
-			} else if (strcmp(token, "mlcomplete") == 0) {
-				SCSI_SET_MLCOMPLETE_LOGGING(level);
-			} else if (strcmp(token, "llqueue") == 0) {
-				SCSI_SET_LLQUEUE_LOGGING(level);
-			} else if (strcmp(token, "llcomplete") == 0) {
-				SCSI_SET_LLCOMPLETE_LOGGING(level);
-			} else if (strcmp(token, "hlqueue") == 0) {
-				SCSI_SET_HLQUEUE_LOGGING(level);
-			} else if (strcmp(token, "hlcomplete") == 0) {
-				SCSI_SET_HLCOMPLETE_LOGGING(level);
-			} else if (strcmp(token, "ioctl") == 0) {
-				SCSI_SET_IOCTL_LOGGING(level);
-			} else {
-				goto out;
-			}
-		}
-
-		printk(KERN_INFO "scsi logging level set to 0x%8.8x\n", scsi_logging_level);
-	}
-#endif	/* CONFIG_SCSI_LOGGING */
-
 	/*
 	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
-	 * Consider this feature BETA.
-	 *     CAUTION: This is not for hotplugging your peripherals. As
-	 *     SCSI was not designed for this you could damage your
-	 *     hardware !
-	 * However perhaps it is legal to switch on an
-	 * already connected device. It is perhaps not
-	 * guaranteed this device doesn't corrupt an ongoing data transfer.
 	 */
-	if (!strncmp("add-single-device", buffer + 5, 17)) {
+	if (!strncmp("scsi add-single-device", buffer, 22)) {
 		p = buffer + 23;
 
 		host = simple_strtoul(p, &p, 0);
@@ -345,18 +267,12 @@
 		err = scsi_add_single_device(host, channel, id, lun);
 		if (err >= 0)
 			err = length;
+
 	/*
 	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
-	 *
-	 * Consider this feature pre-BETA.
-	 *
-	 *     CAUTION: This is not for hotplugging your peripherals. As
-	 *     SCSI was not designed for this you could damage your
-	 *     hardware and thoroughly confuse the SCSI subsystem.
-	 *
 	 */
-	} else if (!strncmp("remove-single-device", buffer + 5, 20)) {
+	} else if (!strncmp("scsi remove-single-device", buffer, 25)) {
 		p = buffer + 26;
 
 		host = simple_strtoul(p, &p, 0);
@@ -366,8 +282,8 @@
 
 		err = scsi_remove_single_device(host, channel, id, lun);
 	}
-out:
-	
+
+ out:
 	free_page((unsigned long)buffer);
 	return err;
 }
diff -Nru a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
--- /dev/null	Wed Dec 31 16:00:00 1969
+++ b/drivers/scsi/scsi_sysctl.c	Mon Aug 25 13:37:07 2003
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2003 Christoph Hellwig.
+ *	Released under GPL v2.
+ */
+
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sysctl.h>
+
+#include "scsi_logging.h"
+
+
+static ctl_table scsi_table[] = {
+	{ .ctl_name	= DEV_SCSI_LOGGING_LEVEL,
+	  .procname	= "logging_level",
+	  .data		= &scsi_logging_level,
+	  .maxlen	= sizeof(scsi_logging_level),
+	  .mode		= 0644,
+	  .proc_handler	= &proc_dointvec },
+	{ }
+};
+
+static ctl_table scsi_dir_table[] = {
+	{ .ctl_name	= DEV_SCSI,
+	  .procname	= "scsi",
+	  .mode		= 0555,
+	  .child	= scsi_table },
+	{ }
+};
+
+static ctl_table scsi_root_table[] = {
+	{ .ctl_name	= CTL_DEV,
+	  .procname	= "dev",
+	  .mode		= 0555,
+	  .child	= scsi_dir_table },
+	{ }
+};
+
+static struct ctl_table_header *scsi_table_header;
+
+int __init scsi_init_sysctl(void)
+{
+	scsi_table_header = register_sysctl_table(scsi_root_table, 1);
+	if (!scsi_table_header)
+		return -ENOMEM;
+	return 0;
+}
+
+void scsi_exit_sysctl(void)
+{
+	unregister_sysctl_table(scsi_table_header);
+}
diff -Nru a/include/linux/sysctl.h b/include/linux/sysctl.h
--- a/include/linux/sysctl.h	Mon Aug 25 13:37:07 2003
+++ b/include/linux/sysctl.h	Mon Aug 25 13:37:07 2003
@@ -602,7 +600,8 @@
 	DEV_HWMON=2,
 	DEV_PARPORT=3,
 	DEV_RAID=4,
-	DEV_MAC_HID=5
+	DEV_MAC_HID=5,
+	DEV_SCSI=6,
 };
 
 /* /proc/sys/dev/cdrom */
@@ -661,6 +660,11 @@
 	DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE=4,
 	DEV_MAC_HID_MOUSE_BUTTON3_KEYCODE=5,
 	DEV_MAC_HID_ADB_MOUSE_SENDS_KEYCODES=6
+};
+
+/* /proc/sys/dev/scsi */
+enum {
+	DEV_SCSI_LOGGING_LEVEL=1,
 };
 
 /* /proc/sys/abi */
