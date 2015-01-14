From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 36/48] hpsa: do not ack controller events on controllers
 that do not support it
Date: Wed, 14 Jan 2015 16:02:48 -0600
Message-ID: <20150114220248.21325.81694.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:19400 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbANWDf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:03:35 -0500
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

Acking controller events on controllers that do not support
it can cause such controllers to lock up.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5abd49d..afd192d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6674,6 +6674,9 @@ static void hpsa_ack_ctlr_events(struct ctlr_info *h)
 	int i;
 	char *event_type;
 
+	if (!(h->fw_support & MISC_FW_EVENT_NOTIFY))
+		return;
+
 	/* Ask the controller to clear the events we're handling. */
 	if ((h->transMethod & (CFGTBL_Trans_io_accel1
 			| CFGTBL_Trans_io_accel2)) &&

