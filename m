From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 3/4] libfc: adds  FCP failures stats
Date: Fri, 25 May 2012 10:26:48 -0700
Message-ID: <20120525172648.6980.98620.stgit@localhost6.localdomain6>
References: <20120525172638.6980.40338.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20151 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab2EYRm2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 13:42:28 -0400
In-Reply-To: <20120525172638.6980.40338.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, devel@open-fcoe.org

Adds stats to track FCP pkt and frame alloc
failure.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Acked-by : Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    8 ++++++++
 include/scsi/libfc.h        |    6 ++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5c4c504..3c96e93 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -158,6 +158,9 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
 		fsp->timer.data = (unsigned long)fsp;
 		INIT_LIST_HEAD(&fsp->list);
 		spin_lock_init(&fsp->scsi_pkt_lock);
+	} else {
+		per_cpu_ptr(lport->stats, get_cpu())->FcpPktAllocFails++;
+		put_cpu();
 	}
 	return fsp;
 }
@@ -264,6 +267,9 @@ static int fc_fcp_send_abort(struct fc_fcp_pkt *fsp)
 	if (!fsp->seq_ptr)
 		return -EINVAL;
 
+	per_cpu_ptr(fsp->lp->stats, get_cpu())->FcpPktAborts++;
+	put_cpu();
+
 	fsp->state |= FC_SRB_ABORT_PENDING;
 	return fsp->lp->tt.seq_exch_abort(fsp->seq_ptr, 0);
 }
@@ -420,6 +426,8 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 	if (likely(fp))
 		return fp;
 
+	per_cpu_ptr(lport->stats, get_cpu())->FcpFrameAllocFails++;
+	put_cpu();
 	/* error case */
 	fc_fcp_can_queue_ramp_down(lport);
 	return NULL;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index ea52ca2..f257a74 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -232,6 +232,9 @@ struct fc_rport_priv {
  * @RxWords:               Number of received words
  * @ErrorFrames:           Number of received error frames
  * @DumpedFrames:          Number of dumped frames
+ * @FcpPktAllocFails:      Number of fcp packet allocation failures
+ * @FcpPktAborts:          Number of fcp packet aborts
+ * @FcpFrameAllocFails:    Number of fcp frame allocation failures
  * @LinkFailureCount:      Number of link failures
  * @LossOfSignalCount:     Number for signal losses
  * @InvalidTxWordCount:    Number of invalid transmitted words
@@ -252,6 +255,9 @@ struct fc_stats {
 	u64		RxWords;
 	u64		ErrorFrames;
 	u64		DumpedFrames;
+	u64		FcpPktAllocFails;
+	u64		FcpPktAborts;
+	u64		FcpFrameAllocFails;
 	u64		LinkFailureCount;
 	u64		LossOfSignalCount;
 	u64		InvalidTxWordCount;

