From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 03/11] hpsa: correct static checker warnings on driver init
 cleanup
Date: Sat, 18 Jul 2015 11:12:33 -0500
Message-ID: <20150718161233.31955.63909.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:34801 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbbGRQOu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:14:50 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e9b2073..6b083af 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8053,7 +8053,7 @@ reinit_after_soft_reset:
 		rc = hpsa_kdump_soft_reset(h);
 		if (rc)
 			/* Neither hard nor soft reset worked, we're hosed. */
-			goto clean9;
+			goto clean7;
 
 		dev_info(&h->pdev->dev, "Board READY.\n");
 		dev_info(&h->pdev->dev,
@@ -8099,8 +8099,6 @@ reinit_after_soft_reset:
 				h->heartbeat_sample_interval);
 	return 0;
 
-clean9: /* wq, sh, perf, sg, cmd, irq, shost, pci, lu, aer/h */
-	kfree(h->hba_inquiry_data);
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);

