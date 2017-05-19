From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH blktests v2 3/3] sg/001: add regression test for syzcaller generated GPF in sg_read path
Date: Fri, 19 May 2017 15:55:31 +0200
Message-ID: <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1495201975.git.jthumshirn@suse.de>
In-Reply-To: <cover.1495201975.git.jthumshirn@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Add a regression test for commit 48ae8484e9fc ("scsi: sg: don't return
bogus Sg_requests"). This is a general protection fault triggered by
syzcaller via issuing bogus read(2)s on the /dev/sg devices.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 tests/sg/001     | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/sg/001.out |  2 ++
 2 files changed, 49 insertions(+)
 create mode 100755 tests/sg/001
 create mode 100644 tests/sg/001.out

diff --git a/tests/sg/001 b/tests/sg/001
new file mode 100755
index 000000000000..86430409b6a3
--- /dev/null
+++ b/tests/sg/001
@@ -0,0 +1,47 @@
+#!/bin/bash
+#
+# Regression test for commit 48ae8484e9fc ("scsi: sg: don't return bogus
+# Sg_requests")
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
+. common/scsi_debug
+
+DESCRIPTION="try triggering a kernel GPF with 0 byte SG reads"
+QUICK=1
+
+requires() {
+	_have_program src/sg-001 \
+	    && _have_scsi_debug \
+	    && _have_scsi_generic
+}
+
+
+test() {
+	echo "Running ${TEST_NAME}"
+
+	if ! _get_scsi_debug_dev; then
+	    return 1
+	fi
+
+	SG_DEV=$(_get_sg_from_blockdev "$SCSI_DEBUG_NAME")
+	timeout -s INT 10s ./src/sg-001 "$SG_DEV"
+
+	_put_scsi_debug_dev
+
+	echo "Test complete"
+}
diff --git a/tests/sg/001.out b/tests/sg/001.out
new file mode 100644
index 000000000000..beb4c437dd28
--- /dev/null
+++ b/tests/sg/001.out
@@ -0,0 +1,2 @@
+Running sg/001
+Test complete
-- 
2.12.0
