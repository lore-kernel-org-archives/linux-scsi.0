From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] libfcoe: Check for unusable FCFs before looking for
 conflicting FCFs
Date: Tue, 19 Feb 2013 13:02:52 -0800
Message-ID: <20130219210252.19021.71565.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64097 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933652Ab3BSVCy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 16:02:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

When there are multiple FCFs in the fabric, and one of them becomes
unavailable, the fabric name for the unavailable FCF becomes 0 along
with FIP_FL_AVAIL getting reset. In this case, FCF selection logic does
not select any FCF as it first checks for conflicting FCFs (since fabric
name is 0, it fails the condition), instead of first checking if it is
usable or not. Fix it by first checking if FCF is usable and skip that
FCF, and go to the next one in the list to check if it can be selected.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index aff3c44..7aca9fd 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1559,15 +1559,6 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 				fcf->fabric_name, fcf->vfid, fcf->fcf_mac,
 				fcf->fc_map, fcoe_ctlr_mtu_valid(fcf),
 				fcf->flogi_sent, fcf->pri);
-		if (fcf->fabric_name != first->fabric_name ||
-		    fcf->vfid != first->vfid ||
-		    fcf->fc_map != first->fc_map) {
-			LIBFCOE_FIP_DBG(fip, "Conflicting fabric, VFID, "
-					"or FC-MAP\n");
-			return NULL;
-		}
-		if (fcf->flogi_sent)
-			continue;
 		if (!fcoe_ctlr_fcf_usable(fcf)) {
 			LIBFCOE_FIP_DBG(fip, "FCF for fab %16.16llx "
 					"map %x %svalid %savailable\n",
@@ -1577,6 +1568,15 @@ static struct fcoe_fcf *fcoe_ctlr_select(struct fcoe_ctlr *fip)
 					"" : "un");
 			continue;
 		}
+		if (fcf->fabric_name != first->fabric_name ||
+		    fcf->vfid != first->vfid ||
+		    fcf->fc_map != first->fc_map) {
+			LIBFCOE_FIP_DBG(fip, "Conflicting fabric, VFID, "
+					"or FC-MAP\n");
+			return NULL;
+		}
+		if (fcf->flogi_sent)
+			continue;
 		if (!best || fcf->pri < best->pri || best->flogi_sent)
 			best = fcf;
 	}

