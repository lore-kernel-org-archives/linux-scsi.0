From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 07/18] osd_test: User-mode application to run the OSD tests
Date: Tue,  4 Nov 2008 18:44:43 +0200
Message-ID: <1225817083-6040-1-git-send-email-bharrosh@panasas.com>
References: <491073BB.4000900@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:37574 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbYKDQqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 11:46:06 -0500
In-Reply-To: <491073BB.4000900@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.j>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com, Pete Wyckoff <pw@padd.com>

Most simple user-app to invoke the in-kernel test ioctl of the
specified osd device.

Usage: osd_test "/dev/osdX"

Where /dev/osdX is the osd device (lun) to run tests on. The output
of the tests is in dmesg log file

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/Makefile   |   10 +++++-
 drivers/scsi/osd/osd_test.c |   74 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/osd/osd_test.c

diff --git a/drivers/scsi/osd/Makefile b/drivers/scsi/osd/Makefile
index d905344..92d8b19 100755
--- a/drivers/scsi/osd/Makefile
+++ b/drivers/scsi/osd/Makefile
@@ -28,10 +28,16 @@ V ?= 0
 # this is the basic Kbuild out-of-tree invocation, with the M= option
 KBUILD_BASE = +$(MAKE) -C $(KSRC) M=`pwd` KBUILD_OUTPUT=$(KBUILD_OUTPUT) ARCH=$(ARCH) V=$(V)
 
-all: libosd
+all: libosd osd_test
 
 libosd: ;
 	$(KBUILD_BASE) OSD_INC=$(OSD_INC) modules
 
-clean:
+clean: osd_test_clean
 	$(KBUILD_BASE) clean
+
+osd_test: osd_test.o
+	$(CC) -o $@ $<
+
+osd_test_clean:
+	rm -vf osd_test
diff --git a/drivers/scsi/osd/osd_test.c b/drivers/scsi/osd/osd_test.c
new file mode 100644
index 0000000..dc74865
--- /dev/null
+++ b/drivers/scsi/osd/osd_test.c
@@ -0,0 +1,74 @@
+/*
+ * osd_test.c - A user-mode program that calls into the osd ULD
+ *
+ * Copyright (C) 2008 Panasas Inc.  All rights reserved.
+ *
+ * Authors:
+ *   Boaz Harrosh <bharrosh@panasas.com>
+ *   Benny Halevy <bhalevy@panasas.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  1. Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *  2. Redistributions in binary form must reproduce the above copyright
+ *     notice, this list of conditions and the following disclaimer in the
+ *     documentation and/or other materials provided with the distribution.
+ *  3. Neither the name of the Panasas company nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <fcntl.h>
+
+#include "osd_ktests.h"
+
+void usage(void)
+{
+	printf("usage: osd_test /dev/osdX testNo\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int osd_file, ret;
+
+	if (argc <= 1) {
+		usage();
+		return -2;
+	}
+
+	osd_file = open(argv[1], O_RDWR);
+	if (osd_file < 0) {
+		printf("Error opening <%s>\n", argv[1]);
+		return -3;
+	}
+
+	ret = ioctl(osd_file, OSD_TEST_ALL, 0);
+	if (ret) {
+		printf("ioctl 17 returned %d\n", ret);
+		return ret;
+	}
+
+	close(osd_file);
+	return 0;
+}
-- 
1.6.0.1

