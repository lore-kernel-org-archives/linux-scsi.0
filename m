From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 20/24] hpsa: do not ignore failure of sense controller
	parameters command
Date: Thu, 29 May 2014 10:54:05 -0500
Message-ID: <20140529155405.8180.13015.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:21454 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbaE2Py4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:54:56 -0400
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Joe Handzik <joseph.t.handzik@hp.com>

Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e2f85e7..b4b745b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2979,12 +2979,12 @@ static int hpsa_hba_mode_enabled(struct ctlr_info *h)
 		GFP_KERNEL);
 
 	if (!ctlr_params)
-		return 0;
+		return -ENOMEM;
 	rc = hpsa_bmic_ctrl_mode_sense(h, RAID_CTLR_LUNID, 0, ctlr_params,
 		sizeof(struct bmic_controller_parameters));
-	if (rc != 0) {
+	if (rc) {
 		kfree(ctlr_params);
-		return 0;
+		return rc;
 	}
 
 	hba_mode_enabled =
@@ -3031,6 +3031,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	memset(lunzerobits, 0, sizeof(lunzerobits));
 
 	rescan_hba_mode = hpsa_hba_mode_enabled(h);
+	if (rescan_hba_mode < 0)
+		goto out;
 
 	if (!h->hba_mode_enabled && rescan_hba_mode)
 		dev_warn(&h->pdev->dev, "HBA mode enabled\n");

