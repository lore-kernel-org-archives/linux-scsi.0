From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/14] fcoe, libfc, scsi: adds libfcoe module
Date: Tue, 17 Mar 2009 11:42:13 -0700
Message-ID: <20090317184213.22987.65946.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145AbZCQSmP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:42:15 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

Just sets up build environment for libfcoe module towards a
libfcoe library for libfc LLDs using FCoE as libfc transport.

Common library code to libfcoe is added in next patch.

Also, updated MODULE_LICENSE from "GPL" string to "GPL v2" for
libfc, libfcoe and fcoe modules to accurately match the licenses.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/Kconfig        |    8 +++++++-
 drivers/scsi/Makefile       |    1 +
 drivers/scsi/fcoe/Makefile  |    1 +
 drivers/scsi/fcoe/fcoe.c    |    2 +-
 drivers/scsi/fcoe/libfcoe.c |   24 ++++++++++++++++++++++++
 drivers/scsi/libfc/fc_fcp.c |    2 +-
 6 files changed, 35 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/fcoe/libfcoe.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e2f44e6..bbec3a8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -614,10 +614,16 @@ config LIBFC
 	---help---
 	  Fibre Channel library module
 
+config LIBFCOE
+	tristate "LibFCoE module"
+	select LIBFC
+	---help---
+	  Library for Fibre Channel over Ethernet module
+
 config FCOE
 	tristate "FCoE module"
 	depends on PCI
-	select LIBFC
+	select LIBFCOE
 	---help---
 	  Fibre Channel over Ethernet module
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index cf79296..e7c861a 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
 obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_LIBFC)		+= libfc/
+obj-$(CONFIG_LIBFCOE)		+= fcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index 9b590ef..950f276 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_FCOE) += fcoe.o
+obj-$(CONFIG_LIBFCOE) += libfcoe.o
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cbebbf7..af40410 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -70,7 +70,7 @@ static int debug_fcoe;
 
 MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FCoE");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 /* fcoe host list */
 LIST_HEAD(fcoe_hostlist);
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
new file mode 100644
index 0000000..17acbcc
--- /dev/null
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -0,0 +1,24 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#include <linux/module.h>
+
+MODULE_AUTHOR("Open-FCoE.org");
+MODULE_DESCRIPTION("FCoE");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 0997e8b..f555ae9 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -41,7 +41,7 @@
 
 MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("libfc");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 static int fc_fcp_debug;
 

