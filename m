From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] scsi: fix sparse warnings in FlashPoint.c
Date: Mon, 8 Aug 2011 13:43:02 -0700
Message-ID: <20110808134302.128126e1.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57958 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753531Ab1HHUnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2011 16:43:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <jbottomley@parallels.com>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix sparse warnings in FlashPoint.c:

drivers/scsi/FlashPoint.c:2160:37: warning: non-ANSI function declaration of function 'FPT_SccbMgrTableInitAll'
drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/FlashPoint.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- lnx-31-rc1.orig/drivers/scsi/FlashPoint.c
+++ lnx-31-rc1/drivers/scsi/FlashPoint.c
@@ -903,8 +903,8 @@ static void FPT_autoCmdCmplt(unsigned lo
 static void FPT_autoLoadDefaultMap(unsigned long p_port);
 
 static struct sccb_mgr_tar_info FPT_sccbMgrTbl[MAX_CARDS][MAX_SCSI_TAR] =
-    { {{0}} };
-static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {0} };
+    { {{NULL}} };
+static struct sccb_card FPT_BL_Card[MAX_CARDS] = { {NULL} };
 static SCCBSCAM_INFO FPT_scamInfo[MAX_SCSI_TAR] = { {{0}} };
 static struct nvram_info FPT_nvRamInfo[MAX_MB_CARDS] = { {0} };
 
@@ -919,7 +919,7 @@ static unsigned char FPT_scamHAString[] 
 static unsigned short FPT_default_intena = 0;
 
 static void (*FPT_s_PhaseTbl[8]) (unsigned long, unsigned char) = {
-0};
+NULL};
 
 /*---------------------------------------------------------------------
  *
@@ -2157,7 +2157,7 @@ static unsigned char FPT_SccbMgr_bad_isr
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_SccbMgrTableInitAll()
+static void FPT_SccbMgrTableInitAll(void)
 {
 	unsigned char thisCard;
 
