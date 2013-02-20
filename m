From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/5] hpsa: check for dma_mapping_error in
	hpsa_map_sg_chain_block
Date: Wed, 20 Feb 2013 11:24:46 -0600
Message-ID: <20130220172446.12929.56695.stgit@beardog.cce.hp.com>
References: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:46193 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874Ab3BTQYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2013 11:24:50 -0500
In-Reply-To: <20130220172243.12929.69579.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, shuah.khan@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 137ed33..38c8aa5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1131,7 +1131,7 @@ clean:
 	return -ENOMEM;
 }
 
-static void hpsa_map_sg_chain_block(struct ctlr_info *h,
+static int hpsa_map_sg_chain_block(struct ctlr_info *h,
 	struct CommandList *c)
 {
 	struct SGDescriptor *chain_sg, *chain_block;
@@ -1144,8 +1144,15 @@ static void hpsa_map_sg_chain_block(struct ctlr_info *h,
 		(c->Header.SGTotal - h->max_cmd_sg_entries);
 	temp64 = pci_map_single(h->pdev, chain_block, chain_sg->Len,
 				PCI_DMA_TODEVICE);
+	if (dma_mapping_error(&h->pdev->dev, temp64)) {
+		/* prevent subsequent unmapping */
+		chain_sg->Addr.lower = 0;
+		chain_sg->Addr.upper = 0;
+		return -1;
+	}
 	chain_sg->Addr.lower = (u32) (temp64 & 0x0FFFFFFFFULL);
 	chain_sg->Addr.upper = (u32) ((temp64 >> 32) & 0x0FFFFFFFFULL);
+	return 0;
 }
 
 static void hpsa_unmap_sg_chain_block(struct ctlr_info *h,
@@ -2123,7 +2130,10 @@ static int hpsa_scatter_gather(struct ctlr_info *h,
 	if (chained) {
 		cp->Header.SGList = h->max_cmd_sg_entries;
 		cp->Header.SGTotal = (u16) (use_sg + 1);
-		hpsa_map_sg_chain_block(h, cp);
+		if (hpsa_map_sg_chain_block(h, cp)) {
+			scsi_dma_unmap(cmd);
+			return -1;
+		}
 		return 0;
 	}
 

