From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH] hpsa: correct compiler warnings introduced by
 hpsa-add-local-workqueue patch
Date: Fri, 06 Feb 2015 17:44:15 -0600
Message-ID: <20150206234415.23960.78547.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:39414 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbbBFXpW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 18:45:22 -0500
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 545867C5B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Feb 2015 23:45:22 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: keescook@chromium.org, linux-scsi@vger.kernel.org

Correct compiler warning introduced by hpsa-add-local-workqueue patch
6636e7f455b33b957c5ee016daa6de46148026ab hpsa: Use local workqueues
instead of system workqueues

Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 95d581c..a1cfbd3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6831,10 +6831,8 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
 						char *name)
 {
 	struct workqueue_struct *wq = NULL;
-	char wq_name[20];
 
-	snprintf(wq_name, sizeof(wq_name), "%s_%d_hpsa", name, h->ctlr);
-	wq = alloc_ordered_workqueue(wq_name, 0);
+	wq = alloc_ordered_workqueue("%s_%d_hpsa", 0, name, h->ctlr);
 	if (!wq)
 		dev_err(&h->pdev->dev, "failed to create %s workqueue\n", name);
 

