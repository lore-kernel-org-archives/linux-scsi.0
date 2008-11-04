From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 17/18] osd: Kconfig file for in-tree builds
Date: Tue,  4 Nov 2008 18:44:54 +0200
Message-ID: <1225817094-6270-1-git-send-email-bharrosh@panasas.com>
References: <491073BB.4000900@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:37571 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYKDQqF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 11:46:05 -0500
In-Reply-To: <491073BB.4000900@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.j>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>

Kconfig file for the drivers/scsi/osd subdirectory.
Adds the following config items:
	config SCSI_OSD_INITIATOR
	config SCSI_OSD_ULD
	config SCSI_OSD_DEBUG

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/Kconfig |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/osd/Kconfig

diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
new file mode 100644
index 0000000..ac3be8a
--- /dev/null
+++ b/drivers/scsi/osd/Kconfig
@@ -0,0 +1,41 @@
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
+		needed by osdfs, for mounting an OSD based file system.
+
+config SCSI_OSD_DEBUG
+	bool "Compile All OSD modules with lots of DEBUG prints"
+	default n
+	depends on SCSI_OSD_INITIATOR
+	help
+		OSD Code is populated with lots of OSD_DEBUG(..) printouts to
+		dmesg. Enable this if you found a bug and you want to help us
+		track the problem (see also MAINTAINERS).
-- 
1.6.0.1

