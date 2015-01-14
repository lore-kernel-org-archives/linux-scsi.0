From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 19/48] hpsa: report allocation failures while allocating SG
 chain blocks
Date: Wed, 14 Jan 2015 16:01:17 -0600
Message-ID: <20150114220117.21325.98453.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55243 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbbANWCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:02:05 -0500
Received: from g5t1627.atlanta.hp.com (g5t1627.atlanta.hp.com [15.192.137.10])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 575A4524A
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:02:05 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 64d17d1..dc328ce 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1480,13 +1480,17 @@ static int hpsa_allocate_sg_chain_blocks(struct ctlr_info *h)
 
 	h->cmd_sg_list = kzalloc(sizeof(*h->cmd_sg_list) * h->nr_cmds,
 				GFP_KERNEL);
-	if (!h->cmd_sg_list)
+	if (!h->cmd_sg_list) {
+		dev_err(&h->pdev->dev, "Failed to allocate SG list\n");
 		return -ENOMEM;
+	}
 	for (i = 0; i < h->nr_cmds; i++) {
 		h->cmd_sg_list[i] = kmalloc(sizeof(*h->cmd_sg_list[i]) *
 						h->chainsize, GFP_KERNEL);
-		if (!h->cmd_sg_list[i])
+		if (!h->cmd_sg_list[i]) {
+			dev_err(&h->pdev->dev, "Failed to allocate cmd SG\n");
 			goto clean;
+		}
 	}
 	return 0;
 

