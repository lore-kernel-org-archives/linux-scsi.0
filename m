From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/4] libfcoe: Fix Conflicting FCFs issue in the fabric
Date: Tue, 21 May 2013 10:44:33 -0700
Message-ID: <20130521174433.3033.92637.stgit@fritz>
References: <20130521174426.3033.16298.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab3EURog (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 May 2013 13:44:36 -0400
In-Reply-To: <20130521174426.3033.16298.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Krishna Mohan <krmohan@cisco.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Krishna Mohan <krmohan@cisco.com>

When multiple FCFs in use, and first FIP Advertisement received is
with "Available for Login" i.e A bit set to 0, FCF selection will fail.
The fix is to remove the assumption in the code that first FCF is only
allowed selectable FCF.
Consider the scenario fip->fcfs contains FCF1(fabricname X, marked A=0)
FCF2(fabricname Y, marked A=1). list_first_entry(first) points to FCF1
and 1st iteration we ignore the FCF and on 2nd iteration we compare
FCF1 & FCF2 fabric name and we fails to perform FCF selection.

Signed-off-by: Krishna Mohan <krmohan@cisco.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index a762472..4c77641 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1548,9 +1548,6 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *best = fip->sel_fcf;
-	struct fcoe_fcf *first;
-
-	first = list_first_entry(&fip->fcfs, struct fcoe_fcf, list);
 
 	list_for_each_entry(fcf, &fip->fcfs, list) {
 		LIBFCOE_FIP_DBG(fip, "consider FCF fab %16.16llx "
@@ -1568,17 +1565,15 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 					"" : "un");
 			continue;
 		}
-		if (fcf->fabric_name != first->fabric_name ||
-		    fcf->vfid != first->vfid ||
-		    fcf->fc_map != first->fc_map) {
+		if (!best || fcf->pri < best->pri || best->flogi_sent)
+			best = fcf;
+		if (fcf->fabric_name != best->fabric_name ||
+		    fcf->vfid != best->vfid ||
+		    fcf->fc_map != best->fc_map) {
 			LIBFCOE_FIP_DBG(fip, "Conflicting fabric, VFID, "
 					"or FC-MAP\n");
 			return NULL;
 		}
-		if (fcf->flogi_sent)
-			continue;
-		if (!best || fcf->pri < best->pri || best->flogi_sent)
-			best = fcf;
 	}
 	fip->sel_fcf = best;
 	if (best) {

