From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 1 01/25] hpsa: stop zeroing reset_cmds_out and
 ioaccel_cmds_out during rescan
Date: Wed, 28 Oct 2015 17:04:35 -0500
Message-ID: <20151028220435.5323.57054.stgit@brunhilda>
References: <20151028215206.5323.84194.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:48731 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbbJ1WIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2015 18:08:21 -0400
In-Reply-To: <20151028215206.5323.84194.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

pulling the rug out from under the reset handler
likewise for ioaccel_cmds_out

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40669f8..e60c652 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3673,8 +3673,6 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 				DRIVE_CMDS_RESERVED_FOR_FW;
 	else
 		dev->queue_depth = DRIVE_QUEUE_DEPTH; /* conservative */
-	atomic_set(&dev->ioaccel_cmds_out, 0);
-	atomic_set(&dev->reset_cmds_out, 0);
 }
 
 static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,

