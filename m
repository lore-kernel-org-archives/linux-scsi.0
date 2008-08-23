From: jeykholt@cisco.com
Subject: [RFC][PATCH 6/6] fnic: add Makefile, patch Kconfig, MAINTAINERS,
	pci_ids.h
Date: Fri, 22 Aug 2008 19:53:06 -0700
Message-ID: <20080823025305.13569.16119.stgit@feynman.nuovasystems.com>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:18433 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYHWCxL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 22:53:11 -0400
In-Reply-To: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jre@nuovasystems.com, ajoglekar@nuovasystems.com

fnic: add Makefile, patch Kconfig, MAINTAINERS, pci_ids.h

Adds drivers/scsi/fnic/Makefile, adds the fnic (Cisco FCoe HBA) option
to the SCSI Kconfig.  Add PCI vendor and device ID for Cisco and fnic.
Updates MAINTAINERS to add an entry for the fnic driver.

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
---
 MAINTAINERS                |    8 ++++++++
 drivers/scsi/Kconfig       |   10 ++++++++++
 drivers/scsi/Makefile      |    1 +
 drivers/scsi/fnic/Makefile |   15 +++++++++++++++
 include/linux/pci_ids.h    |    3 +++
 5 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fnic/Makefile


diff --git a/MAINTAINERS b/MAINTAINERS
index deedc0d..6499a58 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1161,6 +1161,14 @@ P:	Nils Faerber (port to kernel 2.4)
 M:	Nils Faerber <nils@kernelconcepts.de>
 S:	Maintained
 
+CISCO FCoE HBA DRIVER (drivers/scsi/fnic)
+P:	Abhijeet Joglekar
+M:	abjoglek@cisco.com
+P:	Joe Eykholt
+M:	jeykholt@cisco.com
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+
 CODA FILE SYSTEM
 P:	Jan Harkes
 M:	jaharkes@cs.cmu.edu
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 07b0196..f4df162 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -615,6 +615,16 @@ config SCSI_FLASHPOINT
 	  substantial, so users of MultiMaster Host Adapters may not
 	  wish to include it.
 
+config FCOE_FNIC
+	tristate "Cisco FNIC Driver"
+	depends on LIBFC && PCI && X86_64
+	help
+	  This is support for the Cisco PCI-Express FCoE HBA.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/scsi.txt>.
+	  The module will be called fnic.
+
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 22c01e5..4302ad4 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_SCSI_DH)		+= device_handler/
 
 obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_FCOE) 		+= fcoe/
+obj-$(CONFIG_FCOE_FNIC)		+= fnic/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
diff --git a/drivers/scsi/fnic/Makefile b/drivers/scsi/fnic/Makefile
new file mode 100644
index 0000000..37c3440
--- /dev/null
+++ b/drivers/scsi/fnic/Makefile
@@ -0,0 +1,15 @@
+obj-$(CONFIG_FCOE_FNIC) += fnic.o
+
+fnic-y	:= \
+	fnic_attrs.o \
+	fnic_isr.o \
+	fnic_main.o \
+	fnic_res.o \
+	fnic_fcs.o \
+	fnic_scsi.o \
+	vnic_cq.o \
+	vnic_dev.o \
+	vnic_intr.o \
+	vnic_rq.o \
+	vnic_wq_copy.o \
+	vnic_wq.o
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 35a7841..5b0e0b7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1411,6 +1411,9 @@
 #define PCI_DEVICE_ID_EICON_MAESTRAQ_U	0xe013
 #define PCI_DEVICE_ID_EICON_MAESTRAP	0xe014
 
+#define PCI_VENDOR_ID_CISCO		0x1137
+#define PCI_DEVICE_ID_CISCO_FNIC	0x0045
+
 #define PCI_VENDOR_ID_ZIATECH		0x1138
 #define PCI_DEVICE_ID_ZIATECH_5550_HC	0x5550
  


