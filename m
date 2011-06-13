From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/8] scsi/mac: Remove unused variable default_instance
Date: Mon, 13 Jun 2011 20:39:17 +0200
Message-ID: <1307990362-22768-4-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Finn Thain <fthain@telegraphics.com.au>
List-Id: linux-scsi@vger.kernel.org

This fixes:

drivers/scsi/mac_scsi.c:220:5: warning: "NDEBUG_ABORT" is not defined
drivers/scsi/mac_scsi.c:271:5: warning: "NDEBUG_ABORT" is not defined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_scsi.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 67eb758..af3a6af 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -215,13 +215,6 @@ static int __init mac_scsi_setup(char *str) {
 __setup("mac5380=", mac_scsi_setup);
 
 /*
- * If you want to find the instance with (k)gdb ...
- */
-#if NDEBUG
-static struct Scsi_Host *default_instance;
-#endif
-
-/*
  * Function : int macscsi_detect(struct scsi_host_template * tpnt)
  *
  * Purpose : initializes mac NCR5380 driver based on the
@@ -268,10 +261,7 @@ int __init macscsi_detect(struct scsi_host_template * tpnt)
     /* Once we support multiple 5380s (e.g. DuoDock) we'll do
        something different here */
     instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-#if NDEBUG
-    default_instance = instance;
-#endif
-    
+
     if (macintosh_config->ident == MAC_MODEL_IIFX) {
 	mac_scsi_regp  = via1+0x8000;
 	mac_scsi_drq   = via1+0xE000;
-- 
1.7.0.4
