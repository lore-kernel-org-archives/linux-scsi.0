From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 05/43] hpsa: decrement h->commands_outstanding in
 fail_all_outstanding_cmds
Date: Thu, 16 Apr 2015 08:47:09 -0500
Message-ID: <20150416134709.30238.38976.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:49114 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbbDPNsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:48:10 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
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
 drivers/scsi/hpsa.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2ac700b..6ee92af 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6918,6 +6918,7 @@ static void fail_all_outstanding_cmds(struct ctlr_info *h)
 		if (refcount > 1) {
 			c->err_info->CommandStatus = CMD_CTLR_LOCKUP;
 			finish_cmd(c);
+			atomic_dec(&h->commands_outstanding);
 			failcount++;
 		}
 		cmd_free(h, c);

