From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/19] hpsa: kill annoying messages about SSD Smart Path
	retries
Date: Thu, 08 May 2014 14:28:40 -0500
Message-ID: <20140508192840.13481.15649.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:31451 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaEHT3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:31 -0400
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

There's nothing the user can or should do about these messages,
the commands are retried down the normal RAID path, and the
messages just flood the logs and sap performance.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
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

