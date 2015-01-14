From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 20/48] hpsa: fix memory leak in hpsa_alloc_cmd_pool
Date: Wed, 14 Jan 2015 16:01:22 -0600
Message-ID: <20150114220122.21325.31194.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55247 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbbANWCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:02:10 -0500
Received: from g6t1525.atlanta.hp.com (g6t1525.atlanta.hp.com [15.193.200.68])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 563D3524A
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:02:10 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Partial allocation failure wasn't handled correctly

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index dc328ce..a66a50e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -211,6 +211,7 @@ static struct CommandList *cmd_special_alloc(struct ctlr_info *h);
 static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, u16 page_code, unsigned char *scsi3addr,
 	int cmd_type);
+static void hpsa_free_cmd_pool(struct ctlr_info *h);
 #define VPD_PAGE (1 << 8)
 
 static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
@@ -6471,9 +6472,12 @@ static int hpsa_allocate_cmd_pool(struct ctlr_info *h)
 	    || (h->cmd_pool == NULL)
 	    || (h->errinfo_pool == NULL)) {
 		dev_err(&h->pdev->dev, "out of memory in %s", __func__);
-		return -ENOMEM;
+		goto clean_up;
 	}
 	return 0;
+clean_up:
+	hpsa_free_cmd_pool(h);
+	return -ENOMEM;
 }
 
 static void hpsa_free_cmd_pool(struct ctlr_info *h)

