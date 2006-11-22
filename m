From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/3] Add Kconfig option for asynchronous SCSI scanning
Date: Wed, 22 Nov 2006 13:24:52 -0700
Message-ID: <11642270941849-git-send-email-matthew@wil.cx>
References: <11642270942262-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60589 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1756899AbWKVUYz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 15:24:55 -0500
In-Reply-To: <11642270942262-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

Without this patch, the user has to add a kernel command line parameter
to get asynchronous SCSI scanning.  Now they can select the default at
compile time and still override it at boot time if they need to.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/Kconfig     |   17 +++++++++++++++++
 drivers/scsi/scsi_scan.c |    8 +++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9540eb8..c312444 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -216,6 +216,23 @@ config SCSI_LOGGING
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+config SCSI_SCAN_ASYNC
+	bool "Asynchronous SCSI scanning"
+	depends on SCSI
+	help
+	  The SCSI subsystem can probe for devices while the rest of the
+	  system continues booting, and even probe devices on different
+	  busses in parallel, leading to a significant speed-up.
+	  If you have built SCSI as modules, enabling this option can
+	  be a problem as the devices may not have been found by the
+	  time your system expects them to have been.  You can load the
+	  scsi_wait_scan module to ensure that all scans have completed.
+	  If you build your SCSI drivers into the kernel, then everything
+	  will work fine if you say Y here.
+
+	  You can override this choice by specifying scsi_mod.scan="sync"
+	  or "async" on the kernel's command line.
+
 menu "SCSI Transports"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 148e24c..6855472 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -89,7 +89,13 @@ module_param_named(max_luns, max_scsi_lu
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
-static char scsi_scan_type[6] = "sync";
+#ifdef CONFIG_SCSI_SCAN_ASYNC
+#define SCSI_SCAN_TYPE_DEFAULT "async"
+#else
+#define SCSI_SCAN_TYPE_DEFAULT "sync"
+#endif
+
+static char scsi_scan_type[6] = SCSI_SCAN_TYPE_DEFAULT;
 
 module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S_IRUGO);
 MODULE_PARM_DESC(scan, "sync, async or none");
-- 
1.4.3.3

