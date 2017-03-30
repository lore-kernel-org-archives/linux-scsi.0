From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] add test: generic/420 check information lead for lio-fileio
Date: Thu, 30 Mar 2017 17:19:03 +0400
Message-ID: <1490879944-26240-3-git-send-email-dmonakhov@openvz.org>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36719 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933576AbdC3NTV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 09:19:21 -0400
In-Reply-To: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/generic/420     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/420.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100755 tests/generic/420
 create mode 100644 tests/generic/420.out

diff --git a/tests/generic/420 b/tests/generic/420
new file mode 100755
index 0000000..592703d
--- /dev/null
+++ b/tests/generic/420
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test 420
+#
+# Regression test for  information leak for lio-fileio target
+# BUG: If image  file is less than virtual blockdev then read() may return
+#      unitilized data.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Dmitry Monakhov <dmonakhov@openvz.org>
+# All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	_liotgt_cleanup
+	rm -rf $TEST_DIR/$$
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/liotarget
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_liotarget
+
+mkdir -p $TEST_DIR/$$ || _fail "Can not make test dir"
+
+cfg_path=$(_liotgt_create_fileio  420-test.img $TEST_DIR/$$/420-test.img 128M)
+dev=$(_liotgt_attach_target /backstores/fileio/420-test.img)
+
+$XFS_IO_PROG -f -c "truncate 1M" $TEST_DIR/$$/420-test.img >> $seqres.full
+
+$XFS_IO_PROG -c "pwrite -S 0xa0 -b 512 512 1k" -d $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+
+$XFS_IO_PROG -c "pwrite -S 0xab -b 512 2M 1k" -d $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+
+md5sum $dev | sed -e "s,$dev,loopdev,g"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/420.out b/tests/generic/420.out
new file mode 100644
index 0000000..deed5da
--- /dev/null
+++ b/tests/generic/420.out
@@ -0,0 +1,2 @@
+QA output created by 420
+f5cfb0d8d7bfadbc2127f4f6ca4a0eba  loopdev
diff --git a/tests/generic/group b/tests/generic/group
index 0781f35..1261547 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -422,3 +422,4 @@
 417 auto quick shutdown log
 418 auto rw
 419 auto quick encrypt
+420 auto blockdev liotarget
-- 
2.9.3
