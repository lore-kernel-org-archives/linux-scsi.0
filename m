Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.79
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170890;
	b=G1z55vtj2IN42+NGXKBrwd5lfjOuwoO32n+3cHNE1zi2GX5xQpfnRNTrRunn7TzDxSQy
	 Hw1VshP+eZxw+DdTrHZ/CU2CXcn8ZEAVr2QpWxZ9ffdFG++FtThD/xBHiEn2S9J77yoGh
	 MVCChraAbSKo3WTuANQy/TGTKy5FxBHwASa9MrhdMMqwKBXTj0rfbck2ulk+IJHd/nCl3
	 F68LsjVKoEACr7zWpQmzWCiiEw1ndeNR3bAFAlmfVRvypafp6h65XOI58QFVPPVsW/Kfo
	 G5CnH/ZsG3bQutX1qftsRU7uepWSA9cwpWJrfk4R91d7wcobrqfIAsslQ0WfS6dMMvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170890;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=q9CXgk1Sbc+mG7aFleGXoII7jr2VTpt2NpoubHxsf7U=;
	b=AR0BnEJ/EkkLbK6vIZXaEjUGEObzFl6loQ/97vSX7mFBlonzXbWij0n3BiAG8ieM2UF0
	 w2uCazVCtauvVp8okROKy/5KnT1gcTXlTgnLiXc134RTSIzOeNlNiVGubYI1FONWiUa8s
	 snn0u90jaOdfD+T1IDFy6hjyK5ualVkMYI48Yz2Ytbc2FWJ9Fnp+8aXeVW6DFdriA1Nmg
	 ghw7zirOA1P0i9wi3BqWkyzi5LxT1KDDUXSPVMXFyIo3yaO6YMjFu9VwB9dHWZvZD+1sB
	 8J5E8P0t8q+81AuvtbWAH3jjxyMv5omGM15qY3h+EvU4kW0VxOz4DDWnvAm/2X+HHWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RM9uX5ns;
	arc=none smtp.remote-ip=95.215.58.79
Received: from mta1.migadu.com (out-79.mta1.migadu.com [95.215.58.79])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9427A606D813
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9427A606D813
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RM9uX5ns
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uo2fuVUT6RwART8wxhjQCWV0d8kp+kN+b7O6Im4nr9o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170887; v=1; x=1794775687;
 b=RM9uX5ns60UXe+iGvwgHEumWNwS4DOCeDl1+UlkbIjOdvltg4odDUOCIj5n5XooMTEsDXrY1
 IDlop8kX3TylfDVDFnnCDPEVP92/lyyzkW6PEETGN2/UMFRktn6gLqks4NkaKkU5TO9d8valDgX
 6vyIk5aE1N546OIGedBr4R7A=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 248345ec56a406a5;
	Sun, 08 Nov 2026 20:48:07 +0000
X-Mizu-Trace-ID: 248345ec56a406a5
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 12/29] scsi-multipath: introduce basic SCSI device support
Date: Sun,  8 Nov 2026 20:47:16 +0000
Message-ID: <20261108204733.557995-13-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

Like NS structure for NVME, scsi_mpath_device holds the mpath_device
structure to device management and path selection.

A module param are introduced to enable multipath - the following modes
are available:
- on
- off
- always

SCSI multipath will only be available until the following conditions:
- scsi_multipath enabled and implicit ALUA supported and unique ID
  available in VPD page 83.
- scsi_multipath always mode and unique ID available in VPD page 83

The scsi_device structure contains a pointer to scsi_mpath_device; having
this pointer set or unset indicates whether multipath is enabled or
disabled for the scsi_device.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/Kconfig          |  10 +++
 drivers/scsi/Makefile         |   1 +
 drivers/scsi/scsi.c           |   8 +-
 drivers/scsi/scsi_multipath.c | 150 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c      |   4 +
 drivers/scsi/scsi_sysfs.c     |   2 +
 include/scsi/scsi_device.h    |   2 +
 include/scsi/scsi_multipath.h |  55 +++++++++++++
 8 files changed, 231 insertions(+), 1 deletion(-)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 90b65bebec70..2491fdf6f563 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support (EXPERIMENTAL)"
+	depends on SCSI_MOD
+	select LIBMULTIPATH
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 5b9328dc3b62..989b2455dcc5 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -171,6 +171,7 @@ scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 scsi_mod-$(CONFIG_SCSI_DH)	+= scsi_dh.o
 scsi_mod-$(CONFIG_BLK_DEV_BSG)	+= scsi_bsg.o
+scsi_mod-$(CONFIG_SCSI_MULTIPATH)	+= scsi_multipath.o
 
 hv_storvsc-y			:= storvsc_drv.o
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 05232ab6366f..685297c84755 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -64,6 +64,7 @@
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
 #include <scsi/scsi_tcq.h>
 
 #include "scsi_priv.h"
@@ -1057,12 +1058,16 @@ static int __init init_scsi(void)
 	error = scsi_sysfs_register();
 	if (error)
 		goto cleanup_sysctl;
+	error =  scsi_multipath_init();
+	if (error)
+		goto cleanup_sysfs;
 
 	scsi_netlink_init();
 
 	printk(KERN_NOTICE "SCSI subsystem initialized\n");
 	return 0;
-
+cleanup_sysfs:
+	scsi_sysfs_unregister();
 cleanup_sysctl:
 	scsi_exit_sysctl();
 cleanup_hosts:
@@ -1081,6 +1086,7 @@ static int __init init_scsi(void)
 static void __exit exit_scsi(void)
 {
 	scsi_netlink_exit();
+	scsi_multipath_exit();
 	scsi_sysfs_unregister();
 	scsi_exit_sysctl();
 	scsi_exit_hosts();
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 000000000000..97f7513b4712
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Oracle Corp
+ *
+ */
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_multipath.h>
+
+#include "scsi_priv.h"
+
+#define TPGS_MODE_IMPLICIT		0x1
+
+enum {
+	SCSI_MULTIPATH_OFF,
+	SCSI_MULTIPATH_ON,
+	SCSI_MULTIPATH_ALWAYS,
+};
+
+static const char *scsi_multipath_modes[] = {
+	[SCSI_MULTIPATH_OFF]	= "off",
+	[SCSI_MULTIPATH_ON]	= "on",
+	[SCSI_MULTIPATH_ALWAYS]	= "always",
+};
+
+static int scsi_multipath = SCSI_MULTIPATH_OFF;
+
+static int scsi_multipath_param_set(const char *val, const struct kernel_param *kp)
+{
+	int mode;
+
+	if (!val)
+		return -EINVAL;
+	mode = __sysfs_match_string(scsi_multipath_modes,
+		ARRAY_SIZE(scsi_multipath_modes), val);
+
+	if (mode < 0)
+		return mode;
+	scsi_multipath = mode;
+	return 0;
+}
+
+static int scsi_multipath_param_get(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_multipath_modes[scsi_multipath]);
+}
+
+static const struct kernel_param_ops multipath_param_ops = {
+	.set = scsi_multipath_param_set,
+	.get = scsi_multipath_param_get,
+};
+
+module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
+MODULE_PARM_DESC(multipath, "turn on native multipath support, options: on, off, always");
+
+static int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	int ret;
+
+	ret = scsi_vpd_lun_id(sdev, scsi_mpath_dev->device_id_str,
+				SCSI_MPATH_DEVICE_ID_LEN);
+	if (ret < 0)
+		return ret;
+	else if (ret == 0)
+		return -EINVAL;
+	else if (ret > SCSI_MPATH_DEVICE_ID_LEN)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int scsi_multipath_sdev_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_device *scsi_mpath_dev;
+	struct mpath_device *mpath_device;
+
+	scsi_mpath_dev = kzalloc(sizeof(*scsi_mpath_dev), GFP_KERNEL);
+	if (!scsi_mpath_dev)
+		return -ENOMEM;
+	scsi_mpath_dev->sdev = sdev;
+	sdev->scsi_mpath_dev = scsi_mpath_dev;
+
+	mpath_device = &scsi_mpath_dev->mpath_device;
+	mpath_device->numa_node = dev_to_node(shost->dma_dev);
+	mpath_device->access_state = MPATH_STATE_OPTIMIZED;
+
+	return 0;
+}
+
+static void scsi_multipath_sdev_uninit(struct scsi_device *sdev)
+{
+	kfree(sdev->scsi_mpath_dev);
+	sdev->scsi_mpath_dev = NULL;
+}
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	int ret;
+
+	if (scsi_multipath == SCSI_MULTIPATH_OFF)
+		return 0;
+
+	if (!(scsi_device_tpgs(sdev) & TPGS_MODE_IMPLICIT) &&
+	    (scsi_multipath != SCSI_MULTIPATH_ALWAYS)) {
+		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipath support\n");
+		return 0;
+	}
+
+	ret = scsi_multipath_sdev_init(sdev);
+	if (ret)
+		return ret;
+
+	ret = scsi_mpath_unique_lun_id(sdev);
+	if (ret < 0)
+		goto out_uninit;
+
+	return 0;
+
+out_uninit:
+	scsi_multipath_sdev_uninit(sdev);
+	return 0;
+}
+
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+
+	if (!scsi_mpath_dev)
+		return;
+
+	scsi_multipath_sdev_uninit(sdev);
+}
+
+int __init scsi_multipath_init(void)
+{
+	return 0;
+}
+
+void __exit scsi_multipath_exit(void)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("scsi_multipath");
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8aae12fd38f3..b89bb1442a9e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_eh.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -1129,6 +1130,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->max_queue_depth = sdev->queue_depth;
 	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 
+	if (scsi_mpath_dev_alloc(sdev))
+		return SCSI_SCAN_NO_RESPONSE;
+
 	/*
 	 * Ok, the device is now all set up, we can
 	 * register it and tell the rest of the kernel
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fe54792ed69e..6a68da42df91 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_multipath.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -456,6 +457,7 @@ static void scsi_device_dev_release(struct device *dev)
 	might_sleep();
 
 	scsi_dh_release_device(sdev);
+	scsi_mpath_dev_release(sdev);
 
 	parent = sdev->sdev_gendev.parent;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e6fd6bc30644..1111fb267154 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -280,6 +280,8 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+	struct scsi_mpath_device *scsi_mpath_dev;
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 000000000000..d3d410dafd17
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <linux/multipath.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_driver.h>
+
+#ifdef CONFIG_SCSI_MULTIPATH
+#define SCSI_MPATH_DEVICE_ID_LEN 256
+
+struct scsi_mpath_device {
+	struct mpath_device	mpath_device;
+	struct scsi_device 	*sdev;
+
+	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
+};
+#define to_scsi_mpath_device(d) \
+	container_of(d, struct scsi_mpath_device, mpath_device)
+
+int scsi_mpath_dev_alloc(struct scsi_device *sdev);
+void scsi_mpath_dev_release(struct scsi_device *sdev);
+int scsi_multipath_init(void);
+void scsi_multipath_exit(void);
+#else /* CONFIG_SCSI_MULTIPATH */
+
+struct scsi_mpath_device {
+};
+
+static inline int scsi_mpath_dev_alloc(struct scsi_device *sdev)
+{
+	return 0;
+}
+static inline void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+}
+static inline int scsi_multipath_init(void)
+{
+	return 0;
+}
+static inline void scsi_multipath_exit(void)
+{
+}
+#endif /* CONFIG_SCSI_MULTIPATH */
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.0

