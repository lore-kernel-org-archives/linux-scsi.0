From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 7/8] scsi/sun3: Add various missing NDEBUG* definitions
Date: Mon, 13 Jun 2011 20:39:21 +0200
Message-ID: <1307990362-22768-8-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:46675 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab1FMSjk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 14:39:40 -0400
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Sam Creasey <sammy@sammy.net>

This fixes a.o.:

drivers/scsi/sun3_scsi.h:225:5: warning: "NDEBUG" is not defined
drivers/scsi/sun3_scsi.h:345:14: warning: "NDEBUG_ABORT" is not defined
drivers/scsi/sun3_scsi.h:351:14: warning: "NDEBUG_TAGS" is not defined
drivers/scsi/sun3_scsi.h:357:14: warning: "NDEBUG_MERGING" is not defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 drivers/scsi/sun3_scsi.c     |    8 ++++++--
 drivers/scsi/sun3_scsi_vme.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2cc83ef..baf7328 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -70,6 +70,12 @@
 #include <asm/idprom.h>
 #include <asm/machines.h>
 
+#define NDEBUG 0
+
+#define NDEBUG_ABORT		0x00100000
+#define NDEBUG_TAGS		0x00200000
+#define NDEBUG_MERGING		0x00400000
+
 /* dma on! */
 #define REAL_DMA
 
@@ -86,8 +92,6 @@ static void NCR5380_print(struct Scsi_Host *instance);
 /*#define RESET_BOOT */
 #define DRIVER_SETUP
 
-#define NDEBUG 0
-
 /*
  * BUG can be used to trigger a strange code-size related hang on 2.1 kernels
  */
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index c0252db..fbba78e 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -39,6 +39,12 @@
 /* dma on! */
 #define REAL_DMA
 
+#define NDEBUG 0
+
+#define NDEBUG_ABORT		0x00100000
+#define NDEBUG_TAGS		0x00200000
+#define NDEBUG_MERGING		0x00400000
+
 #include "scsi.h"
 #include "initio.h"
 #include <scsi/scsi_host.h>
@@ -50,8 +56,6 @@ extern int sun3_map_test(unsigned long, char *);
 /*#define RESET_BOOT */
 #define DRIVER_SETUP
 
-#define NDEBUG 0
-
 /*
  * BUG can be used to trigger a strange code-size related hang on 2.1 kernels
  */
-- 
1.7.0.4

