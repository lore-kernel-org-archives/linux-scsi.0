From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg: max_scatter_elem_sz parameter; lk 2.6.17-rc1
Date: Tue, 11 Apr 2006 14:51:08 -0400
Message-ID: <443BFA9C.6030302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030300010009060100090203"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:34759 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1750971AbWDKSyC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 14:54:02 -0400
Received: from mtl-hse-ppp199515.qc.sympatico.ca ([65.94.219.71] helo=[192.168.1.100])
	by canuck.infradead.org with esmtpsa (Exim 4.61 #1 (Red Hat Linux))
	id 1FTO00-0006Fd-6Y
	for linux-scsi@vger.kernel.org; Tue, 11 Apr 2006 14:54:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030300010009060100090203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

There is a small band of folks out there who push
the "big data transfer per command" limit. That
became a more interesting exercise in lk 2.6.16 as
discussed in:
http://www.torque.net/sg/sg_io.html [in the maximum
transfer size section].

To make the sg driver more flexible in this area,
the attachment introduces the max_scatter_elem_sz
sysfs/kernel_or_module load time parameter that
overrides the SG_SCATTER_SZ define when given.

Post lk 2.6.16 the largest scatter gather element
size is limited to MAX_SEGMENT_SIZE [64 KB] unless
that is overridden by a blk_queue_max_segment_size()
in the LLD.

Changelog:
  - add max_scatter_elem_sz parameter; can be read or
    written in sysfs, or supplied as a kernel load time,
    or module load time parameter
  - bump sg version number to 3.5.34 to reflect change
    (addition) to its interface

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------030300010009060100090203
Content-Type: text/x-patch;
 name="sg2616max_scat.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2616max_scat.diff"

--- linux/drivers/scsi/sg.c	2006-03-20 10:08:49.000000000 -0500
+++ linux/drivers/scsi/sg.c2616max_scat	2006-03-29 22:05:53.000000000 -0500
@@ -18,8 +18,8 @@
  *
  */
 
-static int sg_version_num = 30533;	/* 2 digits for each component */
-#define SG_VERSION_STR "3.5.33"
+static int sg_version_num = 30534;	/* 2 digits for each component */
+#define SG_VERSION_STR "3.5.34"
 
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
@@ -62,7 +62,7 @@
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
-static char *sg_version_date = "20050908";
+static char *sg_version_date = "20060329";
 
 static int sg_proc_init(void);
 static void sg_proc_cleanup(void);
@@ -96,6 +96,8 @@
 static int def_reserved_size = -1;	/* picks up init parameter */
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
+static int max_scatter_elem_sz = SG_SCATTER_SZ;
+
 #define SG_SECTOR_SZ 512
 #define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
 
@@ -1570,6 +1572,7 @@
  * of sysfs parameters (which module_param doesn't yet support).
  * Sysfs parameters defined explicitly below.
  */
+module_param_named(max_scatter_elem_sz, max_scatter_elem_sz, int, S_IRUGO | S_IWUSR);
 module_param_named(def_reserved_size, def_reserved_size, int, S_IRUGO);
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
 
@@ -1578,6 +1581,8 @@
 MODULE_LICENSE("GPL");
 MODULE_VERSION(SG_VERSION_STR);
 
+MODULE_PARM_DESC(max_scatter_elem_sz, "maximum scatter gather element "
+		 "size (default: 32768)");
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
@@ -1872,7 +1877,8 @@
 	     (rem_sz > 0) && (k < mx_sc_elems);
 	     ++k, rem_sz -= ret_sz, ++sg) {
 		
-		num = (rem_sz > SG_SCATTER_SZ) ? SG_SCATTER_SZ : rem_sz;
+		num = (rem_sz > max_scatter_elem_sz) ?
+			max_scatter_elem_sz : rem_sz;
 		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
 		if (!p)
 			return -ENOMEM;

--------------030300010009060100090203--
