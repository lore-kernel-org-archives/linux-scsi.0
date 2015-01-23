From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 02/48] hpsa: fix memory leak in kdump hard reset
Date: Fri, 23 Jan 2015 16:41:14 -0600
Message-ID: <20150123224114.14919.52121.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:34086 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbbAWWmI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:08 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
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

