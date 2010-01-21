From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/5] libfc: Fix e_d_tov ns -> ms scaling factor in PLOGI
	response.
Date: Thu, 21 Jan 2010 10:15:49 -0800
Message-ID: <20100121181549.16741.12028.stgit@localhost.localdomain>
References: <20100121181538.16741.33676.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3123 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab0AUSPu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jan 2010 13:15:50 -0500
In-Reply-To: <20100121181538.16741.33676.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hugh Daschbach <hdasch@broadcom.com>, Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Hugh Daschbach <hdasch@broadcom.com>

Both PLOGI and RTV response processing conditionally scale e_d_tov,
but use different scaling factors.  The scaling factor is correct in
RTV response processing.  Bring PLOGI e_d_tov scaling in line with RTV
common service parameter inspection.

Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
Acked-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_rport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 0230052..97923bb 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -623,7 +623,7 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 		tov = ntohl(plp->fl_csp.sp_e_d_tov);
 		if (ntohs(plp->fl_csp.sp_features) & FC_SP_FT_EDTR)
-			tov /= 1000;
+			tov /= 1000000;
 		if (tov > rdata->e_d_tov)
 			rdata->e_d_tov = tov;
 		csp_seq = ntohs(plp->fl_csp.sp_tot_seq);

