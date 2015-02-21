From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 10/43] hpsa: do not ignore return value of hpsa_register_scsi
Date: Sat, 21 Feb 2015 16:18:26 -0600
Message-ID: <20150221221826.21954.84017.stgit@brunhilda>
References: <20150221221553.21954.32599.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:55775 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbbBUWTp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2015 17:19:45 -0500
Received: from g6t1524.atlanta.hp.com (g6t1524.atlanta.hp.com [15.193.200.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id E5B431F4
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2015 22:19:44 +0000 (UTC)
In-Reply-To: <20150221221553.21954.32599.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

add error handling for failure when registering with SCSI subsystem.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 361937a..d163440 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -7469,7 +7469,8 @@ reinit_after_soft_reset:
 	h->access.set_intr_mask(h, HPSA_INTR_ON);
 
 	hpsa_hba_inquiry(h);
-	hpsa_register_scsi(h);	/* hook ourselves into SCSI subsystem */
+	if (hpsa_register_scsi(h)) /* hook ourselves into SCSI subsystem */
+		goto clean4;
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;

