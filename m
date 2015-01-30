From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 4/5] scsi: Move scsi/scsi_ioctl.h to uapi/linux/scsi_ioctl.h
Date: Thu, 29 Jan 2015 16:56:36 -0800
Message-ID: <1422579397-18696-5-git-send-email-agrover@redhat.com>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbbA3A4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 19:56:44 -0500
In-Reply-To: <1422579397-18696-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

Make all scsi ioctl-related definitions available via a uapi header.

Change files referencing scsi/scsi_ioctl.h to refer to
uapi/linux/scsi_ioctl.h.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 block/bsg.c                        |  2 +-
 block/scsi_ioctl.c                 |  2 +-
 drivers/block/cciss.c              |  2 +-
 drivers/block/pktcdvd.c            |  2 +-
 drivers/ide/ide-floppy.c           |  2 +-
 drivers/ide/ide-floppy_ioctl.c     |  2 +-
 drivers/scsi/ch.c                  |  2 +-
 drivers/scsi/fdomain.c             |  2 +-
 drivers/scsi/nsp32.c               |  2 +-
 drivers/scsi/osd/osd_uld.c         |  2 +-
 drivers/scsi/osst.c                |  2 +-
 drivers/scsi/pcmcia/aha152x_stub.c |  2 +-
 drivers/scsi/pcmcia/fdomain_stub.c |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c       |  2 +-
 drivers/scsi/pcmcia/qlogic_stub.c  |  2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c |  2 +-
 drivers/scsi/scsi_error.c          |  2 +-
 drivers/scsi/scsi_ioctl.c          |  2 +-
 drivers/scsi/sd.c                  |  2 +-
 drivers/scsi/sd_dif.c              |  2 +-
 drivers/scsi/sg.c                  |  2 +-
 drivers/scsi/sr.c                  |  2 +-
 drivers/scsi/sr_ioctl.c            |  2 +-
 drivers/scsi/sr_vendor.c           |  2 +-
 drivers/scsi/st.c                  |  2 +-
 fs/compat_ioctl.c                  |  2 +-
 include/scsi/scsi_ioctl.h          | 68 -----------------------------------
 include/uapi/linux/Kbuild          |  1 +
 include/uapi/linux/scsi_ioctl.h    | 72 ++++++++++++++++++++++++++++++++++++++
 29 files changed, 99 insertions(+), 94 deletions(-)
 delete mode 100644 include/scsi/scsi_ioctl.h
 create mode 100644 include/uapi/linux/scsi_ioctl.h

diff --git a/block/bsg.c b/block/bsg.c
index 276e869..f5796993 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -23,7 +23,7 @@
 #include <linux/slab.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_driver.h>
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 28163fad..7bf22f2 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -31,7 +31,7 @@
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 
 struct blk_cmd_filter {
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f19..8c79ac0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -51,7 +51,7 @@
 #include <linux/completion.h>
 #include <scsi/scsi.h>
 #include <scsi/sg.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <linux/cdrom.h>
 #include <linux/scatterlist.h>
 #include <linux/kthread.h>
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09e628da..46b7ce4 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -62,7 +62,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsi.h>
 #include <linux/debugfs.h>
 #include <linux/device.h>
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 8c6363c..da947b2 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -32,7 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include <asm/byteorder.h>
 #include <linux/uaccess.h>
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index a22ca84..058d802 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -9,7 +9,7 @@
 
 #include <asm/unaligned.h>
 
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include "ide-floppy.h"
 
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 0045742..3537519 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -27,7 +27,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_driver.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index fff6829..fea41e3 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -287,7 +287,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include "fdomain.h"
 
 #ifndef PCMCIA
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 90abb03..aa7c549 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -44,7 +44,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include "nsp32.h"
 
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 243eab3..34f76cd 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -55,7 +55,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 5033223..3be45e7 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -70,7 +70,7 @@ static const char * osst_version = "0.99.4";
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #define ST_KILOBYTE 1024
 
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 7d1609f..8fd95b4 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -43,7 +43,7 @@
 #include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 714b248..f3a18c6e 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -40,7 +40,7 @@
 #include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 34aad32..961f2a7 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -45,7 +45,7 @@
 #include <scsi/scsi_host.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index bcaf89f..8a87325 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -41,7 +41,7 @@
 #include <scsi/scsi.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <linux/interrupt.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 155f957..77b8239 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -65,7 +65,7 @@
 #include <asm/dma.h>
 #include <asm/irq.h>
 
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4cdaffc..012ccc2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -35,7 +35,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/sg.h>
 
 #include "scsi_priv.h"
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index c4f7b56..d327eccf 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -19,7 +19,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/sg.h>
 #include <scsi/scsi_dbg.h>
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ebf35cb6..f88bd15 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -61,7 +61,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 
 #include "sd.h"
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 14c7d42..183d7b6 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -30,7 +30,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 
 #include "sd.h"
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b14f64c..944ff17 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -56,7 +56,7 @@ static int sg_version_num = 30536;	/* 2 digits for each component */
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_driver.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/sg.h>
 
 #include "scsi_logging.h"
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8bd54a6..219207d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -55,7 +55,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>	/* For the door lock/unlock commands */
+#include <uapi/linux/scsi_ioctl.h>	/* For the door lock/unlock commands */
 
 #include "scsi_logging.h"
 #include "sr.h"
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 03054c0..013cf5e 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -17,7 +17,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 
 #include "sr.h"
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 11a238c..67300e5 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -45,7 +45,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 
 #include "sr.h"
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 128d3b5..f3f35a5 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -50,7 +50,7 @@ static const char *verstr = "20101219";
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/sg.h>
 
 
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index afec645..310bf46 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -69,7 +69,7 @@
 #include <linux/cdrom.h>
 #include <linux/fd.h>
 #include <scsi/scsi.h>
-#include <scsi/scsi_ioctl.h>
+#include <uapi/linux/scsi_ioctl.h>
 #include <scsi/sg.h>
 #endif
 
diff --git a/include/scsi/scsi_ioctl.h b/include/scsi/scsi_ioctl.h
deleted file mode 100644
index 4d9f71f..0000000
--- a/include/scsi/scsi_ioctl.h
+++ /dev/null
@@ -1,68 +0,0 @@
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
-/*
- * Here are some scsi specific ioctl commands which are sometimes useful.
- *
- * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
- */
-
-/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
-#define SCSI_IOCTL_GET_IDLUN		0x5382
-
-/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
-
-/* Used to obtain the host number of a device. */
-#define SCSI_IOCTL_PROBE_HOST		0x5385
-
-/* Used to obtain the bus number for a device */
-#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
-
-/* Used to obtain the PCI location of a device */
-#define SCSI_IOCTL_GET_PCI		0x5387
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
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 80c5d8e..6e54bbb 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -349,6 +349,7 @@ header-y += rtc.h
 header-y += rtnetlink.h
 header-y += scc.h
 header-y += scsi.h
+header-y += scsi_ioctl.h
 header-y += sched.h
 header-y += screen_info.h
 header-y += sctp.h
diff --git a/include/uapi/linux/scsi_ioctl.h b/include/uapi/linux/scsi_ioctl.h
new file mode 100644
index 0000000..7a2075e
--- /dev/null
+++ b/include/uapi/linux/scsi_ioctl.h
@@ -0,0 +1,72 @@
+/*
+ * SCSI specific ioctl commands.
+ *
+ * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
+ */
+
+#include <linux/types.h>
+
+#ifndef _UAPI_LINUX_SCSI_IOCTL_H
+#define _UAPI_LINUX_SCSI_IOCTL_H
+
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
+/*
+ * Here are some scsi specific ioctl commands which are sometimes useful.
+ *
+ * Note that include/linux/cdrom.h also defines IOCTL 0x5300 - 0x5395
+ */
+
+/* Used to obtain PUN and LUN info.  Conflicts with CDROMAUDIOBUFSIZ */
+#define SCSI_IOCTL_GET_IDLUN		0x5382
+
+/* 0x5383 and 0x5384 were used for SCSI_IOCTL_TAGGED_{ENABLE,DISABLE} */
+
+/* Used to obtain the host number of a device. */
+#define SCSI_IOCTL_PROBE_HOST		0x5385
+
+/* Used to obtain the bus number for a device */
+#define SCSI_IOCTL_GET_BUS_NUMBER	0x5386
+
+/* Used to obtain the PCI location of a device */
+#define SCSI_IOCTL_GET_PCI		0x5387
+
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
+
+#ifdef __KERNEL__
+
+struct scsi_device;
+
+int scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev,
+		int cmd, bool ndelay);
+extern int scsi_ioctl(struct scsi_device *, int, void __user *);
+
+#endif /* __KERNEL__ */
+#endif /* _UAPI_LINUX_SCSI_IOCTL_H */
-- 
2.1.0

