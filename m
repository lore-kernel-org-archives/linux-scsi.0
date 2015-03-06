From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 30/41] hpsa: performance tweak for hpsa_scatter_gather()
Date: Fri, 06 Mar 2015 17:48:25 -0600
Message-ID: <20150306234825.29973.3340.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:37726 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbbCFXtz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:49:55 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Divide the loop in hpsa_scatter_gather() into two, one for the initial SG list
and a second one for the chained list, if any.  This allows the conditional
check which resets the indicies for the chained list to be performed outside
the loop instead of being done on every iteration inside the loop.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b91fe35..c2b2c42 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3712,7 +3712,7 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 		struct scsi_cmnd *cmd)
 {
 	struct scatterlist *sg;
-	int use_sg, i, sg_index, chained;
+	int use_sg, i, sg_limit, chained, last_sg;
 	struct SGDescriptor *curr_sg;
 
 	BUG_ON(scsi_sg_count(cmd) > h->maxsgentries);
@@ -3724,22 +3724,39 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 	if (!use_sg)
 		goto sglist_finished;
 
+	/*
+	 * If the number of entries is greater than the max for a single list,
+	 * then we have a chained list; we will set up all but one entry in the
+	 * first list (the last entry is saved for link information);
+	 * otherwise, we don't have a chained list and we'll set up at each of
+	 * the entries in the one list.
+	 */
 	curr_sg = cp->SG;
-	chained = 0;
-	sg_index = 0;
-	scsi_for_each_sg(cmd, sg, use_sg, i) {
-		if (i == h->max_cmd_sg_entries - 1 &&
-			use_sg > h->max_cmd_sg_entries) {
-			chained = 1;
-			curr_sg = h->cmd_sg_list[cp->cmdindex];
-			sg_index = 0;
-		}
+	chained = use_sg > h->max_cmd_sg_entries;
+	sg_limit = chained ? h->max_cmd_sg_entries - 1 : use_sg;
+	last_sg = scsi_sg_count(cmd) - 1;
+	scsi_for_each_sg(cmd, sg, sg_limit, i) {
 		hpsa_set_sg_descriptor(curr_sg, sg);
 		curr_sg++;
 	}
 
+	if (chained) {
+		/*
+		 * Continue with the chained list.  Set curr_sg to the chained
+		 * list.  Modify the limit to the total count less the entries
+		 * we've already set up.  Resume the scan at the list entry
+		 * where the previous loop left off.
+		 */
+		curr_sg = h->cmd_sg_list[cp->cmdindex];
+		sg_limit = use_sg - sg_limit;
+		for_each_sg(sg, sg, sg_limit, i) {
+			hpsa_set_sg_descriptor(curr_sg, sg);
+			curr_sg++;
+		}
+	}
+
 	/* Back the pointer up to the last entry and mark it as "last". */
-	(--curr_sg)->Ext = cpu_to_le32(HPSA_SG_LAST);
+	(curr_sg - 1)->Ext = cpu_to_le32(HPSA_SG_LAST);
 
 	if (use_sg + chained > h->maxSG)
 		h->maxSG = use_sg + chained;

