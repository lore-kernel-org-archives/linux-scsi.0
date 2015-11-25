From: Anup Limbu <anuplimbu14@gmail.com>
Subject: [PATCH] scsi: aic7xxx: kfree() NULL pointer cleanups
Date: Wed, 25 Nov 2015 15:54:42 +0530
Message-ID: <1448447082-15920-1-git-send-email-anuplimbu14@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anup Limbu <anuplimbu14@gmail.com>
List-Id: linux-scsi@vger.kernel.org

kfree() handles NULL pointers fine - checking is redundant

Signed-off-by: Anup Limbu <anuplimbu14@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 109e2c9..a710a35 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3681,8 +3681,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u_int scsi_id, char channel, int force)
 		return;
 
 	tstate = ahd->enabled_targets[scsi_id];
-	if (tstate != NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahd->enabled_targets[scsi_id] = NULL;
 }
 #endif
@@ -6145,8 +6144,7 @@ ahd_set_unit(struct ahd_softc *ahd, int unit)
 void
 ahd_set_name(struct ahd_softc *ahd, char *name)
 {
-	if (ahd->name != NULL)
-		kfree(ahd->name);
+	kfree(ahd->name);
 	ahd->name = name;
 }
 
@@ -6213,12 +6211,9 @@ ahd_free(struct ahd_softc *ahd)
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
-- 
1.9.1
