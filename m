From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] aha152x: Close narrow race in release
Date: Wed, 15 Aug 2007 12:56:57 -0600
Message-ID: <11872042212630-git-send-email-matthew@wil.cx>
References: <11872042213451-git-send-email-matthew@wil.cx>
 <11872042213665-git-send-email-matthew@wil.cx>
 <11872042211224-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:33276 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765811AbXHOS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:57 -0400
In-Reply-To: <11872042211224-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

We were releasing the IRQ before removing the host, so commands could
still be coming in which would never be seen by the interrupt handler.
Just remove the host before releasing the IRQ to close this race.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/aha152x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d30a307..f08e71e 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -907,9 +907,10 @@ out_host_put:
 
 void aha152x_release(struct Scsi_Host *shpnt)
 {
-	if(!shpnt)
+	if (!shpnt)
 		return;
 
+	scsi_remove_host(shpnt);
 	if (shpnt->irq)
 		free_irq(shpnt->irq, shpnt);
 
@@ -923,7 +924,6 @@ void aha152x_release(struct Scsi_Host *shpnt)
 		pnp_device_detach(HOSTDATA(shpnt)->pnpdev);
 #endif
 
-	scsi_remove_host(shpnt);
 	list_del(&HOSTDATA(shpnt)->host_list);
 	scsi_host_put(shpnt);
 }
-- 
1.5.2.4

