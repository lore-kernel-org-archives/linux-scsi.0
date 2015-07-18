From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 01/11] hpsa: Correct double unlock of mutex
Date: Sat, 18 Jul 2015 11:12:22 -0500
Message-ID: <20150718161222.31955.95845.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:56140 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbbGRQOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:14:40 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1dafeb4..1d5f4fd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2749,11 +2749,10 @@ static int hpsa_do_reset(struct ctlr_info *h, struct hpsa_scsi_dev_t *dev,
 			lockup_detected(h));
 
 	if (unlikely(lockup_detected(h))) {
-			dev_warn(&h->pdev->dev,
-				 "Controller lockup detected during reset wait\n");
-			mutex_unlock(&h->reset_mutex);
-			rc = -ENODEV;
-		}
+		dev_warn(&h->pdev->dev,
+			 "Controller lockup detected during reset wait\n");
+		rc = -ENODEV;
+	}
 
 	if (unlikely(rc))
 		atomic_set(&dev->reset_cmds_out, 0);

