From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC PATCH 8/19] Target_Core_Mod Makefile and Kconfig
Date: Sat, 04 Apr 2009 21:01:55 -0700
Message-ID: <1238904115.4250.749.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:42490 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757752AbZDEEEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Apr 2009 00:04:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Zhang <blackmagic02881@gmail.com>, Philipp Reisner <philipp.reisner@linbit.com>, Linus Torvalds <torvalds@linux-foundation.org>

This patch adds the Makefile and Kconfig changes

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/Makefile b/drivers/Makefile
index 2618a61..fea0008 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -36,14 +36,15 @@ obj-$(CONFIG_FB_INTEL)          += video/intelfb/
 
 obj-y				+= serial/
 obj-$(CONFIG_PARPORT)		+= parport/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
 obj-$(CONFIG_SCSI)		+= scsi/
 obj-$(CONFIG_ATA)		+= ata/
+obj-$(CONFIG_TARGET_CORE)	+= target/
 obj-$(CONFIG_FUSION)		+= message/
 obj-$(CONFIG_FIREWIRE)		+= firewire/
 obj-y				+= ieee1394/
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
new file mode 100644
index 0000000..57a1207
--- /dev/null
+++ b/drivers/target/Kconfig
@@ -0,0 +1,6 @@
+config TARGET_CORE
+        tristate "Generic Target Core Engine and ConfigFS Infrastructure"
+	select CONFIGFS_FS
+        default m
+        ---help---
+        Say Y here to enable the Storage Engine, Subsystem Plugins, and ConfigFS enabled control path for the Generic Target Engine.
diff --git a/drivers/target/MCONFIG_ALL b/drivers/target/MCONFIG_ALL
new file mode 100644
index 0000000..df4d628
--- /dev/null
+++ b/drivers/target/MCONFIG_ALL
@@ -0,0 +1,20 @@
+MODVER ?= 1
+
+EZLK ?= 0
+USEGDB ?= 1
+
+ERLONE ?= 1
+ERLTWO ?= 1
+
+DEBUG_ISCSI ?= 0
+DEBUG_OPCODES ?= 0
+
+DEBUG_AUTHD ?= 0
+DEBUG_CHAP ?= 0
+DEBUG_ERL ?= 0
+DEBUG_DEV ?= 0
+
+DEBUG_SUSE ?= 0
+
+SNMP_FEATURE ?= 1
+SNAP_FEATURE ?= 1
diff --git a/drivers/target/MCONFIG_TARGET b/drivers/target/MCONFIG_TARGET
new file mode 100644
index 0000000..77378be
--- /dev/null
+++ b/drivers/target/MCONFIG_TARGET
@@ -0,0 +1,23 @@
+##################################################################################
+# Filename:  MCONFIG_TARGET
+#
+##################################################################################
+
+
+PYX_ISCSI_VENDOR ?="Linux-iSCSI.org"
+
+# Transport Plugins and Devices.
+#
+LINUX_PARALLEL_SCSI ?= 1
+LINUX_SCSI_MEDIA_ROM ?= 1
+LINUX_PARALLEL_ATA ?= 0
+LINUX_IBLOCK ?= 1
+LINUX_RAMDISK ?= 1
+LINUX_FILEIO ?= 1
+
+#
+# Workarounds for stupidity
+#
+LINUX_VPD_PAGE_CHECK?=1
+
+LIO_TARGET_CONFIGFS?=1
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
new file mode 100644
index 0000000..63c1e3b
--- /dev/null
+++ b/drivers/target/Makefile
@@ -0,0 +1,101 @@
+##################################################################################
+# Filename:  Makefile
+#
+# Copyright (c) 2002, 2003, 2004, 2005 PyX Technologies, Inc.
+# Copyright (c) 2005, 2006, 2007 SBE, Inc. 
+# Copyright (c) 2007 Rising Tide Software, Inc.
+#
+# Nicholas A. Bellinger <nab@kernel.org>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+##################################################################################
+
+CWD=$(shell pwd)
+
+include $(CWD)/drivers/target/MCONFIG_TARGET
+include $(CWD)/drivers/target/MCONFIG_ALL
+
+obj-$(CONFIG_TARGET_CORE)		+=	target_core_mod.o
+target_core_mod-objs			:=	target_core_configfs.o \
+						target_core_device.o \
+						target_core_hba.o \
+						target_core_plugin.o \
+						target_core_pr.o \
+						target_core_alua.o \
+						target_core_scdb.o \
+						target_core_seobj.o \
+						target_core_tmr.o \
+						target_core_tpg.o \
+						target_core_transport.o \
+						target_core_ua.o \
+						div64.o
+
+ifeq ($(LINUX_IBLOCK), 1)
+target_core_mod-objs			+=	target_core_iblock.o
+EXTRA_CFLAGS				+=	-DPYX_IBLOCK
+endif
+ifeq ($(LINUX_PARALLEL_SCSI), 1)
+target_core_mod-objs			+=	target_core_pscsi.o
+EXTRA_CFLAGS				+=	-DPARALLEL_SCSI
+endif
+ifeq ($(LINUX_RAMDISK), 1)
+target_core_mod-objs			+=	target_core_rd.o
+EXTRA_CFLAGS				+=	-DPYX_RAMDISK
+endif
+ifeq ($(LINUX_FILEIO), 1)
+target_core_mod-objs			+=	target_core_file.o
+EXTRA_CFLAGS				+=	-DPYX_FILEIO
+endif
+ifeq ($(SNMP_FEATURE), 1)
+target_core_mod-objs			+=	target_core_mib.o
+EXTRA_CFLAGS				+=	-DSNMP_SUPPORT
+endif
+ifeq ($(LINUX_VPD_PAGE_CHECK), 1)
+EXTRA_CFLAGS += -DLINUX_VPD_PAGE_CHECK
+endif
+ifeq ($(LINUX_SCSI_MEDIA_ROM), 1)
+EXTRA_CFLAGS += -DLINUX_SCSI_MEDIA_ROM
+endif
+
+ifeq ($(DEBUG_DEV), 1)
+EXTRA_CFLAGS += -DDEBUG_DEV
+endif
+
+
+EXTRA_CFLAGS+=-I$(CWD)/drivers/target/ -I$(CWD)/drivers/scsi/
+EXTRA_CFLAGS+=-D_TARGET -DLINUX -DLINUX_KERNEL_26 -DLINUX_SCSI_HOST_LOCK -DLINUX_USE_SIGHAND
+EXTRA_CFLAGS+=-DLINUX_SCATTERLIST_HAS_PAGE -DPYX_ISCSI_VENDOR='"Linux-iSCSI.org"'
+
+all:
+	$(MAKE) -C $(KERNEL_DIR) SUBDIRS=$(CWD) modules CWD=$(CWD) ARCH=$(ARCH) KBUILD_VERBOSE=0
+
+install ins:
+	rm -f /lib/modules/`uname -r`/kernel/drivers/scsi/iscsi_target_mod.ko
+	rm -f /lib/modules/`uname -r`/kernel/drivers/iscsi/iscsi_target_mod.ko
+	mkdir -p /lib/modules/`uname -r`/kernel/drivers/iscsi
+	cp -f iscsi_target_mod.ko /lib/modules/`uname -r`/kernel/drivers/iscsi
+	cp -f target_core_mod.ko /lib/modules/`uname -r`/kernel/drivers/iscsi
+	depmod -ae
+
+
+
+clean:
+	rm -f $(foreach prog,$(target_core_mod-objs) $(obj-m),$(CWD)/$(prog)) $(CWD)/target_core_mod.mod.o
+	rm -f target_core_mod.ko target_core_mod.mod.c
+	rm -f .*.cmd ../common/.*.cmd .make_autoconfig *~
+	rm -fr .tmp_versions
+
+



