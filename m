From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 11/12] libfc: set both precision and field with when printing
	FC IDs
Date: Fri, 09 Apr 2010 14:23:10 -0700
Message-ID: <20100409212310.1968.94657.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39525 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab0DIVXL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:23:11 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Chris Leech <christopher.leech@intel.com>, Robert Love <robert.w.love@intel.com>

From: Chris Leech <christopher.leech@intel.com>

Most of the prints of fabric IDs were specified as %6x, which will not
print any leading 0s.  It's nice to see leading 0s for identifiers
like this, which are a fixed length.  This patch sets the precision
modifier as well, making the specifier %6.6x, which forces the
printing of leading 0s.

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |    6 +++---
 drivers/scsi/libfc/fc_fcp.c   |   16 ++++++++--------
 drivers/scsi/libfc/fc_libfc.h |    6 +++---
 drivers/scsi/libfc/fc_lport.c |   14 +++++++-------
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 1087a7f..83314a1 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -132,7 +132,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		switch (fmt) {
 		case ELS_ADDR_FMT_PORT:
 			FC_DISC_DBG(disc, "Port address format for port "
-				    "(%6x)\n", ntoh24(pp->rscn_fid));
+				    "(%6.6x)\n", ntoh24(pp->rscn_fid));
 			dp = kzalloc(sizeof(*dp), GFP_KERNEL);
 			if (!dp) {
 				redisc = 1;
@@ -449,7 +449,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 			} else {
 				printk(KERN_WARNING "libfc: Failed to allocate "
 				       "memory for the newly discovered port "
-				       "(%6x)\n", ids.port_id);
+				       "(%6.6x)\n", ids.port_id);
 				error = -ENOMEM;
 			}
 		}
@@ -607,7 +607,7 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 			rdata->ids.port_name = port_name;
 		else if (rdata->ids.port_name != port_name) {
 			FC_DISC_DBG(disc, "GPN_ID accepted.  WWPN changed. "
-				    "Port-id %x wwpn %llx\n",
+				    "Port-id %6.6x wwpn %llx\n",
 				    rdata->ids.port_id, port_name);
 			lport->tt.rport_logoff(rdata);
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f99d66f..81a7c97 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -489,7 +489,7 @@ crc_err:
 			/* per cpu count, not total count, but OK for limit */
 			if (stats->InvalidCRCCount++ < 5)
 				printk(KERN_WARNING "libfc: CRC error on data "
-				       "frame for port (%6x)\n",
+				       "frame for port (%6.6x)\n",
 				       fc_host_port_id(lport->host));
 			put_cpu();
 			/*
@@ -894,7 +894,7 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			return;
 		}
 		fsp->status_code = FC_DATA_OVRRUN;
-		FC_FCP_DBG(fsp, "tgt %6x xfer len %zx greater than expected, "
+		FC_FCP_DBG(fsp, "tgt %6.6x xfer len %zx greater than expected, "
 			   "len %x, data len %x\n",
 			   fsp->rport->port_id,
 			   fsp->xfer_len, expected_len, fsp->data_len);
@@ -1562,7 +1562,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		break;
 
 	default:
-		FC_FCP_DBG(fsp, "REC %p fid %x error unexpected error %d\n",
+		FC_FCP_DBG(fsp, "REC %p fid %6.6x error unexpected error %d\n",
 			   fsp, fsp->rport->port_id, error);
 		fsp->status_code = FC_CMD_PLOGO;
 		/* fall through */
@@ -1572,7 +1572,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		 * Assume REC or LS_ACC was lost.
 		 * The exchange manager will have aborted REC, so retry.
 		 */
-		FC_FCP_DBG(fsp, "REC fid %x error error %d retry %d/%d\n",
+		FC_FCP_DBG(fsp, "REC fid %6.6x error error %d retry %d/%d\n",
 			   fsp->rport->port_id, error, fsp->recov_retry,
 			   FC_MAX_RECOV_RETRY);
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
@@ -2053,7 +2053,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	if (lport->state != LPORT_ST_READY)
 		return rc;
 
-	FC_SCSI_DBG(lport, "Resetting rport (%6x)\n", rport->port_id);
+	FC_SCSI_DBG(lport, "Resetting rport (%6.6x)\n", rport->port_id);
 
 	fsp = fc_fcp_pkt_alloc(lport, GFP_NOIO);
 	if (fsp == NULL) {
@@ -2101,11 +2101,11 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 	if (fc_fcp_lport_queue_ready(lport)) {
 		shost_printk(KERN_INFO, shost, "libfc: Host reset succeeded "
-			     "on port (%6x)\n", fc_host_port_id(lport->host));
+			     "on port (%6.6x)\n", fc_host_port_id(lport->host));
 		return SUCCESS;
 	} else {
 		shost_printk(KERN_INFO, shost, "libfc: Host reset failed, "
-			     "port (%6x) is not ready.\n",
+			     "port (%6.6x) is not ready.\n",
 			     fc_host_port_id(lport->host));
 		return FAILED;
 	}
@@ -2191,7 +2191,7 @@ void fc_fcp_destroy(struct fc_lport *lport)
 
 	if (!list_empty(&si->scsi_pkt_queue))
 		printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
-		       "port (%6x)\n", fc_host_port_id(lport->host));
+		       "port (%6.6x)\n", fc_host_port_id(lport->host));
 
 	mempool_destroy(si->scsi_pkt_pool);
 	kfree(si);
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index 741fd5c..efc6b3f 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -45,7 +45,7 @@ extern unsigned int fc_debug_logging;
 
 #define FC_LPORT_DBG(lport, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
-			 printk(KERN_INFO "host%u: lport %6x: " fmt,	\
+			 printk(KERN_INFO "host%u: lport %6.6x: " fmt,	\
 				(lport)->host->host_no,			\
 				fc_host_port_id((lport)->host), ##args))
 
@@ -57,7 +57,7 @@ extern unsigned int fc_debug_logging;
 
 #define FC_RPORT_ID_DBG(lport, port_id, fmt, args...)			\
 	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
-			 printk(KERN_INFO "host%u: rport %6x: " fmt,	\
+			 printk(KERN_INFO "host%u: rport %6.6x: " fmt,	\
 				(lport)->host->host_no,			\
 				(port_id), ##args))
 
@@ -66,7 +66,7 @@ extern unsigned int fc_debug_logging;
 
 #define FC_FCP_DBG(pkt, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
-			 printk(KERN_INFO "host%u: fcp: %6x: " fmt,	\
+			 printk(KERN_INFO "host%u: fcp: %6.6x: " fmt,	\
 				(pkt)->lp->host->host_no,		\
 				pkt->rport->port_id, ##args))
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a6cf94d..e89bdd5 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -172,7 +172,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				    struct fc_rport_priv *rdata,
 				    enum fc_rport_event event)
 {
-	FC_LPORT_DBG(lport, "Received a %d event for port (%6x)\n", event,
+	FC_LPORT_DBG(lport, "Received a %d event for port (%6.6x)\n", event,
 		     rdata->ids.port_id);
 
 	mutex_lock(&lport->lp_mutex);
@@ -183,7 +183,7 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 			fc_lport_enter_ns(lport, LPORT_ST_RNN_ID);
 		} else {
 			FC_LPORT_DBG(lport, "Received an READY event "
-				     "on port (%6x) for the directory "
+				     "on port (%6.6x) for the directory "
 				     "server, but the lport is not "
 				     "in the DNS state, it's in the "
 				     "%d state", rdata->ids.port_id,
@@ -575,7 +575,7 @@ void __fc_linkup(struct fc_lport *lport)
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link up on port (%6x)\n",
+	printk(KERN_INFO "host%d: libfc: Link up on port (%6.6x)\n",
 	       lport->host->host_no, fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
@@ -605,7 +605,7 @@ void __fc_linkdown(struct fc_lport *lport)
  */
 void fc_linkdown(struct fc_lport *lport)
 {
-	printk(KERN_INFO "host%d: libfc: Link down on port (%6x)\n",
+	printk(KERN_INFO "host%d: libfc: Link down on port (%6.6x)\n",
 	       lport->host->host_no, fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
@@ -707,7 +707,7 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 		break;
 	case DISC_EV_FAILED:
 		printk(KERN_ERR "host%d: libfc: "
-		       "Discovery failed for port (%6x)\n",
+		       "Discovery failed for port (%6.6x)\n",
 		       lport->host->host_no, fc_host_port_id(lport->host));
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
@@ -753,7 +753,7 @@ static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
 				 struct fc_frame *fp)
 {
 	if (port_id)
-		printk(KERN_INFO "host%d: Assigned Port ID %6x\n",
+		printk(KERN_INFO "host%d: Assigned Port ID %6.6x\n",
 		       lport->host->host_no, port_id);
 
 	fc_host_port_id(lport->host) = port_id;
@@ -1499,7 +1499,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				lport->r_a_tov = 2 * e_d_tov;
 				fc_lport_set_port_id(lport, did, fp);
 				printk(KERN_INFO "host%d: libfc: "
-				       "Port (%6x) entered "
+				       "Port (%6.6x) entered "
 				       "point-to-point mode\n",
 				       lport->host->host_no, did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),

