From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 18/48] hpsa: pass error from pci_set_consistent_dma_mask
 from hpsa_message
Date: Fri, 23 Jan 2015 16:42:37 -0600
Message-ID: <20150123224237.14919.66422.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34781 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbbAWWnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:43:31 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Return the actual error code instead of a generic error code.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f29f569..64d17d1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5610,7 +5610,7 @@ static int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (err) {
 		iounmap(vaddr);
-		return -ENOMEM;
+		return err;
 	}
 
 	cmd = pci_alloc_consistent(pdev, cmd_sz, &paddr64);

