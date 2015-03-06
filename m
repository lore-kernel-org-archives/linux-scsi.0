From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 05/41] hpsa: decrement h->commands_outstanding in
 fail_all_outstanding_cmds
Date: Fri, 06 Mar 2015 17:46:14 -0600
Message-ID: <20150306234613.29973.54880.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:40627 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbbCFXrn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:47:43 -0500
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

make tracking of outstanding commands more robust

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ca3a860..7ff59b7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6948,7 +6948,7 @@ static void fail_all_outstanding_cmds(struct ctlr_info *h)
 		if (refcount > 1) {
 			c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
 			finish_cmd(c);
-			failcount++;
+			atomic_dec(&h->commands_outstanding);
 		}
 		cmd_free(h, c);
 	}

