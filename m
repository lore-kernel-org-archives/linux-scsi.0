From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] tests/scsi/0001: Regression test for SCSI device blacklisting
Date: Wed,  9 Aug 2017 12:50:06 +0200
Message-ID: <1502275806-27972-2-git-send-email-hare@suse.de>
References: <1502275806-27972-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38891 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751884AbdHIKuR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 06:50:17 -0400
In-Reply-To: <1502275806-27972-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@fb.com>
Cc: linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

SCSI device blacklisting seems to be a tricky subject, with
lots of potential for messing up the selection algorithm.
This adds a test for catching regressions here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 tests/scsi/001     | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/scsi/001.out | 10 ++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 tests/scsi/001
 create mode 100644 tests/scsi/001.out

diff --git a/tests/scsi/001 b/tests/scsi/001
new file mode 100644
index 0000000..374a458
--- /dev/null
+++ b/tests/scsi/001
@@ -0,0 +1,69 @@
+#!/bin/bash
+#
+# Regression test for scsi device blacklisting
+#
+# Copyright (C) 2017 Hannes Reinecke, SUSE Linux GmbH
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
+DESCRIPTION="SCSI device blacklisting"
+
+QUICK=1
+
+CHECK_DMESG=0
+
+requires() {
+    if modinfo scsi_debug | grep -q inq_vendor ; then
+	return 0
+    fi
+    return 1
+}
+
+test() {
+    local inq vendor model host dev blacklist
+
+    echo "Running ${TEST_NAME}"
+
+    for inq in \
+	"                        " \
+	"AAAAAAAABBBBBBBBBBBBBBBB" \
+	"HITACHI OPEN-V          " \
+	"        Scanner         " \
+	"Inateck                 " \
+	"Promise STEX            " \
+	"HITA    OPEN-V          " \
+	"ABCD    Scanner         " ; do
+	vendor=${inq:0:8}
+	model=${inq:8:16}
+	modprobe scsi_debug inq_vendor="$vendor" inq_product="$model"
+	host=$(lsscsi -H | sed -n 's/.\([0-9]*\).*scsi_debug/\1/p')
+	if [ -z "$host" ] ; then
+	    echo "Test failed, scsi_debug could not be loaded"
+	    return 1
+	fi
+	dev=$(lsscsi | grep $host | sed -n 's/.*\/dev\/\(sd[a-z]*\).*/\1/p')
+	if [ -z "$dev" ] ; then
+	    echo "Test failed, SCSI device not found"
+	    rmmod scsi_debug
+	    return 1
+	fi
+	vendor=$(cat /sys/block/$dev/device/vendor)
+	model=$(cat /sys/block/$dev/device/model)
+	blacklist=$(cat /sys/block/$dev/device/blacklist)
+	echo "$vendor $model $blacklist"
+	rmmod scsi_debug
+    done
+    echo "Test complete"
+    return 0
+}
diff --git a/tests/scsi/001.out b/tests/scsi/001.out
new file mode 100644
index 0000000..64db97c
--- /dev/null
+++ b/tests/scsi/001.out
@@ -0,0 +1,10 @@
+Running scsi/001
+                          0x0
+AAAAAAAA BBBBBBBBBBBBBBBB 0x0
+HITACHI  OPEN-V           0x20000
+         Scanner          0x1
+Inateck                   0x0
+Promise  STEX             0x40
+HITA     OPEN-V           0x0
+ABCD     Scanner          0x0
+Test complete
-- 
1.8.5.6
