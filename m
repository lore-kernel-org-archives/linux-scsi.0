From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 21/48] hpsa: avoid unneccesary calls to resource freeing
 functions
Date: Fri, 23 Jan 2015 16:42:54 -0600
Message-ID: <20150123224253.14919.53972.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:49064 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbAWWnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:43:49 -0500
Received: from g6t1526.atlanta.hp.com (g6t1526.atlanta.hp.com [15.193.200.69])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id A436D991
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2015 22:43:48 +0000 (UTC)
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

If hpsa_allocate_cmd_pool failed, we were calling two functions unnecessarily:

  hpsa_free_sg_chain_blocks(h);
  hpsa_free_cmd_pool(h);

This didn't cause any problem, as those functions can tolerate being called
when what they free hasn't been allocated (relevant pointers would be NULL)
but it is potentially confusing.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a66a50e..bee24b2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6948,8 +6948,9 @@ reinit_after_soft_reset:
 	dev_info(&pdev->dev, "%s: <0x%x> at IRQ %d%s using DAC\n",
 	       h->devname, pdev->device,
 	       h->intr[h->intr_mode], dac ? "" : " not");
-	if (hpsa_allocate_cmd_pool(h))
-		goto clean4;
+	rc = hpsa_allocate_cmd_pool(h);
+	if (rc)
+		goto clean2_and_free_irqs;
 	if (hpsa_allocate_sg_chain_blocks(h))
 		goto clean4;
 	init_waitqueue_head(&h->scan_wait_queue);
@@ -7038,6 +7039,7 @@ reinit_after_soft_reset:
 clean4:
 	hpsa_free_sg_chain_blocks(h);
 	hpsa_free_cmd_pool(h);
+clean2_and_free_irqs:
 	hpsa_free_irqs(h);
 clean2:
 clean1:

