From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH v7 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Fri, 29 May 2015 01:04:09 -0700
Message-ID: <1432886649-12034-10-git-send-email-nmusini@cisco.com>
References: <1432886649-12034-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-7.cisco.com ([173.37.142.94]:17504 "EHLO
	alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbbE2IJJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2015 04:09:09 -0400
In-Reply-To: <1432886649-12034-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de, boaz@plexistor.com, jthumshirn@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

Kconfig for kbuild
Makefile to build snic module

Updated MAINTAINERS file

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
* v3
- Added additional config section (CONFIG_SNIC_DEBUG_FS) for enabling debugging
  functionality.

* v2
- Added compile time flags for debugfs dependent functionality.

 MAINTAINERS                |  7 +++++++
 drivers/scsi/Kconfig       | 17 +++++++++++++++++
 drivers/scsi/Makefile      |  1 +
 drivers/scsi/snic/Makefile | 17 +++++++++++++++++
 4 files changed, 42 insertions(+)
 create mode 100644 drivers/scsi/snic/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a97e05..368fb76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2536,6 +2536,13 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/fnic/
 
+CISCO SCSI HBA DRIVER
+M:	Narsimhulu Musini <nmusini@cisco.com>
+M:	Sesidhar Baddela <sebaddel@cisco.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/snic/
+
 CMPC ACPI DRIVER
 M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
 M:	Daniel Oliveira Nascimento <don@syst.com.br>
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9c92f41..353d550 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -634,6 +634,23 @@ config FCOE_FNIC
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called fnic.
 
+config SCSI_SNIC
+	tristate "Cisco SNIC Driver"
+	depends on PCI && SCSI
+	help
+	  This is support for the Cisco PCI-Express SCSI HBA.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/scsi.txt>.
+	  The module will be called snic.
+
+config SCSI_SNIC_DEBUG_FS
+	bool "Cisco SNIC Driver Debugfs Support"
+	depends on SCSI_SNIC && DEBUG_FS
+	help
+	  This enables to list debugging information from SNIC Driver
+	  available via debugfs file system
+
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 58158f1..f643942 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_LIBFCOE)		+= fcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
 obj-$(CONFIG_FCOE_FNIC)		+= fnic/
+obj-$(CONFIG_SCSI_SNIC)		+= snic/
 obj-$(CONFIG_SCSI_BNX2X_FCOE)	+= libfc/ fcoe/ bnx2fc/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile
new file mode 100644
index 0000000..ef7c0dd
--- /dev/null
+++ b/drivers/scsi/snic/Makefile
@@ -0,0 +1,17 @@
+obj-$(CONFIG_SCSI_SNIC) += snic.o
+
+snic-y := \
+	snic_attrs.o \
+	snic_main.o \
+	snic_res.o \
+	snic_isr.o \
+	snic_ctl.o \
+	snic_io.o \
+	snic_scsi.o \
+	snic_disc.o \
+	vnic_cq.o \
+	vnic_intr.o \
+	vnic_dev.o \
+	vnic_wq.o
+
+snic-$(CONFIG_SCSI_SNIC_DEBUG_FS) += snic_debugfs.o snic_trc.o
-- 
1.8.5.4

