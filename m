From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC PATCH 19/19] Target_Core_Mod Makefile/Kconfig and div64.c
Date: Fri, 11 Sep 2009 18:58:46 -0700
Message-ID: <1252720726.2067.234.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:48308 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757376AbZILCGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 22:06:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>

[RFC PATCH 19/19] Target_Core_Mod Makefile/Kconfig and div64.c

This patch adds the remaining misc Makefile and Kconfig changes

It also has wrappers for unsigned long division in div64c, that will be converted to
include/asm-generic/div64.h

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
diff --git a/drivers/target/div64.c b/drivers/target/div64.c
new file mode 100644
index 0000000..6d59864
--- /dev/null
+++ b/drivers/target/div64.c
@@ -0,0 +1,16 @@
+#include <asm/types.h>
+#include <asm/div64.h>
+
+#if BITS_PER_LONG == 32
+
+u64 __udivdi3(u64 a, u64 b)
+{
+  do_div(a, b);
+  return a;
+}
+
+u64 __umoddi3(u64 a, u64 b)
+{
+  return do_div(a, b);
+}
+#endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
new file mode 100644
index 0000000..3e413b0
--- /dev/null
+++ b/drivers/target/Makefile
@@ -0,0 +1,96 @@
+CWD=$(shell pwd)
+
+PYX_ISCSI_VENDOR ?="Linux-iSCSI.org"
+
+# Transport Plugins and Devices.
+ #
+LINUX_PARALLEL_SCSI ?= 1
+LINUX_STGT ?= 1
+LINUX_SCSI_MEDIA_ROM ?= 1
+LINUX_PARALLEL_ATA ?= 0
+LINUX_IBLOCK ?= 1
+LINUX_RAMDISK ?= 1
+LINUX_FILEIO ?= 1
+
+LINUX_VPD_PAGE_CHECK?=1
+LIO_TARGET_CONFIGFS?=1
+
+MODVER ?= 1
+USEGDB ?= 1
+DEBUG_DEV ?= 0
+SNMP_FEATURE ?= 1
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
+ifeq ($(LINUX_STGT), 1)
+target_core_mod-objs			+=	target_core_stgt.o
+EXTRA_CFLAGS				+=	-DSTGT_PLUGIN
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
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
new file mode 100644
index 0000000..04564f1
--- /dev/null
+++ b/drivers/target/Kconfig
@@ -0,0 +1,7 @@
+config TARGET_CORE
+        tristate "Generic Target Core Engine and ConfigFS Infrastructure"
+	select CONFIGFS_FS
+	select SCSI_TGT
+        default m
+        ---help---
+        Say Y here to enable the Storage Engine, Subsystem Plugins, and ConfigFS enabled control path for the Generic Target Engine.


