From: akpm@linux-foundation.org
Subject: [patch 15/30] drivers/scsi/aic7xxx/: make functions static
Date: Fri, 16 Feb 2007 01:46:33 -0800
Message-ID: <200702160946.l1G9kXou026660@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37217 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423532AbXBPJts (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:49:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_osm.c  |    6 ++++--
 drivers/scsi/aic7xxx/aic79xx_osm.h  |    2 --
 drivers/scsi/aic7xxx/aic7xxx.h      |    5 -----
 drivers/scsi/aic7xxx/aic7xxx_core.c |    2 +-
 4 files changed, 5 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -363,6 +363,8 @@ static int ahd_linux_run_command(struct 
 				 struct scsi_cmnd *);
 static void ahd_linux_setup_tag_info_global(char *p);
 static int  aic79xx_setup(char *c);
+static void ahd_freeze_simq(struct ahd_softc *ahd);
+static void ahd_release_simq(struct ahd_softc *ahd);
 
 static int ahd_linux_unit;
 
@@ -2016,13 +2018,13 @@ ahd_linux_queue_cmd_complete(struct ahd_
 	cmd->scsi_done(cmd);
 }
 
-void
+static void
 ahd_freeze_simq(struct ahd_softc *ahd)
 {
 	scsi_block_requests(ahd->platform_data->host);
 }
 
-void
+static void
 ahd_release_simq(struct ahd_softc *ahd)
 {
 	scsi_unblock_requests(ahd->platform_data->host);
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -837,8 +837,6 @@ int	ahd_platform_alloc(struct ahd_softc 
 void	ahd_platform_free(struct ahd_softc *ahd);
 void	ahd_platform_init(struct ahd_softc *ahd);
 void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
-void	ahd_freeze_simq(struct ahd_softc *ahd);
-void	ahd_release_simq(struct ahd_softc *ahd);
 
 static __inline void
 ahd_freeze_scb(struct scb *scb)
diff -puN drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic7xxx.h
--- a/drivers/scsi/aic7xxx/aic7xxx.h~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1278,11 +1278,6 @@ typedef enum {
 	AHC_QUEUE_TAGGED
 } ahc_queue_alg;
 
-void			ahc_set_tags(struct ahc_softc *ahc,
-				     struct scsi_cmnd *cmd,
-				     struct ahc_devinfo *devinfo,
-				     ahc_queue_alg alg);
-
 /**************************** Target Mode *************************************/
 #ifdef AHC_TARGET_MODE
 void		ahc_send_lstate_events(struct ahc_softc *,
diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-make-functions-static drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c~drivers-scsi-aic7xxx-make-functions-static
+++ a/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -2073,7 +2073,7 @@ ahc_set_width(struct ahc_softc *ahc, str
 /*
  * Update the current state of tagged queuing for a given target.
  */
-void
+static void
 ahc_set_tags(struct ahc_softc *ahc, struct scsi_cmnd *cmd,
 	     struct ahc_devinfo *devinfo, ahc_queue_alg alg)
 {
_
