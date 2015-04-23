From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 11/42] hpsa: try resubmitting down raid path on task set
 full
Date: Thu, 23 Apr 2015 09:32:43 -0500
Message-ID: <20150423143243.18832.66551.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:45461 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965008AbbDWOdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:33:50 -0400
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

allow the controller firmware to queue up commands when the ioaccel device
queue is full.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6f88756..b6eafe4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1820,8 +1820,7 @@ static int handle_ioaccel_mode2_error(struct ctlr_info *h,
 			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_SET_FULL:
-			/* Make scsi midlayer do unlimited retries */
-			cmd->result = DID_IMM_RETRY << 16;
+			retry = 1;
 			break;
 		case IOACCEL2_STATUS_SR_TASK_COMP_ABORTED:
 			dev_warn(&h->pdev->dev,

