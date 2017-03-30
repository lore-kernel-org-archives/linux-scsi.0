From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] add test: generic/421 basic blockdev T10-DIF-TYPE1 integrity checks
Date: Thu, 30 Mar 2017 17:19:04 +0400
Message-ID: <1490879944-26240-4-git-send-email-dmonakhov@openvz.org>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34615 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933569AbdC3NTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 09:19:22 -0400
In-Reply-To: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>

Test create virtual block device via lio-targed infastructure and
perform basic IO operations with data corruption detection.

Temprorally mark is as dangerous, because currently it trigger BUG_ON
inside blkdev_issue_flush

BTW: I use 'dd' to test read from corrupted image instead of xfs_io
because even if pread failed, xfs_io still exit with success, BUG?

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/generic/421     | 136 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/421.out |  16 ++++++
 tests/generic/group   |   1 +
 3 files changed, 153 insertions(+)
 create mode 100644 tests/generic/421
 create mode 100644 tests/generic/421.out

diff --git a/tests/generic/421 b/tests/generic/421
new file mode 100644
index 0000000..de1ba73
--- /dev/null
+++ b/tests/generic/421
@@ -0,0 +1,136 @@
+#! /bin/bash
+# FS QA Test 421
+#
+# Check basic T10-DIF integrity features for a block device
+#
+# DIF/DIX TYPE: T10-DIF-TYPE1-CRC
+# Kernel docs: Documentation/block/data-integrity.txt
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
+# Create virtual block device
+cfg_path=$(_liotgt_create_fileio  t10-dif-t1 $TEST_DIR/$$/t10-dif-t1 32M)
+
+_liotgt_set_attribute $cfg_path  pi_prot_type 1
+_liotgt_set_attribute $cfg_path  pi_prot_format 1
+
+dev=$(_liotgt_attach_target /backstores/fileio/t10-dif-t1)
+
+echo "T0: Test basic IO"
+$XFS_IO_PROG -c "pwrite -S 0xa0 -b 4M 0 16M" -d $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+
+$XFS_IO_PROG -c "pwrite -S 0xa1 -b 1k -V8  20M 32k" -d $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+
+$XFS_IO_PROG -c "pwrite -S 0xa2 -b 1k -V8  2M 32k" -f $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+
+$XFS_IO_PROG -c "pwrite -S 0xa3 -b 4k  1536000 8k" -f $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+
+$XFS_IO_PROG -c "fsync" -d $dev >>$seqres.full 2>&1 || _fail "fsync failed"
+
+echo "Check that buffered and direct read works"
+dd if=$dev bs=4k  2>$seqres.full | md5sum
+dd if=$dev bs=4M iflag=direct 2>$seqres.full | md5sum
+
+echo "Check csum corruption detection"
+# LIO-fileio store t10 DIF data in separate file ${IMG}.protection
+# struct t10_pi_tuple {
+#	__be16 guard_tag;       /* Checksum */
+#       __be16 app_tag;         /* Opaque storage */
+#       __be32 ref_tag;         /* Target LBA or indirect LBA */
+#}
+# Play with 3000'th sector -> t10_pi_tuple offset == 3000 * 8 == 24000
+#
+echo "T1: Corrupt guard_tag, next read should fail"
+$XFS_IO_PROG -c "pwrite -S 0xde -b2 24000 2 -w" \
+	     -f $TEST_DIR/$$/t10-dif-t1.protection >>$seqres.full 2>&1
+dd if=$dev bs=1M count=2 iflag=direct >>$seqres.full 2>&1 &&
+    _fail "read should fail on 3000'th sector"
+
+echo "T2: Check that unaffected blocks are still readable"
+dd if=$dev bs=1M count=1 iflag=direct >>$seqres.full 2>&1 || _fail "read failed"
+
+echo "T3: Rewrite corrupted sector and check that read works"
+$XFS_IO_PROG -c "pwrite -S 0xa3 -b 4k 1536000 4k" -d $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+dd if=$dev bs=2M count=1 iflag=direct >>$seqres.full 2>&1 || _fail "read failed"
+
+echo "T4: Corrupt app_tag, should not affect read"
+$XFS_IO_PROG -c "pwrite -S 0xde -b2 24002 2 -w" \
+	     -f $TEST_DIR/$$/t10-dif-t1.protection >>$seqres.full 2>&1
+dd if=$dev bs=2M count=1 iflag=direct >>$seqres.full 2>&1 || _fail "read failed"
+
+echo "T5: Corrupt ref_tag, next read should fail"
+$XFS_IO_PROG -c "pwrite -S 0xde -b4 24004 4 -w"  \
+	     $TEST_DIR/$$/t10-dif-t1.protection  >>$seqres.full 2>&1
+dd if=$dev bs=1M count=2 iflag=direct >>$seqres.full 2>&1 &&
+    _fail "read should fail on 3000'th sector"
+
+echo "T6: Check that unaffected blocks are still readable"
+dd if=$dev bs=1M count=1 iflag=direct >>$seqres.full 2>&1 || _fail "read failed"
+
+echo "T7: Rewrite corrupted sector and check that read works"
+$XFS_IO_PROG -c "pwrite -S 0xa3 -b 4k 1536000 4k" -d $dev >>$seqres.full 2>&1 || \
+    _fail "pwrite failed"
+
+echo "Check that buffered and direct read works"
+dd if=$dev bs=4k  2>$seqres.full | md5sum
+dd if=$dev bs=4M iflag=direct 2>$seqres.full | md5sum
+# success, all done
+status=0
+exit
diff --git a/tests/generic/421.out b/tests/generic/421.out
new file mode 100644
index 0000000..087d717
--- /dev/null
+++ b/tests/generic/421.out
@@ -0,0 +1,16 @@
+QA output created by 421
+T0: Test basic IO
+Check that buffered and direct read works
+d4dacb57332e9125d56a0bad5fbfb8ff  -
+d4dacb57332e9125d56a0bad5fbfb8ff  -
+Check csum corruption detection
+T1: Corrupt guard_tag, next read should fail
+T2: Check that unaffected blocks are still readable
+T3: Rewrite corrupted sector and check that read works
+T4: Corrupt app_tag, should not affect read
+T5: Corrupt ref_tag, next read should fail
+T6: Check that unaffected blocks are still readable
+T7: Rewrite corrupted sector and check that read works
+Check that buffered and direct read works
+d4dacb57332e9125d56a0bad5fbfb8ff  -
+d4dacb57332e9125d56a0bad5fbfb8ff  -
diff --git a/tests/generic/group b/tests/generic/group
index 1261547..c3c6042 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -423,3 +423,4 @@
 418 auto rw
 419 auto quick encrypt
 420 auto blockdev liotarget
+421 auto blockdev dangerous liotarget integrity
-- 
2.9.3
