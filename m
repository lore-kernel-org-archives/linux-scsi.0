From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 12/14] osd: Kconfig file for in-tree builds
Date: Thu, 24 Jul 2008 21:00:53 +0300
Message-ID: <4888C355.6000201@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25293 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751739AbYGXSBn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 14:01:43 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


This file is not needed in the out-of-tree repository, but is put here
so the defines are kept in sync. (eg. CONFIG_SCSI_OSD_DEBUG)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/Kconfig |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/osd/Kconfig

diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
new file mode 100644
index 0000000..006fc87
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
+		to user-mode for testing and controlling OSD devices. This is
+		only useful if you want to run the OSD regression tests
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
1.5.6.rc1.5.gadf6


