From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 02/27] hpsa: stop zeroing reset_cmds_out and
 ioaccel_cmds_out during rescan
Date: Wed, 04 Nov 2015 15:50:07 -0600
Message-ID: <20151104215007.15472.98628.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53262 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965397AbbKDVyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:03 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

pulling the rug out from under the reset handler
likewise for ioaccel_cmds_out

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 815dc7f..4085401 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3671,8 +3671,6 @@ static void hpsa_get_ioaccel_drive_info(struct ctlr_info *h,
 				DRIVE_CMDS_RESERVED_FOR_FW;
 	else
 		dev->queue_depth = DRIVE_QUEUE_DEPTH; /* conservative */
-	atomic_set(&dev->ioaccel_cmds_out, 0);
-	atomic_set(&dev->reset_cmds_out, 0);
 }
 
 static void hpsa_get_path_info(struct hpsa_scsi_dev_t *this_device,

