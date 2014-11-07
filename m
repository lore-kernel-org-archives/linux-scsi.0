From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: fix potential resource leak
Date: Fri,  7 Nov 2014 12:00:16 +0100
Message-ID: <1415358016-6012-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKGLAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 06:00:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, Elliott@hp.com, brace77070@gmail.com

We should free the cfgtable allocated a few lines above.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1ce2b43608..7d4cef779f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5994,7 +5994,7 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	}
 	rc = write_driver_ver_to_cfgtable(cfgtable);
 	if (rc)
-		goto unmap_vaddr;
+		goto unmap_cfgtable;
 
 	/* If reset via doorbell register is supported, use that.
 	 * There are two such methods.  Favor the newest method.
-- 
1.9.3

