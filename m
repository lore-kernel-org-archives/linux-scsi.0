From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 33/48] hpsa: do not check for msi(x) in interrupt_pending
Date: Fri, 23 Jan 2015 16:43:56 -0600
Message-ID: <20150123224356.14919.46189.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:49096 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbAWWov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:44:51 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id BA1CA15C7
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2015 22:44:50 +0000 (UTC)
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

No need to check whether interrupt pending for MSI(X) and
conversely, no need to check whether MSI(X) interrupts are
being used when checking if interrupts are pending.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index aa6cb0b..239ecea 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -479,9 +479,6 @@ static bool SA5_performant_intr_pending(struct ctlr_info *h)
 	if (!register_value)
 		return false;
 
-	if (h->msi_vector || h->msix_vector)
-		return true;
-
 	/* Read outbound doorbell to flush */
 	register_value = readl(h->vaddr + SA5_OUTDB_STATUS);
 	return register_value & SA5_OUTDB_STATUS_PERF_BIT;

