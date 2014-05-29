From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 19/24] hpsa: fix memory leak in hpsa_hba_mode_enabled
Date: Thu, 29 May 2014 10:54:00 -0500
Message-ID: <20140529155359.8180.16415.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:19867 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbaE2PzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:01 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id F3633DD3
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:35:43 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Joe Handzik <joseph.t.handzik@hp.com>

And while we're at it fix a magic number

Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 ++++++-
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3446b8d..e2f85e7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2973,6 +2973,7 @@ u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
 static int hpsa_hba_mode_enabled(struct ctlr_info *h)
 {
 	int rc;
+	int hba_mode_enabled;
 	struct bmic_controller_parameters *ctlr_params;
 	ctlr_params = kzalloc(sizeof(struct bmic_controller_parameters),
 		GFP_KERNEL);
@@ -2985,7 +2986,11 @@ static int hpsa_hba_mode_enabled(struct ctlr_info *h)
 		kfree(ctlr_params);
 		return 0;
 	}
-	return ctlr_params->nvram_flags & (1 << 3) ? 1 : 0;
+
+	hba_mode_enabled =
+		((ctlr_params->nvram_flags & HBA_MODE_ENABLED_FLAG) != 0);
+	kfree(ctlr_params);
+	return hba_mode_enabled;
 }
 
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 18f5093..24472ce 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -91,6 +91,7 @@ struct bmic_controller_parameters {
 	u8   automatic_drive_slamming;
 	u8   reserved1;
 	u8   nvram_flags;
+#define HBA_MODE_ENABLED_FLAG (1 << 3)
 	u8   cache_nvram_flags;
 	u8   drive_config_flags;
 	u16  reserved2;

