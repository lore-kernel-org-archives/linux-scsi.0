From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] make /proc/scsi/scsi/ support optional
Date: Mon, 25 Aug 2003 14:21:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825122126.GB15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:50843 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261754AbTHYMV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:21:29 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

There's no more essential functionality in it so allow the
embedded folks to configure it out.



diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Mon Aug 25 13:37:11 2003
+++ b/drivers/scsi/Kconfig	Mon Aug 25 13:37:12 2003
@@ -22,6 +22,17 @@
 	  module if your root file system (the one containing the directory /)
 	  is located on a SCSI device.
 
+config SCSI_PROC_FS
+	bool "legacy /proc/scsi/ support"
+	depends on SCSI
+	default y
+	---help---
+	  This option enables support for the various files in
+	  /proc/scsi.  In Linux 2.6 this has been superceeded by
+	  files in sysfs but many legacy applications rely on this.
+
+	  If unusure say Y.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Mon Aug 25 13:37:11 2003
+++ b/drivers/scsi/Makefile	Mon Aug 25 13:37:11 2003
@@ -127,7 +127,7 @@
 				   scsi_scan.o scsi_syms.o scsi_sysfs.o \
 				   scsi_devinfo.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
-scsi_mod-$(CONFIG_PROC_FS)	+= scsi_proc.o
+scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-$(CONFIG_X86_PC9800)	+= scsi_pc98.o
 			
 sd_mod-objs	:= sd.o
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:11 2003
+++ b/drivers/scsi/scsi_priv.h	Mon Aug 25 13:37:11 2003
@@ -109,7 +109,7 @@
 extern void scsi_exit_queue(void);
 
 /* scsi_proc.c */
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 extern void scsi_proc_hostdir_add(struct scsi_host_template *);
 extern void scsi_proc_hostdir_rm(struct scsi_host_template *);
 extern void scsi_proc_host_add(struct Scsi_Host *);
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Mon Aug 25 13:37:11 2003
+++ b/drivers/scsi/sg.c	Mon Aug 25 13:37:11 2003
@@ -70,7 +70,7 @@
 
 #include "scsi_logging.h"
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -222,7 +222,7 @@
 // static void sg_unmap_and(Sg_scatter_hold * schp, int free_also);
 static Sg_device *sg_get_dev(int dev);
 static inline unsigned char *sg_scatg2virt(const struct scatterlist *sclp);
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 static int sg_last_dev(void);
 #endif
 
@@ -1516,18 +1516,18 @@
 	rc = scsi_register_interface(&sg_interface);
 	if (rc)
 		return rc;
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 	sg_proc_init();
-#endif				/* CONFIG_PROC_FS */
+#endif				/* CONFIG_SCSI_PROC_FS */
 	return 0;
 }
 
 static void __exit
 exit_sg(void)
 {
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 	sg_proc_cleanup();
-#endif				/* CONFIG_PROC_FS */
+#endif				/* CONFIG_SCSI_PROC_FS */
 	scsi_unregister_interface(&sg_interface);
 	unregister_chrdev(SCSI_GENERIC_MAJOR, "sg");
 	if (sg_dev_arr != NULL) {
@@ -2225,7 +2225,7 @@
 	return resp;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 static Sg_request *
 sg_get_nth_request(Sg_fd * sfp, int nth)
 {
@@ -2317,7 +2317,7 @@
 	return res;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 static Sg_fd *
 sg_get_nth_sfp(Sg_device * sdp, int nth)
 {
@@ -2548,7 +2548,7 @@
 	return 0;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 static int
 sg_last_dev(void)
 {
@@ -2579,7 +2579,7 @@
 	return sdp;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_SCSI_PROC_FS
 
 static struct proc_dir_entry *sg_proc_sgp = NULL;
 
@@ -2971,7 +2971,7 @@
 	PRINT_PROC("%d\t%s\n", sg_version_num, sg_version_str);
 	return 1;
 }
-#endif				/* CONFIG_PROC_FS */
+#endif				/* CONFIG_SCSI_PROC_FS */
 
 module_init(init_sg);
 module_exit(exit_sg);
diff -Nru a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	Mon Aug 25 13:37:16 2003
+++ b/drivers/scsi/scsi_devinfo.c	Mon Aug 25 13:37:16 2003
@@ -381,6 +381,7 @@
 	return scsi_default_dev_flags;
 }
 
+#ifdef CONFIG_SCSI_PROC_FS
 /* 
  * proc_scsi_dev_info_read: dump the scsi_dev_info_list via
  * /proc/scsi/device_info
@@ -451,6 +452,7 @@
 	free_page((unsigned long)buffer);
 	return err;
 }
+#endif /* CONFIG_SCSI_PROC_FS */
 
 module_param_string(dev_flags, scsi_dev_flags, sizeof(scsi_dev_flags), 0);
 MODULE_PARM_DESC(dev_flags,
@@ -471,7 +473,9 @@
 	struct list_head *lh, *lh_next;
 	struct scsi_dev_info_list *devinfo;
 
+#ifdef CONFIG_SCSI_PROC_FS
 	remove_proc_entry("scsi/device_info", 0);
+#endif
 
 	list_for_each_safe(lh, lh_next, &scsi_dev_info_list) {
 		devinfo = list_entry(lh, struct scsi_dev_info_list,
@@ -490,7 +494,9 @@
  **/
 int scsi_init_devinfo(void)
 {
+#ifdef CONFIG_SCSI_PROC_FS
 	struct proc_dir_entry *p;
+#endif
 	int error, i;
 
 	error = scsi_dev_info_list_add_str(scsi_dev_flags);
@@ -507,6 +513,7 @@
 			goto out;
 	}
 
+#ifdef CONFIG_SCSI_PROC_FS
 	p = create_proc_entry("scsi/device_info", 0, NULL);
 	if (!p) {
 		error = -ENOMEM;
@@ -516,6 +523,7 @@
 	p->owner = THIS_MODULE;
 	p->get_info = proc_scsi_devinfo_read;
 	p->write_proc = proc_scsi_devinfo_write;
+#endif /* CONFIG_SCSI_PROC_FS */
 
  out:
 	if (error)
