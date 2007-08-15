From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] simscsi: Free scsi host on error
Date: Wed, 15 Aug 2007 12:56:54 -0600
Message-ID: <11872042213451-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:51423 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764305AbXHOS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

If scsi_add_host returned an error, the host would never be freed.
We need to call scsi_host_put() if an error happens.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 arch/ia64/hp/sim/simscsi.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index e62694f..a43e1e1 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -373,8 +373,13 @@ simscsi_init(void)
 		return -ENOMEM;
 
 	error = scsi_add_host(host, NULL);
-	if (!error)
-		scsi_scan_host(host);
+	if (error)
+		goto free_host;
+	scsi_scan_host(host);
+	return 0;
+
+ free_host:
+	scsi_host_put(host);
 	return error;
 }
 
-- 
1.5.2.4

