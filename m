From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 16/48] hpsa: report failure to ioremap config table
Date: Wed, 14 Jan 2015 16:01:00 -0600
Message-ID: <20150114220100.21325.4164.stgit@brunhilda>
References: <20150114215756.21325.41198.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:58137 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbANWBs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2015 17:01:48 -0500
Received: from g5t1627.atlanta.hp.com (g5t1627.atlanta.hp.com [15.192.137.10])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id EF34563538
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2015 22:01:47 +0000 (UTC)
In-Reply-To: <20150114215756.21325.41198.stgit@brunhilda>
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

