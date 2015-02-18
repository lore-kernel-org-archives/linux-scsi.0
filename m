From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/4] scsi_debug: vfree is null safe so drop the check
Date: Thu, 19 Feb 2015 00:31:38 +0200
Message-ID: <1424298699-2581-4-git-send-email-tomas.winkler@intel.com>
References: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42097 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbbBRWdR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2015 17:33:17 -0500
In-Reply-To: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/scsi_debug.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 11774cd1741a..80410f9588ba 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4959,10 +4959,8 @@ bus_unreg:
 dev_unreg:
 	root_device_unregister(pseudo_primary);
 free_vm:
-	if (map_storep)
-		vfree(map_storep);
-	if (dif_storep)
-		vfree(dif_storep);
+	vfree(map_storep);
+	vfree(dif_storep);
 	vfree(fake_storep);
 
 	return ret;
@@ -4980,9 +4978,7 @@ static void __exit scsi_debug_exit(void)
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
 
-	if (dif_storep)
-		vfree(dif_storep);
-
+	vfree(dif_storep);
 	vfree(fake_storep);
 }
 
-- 
1.9.3

