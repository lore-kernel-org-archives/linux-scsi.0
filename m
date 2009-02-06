From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/17] libfc: runtime debugging with debug_logging module
	parameter
Date: Fri, 06 Feb 2009 10:56:37 -0800
Message-ID: <20090206185637.26188.95309.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15666 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbZBFS4i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:38 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This patch adds the /sys/module/libfc/parameters/debug_logging
file to sysfs as a module parameter. It accepts an integer
bitmask for logging. Currently it supports:

LSB x = lport debugging
    x = disc debugging
    x = rport debugging
    x = fcp debugging
    x = EM debugging

the other bits are not used at this time.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   15 +++------------
 drivers/scsi/libfc/fc_exch.c  |   11 -----------
 drivers/scsi/libfc/fc_fcp.c   |   10 +++-------
 drivers/scsi/libfc/fc_lport.c |    8 --------
 drivers/scsi/libfc/fc_rport.c |    8 --------
 include/scsi/libfc.h          |   37 +++++++++++++++++++++++++++++++++++++
 6 files changed, 43 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index cfbce89..05189f6 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -45,14 +45,6 @@
 
 #define	FC_DISC_DELAY		3
 
-static int fc_disc_debug;
-
-#define FC_DEBUG_DISC(fmt...)			\
-	do {					\
-		if (fc_disc_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
 static int fc_disc_new_target(struct fc_disc *, struct fc_rport *,
@@ -487,10 +479,9 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 {
 	struct fc_lport *lport = disc->lport;
 	unsigned long delay = 0;
-	if (fc_disc_debug)
-		FC_DBG("Error %ld, retries %d/%d\n",
-		       PTR_ERR(fp), disc->retry_count,
-		       FC_DISC_RETRY_LIMIT);
+	FC_DEBUG_DISC("Error %ld, retries %d/%d\n",
+		      PTR_ERR(fp), disc->retry_count,
+		      FC_DISC_RETRY_LIMIT);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
 		/*
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 8c40189..ce608d7 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -32,17 +32,6 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
-/*
- * fc_exch_debug can be set in debugger or at compile time to get more logs.
- */
-static int fc_exch_debug;
-
-#define FC_DEBUG_EXCH(fmt...)			\
-	do {					\
-		if (fc_exch_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static struct kmem_cache *fc_em_cachep;	/* cache for exchanges */
 
 /*
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index ecc7261..3f93930 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -43,13 +43,9 @@ MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("libfc");
 MODULE_LICENSE("GPL");
 
-static int fc_fcp_debug;
-
-#define FC_DEBUG_FCP(fmt...)			\
-	do {					\
-		if (fc_fcp_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
+unsigned int debug_logging;
+module_param(debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
 static struct kmem_cache *scsi_pkt_cachep;
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 7dd433c..f777723 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -101,14 +101,6 @@
 
 #define	DNS_DELAY	      3 /* Discovery delay after RSCN (in seconds)*/
 
-static int fc_lport_debug;
-
-#define FC_DEBUG_LPORT(fmt...)			\
-	do {					\
-		if (fc_lport_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static void fc_lport_error(struct fc_lport *, struct fc_frame *);
 
 static void fc_lport_enter_reset(struct fc_lport *);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 4f23a9b..05330c0 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -55,14 +55,6 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
-static int fc_rport_debug;
-
-#define FC_DEBUG_RPORT(fmt...)			\
-	do {					\
-		if (fc_rport_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 struct workqueue_struct *rport_event_queue;
 
 static void fc_rport_enter_plogi(struct fc_rport *);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 37df48e..01f68f6 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -45,6 +45,43 @@
 #define FC_DBG(fmt, args...)
 #endif
 
+#define FC_LPORT_LOGGING 0x01
+#define FC_DISC_LOGGING  0x02
+#define FC_RPORT_LOGGING 0x04
+#define FC_FCP_LOGGING   0x08
+#define FC_EXCH_LOGGING  0x10
+
+extern unsigned int debug_logging;
+
+#define FC_CHECK_LOGGING(LEVEL, CMD)				\
+do {								\
+	if (unlikely(debug_logging & LEVEL))			\
+		do {						\
+			CMD;					\
+		} while (0);					\
+} while (0)
+
+#define FC_DEBUG_LPORT(fmt, args...)					\
+	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
+			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
+
+#define FC_DEBUG_DISC(fmt, args...)					\
+	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
+			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
+
+#define FC_DEBUG_RPORT(fmt, args...)					\
+	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
+			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
+
+#define FC_DEBUG_FCP(fmt, args...)					\
+	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
+			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
+
+#define FC_DEBUG_EXCH(fmt, args...)					\
+	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
+			 printk(KERN_INFO "%s " fmt, __func__, ##args);)
+
+
 /*
  * libfc error codes
  */

