From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] aic7xxx: replace kmalloc/strcpy by kstrdup
Date: Tue, 14 Jul 2015 09:25:16 +0200
Message-ID: <4159f01e6450cee8093e7d6a0d979bbeab8243d0.1436858599.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, JBottomley@odin.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

This replaces kmalloc + strcpy by an equivalent call to kstrdup.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 3 +--
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index ce96a0b..ae78e6d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1250,9 +1250,8 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
 	ahd_set_unit(ahd, ahd_linux_unit++);
 	ahd_unlock(ahd, &s);
 	sprintf(buf, "scsi%d", host->host_no);
-	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	new_name = kstrdup(buf, GFP_ATOMIC);
 	if (new_name != NULL) {
-		strcpy(new_name, buf);
 		ahd_set_name(ahd, new_name);
 	}
 	host->unique_id = ahd->unit;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index a2f2c77..ba59947 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1114,9 +1114,8 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	ahc_set_unit(ahc, ahc_linux_unit++);
 	ahc_unlock(ahc, &s);
 	sprintf(buf, "scsi%d", host->host_no);
-	new_name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	new_name = kstrdup(buf, GFP_ATOMIC);
 	if (new_name != NULL) {
-		strcpy(new_name, buf);
 		ahc_set_name(ahc, new_name);
 	}
 	host->unique_id = ahc->unit;
-- 
2.1.4
