From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/22] libfc: Remove the FC_EM_DBG macro
Date: Wed, 29 Jul 2009 17:05:05 -0700
Message-ID: <20090730000505.24658.35834.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbZG3AFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:05:04 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Currently there is a 1:1 relationship between the lport
and exchange manager. This macro takes an EM as an argument
and determines the lport from it. However, later patches
will use an EM list per lport, so we will no longer have
this 1:1 relationship- this macro must change.

The FC_EM_DBG macro is rarely used. There are four callers,
two can use FC_LPORT_DBG instead and two can be removed
since they're not necessary. This patch makes those changes
and removes the macro.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_exch.c |   13 ++++++-------
 include/scsi/libfc.h         |    6 ------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index f1fa2b1..3ad7f88 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1129,7 +1129,7 @@ static void fc_exch_recv_req(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			lp->tt.lport_recv(lp, sp, fp);
 		fc_exch_release(ep);	/* release from lookup */
 	} else {
-		FC_EM_DBG(mp, "exch/seq lookup failed: reject %x\n", reject);
+		FC_LPORT_DBG(lp, "exch/seq lookup failed: reject %x\n", reject);
 		fc_frame_free(fp);
 	}
 }
@@ -1235,13 +1235,12 @@ static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	struct fc_seq *sp;
 
 	sp = fc_seq_lookup_orig(mp, fp);	/* doesn't hold sequence */
-	if (!sp) {
+
+	if (!sp)
 		atomic_inc(&mp->stats.xid_not_found);
-		FC_EM_DBG(mp, "seq lookup failed\n");
-	} else {
+	else
 		atomic_inc(&mp->stats.non_bls_resp);
-		FC_EM_DBG(mp, "non-BLS response to sequence");
-	}
+
 	fc_frame_free(fp);
 }
 
@@ -1950,7 +1949,7 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			fc_exch_recv_req(lp, mp, fp);
 		break;
 	default:
-		FC_EM_DBG(mp, "dropping invalid frame (eof %x)", fr_eof(fp));
+		FC_LPORT_DBG(lp, "dropping invalid frame (eof %x)", fr_eof(fp));
 		fc_frame_free(fp);
 		break;
 	}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index b381b1c..f1bde91 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -88,12 +88,6 @@ do {									\
 				(pkt)->lp->host->host_no,		\
 				pkt->rport->port_id, ##args))
 
-#define FC_EM_DBG(em, fmt, args...)					\
-	FC_CHECK_LOGGING(FC_EM_LOGGING,					\
-			 printk(KERN_INFO "host%u: em: " fmt,		\
-				(em)->lp->host->host_no,		\
-				##args))
-
 #define FC_EXCH_DBG(exch, fmt, args...)					\
 	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
 			 printk(KERN_INFO "host%u: xid %4x: " fmt,	\

