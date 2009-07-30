From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/22] libfc: change debug messages to give host number.
Date: Wed, 29 Jul 2009 17:04:12 -0700
Message-ID: <20090730000411.24658.69966.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZG3AEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:04:11 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

libfc debug messages currently show 'lport: <fc-id>:'
wher <fc-id> is the hex assigned port-id.  When the lport
is logged off, that will be zero, so its hard to distinguish
which instance is involved.  The FC-ID can change
if the port is re-patched or changes VSANs.

Two lports may even have the same FC-ID if connected to isolated SANs.

Change the debug messages to print the SCSI host number "hostN:",
which will not change for the life of the lport.
Still show the FC_ID on lport messages.

Also, add a macro to FC_RPORT_ID_DBG for rport debugging where there's
no rdata structure involved.  It takes the lport and port_id as parameters.
Use this in fc_rport_recv_plogi_req() and fc_rport_recv_logo_req().

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/libfc.h |   36 ++++++++++++++++++++----------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index ef04a2c..efdb6ba 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -59,47 +59,51 @@ do {								\
 
 #define FC_LPORT_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
-			 printk(KERN_INFO "lport: %6x: " fmt,		\
-				fc_host_port_id(lport->host), ##args))
+			 printk(KERN_INFO "host%u: lport %6x: " fmt,	\
+				(lport)->host->host_no,			\
+				fc_host_port_id((lport)->host), ##args))
 
 #define FC_DISC_DBG(disc, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
-			 printk(KERN_INFO "disc: %6x: " fmt,		\
-				fc_host_port_id(disc->lport->host),	\
+			 printk(KERN_INFO "host%u: disc: " fmt,		\
+				(disc)->lport->host->host_no,		\
 				##args))
 
+#define FC_RPORT_ID_DBG(lport, port_id, fmt, args...)			\
+	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
+			 printk(KERN_INFO "host%u: rport %6x: " fmt,	\
+				(lport)->host->host_no,			\
+				(port_id), ##args))
+
 #define FC_RPORT_DBG(rport, fmt, args...)				\
 do {									\
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;		\
 	struct fc_lport *lport = rdata->local_port;			\
-	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
-			 printk(KERN_INFO "rport: %6x: %6x: " fmt,	\
-				fc_host_port_id(lport->host),		\
-				rport->port_id, ##args));		\
+	FC_RPORT_ID_DBG(lport, rport->port_id, fmt, ##args);		\
 } while (0)
 
 #define FC_FCP_DBG(pkt, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
-			 printk(KERN_INFO "fcp: %6x: %6x: " fmt,	\
-				fc_host_port_id(pkt->lp->host),		\
+			 printk(KERN_INFO "host%u: fcp: %6x: " fmt,	\
+				(pkt)->lp->host->host_no,		\
 				pkt->rport->port_id, ##args))
 
 #define FC_EM_DBG(em, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EM_LOGGING,					\
-			 printk(KERN_INFO "em: %6x: " fmt,		\
-				fc_host_port_id(em->lp->host),		\
+			 printk(KERN_INFO "host%u: em: " fmt,		\
+				(em)->lp->host->host_no,		\
 				##args))
 
 #define FC_EXCH_DBG(exch, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
-			 printk(KERN_INFO "exch: %6x: %4x: " fmt,	\
-				fc_host_port_id(exch->lp->host),	\
+			 printk(KERN_INFO "host%u: xid %4x: " fmt,	\
+				(exch)->lp->host->host_no,		\
 				exch->xid, ##args))
 
 #define FC_SCSI_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_SCSI_LOGGING,                               \
-			 printk(KERN_INFO "scsi: %6x: " fmt,		\
-				fc_host_port_id(lport->host), ##args))
+			 printk(KERN_INFO "host%u: scsi: " fmt,		\
+				(lport)->host->host_no,	##args))
 
 /*
  * libfc error codes

