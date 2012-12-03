From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: fix potential resource leak
Date: Mon, 03 Dec 2012 13:13:49 +0100
Message-ID: <50BC977D.4060007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab2LCMOV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Dec 2012 07:14:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

I think we should free also the cfgtable allocated a few lines
above this point.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 796482b..3cc18aa 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3858,7 +3858,7 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	}
 	rc = write_driver_ver_to_cfgtable(cfgtable);
 	if (rc)
-		goto unmap_vaddr;
+		goto unmap_cfgtable;
 
 	/* If reset via doorbell register is supported, use that.
 	 * There are two such methods.  Favor the newest method.
-- 
1.7.11.7

