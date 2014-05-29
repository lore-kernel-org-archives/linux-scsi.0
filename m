From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 21/24] hpsa: remove messages about volume status VPD inquiry
	page not supported
Date: Thu, 29 May 2014 10:54:10 -0500
Message-ID: <20140529155410.8180.66056.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:21518 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaE2PzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:01 -0400
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

They are annoying and do not help anyone.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Justin Lindley <justin.lindley@hp.com>
Reviewed-by: Mike Miller <michael.miller@hp.com>
---
 drivers/scsi/hpsa.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b4b745b..654e341 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2516,27 +2516,21 @@ static int hpsa_get_volume_status(struct ctlr_info *h,
 		return HPSA_VPD_LV_STATUS_UNSUPPORTED;
 
 	/* Does controller have VPD for logical volume status? */
-	if (!hpsa_vpd_page_supported(h, scsi3addr, HPSA_VPD_LV_STATUS)) {
-		dev_warn(&h->pdev->dev, "Logical volume status VPD page is unsupported.\n");
+	if (!hpsa_vpd_page_supported(h, scsi3addr, HPSA_VPD_LV_STATUS))
 		goto exit_failed;
-	}
 
 	/* Get the size of the VPD return buffer */
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | HPSA_VPD_LV_STATUS,
 					buf, HPSA_VPD_HEADER_SZ);
-	if (rc != 0) {
-		dev_warn(&h->pdev->dev, "Logical volume status VPD inquiry failed.\n");
+	if (rc != 0)
 		goto exit_failed;
-	}
 	size = buf[3];
 
 	/* Now get the whole VPD buffer */
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | HPSA_VPD_LV_STATUS,
 					buf, size + HPSA_VPD_HEADER_SZ);
-	if (rc != 0) {
-		dev_warn(&h->pdev->dev, "Logical volume status VPD inquiry failed.\n");
+	if (rc != 0)
 		goto exit_failed;
-	}
 	status = buf[4]; /* status byte */
 
 	kfree(buf);

