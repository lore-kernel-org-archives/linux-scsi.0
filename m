From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 43/48] hpsa: move SG descriptor set-up out of
 hpsa_scatter_gather()
Date: Wed, 14 Jan 2015 16:03:25 -0600
Message-ID: <20150114220324.21325.5807.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:59463 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbbANWEL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:04:11 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Webb Scales <webbnh@hp.com>

Move the code which sets up the SG descriptor out of hpsa_scatter_gather()
and into a subroutine where it can be reused (in the next patch).  The Ext
field is now assigned unconditionally: this makes the refactor much simpler,
but more importantly it removes a conditional operation from inside the
loop.  The case for which the conditional formerly tested is now executed
(unconditionally) after the loop is exited.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a23277d..7915dc4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3236,6 +3236,17 @@ out:
 	kfree(id_phys);
 }
 
+static void hpsa_set_sg_descriptor(struct SGDescriptor *desc,
+				   struct scatterlist *sg)
+{
+	u64 addr64 = (u64) sg_dma_address(sg);
+	unsigned int len = sg_dma_len(sg);
+
+	desc->Addr = cpu_to_le64(addr64);
+	desc->Len = cpu_to_le32(len);
+	desc->Ext = 0;
+}
+
 /*
  * hpsa_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
  * dma mapping  and fills in the scatter gather entries of the
@@ -3245,9 +3256,7 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 		struct CommandList *cp,
 		struct scsi_cmnd *cmd)
 {
-	unsigned int len;
 	struct scatterlist *sg;
-	u64 addr64;
 	int use_sg, i, sg_index, chained;
 	struct SGDescriptor *curr_sg;
 
@@ -3270,13 +3279,11 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 			curr_sg = h->cmd_sg_list[cp->cmdindex];
 			sg_index = 0;
 		}
-		addr64 = (u64) sg_dma_address(sg);
-		len  = sg_dma_len(sg);
-		curr_sg->Addr = cpu_to_le64(addr64);
-		curr_sg->Len = cpu_to_le32(len);
-		curr_sg->Ext = cpu_to_le32(0);
+		hpsa_set_sg_descriptor(curr_sg, sg);
 		curr_sg++;
 	}
+
+	/* Back the pointer up to the last entry and mark it as "last". */
 	(--curr_sg)->Ext = cpu_to_le32(HPSA_SG_LAST);
 
 	if (use_sg + chained > h->maxSG)

