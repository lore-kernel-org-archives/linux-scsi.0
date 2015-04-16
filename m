From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 11/43] hpsa: try resubmitting down raid path on task set
 full
Date: Thu, 16 Apr 2015 08:47:41 -0500
Message-ID: <20150416134741.30238.50426.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:44169 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbbDPNsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:48:47 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

allow the controller firmware to queue up commands when the ioaccel device
queue is full.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 292b8bd..9c184d1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1825,8 +1825,7 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL:
-			/* Make scsi midlayer do unlimited retries */
-			cmd->result = DID_IMM_RETRY << 16;
+			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_ABORTED:
 			dev_warn(&h->pdev->dev,

