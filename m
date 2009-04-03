From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/15] libfc: Add runtime debugging with debug_logging module
	parameter
Date: Fri, 03 Apr 2009 14:58:47 -0700
Message-ID: <20090403215846.10856.99436.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759769AbZDCV6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:58:48 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

This patch adds the /sys/module/libfc/parameters/debug_logging
file to sysfs as a module parameter. It accepts an integer
bitmask for logging. Currently it supports:

   bit
LSB 0 = general libfc debugging
    1 = lport debugging
    2 = disc debugging
    3 = rport debugging
    4 = fcp debugging
    5 = EM debugging
    6 = exch/seq debugging
    7 = scsi logging (mostly error handling)

the other bits are not used at this time.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    4 +++
 include/scsi/libfc.h        |   67 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f555ae9..f21fbcc 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -43,6 +43,10 @@ MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("libfc");
 MODULE_LICENSE("GPL v2");
 
+unsigned int fc_debug_logging;
+module_param_named(debug_logging, fc_debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
+
 static int fc_fcp_debug;
 
 #define FC_DEBUG_FCP(fmt...)			\
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 45f9cc6..3afa005 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -46,6 +46,73 @@
 #define FC_DBG(fmt, args...)
 #endif
 
+#define FC_LIBFC_LOGGING 0x01 /* General logging, not categorized */
+#define FC_LPORT_LOGGING 0x02 /* lport layer logging */
+#define FC_DISC_LOGGING  0x04 /* discovery layer logging */
+#define FC_RPORT_LOGGING 0x08 /* rport layer logging */
+#define FC_FCP_LOGGING   0x10 /* I/O path logging */
+#define FC_EM_LOGGING    0x20 /* Exchange Manager logging */
+#define FC_EXCH_LOGGING  0x40 /* Exchange/Sequence logging */
+#define FC_SCSI_LOGGING  0x80 /* SCSI logging (mostly error handling) */
+
+extern unsigned int fc_debug_logging;
+
+#define FC_CHECK_LOGGING(LEVEL, CMD)				\
+do {								\
+	if (unlikely(fc_debug_logging & LEVEL))			\
+		do {						\
+			CMD;					\
+		} while (0);					\
+} while (0);
+
+#define FC_LIBFC_DBG(fmt, args...)					\
+	FC_CHECK_LOGGING(FC_LIBFC_LOGGING,				\
+			 printk(KERN_INFO "libfc: " fmt, ##args);)
+
+#define FC_LPORT_DBG(lport, fmt, args...)				\
+	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
+			 printk(KERN_INFO "lport: %6x: " fmt,		\
+				fc_host_port_id(lport->host), ##args);)
+
+#define FC_DISC_DBG(disc, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
+			 printk(KERN_INFO "disc: %6x: " fmt,		\
+				fc_host_port_id(disc->lport->host),	\
+				##args);)
+
+#define FC_RPORT_DBG(rport, fmt, args...)				\
+do {									\
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;		\
+	struct fc_lport *lport = rdata->local_port;			\
+	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
+			 printk(KERN_INFO "rport: %6x: %6x: " fmt,	\
+				fc_host_port_id(lport->host),		\
+				rport->port_id, ##args);)		\
+} while (0);
+
+#define FC_FCP_DBG(pkt, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
+			 printk(KERN_INFO "fcp: %6x: %6x: " fmt,	\
+				fc_host_port_id(pkt->lp->host),		\
+				pkt->rport->port_id, ##args);)
+
+#define FC_EM_DBG(em, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_EM_LOGGING,					\
+			 printk(KERN_INFO "em: %6x: " fmt,		\
+				fc_host_port_id(em->lp->host),		\
+				##args);)
+
+#define FC_EXCH_DBG(exch, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
+			 printk(KERN_INFO "exch: %6x: %4x: " fmt,	\
+				fc_host_port_id(exch->lp->host),	\
+				exch->xid, ##args);)
+
+#define FC_SCSI_DBG(lport, fmt, args...)				\
+	FC_CHECK_LOGGING(FC_SCSI_LOGGING,                               \
+			 printk(KERN_INFO "scsi: %6x: " fmt,		\
+				fc_host_port_id(lport->host), ##args);)
+
 /*
  * libfc error codes
  */

