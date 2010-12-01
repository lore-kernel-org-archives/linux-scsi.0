From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 22/27] libfcoe: fix checking of conflicting fabrics in
	fcoe_ctlr_select()
Date: Tue, 30 Nov 2010 16:19:51 -0800
Message-ID: <20101201001951.18369.1120.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26147 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0LAATw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:19:52 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

The check for conflicting fabrics in fcoe_ctlr_select()
ignores any FCFs that aren't usable.  This is a minor
problem now but becomes more pronounced after later patches.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 4d0be20..826c260 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -1361,12 +1361,22 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *best = NULL;
+	struct fcoe_fcf *first;
+
+	first = list_first_entry(&fip->fcfs, struct fcoe_fcf, list);
 
 	list_for_each_entry(fcf, &fip->fcfs, list) {
 		LIBFCOE_FIP_DBG(fip, "consider FCF for fab %16.16llx "
 				"VFID %d map %x val %d\n",
 				fcf->fabric_name, fcf->vfid,
 				fcf->fc_map, fcoe_ctlr_mtu_valid(fcf));
+		if (fcf->fabric_name != first->fabric_name ||
+		    fcf->vfid != first->vfid ||
+		    fcf->fc_map != first->fc_map) {
+			LIBFCOE_FIP_DBG(fip, "Conflicting fabric, VFID, "
+					"or FC-MAP\n");
+			return NULL;
+		}
 		if (!fcoe_ctlr_fcf_usable(fcf)) {
 			LIBFCOE_FIP_DBG(fip, "FCF for fab %16.16llx "
 					"map %x %svalid %savailable\n",
@@ -1380,13 +1390,6 @@ static void fcoe_ctlr_select(struct fcoe_ctlr *fip)
 			best = fcf;
 			continue;
 		}
-		if (fcf->fabric_name != best->fabric_name ||
-		    fcf->vfid != best->vfid ||
-		    fcf->fc_map != best->fc_map) {
-			LIBFCOE_FIP_DBG(fip, "Conflicting fabric, VFID, "
-					"or FC-MAP\n");
-			return;
-		}
 		if (fcf->pri < best->pri)
 			best = fcf;
 	}

