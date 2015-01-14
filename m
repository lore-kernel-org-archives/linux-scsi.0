From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 02/48] hpsa: fix memory leak in kdump hard reset
Date: Wed, 14 Jan 2015 15:59:44 -0600
Message-ID: <20150114215944.21325.70894.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:58107 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbANWAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:00:32 -0500
Received: from g5t1627.atlanta.hp.com (g5t1627.atlanta.hp.com [15.192.137.10])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id C18016244F
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:00:31 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

There is a potential memory leak in hpsa_kdump_hard_reset_controller.


Reviewed-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2b9baea..d97f455 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5840,7 +5840,7 @@ static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	}
 	rc = write_driver_ver_to_cfgtable(cfgtable);
 	if (rc)
-		goto unmap_vaddr;
+		goto unmap_cfgtable;
 
 	/* If reset via doorbell register is supported, use that.
 	 * There are two such methods.  Favor the newest method.

