From: Jeff Garzik <jeff@garzik.org>
Subject: [SCSI PATCH] sd: max-retries becomes configurable
Date: Mon, 24 Sep 2012 17:00:49 -0400
Message-ID: <20120924210049.GA18527@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



 drivers/scsi/sd.c |    4 ++++
 drivers/scsi/sd.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..d15074b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -92,6 +92,10 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
+static int sd_max_retries = 5;
+module_param_named(max_retries, sd_max_retries, int, 0644);
+MODULE_PARM_DESC(max_retries, "Maximum number of retries, before failing command (default 5)");
+
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
 #else
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f703f48..f8488fa 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -18,7 +18,7 @@
 /*
  * Number of allowed retries
  */
-#define SD_MAX_RETRIES		5
+#define SD_MAX_RETRIES		sd_max_retries
 #define SD_PASSTHROUGH_RETRIES	1
 #define SD_MAX_MEDIUM_TIMEOUTS	2
 
