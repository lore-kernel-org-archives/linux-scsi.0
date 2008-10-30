From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 9/9] [out-of-tree] open-osd: Global Makefile and do-osdfs test script
Date: Thu, 30 Oct 2008 17:04:28 +0200
Message-ID: <1225379068-25764-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
List-Id: linux-scsi@vger.kernel.org

Added a global out-of-tree Makefile that includes both fs/osdfs
and drivers/scsi/osd. This way imported symbols from libosd are
accounted for by the Kernel's build system

Added a small interactive script to test drive osdfs mount/unmout
and preform some tests.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 Makefile |   20 ++++++++++++
 do-osdfs |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 Makefile
 create mode 100755 do-osdfs

diff --git a/Makefile b/Makefile
new file mode 100644
index 0000000..caa26f6
--- /dev/null
+++ b/Makefile
@@ -0,0 +1,20 @@
+OSD_INC=`pwd`/include
+LIBOSD=drivers/scsi/osd
+OSDFS=fs/osdfs
+
+# Kbuild part (Embeded in this Makefile)
+obj-m := $(LIBOSD)/ $(OSDFS)/
+
+# Makefile for out-of-tree builds
+KSRC ?= /lib/modules/$(shell uname -r)/build
+KBUILD_OUTPUT ?=
+ARCH ?=
+
+# this is the basic Kbuild out-of-tree invocation, with the M= option
+KBUILD_BASE = +$(MAKE) -C $(KSRC) M=`pwd` KBUILD_OUTPUT=$(KBUILD_OUTPUT) ARCH=$(ARCH)
+
+all: ;
+	$(KBUILD_BASE) OSD_INC=$(OSD_INC) modules
+
+clean: ;
+	$(KBUILD_BASE) clean
diff --git a/do-osdfs b/do-osdfs
new file mode 100755
index 0000000..495a1f7
--- /dev/null
+++ b/do-osdfs
@@ -0,0 +1,106 @@
+#!/bin/sh
+#
+
+MOUNTDIR=`dirname $0`/mnt
+DEV_OSD=/dev/osd0
+PID=65536
+
+do_cmd()
+{
+	$* 2>&1 | logger -t `basename $1` &
+}
+
+prompt()
+{
+	read -p "$* >>> "
+}
+
+start_osdf()
+{
+	insmod osdfs.ko
+# 	add-symbol-file ../../osd-initiator/so_mod.ko
+	add-symbol-file osdfs.ko
+}
+
+stop_osdf()
+{
+	rmmod osdfs
+}
+
+start_mount()
+{
+OPT="pid=$PID,to=50"
+	mount -t osdfs -o $OPT $DEV_OSD $MOUNTDIR
+}
+
+stop_mount()
+{
+	umount $MOUNTDIR
+}
+
+mkosdfs_format()
+{
+OPT="pid=$PID,to=50,mkfs=1,format=10000"
+	mount -t osdfs -o $OPT $DEV_OSD $MOUNTDIR
+}
+
+osdfs_hello_world()
+{
+	echo hello > $MOUNTDIR/world
+	cat $MOUNTDIR/world
+}
+
+case $1 in
+stop)
+	echo $0 Stopping | logger
+
+	prompt stop_mount
+	stop_mount
+
+	prompt stop_osdf
+	stop_osdf
+
+	echo $0 Stopped | logger
+	;;
+
+test)
+
+# TODO: Write lots of tests here
+# osdfs_hello_world && rm $MOUNTDIR/world;
+# cp a kernel-git-tree, edit, git-diff
+# unmount, mount, diff-with-original-tree
+# compile kernel
+# ...
+	;;
+
+format)
+	prompt mkosdfs_format
+	mkosdfs_format
+	;;
+
+format_start)
+	echo $0 Starting | logger
+
+	prompt start_osdf
+	start_osdf
+
+	prompt mkosdfs_format
+	mkosdfs_format
+
+	prompt osdfs_hello_world
+	osdfs_hello_world
+
+	echo $0 Initialized | logger
+	;;
+*)
+	echo $0 Starting | logger
+
+	prompt start_osdf
+	start_osdf
+
+	prompt start_mount
+	start_mount
+
+	echo $0 Initialized | logger
+	;;
+esac
-- 
1.6.0.1

