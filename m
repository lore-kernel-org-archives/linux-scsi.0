From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] add scsi_driver.h
Date: Tue, 24 Jun 2003 08:49:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624064941.GB26582@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:44698 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265722AbTFXGfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 02:35:36 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

include/scsi/scsi_driver.h contains =E6verything related to upper
level drivers.  Unlike the other header moves there's no compatiblity
this time as it's easy to fix up the few users.


diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/hosts.h	Mon Jun 23 11:00:34 2003
@@ -26,28 +26,8 @@
=20
 #include <linux/config.h>
 #include <linux/proc_fs.h>
-#include <linux/types.h>
=20
 #include <scsi/scsi_host.h>
-
-struct scsi_driver {
-	struct module		*owner;
-	struct device_driver	gendrv;
-
-	int (*init_command)(struct scsi_cmnd *);
-	void (*rescan)(struct device *);
-};
-#define to_scsi_driver(drv) \
-	container_of((drv), struct scsi_driver, gendrv)
-
-extern int scsi_register_driver(struct device_driver *);
-#define scsi_unregister_driver(drv) \
-	driver_unregister(drv);
-
-extern int scsi_register_interface(struct class_interface *);
-#define scsi_unregister_interface(intf) \
-	class_interface_unregister(intf)
-
=20
 /**
  * scsi_find_device - find a device given the host
diff -Nru a/drivers/scsi/osst.c b/drivers/scsi/osst.c
--- a/drivers/scsi/osst.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/osst.c	Mon Jun 23 11:00:34 2003
@@ -63,6 +63,7 @@
=20
 #include "scsi.h"
 #include "hosts.h"
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
=20
 #define ST_KILOBYTE 1024
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/scsi_lib.c	Mon Jun 23 11:00:34 2003
@@ -18,6 +18,7 @@
=20
 #include "scsi.h"
 #include "hosts.h"
+#include <scsi/scsi_driver.h>
=20
 #include "scsi_priv.h"
 #include "scsi_logging.h"
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/scsi_scan.c	Mon Jun 23 11:00:34 2003
@@ -33,6 +33,7 @@
=20
 #include "scsi.h"
 #include "hosts.h"
+#include <scsi/scsi_driver.h>
=20
 #include "scsi_priv.h"
 #include "scsi_logging.h"
diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/scsi_syms.c	Mon Jun 23 11:00:34 2003
@@ -19,6 +19,7 @@
 #include <asm/dma.h>
=20
 #include "scsi.h"
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 #include "hosts.h"
 #include "scsi_logging.h"
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/sd.c	Mon Jun 23 11:00:34 2003
@@ -49,6 +49,8 @@
=20
 #include "scsi.h"
 #include "hosts.h"
+
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
=20
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/sg.c	Mon Jun 23 11:00:34 2003
@@ -64,6 +64,7 @@
 #include <linux/blk.h>
 #include "scsi.h"
 #include "hosts.h"
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
=20
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/sr.c	Mon Jun 23 11:00:34 2003
@@ -48,6 +48,8 @@
=20
 #include "scsi.h"
 #include "hosts.h"
+
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
=20
 #include "scsi_logging.h"
diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Mon Jun 23 11:00:34 2003
+++ b/drivers/scsi/st.c	Mon Jun 23 11:00:34 2003
@@ -59,6 +59,8 @@
=20
 #include "scsi.h"
 #include "hosts.h"
+
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
=20
 #define ST_KILOBYTE 1024
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
