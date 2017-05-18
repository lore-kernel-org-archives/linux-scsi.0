From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH blktests 2/3] tests/sg: add SCSI generic test grouop
Date: Thu, 18 May 2017 14:13:07 +0200
Message-ID: <b9201d03f70519230dcffd5cfa92496a3bad5da4.1495109149.git.jthumshirn@suse.de>
References: <cover.1495109149.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58729 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932532AbdERMNu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 08:13:50 -0400
In-Reply-To: <cover.1495109149.git.jthumshirn@suse.de>
In-Reply-To: <cover.1495109149.git.jthumshirn@suse.de>
References: <cover.1495109149.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Add a test group for tests of the SCSI generic driver and and
functions common to the SCSI generic driver and it's test cases.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 common/sg      | 22 ++++++++++++++++++++++
 tests/sg/group | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)
 create mode 100644 common/sg
 create mode 100644 tests/sg/group

diff --git a/common/sg b/common/sg
new file mode 100644
index 000000000000..30b5089c68f7
--- /dev/null
+++ b/common/sg
@@ -0,0 +1,22 @@
+#!/bin/bash
+#
+# SCSI generic helper functions.
+#
+# Copyright (C) 2017 Johannes Thumshirn
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation, either version 3 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+_have_scsi_generic() {
+	_have_module sg
+}
diff --git a/tests/sg/group b/tests/sg/group
new file mode 100644
index 000000000000..55af9a2730eb
--- /dev/null
+++ b/tests/sg/group
@@ -0,0 +1,40 @@
+#!/bin/bash
+#
+# Regression tests for SCSI generic device
+#
+# Copyright (C) 2017 Johannes Thumshirn <jthumshirn@suse.de>
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation, either version 3 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+. common/sg
+
+group_requires() {
+	_have_scsi_generic
+}
+
+# TODO: if this test group has extra requirements for what devices it can be
+# run on, it should define a group_device_requires() function. If tests in this
+# group can be run on the test device, it should return zero. Otherwise, it
+# should return non-zero and set the $SKIP_REASON variable. $TEST_DEV is the
+# full path of the block device (e.g., /dev/nvme0n1 or /dev/sda1), and
+# $TEST_DEV_SYSFS is the sysfs path of the disk (not the partition, e.g.,
+# /sys/block/nvme0n1 or /sys/block/sda).
+#
+# Usually, group_device_requires() just needs to check that the test device is
+# the right type of hardware or supports any necessary features using the
+# _test_dev_foo helpers. If group_device_requires() returns non-zero, all tests
+# in this group will be skipped on that device.
+# group_device_requires() {
+# 	_test_dev_is_foo && _test_dev_supports_bar
+# }
-- 
2.12.0
