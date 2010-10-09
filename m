From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/8] libfc: adds flogi retry in case DID is zero in RJT
Date: Fri, 08 Oct 2010 17:12:20 -0700
Message-ID: <20101009001220.7744.39944.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53792 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAMV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:21 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Sometimes switch in NPV mode rejects flogi request with DID
zero and in that case flogi is not tried again and port
remains offline, so this patch validates DID for non zero
along with only ACC response to allow flogi retry
for RJT with DID=0 also succeed FLOGI in next try.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_lport.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index d9b6e11..9be63ed 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1447,13 +1447,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 
 	did = fc_frame_did(fp);
-
-	if (!did) {
-		FC_LPORT_DBG(lport, "Bad FLOGI response\n");
-		goto out;
-	}
-
-	if (fc_frame_payload_op(fp) == ELS_LS_ACC) {
+	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did) {
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
 		if (flp) {
 			mfs = ntohs(flp->fl_csp.sp_bb_data) &
@@ -1492,8 +1486,10 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				fc_lport_enter_dns(lport);
 			}
 		}
-	} else
+	} else {
+		FC_LPORT_DBG(lport, "FLOGI RJT or bad response\n");
 		fc_lport_error(lport, fp);
+	}
 
 out:
 	fc_frame_free(fp);

