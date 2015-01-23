From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 35/48] hpsa: do not ack controller events on controllers
 that do not support it
Date: Fri, 23 Jan 2015 16:44:07 -0600
Message-ID: <20150123224407.14919.22079.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43556 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbAWWpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:45:03 -0500
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 463D161A00
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2015 22:45:03 +0000 (UTC)
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
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

