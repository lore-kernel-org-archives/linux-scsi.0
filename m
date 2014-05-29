From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 15/24] hpsa: kill annoying messages about SSD Smart Path
	retries
Date: Thu, 29 May 2014 10:53:39 -0500
Message-ID: <20140529155339.8180.82065.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37847 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbaE2Pyl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:54:41 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id CDECA6014C
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:54:40 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

There's nothing the user can or should do about these messages,
the commands are retried down the normal RAID path, and the
messages just flood the logs and sap performance.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
---
 drivers/scsi/hpsa.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 96436bb..8359884 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1653,16 +1653,6 @@ static void process_ioaccel2_completion(struct ctlr_info *h,
 	if (is_logical_dev_addr_mode(dev->scsi3addr) &&
 		c2->error_data.serv_response ==
 			IOACCEL2_SERV_RESPONSE_FAILURE) {
-		if (c2->error_data.status ==
-			IOACCEL2_STATUS_SR_IOACCEL_DISABLED)
-			dev_warn(&h->pdev->dev,
-				"%s: Path is unavailable, retrying on standard path.\n",
-				"HP SSD Smart Path");
-		else
-			dev_warn(&h->pdev->dev,
-				"%s: Error 0x%02x, retrying on standard path.\n",
-				"HP SSD Smart Path", c2->error_data.status);
-
 		dev->offload_enabled = 0;
 		h->drv_req_rescan = 1;	/* schedule controller for a rescan */
 		cmd->result = DID_SOFT_ERROR << 16;

