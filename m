From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 3/3] scsi: Remove scsi_ioctl.h
Date: Thu,  8 Jan 2015 11:47:59 -0800
Message-ID: <1420746479-25949-4-git-send-email-agrover@redhat.com>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbbAHTsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 14:48:08 -0500
In-Reply-To: <1420746479-25949-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

Now that we have uapi/scsi/scsi.h, that is the logical place for SCSI ioctl
definitions to go. The kernel-specific stuff that remains is so little that
it can be folded into scsi/scsi.h, and scsi_ioctl.h removed.

Remove all scsi_ioctl.h #includes since they all also include scsi/scsi.h,
except for ide-floppy_ioctl.c where we just replace it with including
scsi/scsi.h.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 block/bsg.c                        |  1 -
 block/scsi_ioctl.c                 |  1 -
 drivers/block/cciss.c              |  1 -
 drivers/block/pktcdvd.c            |  1 -
 drivers/ide/ide-floppy.c           |  2 --
 drivers/ide/ide-floppy_ioctl.c     |  2 +-
 drivers/scsi/ch.c                  |  1 -
 drivers/scsi/fdomain.c             |  1 -
 drivers/scsi/nsp32.c               |  1 -
 drivers/scsi/osd/osd_uld.c         |  1 -
 drivers/scsi/osst.c                |  1 -
 drivers/scsi/pcmcia/aha152x_stub.c |  1 -
 drivers/scsi/pcmcia/fdomain_stub.c |  1 -
 drivers/scsi/pcmcia/nsp_cs.c       |  1 -
 drivers/scsi/pcmcia/qlogic_stub.c  |  1 -
 drivers/scsi/pcmcia/sym53c500_cs.c |  1 -
 drivers/scsi/scsi_error.c          |  1 -
 drivers/scsi/scsi_ioctl.c          |  1 -
 drivers/scsi/sd.c                  |  1 -
 drivers/scsi/sd_dif.c              |  1 -
 drivers/scsi/sg.c                  |  1 -
 drivers/scsi/sr.c                  |  1 -
 drivers/scsi/sr_ioctl.c            |  1 -
 drivers/scsi/sr_vendor.c           |  1 -
 drivers/scsi/st.c                  |  1 -
 fs/compat_ioctl.c                  |  1 -
 include/scsi/scsi.h                |  6 +++++
 include/scsi/scsi_ioctl.h          | 48 --------------------------------------
 include/uapi/scsi/scsi.h           | 42 ++++++++++++++++++++++++++++-----
 29 files changed, 43 insertions(+), 81 deletions(-)
 delete mode 100644 include/scsi/scsi_ioctl.h

diff --git a/block/bsg.c b/block/bsg.c
index 276e869..440d0ce 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 28163fad..44aec0b 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -31,7 +31,6 @@
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 
 struct blk_cmd_filter {
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f19..b28b0f7 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -51,7 +51,6 @@
 #include <linux/completion.h>
 #include <scsi/scsi.h>
 #include <scsi/sg.h>
-#include <scsi/scsi_ioctl.h>
 #include <linux/cdrom.h>
 #include <linux/scatterlist.h>
 #include <linux/kthread.h>
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09e628da..932b13d 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -62,7 +62,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 8c6363c..1706679 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -32,8 +32,6 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 
-#include <scsi/scsi_ioctl.h>
-
 #include <asm/byteorder.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index a22ca84..d4dd038 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -9,7 +9,7 @@
 
 #include <asm/unaligned.h>
 
-#include <scsi/scsi_ioctl.h>
+#include <scsi/scsi.h>
 
 #include "ide-floppy.h"
 
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 6bac8a7..d3fa6de7 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -27,7 +27,6 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_driver.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index fff6829..3547ee5 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -287,7 +287,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 #include "fdomain.h"
 
 #ifndef PCMCIA
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 90abb03..c2438ab 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -44,7 +44,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 
 #include "nsp32.h"
 
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 243eab3..a0fb7ec 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -55,7 +55,6 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_ioctl.h>
 
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 5033223..04a03ad 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -70,7 +70,6 @@ static const char * osst_version = "0.99.4";
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 
 #define ST_KILOBYTE 1024
 
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 7d1609f..5e6d675 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -43,7 +43,6 @@
 #include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 714b248..c3e7ce5 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -40,7 +40,6 @@
 #include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 34aad32..e764df5 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -45,7 +45,6 @@
 #include <scsi/scsi_host.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index bcaf89f..8887118 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -41,7 +41,6 @@
 #include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
 #include <linux/interrupt.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 155f957..c1a9db9 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -65,7 +65,6 @@
 #include <asm/dma.h>
 #include <asm/irq.h>
 
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9ac9eb1..f265345 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -35,7 +35,6 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
 #include "scsi_priv.h"
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index c4f7b56..391c952 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -19,7 +19,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 #include <scsi/scsi_dbg.h>
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3995169..b4b1585 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -61,7 +61,6 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 
 #include "sd.h"
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 14c7d42..ab697a7 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -30,7 +30,6 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 
 #include "sd.h"
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b14f64c..e6fc868 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -56,7 +56,6 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_driver.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
 #include "scsi_logging.h"
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8bd54a6..8b99e0e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -55,7 +55,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
 
 #include "scsi_logging.h"
 #include "sr.h"
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fb929fa..ab5b947 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -17,7 +17,6 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 
 #include "sr.h"
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 11a238c..042b2cd 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -45,7 +45,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 
 #include "sr.h"
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 128d3b5..b12c6e5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -50,7 +50,6 @@ static const char *verstr = "20101219";
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 
 
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index afec645..ea08c25 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -69,7 +69,6 @@
 #include <linux/cdrom.h>
 #include <linux/fd.h>
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
 #endif
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 4a33602..d78876f 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -73,4 +73,10 @@ scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus);
 /* Returns a human-readable name for the device */
 extern const char * scsi_device_type(unsigned type);
 
+struct scsi_device;
+
+int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
+		int cmd, bool ndelay);
+extern int scsi_ioctl(struct scsi_device *, int, void __user *);
+
 #endif /* _SCSI_SCSI_H */
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
deleted file mode 100644
index 8d19d1d..0000000
--- a/include/scsi/scsi_ioctl.h
+++ /dev/null
@@ -1,48 +0,0 @@
-#ifndef _SCSI_IOCTL_H
-#define _SCSI_IOCTL_H 
-
-#define SCSI_IOCTL_SEND_COMMAND 1
-#define SCSI_IOCTL_TEST_UNIT_READY 2
-#define SCSI_IOCTL_BENCHMARK_COMMAND 3
-#define SCSI_IOCTL_SYNC 4			/* Request synchronous parameters */
-#define SCSI_IOCTL_START_UNIT 5
-#define SCSI_IOCTL_STOP_UNIT 6
-/* The door lock/unlock constants are compatible with Sun constants for
-   the cdrom */
-#define SCSI_IOCTL_DOORLOCK 0x5380		/* lock the eject mechanism */
-#define SCSI_IOCTL_DOORUNLOCK 0x5381		/* unlock the mechanism	  */
-
-#define	SCSI_REMOVAL_PREVENT	1
-#define	SCSI_REMOVAL_ALLOW	0
-
-#ifdef __KERNEL__
-
-struct scsi_device;
-
-/*
- * Structures used for scsi_ioctl et al.
- */
-
-typedef struct scsi_ioctl_command {
-	unsigned int inlen;
-	unsigned int outlen;
-	unsigned char data[0];
-} Scsi_Ioctl_Command;
-
-typedef struct scsi_idlun {
-	__u32 dev_id;
-	__u32 host_unique_id;
-} Scsi_Idlun;
-
-/* Fibre Channel WWN, port_id struct */
-typedef struct scsi_fctargaddress {
-	__u32 host_port_id;
-	unsigned char host_wwn[8]; // include NULL term.
-} Scsi_FCTargAddress;
-
-int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
-		int cmd, bool ndelay);
-extern int scsi_ioctl(struct scsi_device *, int, void __user *);
-
-#endif /* __KERNEL__ */
-#endif /* _SCSI_IOCTL_H */
diff --git a/include/uapi/scsi/scsi.h b/include/uapi/scsi/scsi.h
index 4cadafa..87024a0 100644
--- a/include/uapi/scsi/scsi.h
+++ b/include/uapi/scsi/scsi.h
@@ -500,13 +500,32 @@ static inline int scsi_is_wlun(u64 lun)
 #define SCSI_INQ_PQ_NOT_CON     0x01
 #define SCSI_INQ_PQ_NOT_CAP     0x03
 
+/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
+static inline __u32 scsi_to_u32(__u8 *ptr)
+{
+	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
+}
 
 /*
- * Here are some scsi specific ioctl commands which are sometimes useful.
+ * SCSI specific ioctl commands.
  *
  * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
  */
 
+#define SCSI_IOCTL_SEND_COMMAND 1
+#define SCSI_IOCTL_TEST_UNIT_READY 2
+#define SCSI_IOCTL_BENCHMARK_COMMAND 3
+#define SCSI_IOCTL_SYNC 4			/* Request synchronous parameters */
+#define SCSI_IOCTL_START_UNIT 5
+#define SCSI_IOCTL_STOP_UNIT 6
+/* The door lock/unlock constants are compatible with Sun constants for
+   the cdrom */
+#define SCSI_IOCTL_DOORLOCK 0x5380		/* lock the eject mechanism */
+#define SCSI_IOCTL_DOORUNLOCK 0x5381		/* unlock the mechanism	  */
+
+#define	SCSI_REMOVAL_PREVENT	1
+#define	SCSI_REMOVAL_ALLOW	0
+
 /* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
 #define SCSI_IOCTL_GET_IDLUN		0x5382
 
@@ -521,10 +540,21 @@ static inline int scsi_is_wlun(u64 lun)
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
-/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
-static inline __u32 scsi_to_u32(__u8 *ptr)
-{
-	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
-}
+typedef struct scsi_ioctl_command {
+	unsigned int inlen;
+	unsigned int outlen;
+	unsigned char data[0];
+} Scsi_Ioctl_Command;
+
+typedef struct scsi_idlun {
+	__u32 dev_id;
+	__u32 host_unique_id;
+} Scsi_Idlun;
+
+/* Fibre Channel WWN, port_id struct */
+typedef struct scsi_fctargaddress {
+	__u32 host_port_id;
+	unsigned char host_wwn[8]; // include NULL term.
+} Scsi_FCTargAddress;
 
 #endif /* _UAPI_SCSI_SCSI_H */
-- 
2.1.0

