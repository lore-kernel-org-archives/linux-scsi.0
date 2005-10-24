From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 10/9] ibmmca bug fix
Date: Mon, 24 Oct 2005 18:30:53 -0400
Message-ID: <20051024223053.GA12260@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:14480 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751361AbVJXWa4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:30:56 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 4E2851C011DA
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:30:53 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OMUrOi012332
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:30:53 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


As one would expect, this lives in scsilun-2.6#submit10 branch.


commit bde81cf4dbc63b9fdf38ec30405dbd70bfba23b5
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 18:26:11 2005 -0400

    [SCSI] revert ibmmca change that snuck in
    
    Work from another branch snuck into this one.  Revert.

 drivers/scsi/ibmmca.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

bde81cf4dbc63b9fdf38ec30405dbd70bfba23b5
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index d5e9370..887a5c3 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -673,9 +673,8 @@ static irqreturn_t interrupt_handler(int
 	ld(ihost_index)[ldn].cmd = NULL;
 #ifdef IM_DEBUG_TIMEOUT
 	if (cmd) {
-		if ((cmd->target == TIMEOUT_PUN) && (scsilun_to_int(&cmd->device->lun) == TIMEOUT_LUN)) {
-			scmd_printk(KERN_INFO, cmd,
-				"IBM MCA SCSI: Ignoring interrupt\n");
+		if ((cmd->target == TIMEOUT_PUN) && (cmd->device->lun == TIMEOUT_LUN)) {
+			printk("IBM MCA SCSI: Ignoring interrupt from pun=%x, lun=%x.\n", cmd->target, cmd->device->lun);
 			return IRQ_HANDLED;
 		}
 	}
