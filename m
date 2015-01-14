From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 18/48] hpsa: pass error from pci_set_consistent_dma_mask
 from hpsa_message
Date: Wed, 14 Jan 2015 16:01:11 -0600
Message-ID: <20150114220111.21325.2016.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55241 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbbANWB7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:01:59 -0500
Received: from g5t1627.atlanta.hp.com (g5t1627.atlanta.hp.com [15.192.137.10])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id E5C8F52BE
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:01:58 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
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

