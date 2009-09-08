From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 1/6] scsi layer and be2iscsi Makefile/Kconfig
Date: Tue, 8 Sep 2009 14:07:05 +0530
Message-ID: <20090908083655.GA19495@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:39302 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753865AbZIHIg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2009 04:36:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu, sfr@canb.auug.org.au

The modified Makefile and Kconfig to add be2iscsi

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/Kconfig           |    1 +
 drivers/scsi/Makefile          |    1 +
 drivers/scsi/be2iscsi/Kconfig  |    8 ++++++++
 drivers/scsi/be2iscsi/Makefile |    8 ++++++++
 4 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/be2iscsi/Kconfig
 create mode 100644 drivers/scsi/be2iscsi/Makefile

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9c23122..aed7c50 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -366,6 +366,7 @@ config ISCSI_TCP
 
 source "drivers/scsi/cxgb3i/Kconfig"
 source "drivers/scsi/bnx2i/Kconfig"
+source "drivers/scsi/be2iscsi/Kconfig"
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 25429ea..e9389ac 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -130,6 +130,7 @@ obj-$(CONFIG_SCSI_MVSAS)	+= mvsas/
 obj-$(CONFIG_PS3_ROM)		+= ps3rom.o
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgb3i/
 obj-$(CONFIG_SCSI_BNX2_ISCSI)	+= libiscsi.o bnx2i/
+obj-$(CONFIG_BE2ISCSI)		+= libiscsi.o be2iscsi/
 
 obj-$(CONFIG_ARM)		+= arm/
 
diff --git a/drivers/scsi/be2iscsi/Kconfig b/drivers/scsi/be2iscsi/Kconfig
new file mode 100644
index 0000000..2952fcd
--- /dev/null
+++ b/drivers/scsi/be2iscsi/Kconfig
@@ -0,0 +1,8 @@
+config BE2ISCSI
+	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
+	depends on PCI && SCSI
+	select SCSI_ISCSI_ATTRS
+
+	help
+	This driver implements the iSCSI functionality for ServerEngines'
+	10Gbps Storage adapter - BladeEngine 2.
diff --git a/drivers/scsi/be2iscsi/Makefile b/drivers/scsi/be2iscsi/Makefile
new file mode 100644
index 0000000..c11f443
--- /dev/null
+++ b/drivers/scsi/be2iscsi/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile to build the iSCSI driver for ServerEngine's BladeEngine.
+#
+#
+
+obj-$(CONFIG_BE2ISCSI) += be2iscsi.o
+
+be2iscsi-y := be_iscsi.o be_main.o be_mgmt.o be_cmds.o
-- 
1.6.4

