From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 17/18] osd: Kconfig file for in-tree builds
Date: Mon, 22 Dec 2008 15:18:47 +0200
Message-ID: <1229951927-16201-1-git-send-email-bharrosh@panasas.com>
References: <494F88C0.4070507@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:3198 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbYLVNSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Dec 2008 08:18:53 -0500
In-Reply-To: <494F88C0.4070507@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-s
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Kconfig file for the drivers/scsi/osd subdirectory.
Adds the following config items:
	config SCSI_OSD_INITIATOR
	config SCSI_OSD_ULD
	config SCSI_OSD_DPRINT_SENSE
	config SCSI_OSD_DEBUG

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/Kconfig |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/osd/Kconfig

diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
new file mode 100644
index 0000000..861b5ce
--- /dev/null
+++ b/drivers/scsi/osd/Kconfig
@@ -0,0 +1,53 @@
+#
+# Kernel configuration file for the OSD scsi protocol
+#
+# Copyright (C) 2008 Panasas Inc.  All rights reserved.
+#
+# Authors:
+#   Boaz Harrosh <bharrosh@panasas.com>
+#   Benny Halevy <bhalevy@panasas.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public version 2 License as
+# published by the Free Software Foundation
+#
+# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
+#        How is it done properly?
+#
+
+config SCSI_OSD_INITIATOR
+	tristate "OSD-Initiator library"
+	depends on SCSI
+	help
+		Enable the OSD-Initiator library (libosd.ko).
+		NOTE: You must also select CRYPTO_SHA1 + CRYPTO_HMAC and their
+		dependencies
+
+config SCSI_OSD_ULD
+	tristate "OSD Upper Level driver"
+	depends on SCSI_OSD_INITIATOR
+	help
+		Build a SCSI upper layer driver that exports /dev/osdX devices
+		to user-mode for testing and controlling OSD devices. It is also
+		needed by exofs, for mounting an OSD based file system.
+
+config SCSI_OSD_DPRINT_SENSE
+    int "(0-2) When sense is returned, DEBUG print all sense descriptors"
+    default 1
+    depends on SCSI_OSD_INITIATOR
+    help
+        When a CHECK_CONDITION status is returned from a target, and a
+        sense-buffer is retrieved, turning this on will dump a full
+        sense-decoding message. Setting to 2 will also print recoverable
+        errors that might be regularly returned for some filesystem
+        operations.
+
+config SCSI_OSD_DEBUG
+	bool "Compile All OSD modules with lots of DEBUG prints"
+	default n
+	depends on SCSI_OSD_INITIATOR
+	help
+		OSD Code is populated with lots of OSD_DEBUG(..) printouts to
+		dmesg. Enable this if you found a bug and you want to help us
+		track the problem (see also MAINTAINERS). Setting this will also
+		force SCSI_OSD_DPRINT_SENSE=2.
-- 
1.6.0.1

