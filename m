From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH blktests v2 2/3] tests/sg: add SCSI generic test grouop
Date: Fri, 19 May 2017 15:55:30 +0200
Message-ID: <adaebafc1753d10d7bbb17bcb33af0fa2e701822.1495201975.git.jthumshirn@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49581 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751945AbdESNzk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 09:55:40 -0400
In-Reply-To: <cover.1495201975.git.jthumshirn@suse.de>
In-Reply-To: <cover.1495201975.git.jthumshirn@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>

Add a test group for tests of the SCSI generic driver and and
functions common to the SCSI generic driver and it's test cases.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 common/sg      | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/sg/group | 28 ++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)
 create mode 100644 common/sg
 create mode 100644 tests/sg/group

diff --git a/common/sg b/common/sg
new file mode 100644
index 000000000000..123735178d96
--- /dev/null
+++ b/common/sg
@@ -0,0 +1,41 @@
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
+
+_test_dev_is_scsi() {
+
+	local DEV="$1"
+
+	if [[ -d "/sys/block/$DEV/device/scsi_device" ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+_get_sg_from_blockdev()
+{
+	local sg_path="/sys/block/$1/device/scsi_generic/"
+	local sg_dev=$(ls $sg_path | grep -E 'sg[0-9]+') 
+
+	echo "$sg_dev"
+}
diff --git a/tests/sg/group b/tests/sg/group
new file mode 100644
index 000000000000..3121d799fe25
--- /dev/null
+++ b/tests/sg/group
@@ -0,0 +1,28 @@
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
+group_device_requires() {
+	_test_dev_is_scsi
+}
-- 
2.12.0
