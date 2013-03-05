From: Syam Sidhardhan <syamsidhardh@gmail.com>
Subject: [PATCH] aic7xxx: Remove redundant NULL check before kfree
Date: Wed,  6 Mar 2013 00:56:22 +0530
Message-ID: <1362511582-3657-1-git-send-email-s.syam@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3CET0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 14:26:34 -0500
Received: by mail-pb0-f46.google.com with SMTP id uo15so4849195pbc.5
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2013 11:26:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: syamsidhardh@gmail.com, hare@suse.de, JBottomley@parallels.com

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c |   12 ++++--------
 drivers/scsi/aic7xxx/aic7xxx_core.c |   16 ++++++----------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 0bcacf7..5fc36b0 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6145,8 +6145,7 @@ ahd_set_unit(struct ahd_softc *ahd, int unit)
 void
 ahd_set_name(struct ahd_softc *ahd, char *name)
 {
-	if (ahd->name != NULL)
-		kfree(ahd->name);
+	kfree(ahd->name);
 	ahd->name = name;
 }
 
@@ -6213,12 +6212,9 @@ ahd_free(struct ahd_softc *ahd)
 		kfree(ahd->black_hole);
 	}
 #endif
-	if (ahd->name != NULL)
-		kfree(ahd->name);
-	if (ahd->seep_config != NULL)
-		kfree(ahd->seep_config);
-	if (ahd->saved_stack != NULL)
-		kfree(ahd->saved_stack);
+	kfree(ahd->name);
+	kfree(ahd->seep_config);
+	kfree(ahd->saved_stack);
 #ifndef __FreeBSD__
 	kfree(ahd);
 #endif
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 10172a3..a145e7a 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2200,8 +2200,7 @@ ahc_free_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel, int force)
 	if (channel == 'B')
 		scsi_id += 8;
 	tstate = ahc->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahc->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -4482,8 +4481,7 @@ ahc_set_unit(struct ahc_softc *ahc, int unit)
 void
 ahc_set_name(struct ahc_softc *ahc, char *name)
 {
-	if (ahc->name != NULL)
-		kfree(ahc->name);
+	kfree(ahc->name);
 	ahc->name = name;
 }
 
@@ -4550,10 +4548,8 @@ ahc_free(struct ahc_softc *ahc)
 		kfree(ahc->black_hole);
 	}
 #endif
-	if (ahc->name != NULL)
-		kfree(ahc->name);
-	if (ahc->seep_config != NULL)
-		kfree(ahc->seep_config);
+	kfree(ahc->name);
+	kfree(ahc->seep_config);
 #ifndef __FreeBSD__
 	kfree(ahc);
 #endif
@@ -4958,8 +4954,8 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 	case 0:
 		break;
 	}
-	if (scb_data->scbarray != NULL)
-		kfree(scb_data->scbarray);
+
+	kfree(scb_data->scbarray);
 }
 
 static void
-- 
1.7.9.5

