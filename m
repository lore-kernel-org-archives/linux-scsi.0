From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 3/7 RESEND] scsi_debug: vfree is null safe so drop the check
Date: Tue, 28 Jul 2015 16:54:22 +0300
Message-ID: <1438091666-18113-3-git-send-email-tomas.winkler@intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbbG1N5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2015 09:57:31 -0400
In-Reply-To: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index bbe04dae040c..e2c509e39765 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4955,10 +4955,8 @@ bus_unreg:
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
@@ -4976,9 +4974,7 @@ static void __exit scsi_debug_exit(void)
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
 
-	if (dif_storep)
-		vfree(dif_storep);
-
+	vfree(dif_storep);
 	vfree(fake_storep);
 }
 
-- 
2.4.3

