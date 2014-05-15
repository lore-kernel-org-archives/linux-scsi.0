From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/2] hpsa: do not ignore failure of sense controller
	parameters command
Date: Thu, 15 May 2014 15:44:47 -0500
Message-ID: <20140515204447.27343.98620.stgit@beardog.cce.hp.com>
References: <20140515204441.27343.77902.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:30517 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaEOUpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2014 16:45:40 -0400
In-Reply-To: <20140515204441.27343.77902.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Joe Handzik <joseph.t.handzik@hp.com>

Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a0da81c..654e341 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2973,12 +2973,12 @@ static int hpsa_hba_mode_enabled(struct ctlr_info *h)
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
@@ -3025,6 +3025,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 	memset(lunzerobits, 0, sizeof(lunzerobits));
 
 	rescan_hba_mode = hpsa_hba_mode_enabled(h);
+	if (rescan_hba_mode < 0)
+		goto out;
 
 	if (!h->hba_mode_enabled && rescan_hba_mode)
 		dev_warn(&h->pdev->dev, "HBA mode enabled\n");

