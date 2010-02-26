From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 5/9] cciss: fix scatter gather chain block dma direction kludge
Date: Fri, 26 Feb 2010 16:01:32 -0600
Message-ID: <20100226220132.11979.3861.stgit@beardog.cce.hp.com>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: fix scatter gather chain block dma direction kludge
The data direction for the chained block of scatter gather
elements should always be PCI_DMA_TODEVICE, but was mistakenly
set to the direction of the data transfer, then a kludge to
fix it was added, in which pci_dma_sync_single_for_device or
pci_dma_sync_single_for_cpu was called.  If the correct direction
is used in the first place, the kludge isn't needed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index adc517c..c0d794c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1717,10 +1717,8 @@ static void cciss_softirq_done(struct request *rq)
 		if (curr_sg[sg_index].Ext == CCISS_SG_CHAIN) {
 			temp64.val32.lower = cmd->SG[i].Addr.lower;
 			temp64.val32.upper = cmd->SG[i].Addr.upper;
-			pci_dma_sync_single_for_cpu(h->pdev, temp64.val,
-						cmd->SG[i].Len, ddir);
 			pci_unmap_single(h->pdev, temp64.val,
-						cmd->SG[i].Len, ddir);
+				cmd->SG[i].Len, PCI_DMA_TODEVICE);
 			/* Point to the next block */
 			curr_sg = h->cmd_sg_list[cmd->cmdindex];
 			sg_index = 0;
@@ -3223,11 +3221,11 @@ static void do_cciss_request(struct request_queue *q)
 		 * block with address of next chain block.
 		 */
 		temp64.val = pci_map_single(h->pdev,
-					h->cmd_sg_list[c->cmdindex], len, dir);
+					h->cmd_sg_list[c->cmdindex], len,
+					PCI_DMA_TODEVICE);
 		dma_addr = temp64.val;
 		curr_sg[sg_index].Addr.lower = temp64.val32.lower;
 		curr_sg[sg_index].Addr.upper = temp64.val32.upper;
-		pci_dma_sync_single_for_device(h->pdev, dma_addr, len, dir);
 	}
 
 	/* track how many SG entries we are using */
