From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 2/5] mvsas : redesign the mvsas driver architecture.
Date: Tue, 24 Feb 2009 17:42:33 +0800
Message-ID: <49A3C109.4080700@marvell.com>
Reply-To: kewei@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:28364 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752175AbZBXJn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2009 04:43:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com, qzhao@marvell.com, qswang@marvell.com, jfeng@marvell.com, kewei@marvell.com, jasonchu@marvell.com

Added new Kconfig entry for the mvsas driver.

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/Kconfig  |   42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/mvsas/Makefile |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/Kconfig b/drivers/scsi/mvsas/Kconfig
new file mode 100644
index 0000000..1f56303
--- /dev/null
+++ b/drivers/scsi/mvsas/Kconfig
@@ -0,0 +1,42 @@
+#
+# Kernel configuration file for MV64xx and MV94xx SAS/SATA driver.
+#
+# Copyright (c) 2008-2009 Marvell.  All rights reserved.
+#
+# This file is licensed under GPLv2.
+#
+# This file is part of the mvsas driver.
+#
+# The mvsas driver is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation; version 2 of the
+# License.
+#
+# The mvsas driver is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with mvsas Driver; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#
+
+config SCSI_MVSAS
+	tristate "Marvell 88SE6440/88SE9480 SAS/SATA support"
+	depends on (PCI || ARCH_LOKI) && SCSI
+	select SCSI_SAS_LIBSAS
+	help
+		This driver supports Marvell's 64 bit PCIE-X SAS/SATA 3Gb/s
+		MV64xx chip and 6Gb/s MV94xx chip based host adapters.
+		To compiler this driver as a module, choose M here: the module
+		will be called mvsas.
+
+config MVSAS_DEBUG
+	bool "Compile in debug mode"
+	default y
+	depends on SCSI_MVSAS
+	help
+		Compiles the mvsas driver in debug mode.  In debug mode,
+		the driver prints some messages to the console.

diff --git a/dev/null b/drivers/scsi/mvsas/Makefile
new file mode 100644
index 0000000..02caf51
--- /dev/null
+++ b/drivers/scsi/mvsas/Makefile
@@ -0,0 +1,37 @@
+#
+# Makefile for Marvell MV64xx and MV94xx SAS/SATA.
+#
+# Kernel configuration file for MV64xx and MV94xx SAS/SATA driver.
+#
+# Copyright (c) 2008-2009 Marvell.  All rights reserved.
+#
+# This file is licensed under GPLv2.
+#
+# This file is part of the mvsas driver.
+#
+# The mvsas driver is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation; version 2 of the
+# License.
+#
+# The mvsas driver is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with mvsas Driver; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#
+
+ifeq ($(CONFIG_MVSAS_DEBUG),y)
+	EXTRA_CFLAGS += -DMV_DEBUG
+endif
+
+obj-$(CONFIG_SCSI_MVSAS) += mvsas.o
+mvsas-y := mv_init.o  \
+           mv_sas.o   \
+           mv_64xx.o  \
+           mv_91xx.o  \
+           mv_spi.o

-- 
1.5.4.3




