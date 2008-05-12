From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] [ARM] rpc: acornscsi: stop using private __stringify()
Date: Mon, 12 May 2008 18:02:14 +0100
Message-ID: <git-1210611733-e5a7d2f30204ded6822bab9ce49b68c7d27f127d@dyn-67.arm.linux.org.uk>
References: <git-1210611733-626564f695ac62d2e7ee490370bbbc7b5da72969@dyn-67.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39306 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbYELROM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 13:14:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LAK <linux-arm-kernel@lists.arm.linux.org.uk>

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

The kernel has its own, so let's use that instead.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/arm/acornscsi.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 157ac1b..a2f8113 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -123,12 +123,6 @@
 #define DBG(cmd,xxx...) xxx
 #endif
 
-#ifndef STRINGIFY
-#define STRINGIFY(x) #x
-#endif
-#define STRx(x) STRINGIFY(x)
-#define NO_WRITE_STR STRx(NO_WRITE)
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -141,6 +135,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/stringify.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -2828,7 +2823,7 @@ char *acornscsi_info(struct Scsi_Host *host)
     " LINK"
 #endif
 #if (DEBUG & DEBUG_NO_WRITE)
-    " NOWRITE ("NO_WRITE_STR")"
+    " NOWRITE (" __stringify(NO_WRITE) ")"
 #endif
 		, host->hostt->name, host->io_port, host->irq,
 		VER_MAJOR, VER_MINOR, VER_PATCH);
@@ -2859,7 +2854,7 @@ int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
     " LINK"
 #endif
 #if (DEBUG & DEBUG_NO_WRITE)
-    " NOWRITE ("NO_WRITE_STR")"
+    " NOWRITE (" __stringify(NO_WRITE) ")"
 #endif
 		"\n\n", VER_MAJOR, VER_MINOR, VER_PATCH);
 
