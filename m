From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] ips: Close narrow race in release
Date: Wed, 15 Aug 2007 12:57:00 -0600
Message-ID: <11872042212682-git-send-email-matthew@wil.cx>
References: <11872042213451-git-send-email-matthew@wil.cx>
 <11872042213665-git-send-email-matthew@wil.cx>
 <11872042211224-git-send-email-matthew@wil.cx>
 <11872042212630-git-send-email-matthew@wil.cx>
 <1187204221432-git-send-email-matthew@wil.cx>
 <1187204221728-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58744 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358AbXHOS44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:56 -0400
In-Reply-To: <1187204221728-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

We were releasing the IRQ before removing the host, so commands could
still be coming in which would never be seen by the interrupt handler.
Just remove the host before releasing the IRQ to close this race.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/ips.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 492a51b..eacd666 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -656,6 +656,8 @@ ips_release(struct Scsi_Host *sh)
 
 	METHOD_TRACE("ips_release", 1);
 
+	scsi_remove_host(sh);
+
 	for (i = 0; i < IPS_MAX_ADAPTERS && ips_sh[i] != sh; i++) ;
 
 	if (i == IPS_MAX_ADAPTERS) {
@@ -707,7 +709,6 @@ ips_release(struct Scsi_Host *sh)
 	/* free IRQ */
 	free_irq(ha->irq, ha);
 
-	scsi_remove_host(sh);
 	scsi_host_put(sh);
 
 	ips_released_controllers++;
-- 
1.5.2.4

