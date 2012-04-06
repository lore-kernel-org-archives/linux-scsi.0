From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] libfc: update mfs boundry checking
Date: Fri, 06 Apr 2012 15:52:51 -0700
Message-ID: <20120406225251.4950.87097.stgit@localhost6.localdomain6>
References: <20120406225246.4950.80747.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63263 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2DFWww (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 18:52:52 -0400
In-Reply-To: <20120406225246.4950.80747.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

A previous commit changed the mfs checking to ensure the new
mfs is less or equal to the mfs supported by the FCF. This
doesn't work for BRDCM cards as they set an mfs of 2048 regardless
of whether the switch returns a larger mfs.

This patch validates the new mfs against the upper and lower spec
defined boundries for a FCoE mfs.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ef9560d..cc83b66 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1742,17 +1742,19 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mfs = ntohs(flp->fl_csp.sp_bb_data) &
 		FC_SP_BB_DATA_MASK;
-	if (mfs >= FC_SP_MIN_MAX_PAYLOAD &&
-	    mfs <= lport->mfs) {
-		lport->mfs = mfs;
-		fc_host_maxframe_size(lport->host) = mfs;
-	} else {
+
+	if (mfs < FC_SP_MIN_MAX_PAYLOAD || mfs > FC_SP_MAX_MAX_PAYLOAD) {
 		FC_LPORT_DBG(lport, "FLOGI bad mfs:%hu response, "
 			     "lport->mfs:%hu\n", mfs, lport->mfs);
 		fc_lport_error(lport, fp);
 		goto err;
 	}
 
+	if (mfs <= lport->mfs) {
+		lport->mfs = mfs;
+		fc_host_maxframe_size(lport->host) = mfs;
+	}
+
 	csp_flags = ntohs(flp->fl_csp.sp_features);
 	r_a_tov = ntohl(flp->fl_csp.sp_r_a_tov);
 	e_d_tov = ntohl(flp->fl_csp.sp_e_d_tov);

