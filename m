From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 1/6] [FCoE] Fix the openfc Makefile to build as included in
	kernel
Date: Thu, 07 Feb 2008 00:21:11 -0800
Message-ID: <20080207082111.28965.67934.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbYBGIdd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2008 03:33:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The current build for openfc will fail as it only builds as module.

Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/ofc/openfc/Makefile |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/drivers/scsi/ofc/openfc/Makefile b/drivers/scsi/ofc/openfc/Makefile
index 00606a2..9309266 100644
--- a/drivers/scsi/ofc/openfc/Makefile
+++ b/drivers/scsi/ofc/openfc/Makefile
@@ -9,7 +9,10 @@ openfc-y := \
 	openfc_if.o \
 	openfc_ioctl.o \
 	openfc_pkt.o \
-	openfc_scsi.o \
-	../libfc/libfc.o \
-	../libsa/libsa.o \
-	../libcrc/libcrc.o
+	openfc_scsi.o
+
+ifeq ($(CONFIG_OFC),m)
+	openfc-y += ../libfc/libfc.o \
+		    ../libsa/libsa.o \
+		    ../libcrc/libcrc.o
+endif

