From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 16/48] hpsa: report failure to ioremap config table
Date: Fri, 23 Jan 2015 16:42:27 -0600
Message-ID: <20150123224227.14919.44324.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39009 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbbAWWnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:43:21 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Enhance error reporting.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5973018..354e7f8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6130,8 +6130,10 @@ static int hpsa_find_cfgtables(struct ctlr_info *h)
 		return rc;
 	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
 		       cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
-	if (!h->cfgtable)
+	if (!h->cfgtable) {
+		dev_err(&h->pdev->dev, "Failed mapping cfgtable\n");
 		return -ENOMEM;
+	}
 	rc = write_driver_ver_to_cfgtable(h->cfgtable);
 	if (rc)
 		return rc;

