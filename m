From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] add lio-target helpers
Date: Thu, 30 Mar 2017 17:19:02 +0400
Message-ID: <1490879944-26240-2-git-send-email-dmonakhov@openvz.org>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-scsi@vger.kernel.org

Linux-IO Target is very good framework for testing block backend.
It is more flexible than scsi_debug.

http://linux-iscsi.org/wiki/LIO
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common/config    |   2 +
 common/liotarget | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)
 create mode 100644 common/liotarget

diff --git a/common/config b/common/config
index 59041a3..cfe7913 100644
--- a/common/config
+++ b/common/config
@@ -212,6 +212,8 @@ export XZ_PROG="`set_prog_path xz`"
 export FLOCK_PROG="`set_prog_path flock`"
 export LDD_PROG="`set_prog_path ldd`"
 export TIMEOUT_PROG="`set_prog_path timeout`"
+export TARGETCLI_PROG="`set_prog_path targetcli`"
+export TARGETCTL_PROG="`set_prog_path targetctl`"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/liotarget b/common/liotarget
new file mode 100644
index 0000000..f821692
--- /dev/null
+++ b/common/liotarget
@@ -0,0 +1,111 @@
+#!/bin/bash
+#
+# Copyright (c) 2017 Virtuozzo Inc
+# All Rights Reserved.
+#
+# Written by Dmitry Monakhov <dmonakhov@openvz.org>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#
+# Functions for Linux-IO Target manipulation
+#
+
+_require_liotarget()
+{
+	which $TARGETCLI_PROG >>$seqres.full 2>&1  || \
+	    _notrun "this test requires 'targetcli' tool"
+	which $TARGETCLI_PROG >>$seqres.full 2>&1  || \
+	    _notrun "this test requires 'targetcli' tool"
+
+	$TARGETCLI_PROG ls /backstores/ramdisk >>$seqres.full 2>&1 ||\
+	    _notrun "kernel compiled w/o CONFIG_TARGET_CORE"
+	$TARGETCLI_PROG ls /backstores/fileio >>$seqres.full 2>&1 ||\
+	    _notrun "kernel compiled w/o CONFIG_TCM_FILEIO"
+	$TARGETCLI_PROG ls /loopback >>$seqres.full 2>&1 ||\
+	    _notrun "kernel compiled w/o CONFIG_LOOPBACK_TARGET"
+}
+
+_liotgt_create_fileio()
+{
+	local name=$1
+	local img=$2
+	local sz=$3
+
+	$TARGETCLI_PROG /backstores/fileio create \
+			name=$name file_or_dev=$img  size=$sz >>$seqres.full ||\
+	    _fail "Can not create /backstores/fileio/$name"
+
+	local cfg_path=`ls -d /sys/kernel/config/target/core/fileio_*/$name`
+	[ -d "$cfg_path" ] || _fail "Bad config path"
+	echo $cfg_path
+}
+
+_liotgt_set_attribute()
+{
+	local path=$1
+	local attr_name=$2
+	local attr_val=$3
+
+	[ -f $path/attrib/$attr_name ] || _fail "Bad attribute $attr_name"
+	echo "echo $attr_val >  $path/attrib/$attr_name " >>$seqres.full
+	echo $attr_val >  $path/attrib/$attr_name
+}
+
+_liotgt_create_loopback()
+{
+	local out=`$TARGETCLI_PROG /loopback/ create 2>&1`
+	[ $? -eq 0 ] || _fail "Can not create loopback target"
+	echo $out >>$seqres.full
+
+	local naa=`echo $out | gawk '{ print $3 }'`
+	echo ${naa:0:20} >>$seqres.full
+
+	echo ${naa:0:20}
+}
+
+_liotgt_find_dev()
+{
+	local found=""
+	local name=$1
+	local drives=`find /sys/devices -type f -name model`
+	for d in $drives;do
+		local dir=`dirname $d`
+		local vendor=`cat $dir/vendor`
+		local model=`cat $dir/model`
+		if [ "${vendor//[[:space:]]/}" == "LIO-ORG" ] && \
+		       [ "${model//[[:space:]]/}" == "$name" ]; then
+			found=/dev/$(ls $dir/block)
+			break
+		fi
+	done
+	[ -z "$found" ] && _fail "Can not find device with backend $name"
+	echo "$found"
+}
+
+_liotgt_attach_target()
+{
+	local path=$1
+	local name=`basename $path`
+	local naa=$(_liotgt_create_loopback)
+
+	$TARGETCLI_PROG /loopback/$naa/luns create $path >>$seqres.full 2>&1 ||\
+	    _fail "Can not attach $path to tcm_loop"
+	_liotgt_find_dev $name
+}
+
+_liotgt_cleanup()
+{
+	$TARGETCTL_PROG clear
+}
-- 
2.9.3
