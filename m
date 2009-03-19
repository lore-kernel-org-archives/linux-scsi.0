From: "Andy Yan" <ayan@marvell.com>
Subject: [PATCH 1/3] Layout changes for new mvsas
Date: Thu, 19 Mar 2009 01:50:07 -0700
Message-ID: <FE3F06125A99254E8D92161AA4569C6F0693DCE6@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:25043 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753234AbZCSIuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 04:50:10 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, jeff@garzik.org, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Ying Chu <jasonchu@marvell.com>, Ke Wei <kewei@marvell.com>

>From e444f857a14757cf483cdbd86f91dee32e99d3ac Mon Sep 17 00:00:00 2001
From: Andy yan <ayan@marvell.com>
Date: Thu, 19 Mar 2009 21:46:48 +0800
Subject: [PATCH 1/3] Layout changes for new mvsas
This patch change Kconfig and Makefile for new layout of mvsas, 
mvsas will have own folder, Kconfig, Makefile.

 Signed-off-by: Andy Yan <ayan@marvell.com>
 Signed-off-by: Ke Wei <kewei@marvell.com>
 Signed-off-by: Ying Chu <jasonchu@marvell.com>

---
 drivers/scsi/Kconfig        |    1 +
 drivers/scsi/Makefile       |    2 +-
 drivers/scsi/mvsas/Kconfig  |   42
++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/Makefile |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 1 deletions(-)
 create mode 100644 drivers/scsi/mvsas/Kconfig
 create mode 100644 drivers/scsi/mvsas/Makefile

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e2f44e6..5bb77b1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -507,6 +507,7 @@ config SCSI_AIC7XXX_OLD
 
 source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
 source "drivers/scsi/aic94xx/Kconfig"
+source "drivers/scsi/mvsas/Kconfig"
 
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index cf79296..fdb2dd8 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -124,7 +124,7 @@ obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
-obj-$(CONFIG_SCSI_MVSAS)	+= mvsas.o
+obj-$(CONFIG_SCSI_MVSAS)	+= mvsas/
 obj-$(CONFIG_PS3_ROM)		+= ps3rom.o
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgb3i/
 
diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
new file mode 100644
index 0000000..37096b5
--- /dev/null
+++ b/drivers/scsi/mvsas/Kconfig
@@ -0,0 +1,42 @@
+#
+# Kernel configuration file for 88SE64XX/88SE94XX SAS/SATA driver.
+#
+# Copyright (c) 2005 Adaptec, Inc.  All rights reserved.
+# Copyright (c) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
+#
+# This file is licensed under GPLv2.
+#
+# This file is part of the 88SE64XX/88SE94XX driver.
+#
+# The 88SE64XX/88SE94XX driver is free software; you can redistribute 
+# it and/or modify it under the terms of the GNU General Public License

+# as published by the Free Software Foundation; version 2 of the
+# License.
+#
+# The 88SE64XX/88SE94XX driver is distributed in the hope that it will
be 
+# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with 88SE64XX/88SE94XX Driver; if not, write to the Free
Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
USA
+#
+#
+
+config SCSI_MVSAS
+	tristate "Marvell 88SE64XX/88SE94XX SAS/SATA support"
+	depends on PCI
+	select SCSI_SAS_LIBSAS
+	select FW_LOADER
+	help
+		This driver supports Marvell's SAS/SATA 3Gb/s PCI-E
88SE64XX and 6Gb/s 
+		PCI-E 88SE94XX chip based host adapters.
+
+config SCSI_MVSAS_DEBUG
+	bool "Compile in debug mode"
+	default y
+	depends on SCSI_MVSAS
+	help
+		Compiles the 88SE64XX/88SE94XX driver in debug mode.  In
debug mode,
+		the driver prints some messages to the console.
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
new file mode 100644
index 0000000..cefc0cf
--- /dev/null
+++ b/drivers/scsi/mvsas/Makefile
@@ -0,0 +1,32 @@
+#
+# Kernel Makefile for the libsas helpers
+#
+# Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
+# Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
+#
+# This file is licensed under GPLv2.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation; version 2 of the
+# License.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+# USA
+
+ifeq ($(CONFIG_SCSI_MVSAS_DEBUG),y)
+	EXTRA_CFLAGS += -DMV_DEBUG
+endif
+
+obj-$(CONFIG_SCSI_MVSAS) += mvsas.o
+mvsas-y +=  mv_init.o  \
+           mv_sas.o   \
+           mv_64xx.o  \
+           mv_94xx.o  
-- 
1.6.2.1
