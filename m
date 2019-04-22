From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v2 34/79] docs: target: convert docs to ReST and rename to *.rst
Date: Mon, 22 Apr 2019 10:27:23 -0300
Message-ID: <a65eed34f499e78565d444c7b2f5a43147799e3b.1555938376.git.mchehab+samsung@kernel.org>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1555938375.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Convert the TCM docs to ReST format and add them to the
bookset.

This has a mix of userspace-faced and Kernelspace faced
docs. Still, it sounds a better candidate to be added at
the kernel API set of docs.

The conversion is actually:
  - add blank lines and identation in order to identify paragraphs;
  - fix tables markups;
  - add some lists markups;
  - mark literal blocks;
  - adjust title markups.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/target/index.rst                |  19 ++
 Documentation/target/scripts.rst              |  11 +
 Documentation/target/tcm_mod_builder.rst      | 149 ++++++++++
 Documentation/target/tcm_mod_builder.txt      | 145 ----------
 .../{tcmu-design.txt => tcmu-design.rst}      | 268 ++++++++++--------
 scripts/documentation-file-ref-check          |   2 +-
 6 files changed, 326 insertions(+), 268 deletions(-)
 create mode 100644 Documentation/target/index.rst
 create mode 100644 Documentation/target/scripts.rst
 create mode 100644 Documentation/target/tcm_mod_builder.rst
 delete mode 100644 Documentation/target/tcm_mod_builder.txt
 rename Documentation/target/{tcmu-design.txt => tcmu-design.rst} (69%)

diff --git a/Documentation/target/index.rst b/Documentation/target/index.rst
new file mode 100644
index 000000000000..b68f48982392
--- /dev/null
+++ b/Documentation/target/index.rst
@@ -0,0 +1,19 @@
+:orphan:
+
+==================
+TCM Virtual Device
+==================
+
+.. toctree::
+    :maxdepth: 1
+
+    tcmu-design
+    tcm_mod_builder
+    scripts
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/target/scripts.rst b/Documentation/target/scripts.rst
new file mode 100644
index 000000000000..172d42b522e4
--- /dev/null
+++ b/Documentation/target/scripts.rst
@@ -0,0 +1,11 @@
+TCM mod builder script
+----------------------
+
+.. literalinclude:: tcm_mod_builder.py
+    :language: perl
+
+Target export device script
+---------------------------
+
+.. literalinclude:: target-export-device
+    :language: shell
diff --git a/Documentation/target/tcm_mod_builder.rst b/Documentation/target/tcm_mod_builder.rst
new file mode 100644
index 000000000000..9bfc9822e2bd
--- /dev/null
+++ b/Documentation/target/tcm_mod_builder.rst
@@ -0,0 +1,149 @@
+=========================================
+The TCM v4 fabric module script generator
+=========================================
+
+Greetings all,
+
+This document is intended to be a mini-HOWTO for using the tcm_mod_builder.py
+script to generate a brand new functional TCM v4 fabric .ko module of your very own,
+that once built can be immediately be loaded to start access the new TCM/ConfigFS
+fabric skeleton, by simply using::
+
+	modprobe $TCM_NEW_MOD
+	mkdir -p /sys/kernel/config/target/$TCM_NEW_MOD
+
+This script will create a new drivers/target/$TCM_NEW_MOD/, and will do the following
+
+	1) Generate new API callers for drivers/target/target_core_fabric_configs.c logic
+	   ->make_tpg(), ->drop_tpg(), ->make_wwn(), ->drop_wwn().  These are created
+	   into $TCM_NEW_MOD/$TCM_NEW_MOD_configfs.c
+	2) Generate basic infrastructure for loading/unloading LKMs and TCM/ConfigFS fabric module
+	   using a skeleton struct target_core_fabric_ops API template.
+	3) Based on user defined T10 Proto_Ident for the new fabric module being built,
+	   the TransportID / Initiator and Target WWPN related handlers for
+	   SPC-3 persistent reservation are automatically generated in $TCM_NEW_MOD/$TCM_NEW_MOD_fabric.c
+	   using drivers/target/target_core_fabric_lib.c logic.
+	4) NOP API calls for all other Data I/O path and fabric dependent attribute logic
+	   in $TCM_NEW_MOD/$TCM_NEW_MOD_fabric.c
+
+tcm_mod_builder.py depends upon the mandatory '-p $PROTO_IDENT' and '-m
+$FABRIC_MOD_name' parameters, and actually running the script looks like::
+
+  target:/mnt/sdb/lio-core-2.6.git/Documentation/target# python tcm_mod_builder.py -p iSCSI -m tcm_nab5000
+  tcm_dir: /mnt/sdb/lio-core-2.6.git/Documentation/target/../../
+  Set fabric_mod_name: tcm_nab5000
+  Set fabric_mod_dir:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000
+  Using proto_ident: iSCSI
+  Creating fabric_mod_dir:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000
+  Writing file:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_base.h
+  Using tcm_mod_scan_fabric_ops:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../include/target/target_core_fabric_ops.h
+  Writing file:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_fabric.c
+  Writing file:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_fabric.h
+  Writing file:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_configfs.c
+  Writing file:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/Kbuild
+  Writing file:
+  /mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/Kconfig
+  Would you like to add tcm_nab5000to drivers/target/Kbuild..? [yes,no]: yes
+  Would you like to add tcm_nab5000to drivers/target/Kconfig..? [yes,no]: yes
+
+At the end of tcm_mod_builder.py. the script will ask to add the following
+line to drivers/target/Kbuild::
+
+	obj-$(CONFIG_TCM_NAB5000)       += tcm_nab5000/
+
+and the same for drivers/target/Kconfig::
+
+	source "drivers/target/tcm_nab5000/Kconfig"
+
+#) Run 'make menuconfig' and select the new CONFIG_TCM_NAB5000 item::
+
+	<M>   TCM_NAB5000 fabric module
+
+#) Build using 'make modules', once completed you will have::
+
+    target:/mnt/sdb/lio-core-2.6.git# ls -la drivers/target/tcm_nab5000/
+    total 1348
+    drwxr-xr-x 2 root root   4096 2010-10-05 03:23 .
+    drwxr-xr-x 9 root root   4096 2010-10-05 03:22 ..
+    -rw-r--r-- 1 root root    282 2010-10-05 03:22 Kbuild
+    -rw-r--r-- 1 root root    171 2010-10-05 03:22 Kconfig
+    -rw-r--r-- 1 root root     49 2010-10-05 03:23 modules.order
+    -rw-r--r-- 1 root root    738 2010-10-05 03:22 tcm_nab5000_base.h
+    -rw-r--r-- 1 root root   9096 2010-10-05 03:22 tcm_nab5000_configfs.c
+    -rw-r--r-- 1 root root 191200 2010-10-05 03:23 tcm_nab5000_configfs.o
+    -rw-r--r-- 1 root root  40504 2010-10-05 03:23 .tcm_nab5000_configfs.o.cmd
+    -rw-r--r-- 1 root root   5414 2010-10-05 03:22 tcm_nab5000_fabric.c
+    -rw-r--r-- 1 root root   2016 2010-10-05 03:22 tcm_nab5000_fabric.h
+    -rw-r--r-- 1 root root 190932 2010-10-05 03:23 tcm_nab5000_fabric.o
+    -rw-r--r-- 1 root root  40713 2010-10-05 03:23 .tcm_nab5000_fabric.o.cmd
+    -rw-r--r-- 1 root root 401861 2010-10-05 03:23 tcm_nab5000.ko
+    -rw-r--r-- 1 root root    265 2010-10-05 03:23 .tcm_nab5000.ko.cmd
+    -rw-r--r-- 1 root root    459 2010-10-05 03:23 tcm_nab5000.mod.c
+    -rw-r--r-- 1 root root  23896 2010-10-05 03:23 tcm_nab5000.mod.o
+    -rw-r--r-- 1 root root  22655 2010-10-05 03:23 .tcm_nab5000.mod.o.cmd
+    -rw-r--r-- 1 root root 379022 2010-10-05 03:23 tcm_nab5000.o
+    -rw-r--r-- 1 root root    211 2010-10-05 03:23 .tcm_nab5000.o.cmd
+
+#) Load the new module, create a lun_0 configfs group, and add new TCM Core
+   IBLOCK backstore symlink to port::
+
+    target:/mnt/sdb/lio-core-2.6.git# insmod drivers/target/tcm_nab5000.ko
+    target:/mnt/sdb/lio-core-2.6.git# mkdir -p /sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0
+    target:/mnt/sdb/lio-core-2.6.git# cd /sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0/
+    target:/sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0# ln -s /sys/kernel/config/target/core/iblock_0/lvm_test0 nab5000_port
+
+    target:/sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0# cd -
+    target:/mnt/sdb/lio-core-2.6.git# tree /sys/kernel/config/target/nab5000/
+    /sys/kernel/config/target/nab5000/
+    |-- discovery_auth
+    |-- iqn.foo
+    |   `-- tpgt_1
+    |       |-- acls
+    |       |-- attrib
+    |       |-- lun
+    |       |   `-- lun_0
+    |       |       |-- alua_tg_pt_gp
+    |       |       |-- alua_tg_pt_offline
+    |       |       |-- alua_tg_pt_status
+    |       |       |-- alua_tg_pt_write_md
+    |	|	`-- nab5000_port -> ../../../../../../target/core/iblock_0/lvm_test0
+    |       |-- np
+    |       `-- param
+    `-- version
+
+    target:/mnt/sdb/lio-core-2.6.git# lsmod
+    Module                  Size  Used by
+    tcm_nab5000             3935  4
+    iscsi_target_mod      193211  0
+    target_core_stgt        8090  0
+    target_core_pscsi      11122  1
+    target_core_file        9172  2
+    target_core_iblock      9280  1
+    target_core_mod       228575  31
+    tcm_nab5000,iscsi_target_mod,target_core_stgt,target_core_pscsi,target_core_file,target_core_iblock
+    libfc                  73681  0
+    scsi_debug             56265  0
+    scsi_tgt                8666  1 target_core_stgt
+    configfs               20644  2 target_core_mod
+
+----------------------------------------------------------------------
+
+Future TODO items
+=================
+
+	1) Add more T10 proto_idents
+	2) Make tcm_mod_dump_fabric_ops() smarter and generate function pointer
+	   defs directly from include/target/target_core_fabric_ops.h:struct target_core_fabric_ops
+	   structure members.
+
+October 5th, 2010
+
+Nicholas A. Bellinger <nab@linux-iscsi.org>
diff --git a/Documentation/target/tcm_mod_builder.txt b/Documentation/target/tcm_mod_builder.txt
deleted file mode 100644
index ae22f7005540..000000000000
--- a/Documentation/target/tcm_mod_builder.txt
+++ /dev/null
@@ -1,145 +0,0 @@
->>>>>>>>>> The TCM v4 fabric module script generator <<<<<<<<<<
-
-Greetings all,
-
-This document is intended to be a mini-HOWTO for using the tcm_mod_builder.py
-script to generate a brand new functional TCM v4 fabric .ko module of your very own,
-that once built can be immediately be loaded to start access the new TCM/ConfigFS
-fabric skeleton, by simply using:
-
-	modprobe $TCM_NEW_MOD
-	mkdir -p /sys/kernel/config/target/$TCM_NEW_MOD
-
-This script will create a new drivers/target/$TCM_NEW_MOD/, and will do the following
-
-	*) Generate new API callers for drivers/target/target_core_fabric_configs.c logic
-	   ->make_tpg(), ->drop_tpg(), ->make_wwn(), ->drop_wwn().  These are created
-	   into $TCM_NEW_MOD/$TCM_NEW_MOD_configfs.c
-	*) Generate basic infrastructure for loading/unloading LKMs and TCM/ConfigFS fabric module
-	   using a skeleton struct target_core_fabric_ops API template.
-	*) Based on user defined T10 Proto_Ident for the new fabric module being built,
-	   the TransportID / Initiator and Target WWPN related handlers for
-	   SPC-3 persistent reservation are automatically generated in $TCM_NEW_MOD/$TCM_NEW_MOD_fabric.c
-	   using drivers/target/target_core_fabric_lib.c logic.
-	*) NOP API calls for all other Data I/O path and fabric dependent attribute logic
-	   in $TCM_NEW_MOD/$TCM_NEW_MOD_fabric.c
-
-tcm_mod_builder.py depends upon the mandatory '-p $PROTO_IDENT' and '-m
-$FABRIC_MOD_name' parameters, and actually running the script looks like:
-
-target:/mnt/sdb/lio-core-2.6.git/Documentation/target# python tcm_mod_builder.py -p iSCSI -m tcm_nab5000
-tcm_dir: /mnt/sdb/lio-core-2.6.git/Documentation/target/../../
-Set fabric_mod_name: tcm_nab5000
-Set fabric_mod_dir:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000
-Using proto_ident: iSCSI
-Creating fabric_mod_dir:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000
-Writing file:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_base.h
-Using tcm_mod_scan_fabric_ops:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../include/target/target_core_fabric_ops.h
-Writing file:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_fabric.c
-Writing file:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_fabric.h
-Writing file:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/tcm_nab5000_configfs.c
-Writing file:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/Kbuild
-Writing file:
-/mnt/sdb/lio-core-2.6.git/Documentation/target/../../drivers/target/tcm_nab5000/Kconfig
-Would you like to add tcm_nab5000to drivers/target/Kbuild..? [yes,no]: yes
-Would you like to add tcm_nab5000to drivers/target/Kconfig..? [yes,no]: yes
-
-At the end of tcm_mod_builder.py. the script will ask to add the following
-line to drivers/target/Kbuild:
-
-	obj-$(CONFIG_TCM_NAB5000)       += tcm_nab5000/
-
-and the same for drivers/target/Kconfig:
-
-	source "drivers/target/tcm_nab5000/Kconfig"
-
-*) Run 'make menuconfig' and select the new CONFIG_TCM_NAB5000 item:
-
-	<M>   TCM_NAB5000 fabric module
-
-*) Build using 'make modules', once completed you will have:
-
-target:/mnt/sdb/lio-core-2.6.git# ls -la drivers/target/tcm_nab5000/
-total 1348
-drwxr-xr-x 2 root root   4096 2010-10-05 03:23 .
-drwxr-xr-x 9 root root   4096 2010-10-05 03:22 ..
--rw-r--r-- 1 root root    282 2010-10-05 03:22 Kbuild
--rw-r--r-- 1 root root    171 2010-10-05 03:22 Kconfig
--rw-r--r-- 1 root root     49 2010-10-05 03:23 modules.order
--rw-r--r-- 1 root root    738 2010-10-05 03:22 tcm_nab5000_base.h
--rw-r--r-- 1 root root   9096 2010-10-05 03:22 tcm_nab5000_configfs.c
--rw-r--r-- 1 root root 191200 2010-10-05 03:23 tcm_nab5000_configfs.o
--rw-r--r-- 1 root root  40504 2010-10-05 03:23 .tcm_nab5000_configfs.o.cmd
--rw-r--r-- 1 root root   5414 2010-10-05 03:22 tcm_nab5000_fabric.c
--rw-r--r-- 1 root root   2016 2010-10-05 03:22 tcm_nab5000_fabric.h
--rw-r--r-- 1 root root 190932 2010-10-05 03:23 tcm_nab5000_fabric.o
--rw-r--r-- 1 root root  40713 2010-10-05 03:23 .tcm_nab5000_fabric.o.cmd
--rw-r--r-- 1 root root 401861 2010-10-05 03:23 tcm_nab5000.ko
--rw-r--r-- 1 root root    265 2010-10-05 03:23 .tcm_nab5000.ko.cmd
--rw-r--r-- 1 root root    459 2010-10-05 03:23 tcm_nab5000.mod.c
--rw-r--r-- 1 root root  23896 2010-10-05 03:23 tcm_nab5000.mod.o
--rw-r--r-- 1 root root  22655 2010-10-05 03:23 .tcm_nab5000.mod.o.cmd
--rw-r--r-- 1 root root 379022 2010-10-05 03:23 tcm_nab5000.o
--rw-r--r-- 1 root root    211 2010-10-05 03:23 .tcm_nab5000.o.cmd
-
-*) Load the new module, create a lun_0 configfs group, and add new TCM Core
-   IBLOCK backstore symlink to port:
-
-target:/mnt/sdb/lio-core-2.6.git# insmod drivers/target/tcm_nab5000.ko
-target:/mnt/sdb/lio-core-2.6.git# mkdir -p /sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0
-target:/mnt/sdb/lio-core-2.6.git# cd /sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0/
-target:/sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0# ln -s /sys/kernel/config/target/core/iblock_0/lvm_test0 nab5000_port
-
-target:/sys/kernel/config/target/nab5000/iqn.foo/tpgt_1/lun/lun_0# cd -
-target:/mnt/sdb/lio-core-2.6.git# tree /sys/kernel/config/target/nab5000/
-/sys/kernel/config/target/nab5000/
-|-- discovery_auth
-|-- iqn.foo
-|   `-- tpgt_1
-|       |-- acls
-|       |-- attrib
-|       |-- lun
-|       |   `-- lun_0
-|       |       |-- alua_tg_pt_gp
-|       |       |-- alua_tg_pt_offline
-|       |       |-- alua_tg_pt_status
-|       |       |-- alua_tg_pt_write_md
-|	|	`-- nab5000_port -> ../../../../../../target/core/iblock_0/lvm_test0
-|       |-- np
-|       `-- param
-`-- version
-
-target:/mnt/sdb/lio-core-2.6.git# lsmod
-Module                  Size  Used by
-tcm_nab5000             3935  4
-iscsi_target_mod      193211  0
-target_core_stgt        8090  0
-target_core_pscsi      11122  1
-target_core_file        9172  2
-target_core_iblock      9280  1
-target_core_mod       228575  31
-tcm_nab5000,iscsi_target_mod,target_core_stgt,target_core_pscsi,target_core_file,target_core_iblock
-libfc                  73681  0
-scsi_debug             56265  0
-scsi_tgt                8666  1 target_core_stgt
-configfs               20644  2 target_core_mod
-
-----------------------------------------------------------------------
-
-Future TODO items:
-
-	*) Add more T10 proto_idents
-	*) Make tcm_mod_dump_fabric_ops() smarter and generate function pointer
-	   defs directly from include/target/target_core_fabric_ops.h:struct target_core_fabric_ops
-	   structure members.
-
-October 5th, 2010
-Nicholas A. Bellinger <nab@linux-iscsi.org>
diff --git a/Documentation/target/tcmu-design.txt b/Documentation/target/tcmu-design.rst
similarity index 69%
rename from Documentation/target/tcmu-design.txt
rename to Documentation/target/tcmu-design.rst
index 4cebc1ebf99a..a7b426707bf6 100644
--- a/Documentation/target/tcmu-design.txt
+++ b/Documentation/target/tcmu-design.rst
@@ -1,25 +1,30 @@
-Contents:
+====================
+TCM Userspace Design
+====================
+
+
+.. Contents:
 
-1) TCM Userspace Design
-  a) Background
-  b) Benefits
-  c) Design constraints
-  d) Implementation overview
-     i. Mailbox
-     ii. Command ring
-     iii. Data Area
-  e) Device discovery
-  f) Device events
-  g) Other contingencies
-2) Writing a user pass-through handler
-  a) Discovering and configuring TCMU uio devices
-  b) Waiting for events on the device(s)
-  c) Managing the command ring
-3) A final note
+   1) TCM Userspace Design
+     a) Background
+     b) Benefits
+     c) Design constraints
+     d) Implementation overview
+        i. Mailbox
+        ii. Command ring
+        iii. Data Area
+     e) Device discovery
+     f) Device events
+     g) Other contingencies
+   2) Writing a user pass-through handler
+     a) Discovering and configuring TCMU uio devices
+     b) Waiting for events on the device(s)
+     c) Managing the command ring
+   3) A final note
 
 
 TCM Userspace Design
---------------------
+====================
 
 TCM is another name for LIO, an in-kernel iSCSI target (server).
 Existing TCM targets run in the kernel.  TCMU (TCM in Userspace)
@@ -32,7 +37,8 @@ modules for file, block device, RAM or using another SCSI device as
 storage.  These are called "backstores" or "storage engines".  These
 built-in modules are implemented entirely as kernel code.
 
-Background:
+Background
+----------
 
 In addition to modularizing the transport protocol used for carrying
 SCSI commands ("fabrics"), the Linux kernel target, LIO, also modularizes
@@ -60,7 +66,8 @@ kernel, another approach is to create a userspace pass-through
 backstore for LIO, "TCMU".
 
 
-Benefits:
+Benefits
+--------
 
 In addition to allowing relatively easy support for RBD and GLFS, TCMU
 will also allow easier development of new backstores. TCMU combines
@@ -72,21 +79,25 @@ The disadvantage is there are more distinct components to configure, and
 potentially to malfunction. This is unavoidable, but hopefully not
 fatal if we're careful to keep things as simple as possible.
 
-Design constraints:
+Design constraints
+------------------
 
 - Good performance: high throughput, low latency
 - Cleanly handle if userspace:
+
    1) never attaches
    2) hangs
    3) dies
    4) misbehaves
+
 - Allow future flexibility in user & kernel implementations
 - Be reasonably memory-efficient
 - Simple to configure & run
 - Simple to write a userspace backend
 
 
-Implementation overview:
+Implementation overview
+-----------------------
 
 The core of the TCMU interface is a memory region that is shared
 between kernel and userspace. Within this region is: a control area
@@ -108,7 +119,8 @@ the region mapped at a different virtual address.
 
 See target_core_user.h for the struct definitions.
 
-The Mailbox:
+The Mailbox
+-----------
 
 The mailbox is always at the start of the shared memory region, and
 contains a version, details about the starting offset and size of the
@@ -117,19 +129,27 @@ userspace (respectively) to put commands on the ring, and indicate
 when the commands are completed.
 
 version - 1 (userspace should abort if otherwise)
+
 flags:
-- TCMU_MAILBOX_FLAG_CAP_OOOC: indicates out-of-order completion is
-  supported.  See "The Command Ring" for details.
-cmdr_off - The offset of the start of the command ring from the start
-of the memory region, to account for the mailbox size.
-cmdr_size - The size of the command ring. This does *not* need to be a
-power of two.
-cmd_head - Modified by the kernel to indicate when a command has been
-placed on the ring.
-cmd_tail - Modified by userspace to indicate when it has completed
-processing of a command.
+    - TCMU_MAILBOX_FLAG_CAP_OOOC:
+	indicates out-of-order completion is supported.
+	See "The Command Ring" for details.
 
-The Command Ring:
+cmdr_off
+	The offset of the start of the command ring from the start
+	of the memory region, to account for the mailbox size.
+cmdr_size
+	The size of the command ring. This does *not* need to be a
+	power of two.
+cmd_head
+	Modified by the kernel to indicate when a command has been
+	placed on the ring.
+cmd_tail
+	Modified by userspace to indicate when it has completed
+	processing of a command.
+
+The Command Ring
+----------------
 
 Commands are placed on the ring by the kernel incrementing
 mailbox.cmd_head by the size of the command, modulo cmdr_size, and
@@ -180,29 +200,31 @@ opcode it does not handle, it must set UNKNOWN_OP bit (bit 0) in
 hdr.uflags, update cmd_tail, and proceed with processing additional
 commands, if any.
 
-The Data Area:
+The Data Area
+-------------
 
 This is shared-memory space after the command ring. The organization
 of this area is not defined in the TCMU interface, and userspace
 should access only the parts referenced by pending iovs.
 
 
-Device Discovery:
+Device Discovery
+----------------
 
 Other devices may be using UIO besides TCMU. Unrelated user processes
 may also be handling different sets of TCMU devices. TCMU userspace
 processes must find their devices by scanning sysfs
 class/uio/uio*/name. For TCMU devices, these names will be of the
-format:
+format::
 
-tcm-user/<hba_num>/<device_name>/<subtype>/<path>
+	tcm-user/<hba_num>/<device_name>/<subtype>/<path>
 
 where "tcm-user" is common for all TCMU-backed UIO devices. <hba_num>
 and <device_name> allow userspace to find the device's path in the
 kernel target's configfs tree. Assuming the usual mount point, it is
-found at:
+found at::
 
-/sys/kernel/config/target/core/user_<hba_num>/<device_name>
+	/sys/kernel/config/target/core/user_<hba_num>/<device_name>
 
 This location contains attributes such as "hw_block_size", that
 userspace needs to know for correct operation.
@@ -214,15 +236,16 @@ configure the device, if needed. The name cannot contain ':', due to
 LIO limitations.
 
 For all devices so discovered, the user handler opens /dev/uioX and
-calls mmap():
+calls mmap()::
 
-mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0)
+	mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0)
 
 where size must be equal to the value read from
 /sys/class/uio/uioX/maps/map0/size.
 
 
-Device Events:
+Device Events
+-------------
 
 If a new device is added or removed, a notification will be broadcast
 over netlink, using a generic netlink family name of "TCM-USER" and a
@@ -233,7 +256,8 @@ the LIO device, so that after determining the device is supported
 (based on subtype) it can take the appropriate action.
 
 
-Other contingencies:
+Other contingencies
+-------------------
 
 Userspace handler process never attaches:
 
@@ -258,7 +282,7 @@ Userspace handler process is malicious:
 
 
 Writing a user pass-through handler (with example code)
--------------------------------------------------------
+=======================================================
 
 A user process handing a TCMU device must support the following:
 
@@ -277,103 +301,103 @@ TCMU is designed so that multiple unrelated processes can manage TCMU
 devices separately. All handlers should make sure to only open their
 devices, based opon a known subtype string.
 
-a) Discovering and configuring TCMU UIO devices:
+a) Discovering and configuring TCMU UIO devices::
 
-(error checking omitted for brevity)
+      /* error checking omitted for brevity */
 
-int fd, dev_fd;
-char buf[256];
-unsigned long long map_len;
-void *map;
+      int fd, dev_fd;
+      char buf[256];
+      unsigned long long map_len;
+      void *map;
 
-fd = open("/sys/class/uio/uio0/name", O_RDONLY);
-ret = read(fd, buf, sizeof(buf));
-close(fd);
-buf[ret-1] = '\0'; /* null-terminate and chop off the \n */
+      fd = open("/sys/class/uio/uio0/name", O_RDONLY);
+      ret = read(fd, buf, sizeof(buf));
+      close(fd);
+      buf[ret-1] = '\0'; /* null-terminate and chop off the \n */
 
-/* we only want uio devices whose name is a format we expect */
-if (strncmp(buf, "tcm-user", 8))
+      /* we only want uio devices whose name is a format we expect */
+      if (strncmp(buf, "tcm-user", 8))
 	exit(-1);
 
-/* Further checking for subtype also needed here */
+      /* Further checking for subtype also needed here */
 
-fd = open(/sys/class/uio/%s/maps/map0/size, O_RDONLY);
-ret = read(fd, buf, sizeof(buf));
-close(fd);
-str_buf[ret-1] = '\0'; /* null-terminate and chop off the \n */
+      fd = open(/sys/class/uio/%s/maps/map0/size, O_RDONLY);
+      ret = read(fd, buf, sizeof(buf));
+      close(fd);
+      str_buf[ret-1] = '\0'; /* null-terminate and chop off the \n */
 
-map_len = strtoull(buf, NULL, 0);
+      map_len = strtoull(buf, NULL, 0);
 
-dev_fd = open("/dev/uio0", O_RDWR);
-map = mmap(NULL, map_len, PROT_READ|PROT_WRITE, MAP_SHARED, dev_fd, 0);
+      dev_fd = open("/dev/uio0", O_RDWR);
+      map = mmap(NULL, map_len, PROT_READ|PROT_WRITE, MAP_SHARED, dev_fd, 0);
 
 
-b) Waiting for events on the device(s)
+      b) Waiting for events on the device(s)
 
-while (1) {
-  char buf[4];
+      while (1) {
+        char buf[4];
 
-  int ret = read(dev_fd, buf, 4); /* will block */
+        int ret = read(dev_fd, buf, 4); /* will block */
 
-  handle_device_events(dev_fd, map);
-}
-
-
-c) Managing the command ring
-
-#include <linux/target_core_user.h>
-
-int handle_device_events(int fd, void *map)
-{
-  struct tcmu_mailbox *mb = map;
-  struct tcmu_cmd_entry *ent = (void *) mb + mb->cmdr_off + mb->cmd_tail;
-  int did_some_work = 0;
-
-  /* Process events from cmd ring until we catch up with cmd_head */
-  while (ent != (void *)mb + mb->cmdr_off + mb->cmd_head) {
-
-    if (tcmu_hdr_get_op(ent->hdr.len_op) == TCMU_OP_CMD) {
-      uint8_t *cdb = (void *)mb + ent->req.cdb_off;
-      bool success = true;
+        handle_device_events(dev_fd, map);
+      }
 
-      /* Handle command here. */
-      printf("SCSI opcode: 0x%x\n", cdb[0]);
 
-      /* Set response fields */
-      if (success)
-        ent->rsp.scsi_status = SCSI_NO_SENSE;
-      else {
-        /* Also fill in rsp->sense_buffer here */
-        ent->rsp.scsi_status = SCSI_CHECK_CONDITION;
+c) Managing the command ring::
+
+      #include <linux/target_core_user.h>
+
+      int handle_device_events(int fd, void *map)
+      {
+        struct tcmu_mailbox *mb = map;
+        struct tcmu_cmd_entry *ent = (void *) mb + mb->cmdr_off + mb->cmd_tail;
+        int did_some_work = 0;
+
+        /* Process events from cmd ring until we catch up with cmd_head */
+        while (ent != (void *)mb + mb->cmdr_off + mb->cmd_head) {
+
+          if (tcmu_hdr_get_op(ent->hdr.len_op) == TCMU_OP_CMD) {
+            uint8_t *cdb = (void *)mb + ent->req.cdb_off;
+            bool success = true;
+
+            /* Handle command here. */
+            printf("SCSI opcode: 0x%x\n", cdb[0]);
+
+            /* Set response fields */
+            if (success)
+              ent->rsp.scsi_status = SCSI_NO_SENSE;
+            else {
+              /* Also fill in rsp->sense_buffer here */
+              ent->rsp.scsi_status = SCSI_CHECK_CONDITION;
+            }
+          }
+          else if (tcmu_hdr_get_op(ent->hdr.len_op) != TCMU_OP_PAD) {
+            /* Tell the kernel we didn't handle unknown opcodes */
+            ent->hdr.uflags |= TCMU_UFLAG_UNKNOWN_OP;
+          }
+          else {
+            /* Do nothing for PAD entries except update cmd_tail */
+          }
+
+          /* update cmd_tail */
+          mb->cmd_tail = (mb->cmd_tail + tcmu_hdr_get_len(&ent->hdr)) % mb->cmdr_size;
+          ent = (void *) mb + mb->cmdr_off + mb->cmd_tail;
+          did_some_work = 1;
+        }
+
+        /* Notify the kernel that work has been finished */
+        if (did_some_work) {
+          uint32_t buf = 0;
+
+          write(fd, &buf, 4);
+        }
+
+        return 0;
       }
-    }
-    else if (tcmu_hdr_get_op(ent->hdr.len_op) != TCMU_OP_PAD) {
-      /* Tell the kernel we didn't handle unknown opcodes */
-      ent->hdr.uflags |= TCMU_UFLAG_UNKNOWN_OP;
-    }
-    else {
-      /* Do nothing for PAD entries except update cmd_tail */
-    }
-
-    /* update cmd_tail */
-    mb->cmd_tail = (mb->cmd_tail + tcmu_hdr_get_len(&ent->hdr)) % mb->cmdr_size;
-    ent = (void *) mb + mb->cmdr_off + mb->cmd_tail;
-    did_some_work = 1;
-  }
-
-  /* Notify the kernel that work has been finished */
-  if (did_some_work) {
-    uint32_t buf = 0;
-
-    write(fd, &buf, 4);
-  }
-
-  return 0;
-}
 
 
 A final note
-------------
+============
 
 Please be careful to return codes as defined by the SCSI
 specifications. These are different than some values defined in the
diff --git a/scripts/documentation-file-ref-check b/scripts/documentation-file-ref-check
index bd7d9ab63941..f47ef26754fa 100755
--- a/scripts/documentation-file-ref-check
+++ b/scripts/documentation-file-ref-check
@@ -81,7 +81,7 @@ while (<IN>) {
 		# Remove sched-pelt false-positive
 		next if ($fulref =~ m,^Documentation/scheduler/sched-pelt$,);
 
-		# Discard some build examples from Documentation/target/tcm_mod_builder.txt
+		# Discard some build examples from Documentation/target/tcm_mod_builder.rst
 		next if ($fulref =~ m,mnt/sdb/lio-core-2.6.git/Documentation/target,);
 
 		# Check if exists, evaluating wildcards
-- 
2.20.1
