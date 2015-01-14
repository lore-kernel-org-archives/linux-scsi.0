From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 14/48] hpsa: refactor hpsa_find_board_params() to
 encapsulate legacy test
Date: Wed, 14 Jan 2015 16:00:50 -0600
Message-ID: <20150114220050.21325.16517.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:18398 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbbANWBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:01:36 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Encapsulate the conditional predicate which tests for legacy controllers
in a separate function and rework the code comments.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ec2503a..08d96a9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3107,7 +3107,8 @@ out:
 	kfree(logdev_list);
 }
 
-/* hpsa_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
+/*
+ * hpsa_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
  * dma mapping  and fills in the scatter gather entries of the
  * hpsa command, cp.
  */
@@ -3165,7 +3166,7 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 sglist_finished:
 
 	cp->Header.SGList = (u8) use_sg;   /* no. SGs contig in this cmd */
-	cp->Header.SGTotal = cpu_to_le16(use_sg); /* total sgs in this cmd list */
+	cp->Header.SGTotal = cpu_to_le16(use_sg); /* total sgs in cmd list */
 	return 0;
 }
 
@@ -6162,6 +6163,15 @@ static void hpsa_get_max_perf_mode_cmds(struct ctlr_info *h)
 	}
 }
 
+/* If the controller reports that the total max sg entries is greater than 512,
+ * then we know that chained SG blocks work.  (Original smart arrays did not
+ * support chained SG blocks and would return zero for max sg entries.)
+ */
+static int hpsa_supports_chained_sg_blocks(struct ctlr_info *h)
+{
+	return h->maxsgentries > 512;
+}
+
 /* Interrogate the hardware for some limits:
  * max commands, max SG elements without chaining, and with chaining,
  * SG chain block size, etc.
@@ -6172,18 +6182,20 @@ static void hpsa_find_board_params(struct ctlr_info *h)
 	h->nr_cmds = h->max_commands - 4; /* Allow room for some ioctls */
 	h->maxsgentries = readl(&(h->cfgtable->MaxScatterGatherElements));
 	h->fw_support = readl(&(h->cfgtable->misc_fw_support));
-	/*
-	 * Limit in-command s/g elements to 32 save dma'able memory.
-	 * Howvever spec says if 0, use 31
-	 */
-	h->max_cmd_sg_entries = 31;
-	if (h->maxsgentries > 512) {
+	if (hpsa_supports_chained_sg_blocks(h)) {
+		/* Limit in-command s/g elements to 32 save dma'able memory. */
 		h->max_cmd_sg_entries = 32;
 		h->chainsize = h->maxsgentries - h->max_cmd_sg_entries;
 		h->maxsgentries--; /* save one for chain pointer */
 	} else {
-		h->chainsize = 0;
+		/*
+		 * Original smart arrays supported at most 31 s/g entries
+		 * embedded inline in the command (trying to use more
+		 * would lock up the controller)
+		 */
+		h->max_cmd_sg_entries = 31;
 		h->maxsgentries = 31; /* default to traditional values */
+		h->chainsize = 0;
 	}
 
 	/* Find out what task management functions are supported and cache */

