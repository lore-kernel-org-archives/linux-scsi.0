From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/27] libfc: add print of exchange id for debugging fc_fcp
Date: Tue, 30 Nov 2010 16:19:15 -0800
Message-ID: <20101201001915.18369.87573.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48819 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab0LAATP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:15 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

This is very helpful to match up the corresponding exchange to the actual I/O
described by the fsp, particularly when you do a side-by-side comparison of
the syslog with your trace.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_libfc.h |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index 16d2162..eea0c35 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -66,9 +66,21 @@ extern unsigned int fc_debug_logging;
 
 #define FC_FCP_DBG(pkt, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
-			 printk(KERN_INFO "host%u: fcp: %6.6x: " fmt,	\
+	{								\
+		if ((pkt)->seq_ptr) {					\
+			struct fc_exch *_ep = NULL;			\
+			_ep = fc_seq_exch((pkt)->seq_ptr);		\
+			printk(KERN_INFO "host%u: fcp: %6.6x: "		\
+				"xid %04x-%04x: " fmt,			\
 				(pkt)->lp->host->host_no,		\
-				pkt->rport->port_id, ##args))
+				(pkt)->rport->port_id,			\
+				(_ep)->oxid, (_ep)->rxid, ##args);	\
+		} else {						\
+			printk(KERN_INFO "host%u: fcp: %6.6x: " fmt,	\
+				(pkt)->lp->host->host_no,		\
+				(pkt)->rport->port_id, ##args);		\
+		}							\
+	})
 
 #define FC_EXCH_DBG(exch, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\

