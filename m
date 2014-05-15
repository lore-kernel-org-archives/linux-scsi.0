From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/2] hpsa: fix memory leak in hpsa_hba_mode_enabled
Date: Thu, 15 May 2014 15:44:42 -0500
Message-ID: <20140515204441.27343.77902.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:1290 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaEOUpe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 May 2014 16:45:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Joe Handzik <joseph.t.handzik@hp.com>

And while we're at it fix a magic number

Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    7 ++++++-
 drivers/scsi/hpsa.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2fe8705..a0da81c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2967,6 +2967,7 @@ u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
 static int hpsa_hba_mode_enabled(struct ctlr_info *h)
 {
 	int rc;
+	int hba_mode_enabled;
 	struct bmic_controller_parameters *ctlr_params;
 	ctlr_params = kzalloc(sizeof(struct bmic_controller_parameters),
 		GFP_KERNEL);
@@ -2979,7 +2980,11 @@ static int hpsa_hba_mode_enabled(struct ctlr_info *h)
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

